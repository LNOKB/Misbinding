library(quickpsy)
library(dplyr)

data <- read.csv("CCMAEexp.csv")

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
                           levels = c(1, 2),
                           labels = c("Misbinding(red↑ green↓)", "Control(red↓ green↑)"))

data$test_color <- factor(data$test_color,
                            levels = c(0, 1),
                            labels = c("Test : red", "Test : green"))

data <- data %>%
  filter(!(Subnum %in% c(7, 11)))


#fit <- quickpsy(data, sospeed, opposite_to_ind_response, grouping = c("nowblocktype"))
#, "test_color""Subnum", ,fun = logistic_fun, bootstrap = "none")
fit <- quickpsy(data, testspeed, keypress, grouping = c("nowblocktype", "test_color","Subnum"))

plot(fit, color = nowblocktype)+
  labs(x= "Test Speed (°/sec)", y = "Response against inducer rates (%)")+
  scale_x_continuous(labels = c("S0.6", "S0.3", "0", "O0.3", "O0.6"))

#down response rate plot
summary_data <- data %>%
  group_by(nowblocktype, testspeed, test_color,Subnum) %>%
  summarise(mean_keypress = mean(keypress), .groups = "drop")

ggplot(summary_data, aes(x = testspeed, y = mean_keypress, color = test_color)) +
  geom_point() +
  geom_line() +
  facet_wrap(Subnum ~ nowblocktype, nrow = 10, ncol = 2) +
  labs(x = "Test Speed", y = "Down response rate(%)") +
  theme_minimal()
