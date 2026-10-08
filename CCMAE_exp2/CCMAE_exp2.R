# =============================================================================
# Experiment 2 – Color-Contingent Motion Aftereffect (CCMAE)
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

EXCLUDED_SUBS <- c(5, 6, 8, 10, 12)

# Guess/lapse rate: fixed at the same literature-typical value used in
# Experiment 1 (see CCMAE_exp1/guess_lapse_note.md) rather than quickpsy's
# default of 0. The 0.2-s peripheral test stimuli make a non-zero lapse rate
# especially plausible here (Reviewer 2, Methods Point F), and fixing it at
# zero would fold extra lapses into the slope estimate -- the one measure on
# which Experiment 2 shows a condition difference. As in Experiment 1, both
# asymptotes are fixed to the same small value (see guess_lapse_note.md for
# the full rationale) rather than estimated freely, because with only 5
# speed levels per curve, per-participant estimation of guess/lapse as free
# parameters is non-identifiable.
GUESS_RATE <- 0.03
LAPSE_RATE <- 0.03

# All 12 participants
data_all <- read.csv("CCMAEexp2.csv") %>%
  mutate(
    nowblocktype = factor(nowblocktype, levels = c(1, 2),
                          labels = c("Misbinding", "Control")),
    test_color   = factor(test_color,   levels = c(0, 1),
                          labels = c("Test: red", "Test: green")),
    sospeed      = recode(sospeed,
                          `1` = -0.4, `2` = -0.2, `3` = 0,
                          `4` =  0.2, `5` =  0.4)
  )

# Excluded participants removed
data_excluded <- data_all %>%
  filter(!(Subnum %in% EXCLUDED_SUBS))

# -----------------------------------------------------------------------------
# 1b. Exclusion criterion: Cochran-Armitage trend test (Methods, Data Analysis)
#     For each participant x condition, test whether the proportion of
#     "opposite" responses increases with signed test speed, on raw trial
#     counts (no psychometric fit involved). A participant is excluded if the
#     test fails to reach a Bonferroni-corrected alpha = .05/24 (12
#     participants x 2 conditions) in at least one condition. The check below
#     confirms that this rule reproduces EXCLUDED_SUBS exactly.
# -----------------------------------------------------------------------------

CA_ALPHA <- 0.05 / 24

ca_tests <- data_all %>%
  group_by(Subnum, nowblocktype, sospeed) %>%
  summarise(k = sum(opposite_to_ind_response), n = n(), .groups = "drop") %>%
  group_by(Subnum, nowblocktype) %>%
  summarise(p = prop.trend.test(k, n, score = sospeed)$p.value, .groups = "drop")

ca_by_sub <- ca_tests %>%
  group_by(Subnum) %>%
  summarise(worst_p = max(p), excluded_by_rule = worst_p > CA_ALPHA)

cat("\n=== Cochran-Armitage trend test (exclusion criterion, alpha =",
    signif(CA_ALPHA, 3), ") ===\n")
print(as.data.frame(ca_tests), digits = 3)
print(as.data.frame(ca_by_sub), digits = 3)
stopifnot(setequal(ca_by_sub$Subnum[ca_by_sub$excluded_by_rule], EXCLUDED_SUBS))

# Strip label colors: red for excluded participants
strip_colors <- data_all %>%
  distinct(Subnum) %>%
  arrange(Subnum) %>%
  mutate(color = ifelse(Subnum %in% EXCLUDED_SUBS, "red", "black")) %>%
  pull(color)

# -----------------------------------------------------------------------------
# 2. Fit psychometric functions
#    fit_all:      all 12 participants
#    fit_excluded: participants with reliable fits only
# -----------------------------------------------------------------------------

fit_all      <- quickpsy(data_all,      sospeed, opposite_to_ind_response,
                         grouping = c("nowblocktype", "Subnum"),
                         fun = logistic_fun,
                         guess = GUESS_RATE, lapses = LAPSE_RATE)
fit_excluded <- quickpsy(data_excluded, sospeed, opposite_to_ind_response,
                         grouping = c("nowblocktype", "Subnum"),
                         fun = logistic_fun,
                         guess = GUESS_RATE, lapses = LAPSE_RATE)

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
speed_labels <- c("-0.4" = "S0.4", "-0.2" = "S0.2", "0" = "0",
                  "0.2" = "O0.2",  "0.4" = "O0.4")

# -----------------------------------------------------------------------------
# 4. fit_excluded: group-average psychometric functions (excluded subs removed)
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
  scale_x_continuous(breaks = c(-0.4, -0.2, 0, 0.2, 0.4), labels = speed_labels) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.25),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(x = "Test speed (°/s)", y = "Response rate (%)", color = NULL) +
  theme_publication() +
  theme(legend.position = c(0.78, 0.15))

ggsave("fit_excluded_exp2.png", fit_excluded_plot,
       width = 9, height = 7, units = "cm", dpi = 300)

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
  scale_x_continuous(breaks = c(-0.4, -0.2, 0, 0.2, 0.4), labels = speed_labels) +
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

ggsave("fit_individual_exp2.png", individual_plot,
       width = 21, height = 12, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 6. Bayesian paired t-tests on PSE (p1) and slope (p2)
#    Uses fit_excluded
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

# --- Frequentist one-sample t-test on slope differences (non-preregistered
#     supplementary check, reported alongside the PSE test in the Results) ---
cat("\n=== Frequentist one-sample t-test (slope difference vs. 0; non-preregistered) ===\n")
slope_diff <- p2_data$Misbinding - p2_data$Control
t_slope    <- t.test(slope_diff, mu = 0)
d_slope    <- cohens_d(slope_diff, mu = 0)
cat("t(", t_slope$parameter, ") =", round(t_slope$statistic, 3),
    ", p =", round(t_slope$p.value, 4),
    ", mean diff =", round(mean(slope_diff), 4),
    ", 95% CI = [", round(t_slope$conf.int[1], 4), ",",
    round(t_slope$conf.int[2], 4), "]\n")
print(d_slope)

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

ggsave("violin_params_exp2.png", combined, width = 10, height = 6, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 8. Export data for publication (one CSV per figure panel)
# -----------------------------------------------------------------------------

write.csv(avgs_excluded,                          file = "Figure4a_data.csv", row.names = FALSE)
write.csv(filter(fit_excluded$par, parn == "p1"), file = "Figure4b_data.csv", row.names = FALSE)
write.csv(filter(fit_excluded$par, parn == "p2"), file = "Figure4c_data.csv", row.names = FALSE)

# -----------------------------------------------------------------------------
# 9. Supplementary: individual raw response rates for all 12 participants
#    - Red test dots:   downward response rate vs. testspeed (downward positive)
#    - Green test dots: upward response rate   vs. testspeed (upward positive)
#    Excluded participants are shown with red strip labels.
# -----------------------------------------------------------------------------

# Red: downward response rate (x-axis = physical testspeed, downward positive)
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
  scale_x_continuous(breaks = c(-0.4, -0.2, 0, 0.2, 0.4)) +
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
  scale_x_continuous(breaks = c(-0.4, -0.2, 0, 0.2, 0.4)) +
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

ggsave("supp_individual_red_exp2.png",   plot_red,
       width = 21, height = 10, units = "cm", dpi = 300)
ggsave("supp_individual_green_exp2.png", plot_green,
       width = 21, height = 10, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 10. Bayesian paired t-tests on PSE (p1) and slope (p2)
#     Uses fit_all (ALL 12 participants, no exclusion)
#     Reviewer 1 #3 / Reviewer 2 Methods Point B, D: report the full sample
#     alongside the excluded-sample analysis, since ~42% of participants
#     were excluded in Experiment 2 using a non-preregistered criterion.
# -----------------------------------------------------------------------------

dat_wide_all <- fit_all$par %>%
  pivot_wider(
    names_from  = nowblocktype,
    values_from = par,
    id_cols     = c(Subnum, parn)
  )

p1_data_all <- dat_wide_all %>% filter(parn == "p1") %>% select(-parn)
p2_data_all <- dat_wide_all %>% filter(parn == "p2") %>% select(-parn)

cat("\n=== Bayesian analysis: ALL participants (n = 12, no exclusion) ===\n")

bf_p1_all       <- ttestBF(x = p1_data_all$Misbinding, y = p1_data_all$Control, paired = TRUE)
bf_value_p1_all <- report_bf("PSE (p1) - all participants", bf_p1_all, p1_data_all)
chains_p1_all   <- posterior(bf_p1_all, iterations = 10000)
print(summary(chains_p1_all))

bf_p2_all       <- ttestBF(x = p2_data_all$Misbinding, y = p2_data_all$Control, paired = TRUE)
bf_value_p2_all <- report_bf("Slope (p2) - all participants", bf_p2_all, p2_data_all)
chains_p2_all   <- posterior(bf_p2_all, iterations = 10000)
print(summary(chains_p2_all))

# -----------------------------------------------------------------------------
# 11. Bayesian paired t-tests WITHOUT pooling color (red & green fit separately)
#     Uses fit_excluded_color. Reviewer 1 #2 / Reviewer 2 Methods Point E:
#     the color-motion pairing was fixed (not counterbalanced), so a
#     color-specific bias could masquerade as (or obscure) a condition
#     effect once red and green are pooled.
# -----------------------------------------------------------------------------

fit_excluded_color <- quickpsy(data_excluded, sospeed, opposite_to_ind_response,
                               grouping = c("nowblocktype", "test_color", "Subnum"),
                               fun = logistic_fun,
                               guess = GUESS_RATE, lapses = LAPSE_RATE)

curves_excluded_color <- fit_excluded_color$curves
avgs_excluded_color   <- fit_excluded_color$averages

dat_wide_color <- fit_excluded_color$par %>%
  pivot_wider(
    names_from  = nowblocktype,
    values_from = par,
    id_cols     = c(Subnum, test_color, parn)
  )

cat("\n=== Bayesian analysis WITHOUT pooling color (red & green fit separately) ===\n")

bf_by_color <- list()

for (parn_label in c("p1", "p2")) {
  y_label <- if (parn_label == "p1") "PSE" else "Slope"
  par_data <- dat_wide_color %>% filter(parn == parn_label)

  for (col in levels(par_data$test_color)) {
    sub_data <- par_data %>% filter(test_color == col)
    bf_obj   <- ttestBF(x = sub_data$Misbinding, y = sub_data$Control, paired = TRUE)
    label    <- sprintf("%s (%s)", y_label, col)
    bf_val   <- report_bf(label, bf_obj, sub_data)
    bf_by_color[[paste(parn_label, col)]] <- bf_val

    # Frequentist paired t-test on the same data (reported in the response
    # letter alongside the color-separated BFs)
    t_col <- t.test(sub_data$Misbinding, sub_data$Control, paired = TRUE)
    cat("Paired t-test: t(", t_col$parameter, ") =", round(t_col$statistic, 3),
        ", p =", round(t_col$p.value, 4), "\n")
  }
}

fit_excluded_bycolor_plot <- ggplot() +
  geom_point(
    data = avgs_excluded_color,
    aes(x = sospeed, y = prob, color = nowblocktype),
    size = 1.8, alpha = 0.45, shape = 16
  ) +
  geom_line(
    data = curves_excluded_color,
    aes(x = x, y = y, group = interaction(nowblocktype, Subnum), color = nowblocktype),
    linewidth = 0.45, alpha = 0.35
  ) +
  stat_summary(
    data = curves_excluded_color,
    aes(x = x, y = y, color = nowblocktype, group = nowblocktype),
    fun = mean, geom = "line", linewidth = 1.2
  ) +
  geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.4, color = "gray60") +
  facet_wrap(~ test_color) +
  scale_color_manual(values = COLORS) +
  scale_x_continuous(breaks = c(-0.4, -0.2, 0, 0.2, 0.4), labels = speed_labels) +
  scale_y_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.25),
    labels = scales::percent_format(accuracy = 1)
  ) +
  labs(x = "Test speed (°/s)", y = "Response rate (%)", color = NULL) +
  theme_publication() +
  theme(legend.position = "top")

ggsave("fit_excluded_bycolor_exp2.png", fit_excluded_bycolor_plot,
       width = 16, height = 8, units = "cm", dpi = 300)

# -----------------------------------------------------------------------------
# 12. Formal test of color symmetry (Reviewer 1 #2; Reviewer 2 Methods-E /
#     Procedure-B). See CCMAE_exp1/CCMAE_exp1.R section 13 for the identical
#     approach applied to Experiment 1.
# -----------------------------------------------------------------------------

cat("\n=== Color-symmetry test: is the Misbinding-Control effect the same for red and green test stimuli? ===\n")

color_diff_wide <- dat_wide_color %>%
  mutate(diff = Misbinding - Control) %>%
  select(Subnum, test_color, parn, diff) %>%
  pivot_wider(names_from = test_color, values_from = diff, id_cols = c(Subnum, parn))

bf_color_symmetry <- list()

for (parn_label in c("p1", "p2")) {
  y_label  <- if (parn_label == "p1") "PSE" else "Slope"
  sub_data <- color_diff_wide %>% filter(parn == parn_label)

  bf_obj <- ttestBF(x = sub_data[["Test: red"]], y = sub_data[["Test: green"]], paired = TRUE)
  bf_val <- extractBF(bf_obj)$bf

  cat(sprintf("\n--- Color symmetry: %s (red diff vs. green diff) ---\n", y_label))
  cat("n =", nrow(sub_data), "\n")
  cat("Red (Misbinding-Control) mean:",   mean(sub_data[["Test: red"]]),   "\n")
  cat("Green (Misbinding-Control) mean:", mean(sub_data[["Test: green"]]), "\n")
  cat("BF10 (red vs. green difference):", bf_val, "\n")
  cat("BF01:", 1 / bf_val, "\n")
  cat("Interpretation:", interpret_bf(bf_val), "\n")

  bf_color_symmetry[[parn_label]] <- bf_val
}

# -----------------------------------------------------------------------------
# 13. Supplementary check (response letter, Reviewer 2 Methods Point F):
#     guess fixed at 0, lapse estimated freely per participant (3-parameter
#     fit). With only 5 speed levels per curve this fit is unstable: lapse
#     estimates can fall outside [0, 1] and slopes can change drastically
#     relative to the fixed guess = lapse = 0.03 fit used in the main analysis.
#     Not used for any reported inference.
# -----------------------------------------------------------------------------

fit_free_lapse <- quickpsy(data_all, sospeed, opposite_to_ind_response,
                           grouping = c("nowblocktype", "Subnum"),
                           fun = logistic_fun,
                           guess = 0, lapses = TRUE, bootstrap = "none")

free_lapse_compare <- fit_free_lapse$par %>%
  pivot_wider(names_from = parn, values_from = par,
              id_cols = c(nowblocktype, Subnum)) %>%
  rename(slope_free = p2, lapse_free = p3) %>%
  left_join(fit_all$par %>% filter(parn == "p2") %>%
              select(nowblocktype, Subnum, slope_fixed = par),
            by = c("nowblocktype", "Subnum")) %>%
  mutate(excluded = Subnum %in% EXCLUDED_SUBS)

cat("\n=== Free-lapse (guess = 0) fit: lapse estimates and slope vs. fixed 0.03 fit ===\n")
print(as.data.frame(free_lapse_compare %>% select(-p1)), digits = 3)
cat("Cells with negative lapse estimates:",
    sum(free_lapse_compare$lapse_free < 0), "of", nrow(free_lapse_compare), "\n")

# -----------------------------------------------------------------------------
# 14. Save fit objects for cross-script reuse (e.g. by
#     Perception_manuscript/revision/bayesian_sensitivity_analysis.R), so
#     that combining Experiment 1 and Experiment 2 results does not require
#     sourcing both scripts into the same R session (their objects share
#     names and would overwrite each other).
# -----------------------------------------------------------------------------

saveRDS(list(fit_all = fit_all, fit_excluded = fit_excluded,
             fit_excluded_color = fit_excluded_color),
        file = "fit_objects_exp2.rds")