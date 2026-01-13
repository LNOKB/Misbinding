library(quickpsy)
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

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
                           labels = c("Misbinding", "Control"))
#Misbinding(red↑ green↓)", "Control(red↓ green↑)")


data$test_color <- factor(data$test_color,
                            levels = c(0, 1),
                            labels = c("Test : red", "Test : green"))


data <- data %>%
  filter(!(Subnum %in% c(4, 5, 6, 8, 10, 12)))

data <- data %>%
  mutate(sospeed = recode(sospeed,
                          `1` = -0.6,
                          `2` = -0.3,
                          `3` =  0,
                          `4` =  0.3,
                          `5` =  0.6))

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


###############################################################################
library(BayesFactor)

# データをwide形式に変換（blocktypeを列に）
dat_wide <- fit$par %>%
  pivot_wider(
    names_from = nowblocktype,
    values_from = par,
    id_cols = c(Subnum, parn)
  )

p1_data <- dat_wide %>%
  filter(parn == "p1") %>%
  select(-parn)

p2_data <- dat_wide %>%
  filter(parn == "p2") %>%
  select(-parn)

bf_p1 <- ttestBF(
  x = p1_data$Misbinding,
  y = p1_data$Control,
  paired = TRUE
)

print(bf_p1)
bf_value_p1 <- extractBF(bf_p1)$bf

cat("\n【記述統計】\n")
cat("サンプルサイズ: n =", nrow(p1_data), "\n")
cat("Misbinding平均:", mean(p1_data$Misbinding), "\n")
cat("Control平均:", mean(p1_data$Control), "\n")
cat("差の平均:", mean(p1_data$Misbinding - p1_data$Control), "\n")
cat("差のSD:", sd(p1_data$Misbinding - p1_data$Control), "\n\n")

cat("Bayes Factor (BF10):", bf_value_p1, "\n")
cat("Bayes Factor (BF01):", 1/bf_value_p1, "\n\n")

cat("【解釈】\n")
if (bf_value_p1 > 10) {
  cat("強い証拠で差がある (Strong evidence for H1)\n")
} else if (bf_value_p1 > 3) {
  cat("中程度の証拠で差がある (Moderate evidence for H1)\n")
} else if (bf_value_p1 > 1) {
  cat("弱い証拠で差がある (Anecdotal evidence for H1)\n")
} else if (bf_value_p1 > 1/3) {
  cat("証拠不十分 (Inconclusive)\n")
} else if (bf_value_p1 > 1/10) {
  cat("中程度の証拠で差がない (Moderate evidence for H0)\n")
} else {
  cat("強い証拠で差がない (Strong evidence for H0)\n")
}

# 事後分布のサンプリング
cat("\n【事後分布の統計量】\n")
chains_p1 <- posterior(bf_p1, iterations = 10000)
print(summary(chains_p1))

# ====================
# p2のベイズ対応のあるt検定
# ====================

# ベイズ対応のあるt検定
bf_p2 <- ttestBF(
  x = p2_data$Misbinding,
  y = p2_data$Control,
  paired = TRUE
)
print(bf_p2)
bf_value_p2 <- extractBF(bf_p2)$bf

cat("\n【記述統計】\n")
cat("サンプルサイズ: n =", nrow(p2_data), "\n")
cat("Misbinding平均:", mean(p2_data$Misbinding), "\n")
cat("Control平均:", mean(p2_data$Control), "\n")
cat("差の平均:", mean(p2_data$Misbinding - p2_data$Control), "\n")
cat("差のSD:", sd(p2_data$Misbinding - p2_data$Control), "\n\n")

cat("【ベイズ因子】\n")
cat("Bayes Factor (BF10):", bf_value_p2, "\n")
cat("Bayes Factor (BF01):", 1/bf_value_p2, "\n\n")

# 解釈
cat("【解釈】\n")
if (bf_value_p2 > 10) {
  cat("強い証拠で差がある (Strong evidence for H1)\n")
} else if (bf_value_p2 > 3) {
  cat("中程度の証拠で差がある (Moderate evidence for H1)\n")
} else if (bf_value_p2 > 1) {
  cat("弱い証拠で差がある (Anecdotal evidence for H1)\n")
} else if (bf_value_p2 > 1/3) {
  cat("証拠不十分 (Inconclusive)\n")
} else if (bf_value_p2 > 1/10) {
  cat("中程度の証拠で差がない (Moderate evidence for H0)\n")
} else {
  cat("強い証拠で差がない (Strong evidence for H0)\n")
}

# 事後分布のサンプリング
cat("\n【事後分布の統計量】\n")
chains_p2 <- posterior(bf_p2, iterations = 10000)
print(summary(chains_p2))


###############################################################################
#violin plot for each parameters
p1_long <- p1_data %>%
  pivot_longer(cols = c(Misbinding, Control),
               names_to = "Condition",
               values_to = "Value") %>%
  mutate(Parameter = "p1 (Threshold)")

p2_long <- p2_data %>%
  pivot_longer(cols = c(Misbinding, Control),
               names_to = "Condition",
               values_to = "Value") %>%
  mutate(Parameter = "p2 (Slope)")


# p1のプロット
p1_plot <- ggplot(p1_long, aes(x = Condition, y = Value)) +
  geom_violin(fill = "#8da0cb", alpha = 0.6) +
  geom_line(aes(group = Subnum, color = factor(Subnum)), 
            linewidth = 1, alpha = 0.7) +
  geom_point(aes(color = factor(Subnum)), size = 3, alpha = 0.7) +
  labs(x = NULL,
       y = "Threshold", 
       color = "Subject") +
  theme_minimal() +
  theme(legend.position = "right")+
  stat_summary(fun = mean, geom = "point", size = 2.5)

ggsave("p1.png", p1_plot, width = 4, height = 3, dpi = 300)


# p2のプロット
p2_plot <- ggplot(p2_long, aes(x = Condition, y = Value)) +
  geom_violin(fill = "#fc8d62", alpha = 0.6) +
  geom_line(aes(group = Subnum, color = factor(Subnum)), 
            linewidth = 1, alpha = 0.7) +
  geom_point(aes(color = factor(Subnum)), size = 3, alpha = 0.7) +
  labs(x = NULL,
       y = "Slope", 
       color = "Subject") +
  theme_minimal() +
  theme(legend.position = "right")+
  stat_summary(fun = mean, geom = "point", size = 2.5)

ggsave("p2.png", p2_plot, width = 4, height = 3, dpi = 300)

