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
library(effectsize)

# -----------------------------------------------------------------------------
# 1. Load and preprocess data
# -----------------------------------------------------------------------------

EXCLUDED_SUBS <- c(7, 11)

# All 12 participants
data_all <- read.csv("CCMAEexp1.csv") %>%
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
    ),
    nowblocktype = factor(nowblocktype, levels = c(1, 2),
                          labels = c("Misbinding", "Control")),
    test_color   = factor(test_color,   levels = c(0, 1),
                          labels = c("Test: red", "Test: green"))
  )

# Excluded participants (sub 7 & 11 removed)
data_excluded <- data_all %>%
  filter(!(Subnum %in% EXCLUDED_SUBS))

# Strip label colors: red for excluded participants
strip_colors <- data_all %>%
  distinct(Subnum) %>%
  arrange(Subnum) %>%
  mutate(color = ifelse(Subnum %in% EXCLUDED_SUBS, "red", "black")) %>%
  pull(color)

# -----------------------------------------------------------------------------
# 2. Fit psychometric functions
#    fit_all:      all 12 participants
#    fit_excluded: 10 participants (sub 7 & 11 removed)
# -----------------------------------------------------------------------------

fit_all      <- quickpsy(data_all,      sospeed, opposite_to_ind_response,
                         grouping = c("nowblocktype", "Subnum"))
fit_excluded <- quickpsy(data_excluded, sospeed, opposite_to_ind_response,
                         grouping = c("nowblocktype", "Subnum"))

print(fit_excluded$par)

curves_all      <- fit_all$curves
avgs_all        <- fit_all$averages
curves_excluded <- fit_excluded$curves
avgs_excluded   <- fit_excluded$averages

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
# 4. fit_all: group-average psychometric functions (10 participants only)
# -----------------------------------------------------------------------------

fit_excluded_plot <- ggplot() +
  # Individual observed means
  geom_point(
    data = avgs_excluded,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.45, shape = 16
  ) +
  # Individual fitted curves
  geom_line(
    data = curves_excluded,
    aes(x = x, y = y, group = interaction(nowblocktype, Subnum), color = nowblocktype),
    linewidth = 0.45, alpha = 0.35
  ) +
  # Group mean curves (pointwise mean of individual fitted curves)
  stat_summary(
    data = curves_excluded,
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

ggsave("fit_excluded.png", fit_excluded_plot, width = 9, height = 7, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 5. fit_individual: all 12 participants (excluded = red strip label)
# -----------------------------------------------------------------------------

individual_plot <- ggplot() +
  geom_point(
    data = avgs_all,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.7, shape = 16
  ) +
  geom_line(
    data = curves_all,
    aes(x = x, y = y, color = nowblocktype, group = nowblocktype),
    linewidth = 0.8
  ) +
  geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  facet_wrap(~ Subnum, ncol = 6) +
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
    legend.position = "top",
    axis.text.x     = element_text(size = 8, angle = 45, hjust = 1),
    axis.text.y     = element_text(size = 8),
    strip.text      = element_text(size = 9, face = "plain",
                                   color = strip_colors),
    panel.spacing   = unit(0.8, "lines")
  )

ggsave("fit_individual.png", individual_plot,
       width = 21, height = 12, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 6. Bayesian paired t-tests on PSE (p1) and slope (p2)
#    Uses fit_excluded (10 participants)
# -----------------------------------------------------------------------------

dat_wide <- fit_excluded$par %>%
  pivot_wider(
    names_from  = nowblocktype,
    values_from = par,
    id_cols     = c(Subnum, parn)
  )

p1_data <- dat_wide %>% filter(parn == "p1") %>% select(-parn)
p2_data <- dat_wide %>% filter(parn == "p2") %>% select(-parn)

# --- Frequentist one-sample t-test (preregistered) ---
cat("\n=== Frequentist one-sample t-test (PSE difference vs. 0) ===\n")
pse_diff <- p1_data$Misbinding - p1_data$Control
t_pse    <- t.test(pse_diff, mu = 0)
d_pse    <- cohens_d(pse_diff, mu = 0)
cat("t(", t_pse$parameter, ") =", round(t_pse$statistic, 3),
    ", p =", round(t_pse$p.value, 4),
    ", mean diff =", round(mean(pse_diff), 4),
    ", 95% CI = [", round(t_pse$conf.int[1], 4), ",",
    round(t_pse$conf.int[2], 4), "]\n")
print(d_pse)

interpret_bf <- function(bf) {
  if      (bf > 10)   "Strong evidence for H1"
  else if (bf > 3)    "Moderate evidence for H1"
  else if (bf > 1)    "Anecdotal evidence for H1"
  else if (bf > 1/3)  "Inconclusive"
  else if (bf > 1/10) "Moderate evidence for H0"
  else                "Strong evidence for H0"
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
# 7. Violin plots for PSE and slope
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
# 8. Export data for publication (one CSV per figure panel)
# -----------------------------------------------------------------------------

write.csv(avgs_excluded,                            file = "Figure2a_data.csv", row.names = FALSE)
write.csv(filter(fit_excluded$par, parn == "p1"),   file = "Figure2b_data.csv", row.names = FALSE)
write.csv(filter(fit_excluded$par, parn == "p2"),   file = "Figure2c_data.csv", row.names = FALSE)

# -----------------------------------------------------------------------------
# 9. Supplementary: individual raw response rates for all 12 participants
#    - Red test dots:   downward response rate vs. testspeed (downward positive)
#    - Green test dots: upward response rate   vs. testspeed (upward positive)
#    Excluded participants (sub 7 & 11) are shown with red strip labels.
# -----------------------------------------------------------------------------

# Red: downward response rate (positive x = downward motion)
summary_red <- data_all %>%
  filter(test_color == "Test: red") %>%
  group_by(Subnum, nowblocktype, testspeed) %>%
  summarise(pct_down = mean(keypress) * 100, .groups = "drop")

plot_red <- ggplot(summary_red,
                   aes(x = testspeed, y = pct_down,
                       color = nowblocktype, group = nowblocktype)) +
  geom_point(size = 1.5, alpha = 0.8) +
  geom_line(linewidth = 0.7) +
  geom_hline(yintercept = 50, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  facet_wrap(~ Subnum, ncol = 6) +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25)) +
  labs(
    x     = "Test speed – downward motion (°/s)",
    y     = "Downward response rate (%)",
    color = NULL
  ) +
  theme_publication() +
  theme(
    legend.position = "top",
    axis.text.x     = element_text(size = 8, angle = 45, hjust = 1),
    strip.text      = element_text(size = 9, face = "plain",
                                   color = strip_colors),
    panel.spacing   = unit(0.8, "lines")
  )

# Green: upward response rate (positive x = upward motion)
# upward rate = 1 - downward rate (keypress = 1 means downward)
summary_green <- data_all %>%
  filter(test_color == "Test: green") %>%
  mutate(testspeed_up = -testspeed) %>%
  group_by(Subnum, nowblocktype, testspeed_up) %>%
  summarise(pct_up = (1 - mean(keypress)) * 100, .groups = "drop")

plot_green <- ggplot(summary_green,
                     aes(x = testspeed_up, y = pct_up,
                         color = nowblocktype, group = nowblocktype)) +
  geom_point(size = 1.5, alpha = 0.8) +
  geom_line(linewidth = 0.7) +
  geom_hline(yintercept = 50, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  facet_wrap(~ Subnum, ncol = 6) +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(breaks = c(-0.6, -0.3, 0, 0.3, 0.6)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25)) +
  labs(
    x     = "Test speed – upward motion (°/s)",
    y     = "Upward response rate (%)",
    color = NULL
  ) +
  theme_publication() +
  theme(
    legend.position = "top",
    axis.text.x     = element_text(size = 8, angle = 45, hjust = 1),
    strip.text      = element_text(size = 9, face = "plain",
                                   color = strip_colors),
    panel.spacing   = unit(0.8, "lines")
  )

ggsave("supp_individual_red_exp1.png",   plot_red,
       width = 21, height = 10, units = "cm", dpi = 300)
ggsave("supp_individual_green_exp1.png", plot_green,
       width = 21, height = 10, units = "cm", dpi = 300)