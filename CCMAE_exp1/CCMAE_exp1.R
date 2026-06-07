# =============================================================================
# Experiment 1 – Color-Contingent Motion Aftereffect (CCMAE)
# Psychometric function fitting and Bayesian analysis
# =============================================================================

library(quickpsy)
library(dplyr)
library(tidyr)
library(ggplot2)
library(BayesFactor)
library(patchwork)

# -----------------------------------------------------------------------------
# 1. Load and preprocess data
# -----------------------------------------------------------------------------

data <- read.csv("CCMAEexp1.csv")

# Recode sospeed: direction relative to the inducer
# (negative = same direction as inducer, positive = opposite direction)
data <- data %>%
  mutate(
    sospeed = case_when(
      # Red stimulus, Block type 1 (inducer: red upward)
      test_color == 0 & nowblocktype == 1 & testspeed ==  0.6 ~  0.6,
      test_color == 0 & nowblocktype == 1 & testspeed ==  0.3 ~  0.3,
      test_color == 0 & nowblocktype == 1 & testspeed ==  0.0 ~  0.0,
      test_color == 0 & nowblocktype == 1 & testspeed == -0.3 ~ -0.3,
      test_color == 0 & nowblocktype == 1 & testspeed == -0.6 ~ -0.6,
      
      # Red stimulus, Block type 2 (inducer: red downward)
      test_color == 0 & nowblocktype == 2 & testspeed ==  0.6 ~ -0.6,
      test_color == 0 & nowblocktype == 2 & testspeed ==  0.3 ~ -0.3,
      test_color == 0 & nowblocktype == 2 & testspeed ==  0.0 ~  0.0,
      test_color == 0 & nowblocktype == 2 & testspeed == -0.3 ~  0.3,
      test_color == 0 & nowblocktype == 2 & testspeed == -0.6 ~  0.6,
      
      # Green stimulus, Block type 1 (inducer: green downward)
      test_color == 1 & nowblocktype == 1 & testspeed ==  0.6 ~ -0.6,
      test_color == 1 & nowblocktype == 1 & testspeed ==  0.3 ~ -0.3,
      test_color == 1 & nowblocktype == 1 & testspeed ==  0.0 ~  0.0,
      test_color == 1 & nowblocktype == 1 & testspeed == -0.3 ~  0.3,
      test_color == 1 & nowblocktype == 1 & testspeed == -0.6 ~  0.6,
      
      # Green stimulus, Block type 2 (inducer: green upward)
      test_color == 1 & nowblocktype == 2 & testspeed ==  0.6 ~  0.6,
      test_color == 1 & nowblocktype == 2 & testspeed ==  0.3 ~  0.3,
      test_color == 1 & nowblocktype == 2 & testspeed ==  0.0 ~  0.0,
      test_color == 1 & nowblocktype == 2 & testspeed == -0.3 ~ -0.3,
      test_color == 1 & nowblocktype == 2 & testspeed == -0.6 ~ -0.6,
      
      TRUE ~ NA_real_
    )
  )

# Factor labels
data <- data %>%
  mutate(
    nowblocktype = factor(nowblocktype, levels = c(1, 2),
                          labels = c("Misbinding", "Control")),
    test_color   = factor(test_color,   levels = c(0, 1),
                          labels = c("Test: red", "Test: green"))
  )

# Exclude participants with non-convergent or unreliable psychometric fits
data <- data %>%
  filter(!(Subnum %in% c(7, 11)))

# -----------------------------------------------------------------------------
# 2. Fit psychometric functions
# -----------------------------------------------------------------------------

fit <- quickpsy(data, sospeed, opposite_to_ind_response,
                grouping = c("nowblocktype", "Subnum"))

print(fit$par)

curves <- fit$curves
avgs   <- fit$averages

# -----------------------------------------------------------------------------
# 3. Shared plot theme and color palette
# -----------------------------------------------------------------------------

theme_publication <- function(base_size = 11) {
  theme_classic(base_size = base_size) +
    theme(
      axis.line         = element_line(linewidth = 0.5, color = "black"),
      axis.ticks        = element_line(linewidth = 0.4, color = "black"),
      axis.text         = element_text(size = base_size - 1, color = "black"),
      axis.title        = element_text(size = base_size,     color = "black"),
      strip.background  = element_blank(),
      strip.text        = element_text(size = base_size - 1, color = "black"),
      legend.background = element_blank(),
      legend.key        = element_blank(),
      legend.title      = element_blank(),
      legend.text       = element_text(size = base_size - 1),
      panel.spacing     = unit(1, "lines")
    )
}

COLORS       <- c("Misbinding" = "#E8826A", "Control" = "#5BB8C4")
speed_labels <- c("-0.6" = "S0.6", "-0.3" = "S0.3", "0" = "0",
                  "0.3" = "O0.3",  "0.6" = "O0.6")

# -----------------------------------------------------------------------------
# 4. Figure: group-average and individual psychometric functions
# -----------------------------------------------------------------------------

fit_plot <- ggplot() +
  # Individual observed means
  geom_point(
    data = avgs,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.45, shape = 16
  ) +
  # Individual fitted curves
  geom_line(
    data = curves,
    aes(x = x, y = y, group = interaction(nowblocktype, Subnum), color = nowblocktype),
    linewidth = 0.45, alpha = 0.35
  ) +
  # Group mean curves (pointwise mean of individual fitted curves)
  stat_summary(
    data = curves,
    aes(x = x, y = y, color = nowblocktype, group = nowblocktype),
    fun = mean, geom = "line", linewidth = 1.2
  ) +
  geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6), labels = speed_labels) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.25),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(x = "Test speed (°/s)", y = "Response rate (%)", color = NULL) +
  theme_publication() +
  theme(legend.position = c(0.78, 0.15))

ggsave("fit_all.png", fit_plot, width = 9, height = 7, units = "cm", dpi = 300)

# Individual participant plots
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
  facet_wrap(~ Subnum, ncol = 5) +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6), labels = speed_labels) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = c(0, 0.5, 1),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(x = "Test speed (°/s)", y = "Response rate (%)", color = NULL) +
  theme_publication() +
  theme(
    legend.position = "none",
    axis.text.x     = element_text(size = 8, angle = 45, hjust = 1),
    axis.text.y     = element_text(size = 8),
    strip.text      = element_text(size = 9, face = "plain"),
    panel.spacing   = unit(0.8, "lines")
  )

ggsave("fit_individual.png", individual_plot, width = 18, height = 8, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 5. Bayesian paired t-tests on PSE (p1) and slope (p2)
# -----------------------------------------------------------------------------

dat_wide <- fit$par %>%
  pivot_wider(
    names_from  = nowblocktype,
    values_from = par,
    id_cols     = c(Subnum, parn)
  )

p1_data <- dat_wide %>% filter(parn == "p1") %>% select(-parn)
p2_data <- dat_wide %>% filter(parn == "p2") %>% select(-parn)

interpret_bf <- function(bf) {
  if      (bf > 10)  "Strong evidence for H1"
  else if (bf > 3)   "Moderate evidence for H1"
  else if (bf > 1)   "Anecdotal evidence for H1"
  else if (bf > 1/3) "Inconclusive"
  else if (bf > 1/10)"Moderate evidence for H0"
  else               "Strong evidence for H0"
}

report_bf <- function(label, bf_obj, par_data) {
  bf_val <- extractBF(bf_obj)$bf
  cat(sprintf("\n--- %s ---\n", label))
  cat("n =", nrow(par_data), "\n")
  cat("Misbinding mean:", mean(par_data$Misbinding), "\n")
  cat("Control mean:",    mean(par_data$Control), "\n")
  cat("Mean difference:", mean(par_data$Misbinding - par_data$Control), "\n")
  cat("SD of difference:", sd(par_data$Misbinding - par_data$Control), "\n")
  cat("BF10:", bf_val, "\n")
  cat("BF01:", 1 / bf_val, "\n")
  cat("Interpretation:", interpret_bf(bf_val), "\n")
  bf_val
}

bf_p1       <- ttestBF(x = p1_data$Misbinding, y = p1_data$Control, paired = TRUE)
bf_value_p1 <- report_bf("PSE (p1)", bf_p1, p1_data)
chains_p1   <- posterior(bf_p1, iterations = 10000)
print(summary(chains_p1))

bf_p2       <- ttestBF(x = p2_data$Misbinding, y = p2_data$Control, paired = TRUE)
bf_value_p2 <- report_bf("Slope (p2)", bf_p2, p2_data)
chains_p2   <- posterior(bf_p2, iterations = 10000)
print(summary(chains_p2))

# -----------------------------------------------------------------------------
# 6. Violin plots for PSE and slope
# -----------------------------------------------------------------------------

theme_violin <- function(base_size = 11) {
  theme_classic(base_size = base_size) +
    theme(
      axis.line        = element_line(linewidth = 0.5, color = "black"),
      axis.ticks       = element_line(linewidth = 0.4, color = "black"),
      axis.text        = element_text(size = base_size - 1, color = "black"),
      axis.title       = element_text(size = base_size,     color = "black"),
      legend.position  = "none",
      strip.background = element_blank(),
      strip.text       = element_blank(),
      plot.title       = element_text(size = base_size, face = "plain", hjust = 0.5),
      panel.spacing    = unit(1, "lines")
    )
}

format_bf <- function(bf) {
  if      (bf >= 100) sprintf("BF[10] == '%.0f'", bf)
  else if (bf >= 10)  sprintf("BF[10] == '%.1f'", bf)
  else if (bf >= 1)   sprintf("BF[10] == '%.2f'", bf)
  else if (bf >= 0.1) sprintf("BF[10] == '%.2f'", bf)
  else                sprintf("BF[10] == '%.3f'", bf)
}

make_violin <- function(long_data, y_label, bf_val) {
  ggplot(long_data, aes(x = Condition, y = Value, fill = Condition)) +
    geom_violin(trim = TRUE, alpha = 0.30, color = NA, width = 0.7) +
    geom_line(aes(group = Subnum), linewidth = 0.55, alpha = 0.35, color = "gray50") +
    geom_point(aes(color = Condition), size = 2.2, alpha = 0.75) +
    stat_summary(fun = mean, geom = "point",
                 shape = 21, size = 3.5, stroke = 1.4,
                 fill = "white", aes(color = Condition)) +
    scale_fill_manual(values  = COLORS) +
    scale_color_manual(values = COLORS) +
    scale_x_discrete(limits = c("Misbinding", "Control")) +
    labs(x = NULL, y = y_label,
         title = parse(text = format_bf(bf_val))) +
    theme_violin()
}

p1_long <- p1_data %>%
  pivot_longer(cols = c(Misbinding, Control),
               names_to = "Condition", values_to = "Value")

p2_long <- p2_data %>%
  pivot_longer(cols = c(Misbinding, Control),
               names_to = "Condition", values_to = "Value")

combined <- make_violin(p1_long, "PSE",   bf_value_p1) +
  make_violin(p2_long, "Slope", bf_value_p2) +
  plot_layout(ncol = 2)

ggsave("violin_params.png", combined, width = 10, height = 6, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 7. Export data for publication (one CSV per figure panel)
# -----------------------------------------------------------------------------

write.csv(avgs,                        file = "Figure2a_data.csv", row.names = FALSE)
write.csv(filter(fit$par, parn == "p1"), file = "Figure2b_data.csv", row.names = FALSE)
write.csv(filter(fit$par, parn == "p2"), file = "Figure2c_data.csv", row.names = FALSE)