library(quickpsy)
library(dplyr)
library(tidyr)
library(ggplot2)

data <- read.csv("CCMAEexp.csv")

data <- data %>%
  mutate(
    sospeed = case_when(
      # test_color == 0 (red) & nowblocktype == 1 (red↑)
      test_color == 0 & nowblocktype == 1 & testspeed == 0.6  ~ 5L,
      test_color == 0 & nowblocktype == 1 & testspeed == 0.3  ~ 4L,
      test_color == 0 & nowblocktype == 1 & testspeed == 0    ~ 3L,
      test_color == 0 & nowblocktype == 1 & testspeed == -0.3 ~ 2L,
      test_color == 0 & nowblocktype == 1 & testspeed == -0.6 ~ 1L,
      
      # test_color == 0 (red) & nowblocktype == 2 (red↓)
      test_color == 0 & nowblocktype == 2 & testspeed == 0.6  ~ 1L,
      test_color == 0 & nowblocktype == 2 & testspeed == 0.3  ~ 2L,
      test_color == 0 & nowblocktype == 2 & testspeed == 0    ~ 3L,
      test_color == 0 & nowblocktype == 2 & testspeed == -0.3 ~ 4L,
      test_color == 0 & nowblocktype == 2 & testspeed == -0.6 ~ 5L,
      
      # test_color == 1 (green) & nowblocktype == 1 (green↓)
      test_color == 1 & nowblocktype == 1 & testspeed == 0.6  ~ 1L,
      test_color == 1 & nowblocktype == 1 & testspeed == 0.3  ~ 2L,
      test_color == 1 & nowblocktype == 1 & testspeed == 0    ~ 3L,
      test_color == 1 & nowblocktype == 1 & testspeed == -0.3 ~ 4L,
      test_color == 1 & nowblocktype == 1 & testspeed == -0.6 ~ 5L,
      
      # test_color == 1 (green) & nowblocktype == 2 (green↑)
      test_color == 1 & nowblocktype == 2 & testspeed == 0.6  ~ 5L,
      test_color == 1 & nowblocktype == 2 & testspeed == 0.3  ~ 4L,
      test_color == 1 & nowblocktype == 2 & testspeed == 0    ~ 3L,
      test_color == 1 & nowblocktype == 2 & testspeed == -0.3 ~ 2L,
      test_color == 1 & nowblocktype == 2 & testspeed == -0.6 ~ 1L,
      
      TRUE ~ NA_integer_
    )
  )

data <- data %>%
  mutate(sospeed = recode(sospeed,
                          `1` = -0.6,
                          `2` = -0.3,
                          `3` =  0,
                          `4` =  0.3,
                          `5` =  0.6))

data$nowblocktype <- factor(data$nowblocktype,
                            levels = c(1, 2),
                            labels = c("Misbinding", "Control"))

data$test_color <- factor(data$test_color,
                          levels = c(0, 1),
                          labels = c("Test : red", "Test : green"))

data <- data %>%
  filter(!(Subnum %in% c(7, 11))) 

summary_data <- data %>%
  filter(Subnum %in% c(1)) %>%
  filter(nowblocktype %in% c("Misbinding")) %>%
  group_by(nowblocktype, sospeed, Subnum) %>%
  summarise(mean_keypress = mean(opposite_to_ind_response), .groups = "drop")

p1 <- ggplot(summary_data, aes(x = sospeed, y = mean_keypress * 100)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1) +
  labs(
    x = "Test speed (°/s)",
    y = "Rate of responses \nopposite to the inducer (%)"
  ) +
  #facet_wrap(Subnum ~ nowblocktype) +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.line = element_line(color = "black", linewidth = 0.8),
    axis.ticks = element_line(color = "black"),
    axis.text  = element_text(color = "black", size = 12),
    axis.title = element_text(color = "black", size = 16)
  )

ggsave("sum.png", p1, width = 4, height = 4, dpi = 300)
  
  
#############################################################down response rate plot
summary_data <- data %>%
  filter(Subnum %in% c(1)) %>%
  filter(test_color %in% c("Test : red")) %>%
  filter(nowblocktype %in% c("Misbinding")) %>%
  group_by(nowblocktype, testspeed, test_color,Subnum) %>%
  summarise(mean_keypress = mean(keypress), .groups = "drop")

p2 <- ggplot(summary_data, aes(x = testspeed, y = mean_keypress * 100)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1) +
  labs(
    x = "Test speed (downward motion, °/s)",
    y = "Downward response rate (%)"
  ) +
  #facet_wrap(Subnum ~ nowblocktype) +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.line = element_line(color = "black", linewidth = 0.8),
    axis.ticks = element_line(color = "black"),
    axis.text  = element_text(color = "black", size = 12),
    axis.title = element_text(color = "black", size = 16)
  )

ggsave("down.png", p2, width = 4, height = 4, dpi = 300)


#############################################################up response rate plot

data <- data %>%
  mutate(testspeed = -testspeed)

summary_data <- data %>%
  filter(Subnum %in% c(1)) %>%
  filter(test_color %in% c("Test : green")) %>%
  filter(nowblocktype %in% c("Misbinding")) %>%
  group_by(nowblocktype, testspeed, test_color,Subnum) %>%
  summarise(mean_keypress = mean(keypress), .groups = "drop")

p3 <- ggplot(summary_data, aes(x = testspeed, y = 100 - (mean_keypress * 100))) +
  geom_point(size = 3) +
  geom_line(linewidth = 1) +
  labs(
    x = "Test speed (upward motion, °/s)",
    y = "Upward response rate (%)"
  ) +
  #facet_wrap(Subnum ~ nowblocktype) +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.line = element_line(color = "black", linewidth = 0.8),
    axis.ticks = element_line(color = "black"),
    axis.text  = element_text(color = "black", size = 12),
    axis.title = element_text(color = "black", size = 16)
  )

ggsave("up.png", p3, width = 4, height = 4, dpi = 300)



