# =============================================================================
# CCMAE Experiment – Publication-ready figures
# =============================================================================

library(quickpsy)
library(dplyr)
library(tidyr)
library(ggplot2)

# -----------------------------------------------------------------------------
# 0. Shared theme for publication figures
# -----------------------------------------------------------------------------

theme_publication <- function(base_size = 14) {
  theme_classic(base_size = base_size) +
    theme(
      # Axes
      axis.line        = element_line(color = "black", linewidth = 0.6),
      axis.ticks       = element_line(color = "black", linewidth = 0.4),
      axis.ticks.length = unit(3, "pt"),
      axis.text        = element_text(color = "black", size = base_size - 2),
      axis.title       = element_text(color = "black", size = base_size),
      axis.title.y     = element_text(margin = margin(r = 8)),
      axis.title.x     = element_text(margin = margin(t = 8)),
      # Panel
      panel.grid       = element_blank(),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background  = element_rect(fill = "white", color = NA),
      # Margins
      plot.margin      = margin(10, 12, 8, 8)
    )
}

# -----------------------------------------------------------------------------
# 1. Load & preprocess data
# -----------------------------------------------------------------------------

raw <- read.csv("CCMAEexp.csv")

# Compute sospeed: recode testspeed so that the direction always aligns with
# "speed relative to the inducer" (positive = same direction as inducer)
raw <- raw %>%
  mutate(
    sospeed = case_when(
      # Red stimulus, Block type 1 (inducer moves upward → red moves up)
      test_color == 0 & nowblocktype == 1 & testspeed ==  0.6 ~  0.6,
      test_color == 0 & nowblocktype == 1 & testspeed ==  0.3 ~  0.3,
      test_color == 0 & nowblocktype == 1 & testspeed ==  0.0 ~  0.0,
      test_color == 0 & nowblocktype == 1 & testspeed == -0.3 ~ -0.3,
      test_color == 0 & nowblocktype == 1 & testspeed == -0.6 ~ -0.6,
      
      # Red stimulus, Block type 2 (inducer moves downward → red moves down)
      test_color == 0 & nowblocktype == 2 & testspeed ==  0.6 ~ -0.6,
      test_color == 0 & nowblocktype == 2 & testspeed ==  0.3 ~ -0.3,
      test_color == 0 & nowblocktype == 2 & testspeed ==  0.0 ~  0.0,
      test_color == 0 & nowblocktype == 2 & testspeed == -0.3 ~  0.3,
      test_color == 0 & nowblocktype == 2 & testspeed == -0.6 ~  0.6,
      
      # Green stimulus, Block type 1 (inducer moves downward → green moves down)
      test_color == 1 & nowblocktype == 1 & testspeed ==  0.6 ~ -0.6,
      test_color == 1 & nowblocktype == 1 & testspeed ==  0.3 ~ -0.3,
      test_color == 1 & nowblocktype == 1 & testspeed ==  0.0 ~  0.0,
      test_color == 1 & nowblocktype == 1 & testspeed == -0.3 ~  0.3,
      test_color == 1 & nowblocktype == 1 & testspeed == -0.6 ~  0.6,
      
      # Green stimulus, Block type 2 (inducer moves upward → green moves up)
      test_color == 1 & nowblocktype == 2 & testspeed ==  0.6 ~  0.6,
      test_color == 1 & nowblocktype == 2 & testspeed ==  0.3 ~  0.3,
      test_color == 1 & nowblocktype == 2 & testspeed ==  0.0 ~  0.0,
      test_color == 1 & nowblocktype == 2 & testspeed == -0.3 ~ -0.3,
      test_color == 1 & nowblocktype == 2 & testspeed == -0.6 ~ -0.6,
      
      TRUE ~ NA_real_
    )
  )

# Factor labels
raw <- raw %>%
  mutate(
    nowblocktype = factor(nowblocktype, levels = c(1, 2),
                          labels = c("Misbinding", "Control")),
    test_color   = factor(test_color,   levels = c(0, 1),
                          labels = c("Test: red", "Test: green"))
  )

# Exclude participants with data quality issues (sub 7 & 11)
dat <- raw %>% filter(!(Subnum %in% c(7, 11)))

# -----------------------------------------------------------------------------
# 2. Figure 1 – Response rate opposite to the inducer (sospeed axis)
# -----------------------------------------------------------------------------

sum_p1 <- dat %>%
  filter(Subnum == 1, nowblocktype == "Misbinding") %>%
  group_by(nowblocktype, sospeed, Subnum) %>%
  summarise(pct_opposite = mean(opposite_to_ind_response) * 100,
            .groups = "drop")

p1 <- ggplot(sum_p1, aes(x = sospeed, y = pct_opposite)) +
  geom_line(linewidth = 0.8, color = "black") +
  geom_point(size = 2.5,  color = "black", fill = "white",
             shape = 21,  stroke = 0.8) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25)) +
  labs(
    x = "Test speed (°/s)",
    y = "Responses opposite to inducer (%)"
  ) +
  theme_publication()

ggsave("fig1_opposite_response.png", p1,
       width = 3.7, height = 3.5, dpi = 600)

# -----------------------------------------------------------------------------
# 3. Figure 2 – Downward response rate (red test stimulus)
# -----------------------------------------------------------------------------

sum_p2 <- dat %>%
  filter(Subnum == 1,
         test_color   == "Test: red",
         nowblocktype == "Misbinding") %>%
  group_by(nowblocktype, testspeed, test_color, Subnum) %>%
  summarise(pct_down = mean(keypress) * 100,
            .groups = "drop")

p2 <- ggplot(sum_p2, aes(x = testspeed, y = pct_down)) +
  geom_line(linewidth = 0.8, color = "black") +
  geom_point(size = 2.5,  color = "black", fill = "white",
             shape = 21,  stroke = 0.8) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25)) +
  labs(
    x = "Test speed – downward motion (°/s)",
    y = "Downward response rate (%)"
  ) +
  theme_publication()

ggsave("fig2_downward_response.png", p2,
       width = 3.7, height = 3.5, dpi = 600)

# -----------------------------------------------------------------------------
# 4. Figure 3 – Upward response rate (green test stimulus)
#    Note: testspeed is negated so that the x-axis reflects upward motion
# -----------------------------------------------------------------------------

sum_p3 <- dat %>%
  filter(Subnum == 1,
         test_color   == "Test: green",
         nowblocktype == "Misbinding") %>%
  mutate(testspeed_up = -testspeed,
         pct_up       = 100 - mean(keypress) * 100) %>%   # per-row; aggregated below
  group_by(nowblocktype, testspeed_up, test_color, Subnum) %>%
  summarise(pct_up = 100 - mean(keypress) * 100,
            .groups = "drop")

p3 <- ggplot(sum_p3, aes(x = testspeed_up, y = pct_up)) +
  geom_line(linewidth = 0.8, color = "black") +
  geom_point(size = 2.5,  color = "black", fill = "white",
             shape = 21,  stroke = 0.8) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25)) +
  labs(
    x = "Test speed – upward motion (°/s)",
    y = "Upward response rate (%)"
  ) +
  theme_publication()

ggsave("fig3_upward_response.png", p3,
       width = 3.7, height = 3.5, dpi = 600)