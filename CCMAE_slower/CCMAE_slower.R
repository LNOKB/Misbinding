library(quickpsy)
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(BayesFactor)
library(patchwork)

data <- read.csv("CCMAEexp_slower.csv")

data$nowblocktype <- factor(data$nowblocktype,
                            levels = c(1, 2),
                            labels = c("Misbinding", "Control"))

data$test_color <- factor(data$test_color,
                          levels = c(0, 1),
                          labels = c("Test : red", "Test : green"))

data <- data %>%
  mutate(sospeed = recode(sospeed,
                          `1` = -0.4,
                          `2` = -0.2,
                          `3` =  0,
                          `4` =  0.2,
                          `5` =  0.4))

# --- 除外被験者のfit ---
data_excluded <- data %>%
  filter(Subnum %in% c(4, 5, 6, 8, 10, 12))

fit_excluded <- quickpsy(data_excluded, sospeed, opposite_to_ind_response,
                         grouping = c("nowblocktype", "Subnum"))

curves_ex <- fit_excluded$curves
avgs_ex   <- fit_excluded$averages

# --- 共通テーマ ---
theme_publication <- function(base_size = 11) {
  theme_classic(base_size = base_size) +
    theme(
      axis.line         = element_line(linewidth = 0.5, color = "black"),
      axis.ticks        = element_line(linewidth = 0.4, color = "black"),
      axis.text         = element_text(size = base_size - 1, color = "black"),
      axis.title        = element_text(size = base_size, color = "black"),
      strip.background  = element_blank(),
      strip.text        = element_text(size = base_size - 1, color = "black"),
      legend.background = element_blank(),
      legend.key        = element_blank(),
      legend.title      = element_blank(),
      legend.text       = element_text(size = base_size - 1),
      panel.spacing     = unit(1, "lines")
    )
}

COLORS <- c("Misbinding" = "#E8826A", "Control" = "#5BB8C4")

speed_labels <- c("-0.4" = "S0.4", "-0.2" = "S0.2", "0" = "0", "0.2" = "O0.2", "0.4" = "O0.4")

individual_excluded_plot <- ggplot() +
  geom_point(
    data = avgs_ex,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.7, shape = 16
  ) +
  geom_line(
    data = curves_ex,
    aes(x = x, y = y, color = nowblocktype, group = nowblocktype),
    linewidth = 0.8
  ) +
  geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  facet_wrap(~ Subnum, ncol = 3) +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(
    breaks = c(-0.4, -0.2, 0, 0.2, 0.4),
    labels = speed_labels
  ) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = c(0, 0.5, 1),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    x     = "Test speed (°/s)",
    y     = "Response rate (%)",
    color = NULL
  ) +
  theme_publication() +
  theme(
    legend.position = "none",
    axis.text.x     = element_text(size = 8, angle = 45, hjust = 1),
    axis.text.y     = element_text(size = 8),
    strip.text      = element_text(size = 9),
    panel.spacing   = unit(0.8, "lines")
  )

ggsave("fit_excluded_slower.png", individual_excluded_plot, width = 8, height = 8, units = "cm", dpi = 300)

# --- 除外後のデータ ---
data <- data %>%
  filter(!(Subnum %in% c(4, 5, 6, 8, 10, 12)))

fit <- quickpsy(data, sospeed, opposite_to_ind_response, grouping = c("nowblocktype", "Subnum"))

write.csv(fit$par, file = "CCMAE_slower_par")

curves <- fit$curves
avgs   <- fit$averages

# --- 全体の平均プロット ---
fit_plot <- ggplot() +
  geom_point(
    data = avgs,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.45, shape = 16
  ) +
  geom_line(
    data = curves,
    aes(x = x, y = y, group = interaction(nowblocktype, Subnum), color = nowblocktype),
    linewidth = 0.45, alpha = 0.35
  ) +
  stat_summary(
    data = curves,
    aes(x = x, y = y, color = nowblocktype, group = nowblocktype),
    fun = mean, geom = "line", linewidth = 1.2
  ) +
  geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(
    breaks = c(-0.4, -0.2, 0, 0.2, 0.4),
    labels = speed_labels
  ) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.25),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    x     = "Test speed (°/s)",
    y     = "Response rate (%)",
    color = NULL
  ) +
  theme_publication() +
  theme(legend.position = c(0.78, 0.15))

ggsave("fit_all_slower.png", fit_plot, width = 9, height = 7, units = "cm", dpi = 300)

# --- 参加者ごとのプロット ---
individual_plot <- ggplot() +
  geom_point(
    data = avgs,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.7, shape = 16
  ) +
  geom_line(
    data = curves,
    aes(x = x, y = y, color = nowblocktype, group = nowblocktype),
    linewidth = 0.8
  ) +
  geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  facet_wrap(~ Subnum, ncol = 3) +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(
    breaks = c(-0.4, -0.2, 0, 0.2, 0.4),
    labels = speed_labels
  ) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = c(0, 0.5, 1),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(
    x     = "Test speed (°/s)",
    y     = "Response rate (%)",
    color = NULL
  ) +
  theme_publication() +
  theme(
    legend.position = "none",
    axis.text.x     = element_text(size = 8, angle = 45, hjust = 1),
    axis.text.y     = element_text(size = 8),
    strip.text      = element_text(size = 9, face = "plain"),
    panel.spacing   = unit(0.8, "lines")
  )

ggsave("fit_individual_slower.png", individual_plot, width = 10.8, height = 8, units = "cm", dpi = 300)

###############################################################################
# ベイズ検定

dat_wide <- fit$par %>%
  pivot_wider(
    names_from  = nowblocktype,
    values_from = par,
    id_cols     = c(Subnum, parn)
  )

p1_data <- dat_wide %>% filter(parn == "p1") %>% select(-parn)
p2_data <- dat_wide %>% filter(parn == "p2") %>% select(-parn)

bf_p1 <- ttestBF(x = p1_data$Misbinding, y = p1_data$Control, paired = TRUE)
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

cat("\n【事後分布の統計量】\n")
chains_p1 <- posterior(bf_p1, iterations = 10000)
print(summary(chains_p1))

bf_p2 <- ttestBF(x = p2_data$Misbinding, y = p2_data$Control, paired = TRUE)
print(bf_p2)
bf_value_p2 <- extractBF(bf_p2)$bf

cat("\n【記述統計】\n")
cat("サンプルサイズ: n =", nrow(p2_data), "\n")
cat("Misbinding平均:", mean(p2_data$Misbinding), "\n")
cat("Control平均:", mean(p2_data$Control), "\n")
cat("差の平均:", mean(p2_data$Misbinding - p2_data$Control), "\n")
cat("差のSD:", sd(p2_data$Misbinding - p2_data$Control), "\n\n")
cat("Bayes Factor (BF10):", bf_value_p2, "\n")
cat("Bayes Factor (BF01):", 1/bf_value_p2, "\n\n")

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

cat("\n【事後分布の統計量】\n")
chains_p2 <- posterior(bf_p2, iterations = 10000)
print(summary(chains_p2))

###############################################################################
# バイオリンプロット

p1_long <- p1_data %>%
  pivot_longer(cols = c(Misbinding, Control),
               names_to = "Condition", values_to = "Value") %>%
  mutate(Parameter = "p1 (Threshold)")

p2_long <- p2_data %>%
  pivot_longer(cols = c(Misbinding, Control),
               names_to = "Condition", values_to = "Value") %>%
  mutate(Parameter = "p2 (Slope)")

format_bf <- function(bf) {
  if (bf >= 100)      sprintf("BF[10] == '%.0f'", bf)
  else if (bf >= 10)  sprintf("BF[10] == '%.1f'", bf)
  else if (bf >= 1)   sprintf("BF[10] == '%.2f'", bf)
  else if (bf >= 0.1) sprintf("BF[10] == '%.2f'", bf)
  else                sprintf("BF[10] == '%.3f'", bf)
}

bf_label_p1 <- format_bf(bf_value_p1)
bf_label_p2 <- format_bf(bf_value_p2)

theme_violin <- function(base_size = 11) {
  theme_classic(base_size = base_size) +
    theme(
      axis.line        = element_line(linewidth = 0.5, color = "black"),
      axis.ticks       = element_line(linewidth = 0.4, color = "black"),
      axis.text        = element_text(size = base_size - 1, color = "black"),
      axis.title       = element_text(size = base_size, color = "black"),
      legend.position  = "none",
      strip.background = element_blank(),
      strip.text       = element_blank(),
      plot.title       = element_text(size = base_size, face = "plain", hjust = 0.5),
      panel.spacing    = unit(1, "lines")
    )
}

p1_plot <- ggplot(p1_long, aes(x = Condition, y = Value, fill = Condition)) +
  geom_violin(trim = TRUE, alpha = 0.30, color = NA, width = 0.7) +
  geom_line(aes(group = Subnum), linewidth = 0.55, alpha = 0.35, color = "gray50") +
  geom_point(aes(color = Condition), size = 2.2, alpha = 0.75) +
  stat_summary(fun = mean, geom = "point",
               shape = 21, size = 3.5, stroke = 1.4,
               fill = "white", aes(color = Condition)) +
  scale_fill_manual(values = COLORS) +
  scale_color_manual(values = COLORS) +
  scale_x_discrete(limits = c("Misbinding", "Control")) +
  labs(x = NULL, y = "Threshold",
       title = parse(text = bf_label_p1)) +
  theme_violin()

p2_plot <- ggplot(p2_long, aes(x = Condition, y = Value, fill = Condition)) +
  geom_violin(trim = TRUE, alpha = 0.30, color = NA, width = 0.7) +
  geom_line(aes(group = Subnum), linewidth = 0.55, alpha = 0.35, color = "gray50") +
  geom_point(aes(color = Condition), size = 2.2, alpha = 0.75) +
  stat_summary(fun = mean, geom = "point",
               shape = 21, size = 3.5, stroke = 1.4,
               fill = "white", aes(color = Condition)) +
  scale_fill_manual(values = COLORS) +
  scale_color_manual(values = COLORS) +
  scale_x_discrete(limits = c("Misbinding", "Control")) +
  labs(x = NULL, y = "Slope",
       title = parse(text = bf_label_p2)) +
  theme_violin()

combined <- p1_plot + p2_plot + plot_layout(ncol = 2)

ggsave("violin_params_slower.png", combined, width = 10, height = 6, units = "cm", dpi = 300)