library(quickpsy)
library(dplyr)
library(tidyr)
library(readr)

data <- read.csv("CCMAEexp_slower.csv")

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
  filter(!(Subnum %in% c(4, 5, 6, 8, 10, 12)))


fit <- quickpsy(data, sospeed, opposite_to_ind_response, grouping = c("nowblocktype","Subnum"))
#, "test_color", ,fun = logistic_fun, bootstrap = "none")
#fit <- quickpsy(data, testspeed, keypress, grouping = c("nowblocktype", "test_color","Subnum"))

plot(fit, color = nowblocktype)+
  labs(x= "Test Speed (°/sec)", y = "Response against inducer rates (%)")+
  scale_x_continuous(labels = c("S0.4", "S0.2", "0", "O0.2", "O0.4"))

write.csv(fit$par, file = "CCMAE_slower_par")

# #down response rate plot
# summary_data <- data %>%
#   group_by(nowblocktype, testspeed, test_color,Subnum) %>%
#   summarise(mean_keypress = mean(keypress), .groups = "drop")
# 
# ggplot(summary_data, aes(x = testspeed, y = mean_keypress, color = test_color)) +
#   geom_point() +
#   geom_line() +
#   facet_wrap(Subnum ~ nowblocktype, nrow = 10, ncol = 2) +
#   labs(x = "Test Speed", y = "Down response rate(%)") +
#   theme_minimal()


# データをwide形式に変換（blocktypeを列に）
dat_wide <- fit$par %>%
  select(nowblocktype, Subnum, parn, par) %>%
  pivot_wider(
    names_from = nowblocktype,
    values_from = par
  )

# p1についての対応のあるt検定（Misbinding vs Control）
p1_data <- dat_wide %>%
  filter(parn == "p1")

t_test_p1 <- t.test(
  p1_data$`Misbinding(red↑ green↓)`,
  p1_data$`Control(red↓ green↑)`,
  paired = TRUE
)

# p2についての対応のあるt検定（Misbinding vs Control）
p2_data <- dat_wide %>%
  filter(parn == "p2")

t_test_p2 <- t.test(
  p2_data$`Misbinding(red↑ green↓)`,
  p2_data$`Control(red↓ green↑)`,
  paired = TRUE
)

# 結果表示
cat("=== p1: Misbinding vs Control ===\n")
print(t_test_p1)
cat("\n平均値:\n")
cat("Misbinding:", mean(p1_data$`Misbinding(red↑ green↓)`), "\n")
cat("Control:", mean(p1_data$`Control(red↓ green↑)`), "\n")
cat("差:", mean(p1_data$`Misbinding(red↑ green↓)`) - mean(p1_data$`Control(red↓ green↑)`), "\n\n")

cat("=== p2: Misbinding vs Control ===\n")
print(t_test_p2)
cat("\n平均値:\n")
cat("Misbinding:", mean(p2_data$`Misbinding(red↑ green↓)`), "\n")
cat("Control:", mean(p2_data$`Control(red↓ green↑)`), "\n")
cat("差:", mean(p2_data$`Misbinding(red↑ green↓)`) - mean(p2_data$`Control(red↓ green↑)`), "\n\n")
