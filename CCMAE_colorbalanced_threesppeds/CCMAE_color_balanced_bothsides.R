library(quickpsy)
library(dplyr)

data <- read.csv("CCMAEexp_color_balanced_bothsides.csv")
#keypress = down response rate

#"the percentage of trials in which subjects indicated directions for the test stimuli 
#that were opposite to the perceived direction of adapting dots
#(which possessed the same color as the test stimuli) "

#"the percentage of trials in which subjects indicated that 
#the moving direction of a test stimulus was the same as 
#the physical direction of the adapting dots 
#(or opposite to the perceived direction).

#S and O indicate that the moving direction of a test stimulus was the same as or opposite to 
#that of the adapting dots in the effect part
#(with the same color as the dots in the test stimulus).


data$nowblocktype <- factor(data$nowblocktype,
                           levels = c(1, 2, 3, 4),
                           labels = c("Misbinding_redup", "Misbinding_greenup", 
                                      "Control_redup", "Control_greenup"))

data$test_color <- factor(data$test_color,
                            levels = c(0, 1),
                            labels = c("Test : red", "Test : green"))



# 
# 
# #fit <- quickpsy(data, sospeed, opposite_to_ind_response, grouping = c("nowblocktype","Subnum"))
# #, "test_color", ,fun = logistic_fun, bootstrap = "none")
# fit <- quickpsy(data, testspeed, keypress, grouping = c("nowblocktype", "test_color","Subnum"))
# 
# # plot(fit, color = nowblocktype)+
# #   labs(x= "Test Speed (°/sec)", y = "Response against inducer rates (%)")+
# #   scale_x_continuous(labels = c("S0.4", "S0.2", "0", "O0.2", "O0.4"))
# 
# plot(fit, color = nowblocktype)+
#     labs(x= "Test Speed (°/sec)", y = "Down response rates (%)")+
#     scale_x_continuous(labels = c("-0.3", "0", "0.3"))
# 
#down response rate plot
summary_data <- data %>%
  group_by(nowblocktype, testspeed, test_color,Subnum) %>%
  summarise(mean_keypress = mean(keypress), .groups = "drop")

# summary_data <- summary_data %>%
#   filter(nowblocktype %in% c("Misbinding_redup", "Control_redup"))

summary_data <- summary_data %>%
  filter(nowblocktype %in% c("Misbinding_greenup", "Control_greenup"))

ggplot(summary_data, aes(x = testspeed, y = mean_keypress*100, color = nowblocktype)) +
  geom_point() +
  geom_line() +
  facet_wrap(Subnum ~ test_color, nrow = 10, ncol = 2) +
  labs(
    x = "Test Speed(deg/sec)",
    y = "Down response rate(%)",
    color = "Inducer"  
  ) +
  scale_x_continuous(
    breaks = c(-0.3, 0, 0.3),
    labels = c("Up0.3", "0", "Down0.3")
  ) +
  scale_y_continuous(limits = c(0, 100)) +  
  theme_minimal()
