# Response to Reviewers — PEC-26-0124

We thank both reviewers for their careful, constructive reading of the manuscript. Both raised substantially overlapping concerns — the adequacy of the control condition, the confirmatory status of the Experiment 2 slope effect, the exclusion criterion, the lapse/guess-rate assumption, sample size and sensitivity, the strength of language used to describe anecdotal-to-moderate Bayes factors, and the fixed (rather than counterbalanced) color–motion pairing — and we have revised the manuscript substantially in response. Reviewer comments are reproduced in full below (indented, in italics), followed by our response. Manuscript quotations refer to the revised document (`Perception_main_document.md`); new supplementary material is in `Perception_supplementary_file.md` (Supplementary Tables 1–2); new analysis code is in `bayesian_sensitivity_analysis.R` and `hierarchical_glmm_check.R`.

---

## Reviewer 1

> *This manuscript re-examines the misbinding-induced color-contingent motion aftereffect reported by Zhang et al. (2014, 2016). The question is important, and the study has several strengths, including preregistration of Experiment 1, open data and code, psychometric-function fitting, and complementary Bayesian analyses. However, the present evidence is not sufficiently diagnostic to support the conclusion that the original effect is not robust. Several design and analysis issues substantially limit the interpretation.*

We thank the reviewer for this summary and have substantially moderated the manuscript's conclusions in response to the points below.

### Major comments

**1.**

> *The misbinding percept was not independently verified.*
> *The null aftereffect is interpretable only if participants reliably experienced color–motion misbinding during adaptation. No perceptual report or manipulation check was included. Thus, the absence of a PSE shift could reflect either a weak aftereffect or insufficient induction of the illusion itself. This limitation should be made central to the conclusions; ideally, misbinding strength should be measured in the same observers.*

**Response.** We agree this is an important limitation. The [Discussion](./Perception_main_document.md#discussion) now names it directly as one factor behind an undetected aftereffect ("our control condition may not cleanly isolate misbinding from ordinary sensory adaptation"). In this letter we can be more explicit about why: in the misbinding condition, physically moving dots occupy the effect-part region throughout adaptation, whereas in the control condition that region receives no stimulation at all — so our design cannot distinguish a genuine misbinding-induced effect from ordinary local motion adaptation in the physically stimulated effect part (see also our response to Reviewer 2, Interpretation Point A). We did not add a manipulation check to the present experiments (doing so would require new data collection), but we agree that a design with a manipulation check is needed for a decisive test, and we flag this as a priority for follow-up work.

**2.**

> *Color–motion pairing was confounded with adaptation condition.*
> *Unlike Zhang et al. (2014), the present study fixed the color–motion pairing rather than counterbalancing it. Consequently, adaptor condition is confounded with specific colors and motion directions. This is not a trivial simplification, particularly when testing a small effect. The manuscript should not describe the experiment as methodologically identical to the original study. Color-specific results should also be reported separately.*

**Response.** We now flag this departure from Zhang et al. (2014) in the [Introduction](./Perception_main_document.md#introduction), rather than only in the [Results](./Perception_main_document.md#results) ([Introduction](./Perception_main_document.md#introduction), final paragraph: "Unlike Zhang et al. (2014), who counterbalanced the color–motion pairing of the adaptor across participants, we fixed this pairing within each adaptation condition to simplify the design... This is a departure from a fully direct replication of the original study"), and no longer describe the study as methodologically identical or a "direct" test. We also now report color-specific results, with a pointer from the [Results](./Perception_main_document.md#results) to the full analysis in the Supplementary Material (Supplementary Figure 1). This analysis is one of the more interesting findings of the revision: for **red** test stimuli alone, the misbinding condition showed a PSE shift relative to control supported by *moderate* evidence (BF₁₀ = 6.37; a standard paired *t*-test on the same data agrees, *t*(9) = −3.27, *p* = .010), while green test stimuli alone showed none (BF₁₀ = 0.43; *t*(9) = 0.88, *p* = .40); a direct red-vs-green comparison found only anecdotal evidence that the two differ (BF₁₀ = 2.15). Because the pairing was fixed rather than counterbalanced, we cannot determine whether this reflects a genuine color-specific misbinding effect or an unrelated response bias, and we say so explicitly.

We would also note two reasons for caution before this is read as a strong finding. First, pooling across test colors is not simply a simplification on our part: it follows Zhang et al. (2014) directly, who report finding similar results across color–motion pairing combinations and pooling for that reason. Second, the color-separated comparison was not a planned analysis, so we have no basis for judging whether our sample size provides adequate power for a test of this kind; unlike the pooled PSE and slope comparisons, we have not run a design-sensitivity analysis for the color-separated contrast specifically.

The corresponding Experiment 2 color-separated analysis showed no comparable asymmetry (Supplementary Material; both colors anecdotal, BF₁₀ = 1.50 and 1.03).

**3.**

> *The effective samples are too small, particularly after post hoc exclusions.*
> *Two of twelve participants were excluded from Experiment 1 and five of twelve from Experiment 2 using a criterion that was not preregistered. Experiment 2 therefore rests on only seven participants. The authors should provide an objective exclusion rule, clarify whether exclusions were made blind to condition effects, and report all analyses with and without exclusions. The current samples are insufficient for strong evidence of absence.*

**Response.** We have made two changes. First, we now report the corresponding all-participant (no-exclusion) analyses alongside every excluded-sample analysis throughout the [Results](./Perception_main_document.md#results) (e.g., Experiment 1 PSE: BF₁₀ = 0.34 with n = 12 vs. 0.37 with n = 10; Experiment 2 slope: BF₁₀ = 0.85 with n = 12 vs. 1.84 with n = 7); none of our qualitative conclusions changed. Second, we added a design-sensitivity analysis ([Results](./Perception_main_document.md#results); full detection rates by effect size and sample size in Supplementary Table 1) showing that at our retained sample sizes, a true medium effect (d = 0.5) would reach BF₁₀ > 3 in only 18–24% of simulated replications, and a small effect (d = 0.2) in under 6%. We now describe our null results as inconclusive with respect to a small-to-moderate effect rather than as evidence of its absence ([Results](./Perception_main_document.md#results)).

**4.**

> *The Bayesian results provide only weak evidence for the null.*
> *The reported BF₁₀ values of 0.37 and 0.44 only modestly favor the null. They do not establish equivalence or convincingly rule out a smaller version of the original effect. Claims such as "no robust aftereffect" and "no credible difference" should therefore be softened. The authors should report interval estimates, prior-sensitivity analyses, and preferably an equivalence or interval-null analysis based on the original effect size.*

**Response.** We softened the overstated claims ("no robust aftereffect," "no credible difference," "fragile") throughout the [Abstract](./Perception_main_document.md#abstract), [Results](./Perception_main_document.md#results), and [Discussion](./Perception_main_document.md#discussion) (see also our response to Minor #2 below), and we added the prior-sensitivity and design-sensitivity analyses requested (Supplementary Table 1; described in the [Results](./Perception_main_document.md#results)). Every reported comparison's qualitative conclusion was stable across four Cauchy prior widths (r = 0.2, 1/√2, 1, √2). We were not able to compute a formal replication Bayes factor (Verhagen & Wagenmakers, 2014) or an interval-null/equivalence test anchored to Zhang et al. (2014)'s effect size, because Zhang et al. (2014) report only significance levels (p-values) for the relevant comparisons, not effect sizes or the descriptive statistics (e.g., condition means and SDs of the PSE shift) needed to compute one.

**5.**

> *The slope effect in Experiment 2 is not specific to misbinding.*
> *The misbinding condition contained moving dots in the peripheral effect region, whereas the control condition left that region blank. A shallower psychometric slope could therefore result from ordinary local motion adaptation, masking, or increased visual noise rather than misbinding. The slope difference should not be interpreted as evidence that misbinding reduces motion-direction sensitivity without a physically matched control.*

**Response.** We agree. The [Discussion](./Perception_main_document.md#discussion) now names this directly as a factor that could have masked or produced a misbinding-independent version of the Experiment 2 slope result ("our control condition may not cleanly isolate misbinding from ordinary sensory adaptation"). We give the underlying reasoning in full in our response to Reviewer 2, Interpretation Point A below, which raises the identical point in more detail: the effect part was physically stimulated throughout adaptation in the misbinding condition, with each adaptor renewed by a 5-s top-up, but left entirely unstimulated in the control condition — so the design cannot separate a genuine misbinding effect from ordinary local motion adaptation or masking. Accordingly, we no longer present the Experiment 2 slope result as evidence that misbinding reduces motion-direction sensitivity; we now describe it as exploratory throughout (see also our response to Major #8). We did not add a physically matched control to the present experiments because this control was not part of Zhang et al. (2014)'s original design either: since our aim was to replicate their study as closely as possible, we prioritized fidelity to the original design over introducing a new control condition that would have made the two studies less directly comparable.

**6.**

> *Fixation was not monitored.*
> *Because the critical stimulus and test were presented in a restricted peripheral region, eye movements could alter retinal eccentricity, adaptation strength, and illusion magnitude. The absence of eye tracking is especially problematic when interpreting a null result and should be acknowledged more explicitly.*

**Response.** We revised the [Procedure](./Perception_main_document.md#procedure) to acknowledge this more explicitly rather than only asserting that the illusion is spatially distributed: "However, because the test stimulus itself was brief (0.2 s) and confined to a narrow peripheral strip, small eye movements could still have altered its retinal eccentricity or displaced it toward the adapted or unadapted region; we did not verify fixation stability directly, and we treat this as an open limitation, particularly for interpreting the null PSE results." This is echoed in the [Discussion](./Perception_main_document.md#discussion)'s limitations paragraph.

**7.**

> *The psychometric analysis requires stronger justification.*
> *The authors fixed lapse and guessing rates at zero and excluded participants with poorly behaved functions. Given the small sample and limited speed levels, a hierarchical trial-level psychometric model would be more appropriate. At minimum, the authors should justify the fitting choices and report analyses of unpooled red- and green-test data.*

**Response.** This comment had three parts. On lapse and guessing rates fixed at zero, we refit both experiments with these rates fixed at 0.03 (Wichmann & Hill, 2001) instead, and updated the [Methods](./Perception_main_document.md#methods) to justify this choice and to note why per-participant free estimation of these rates was not viable with only five speed levels per curve. On the exclusion of "poorly behaved" participants, this is addressed under Major #3 above, where we added a quantitative post hoc description of the exclusion criterion and now report full-sample analyses alongside the excluded-sample ones. On the suggestion that a hierarchical trial-level model would be more appropriate, we implemented this as a supplementary robustness check (`hierarchical_glmm_check.R`; Supplementary Table 2), using `lme4::glmer` with per-participant random intercepts and slopes (a frequentist partial-pooling model) rather than `brms`/Stan, because our environment does not have a working C++ toolchain to compile Stan models; `glmer` implements the same hierarchical shrinkage logic the comment is asking for, without requiring every "poorly behaved" participant to be hard-excluded. For both experiments, this model agrees with the two-stage analysis on the PSE term (no credible condition effect in either sample), and full results for both the condition and speed-by-condition terms, in both experiments, are reported in Supplementary Table 2. Finally, the unpooled red/green analyses requested are reported in full for both experiments (see response to Major #2).

**8.**

> *Experiment 2 should be treated as exploratory.*
> *Experiment 2 was not independently preregistered, followed the null result of Experiment 1, and retained only seven participants. Its slope effect should therefore be described as exploratory rather than as a firm basis for theoretical interpretation.*

**Response.** We now describe the Experiment 2 slope effect as exploratory and hypothesis-generating in the [Abstract](./Perception_main_document.md#abstract) ("should be treated as an exploratory, hypothesis-generating result rather than confirmatory evidence for a specific mechanism") and [Discussion](./Perception_main_document.md#discussion) (where it is referred to as "the exploratory Experiment 2 slope result"). The [Results](./Perception_main_document.md#results) state plainly that Experiment 2 "was not independently preregistered" and report the reduced retained sample (n = 7 of 12) directly.

### Minor comments

**1.**

> *The title overstates the evidence. A more appropriate title would be* Limited Evidence for a Motion Aftereffect Contingent on Misbound Color *or* A Re-examination of the Motion Aftereffect Contingent on Misbound Color*.*

**Response.** We adopted the reviewer's suggested title, **"Limited Evidence for a Motion Aftereffect Contingent on Misbound Color."**

**2.**

> *Please distinguish more carefully between a nonsignificant result, evidence favoring the null, and evidence of practical equivalence.*

**Response.** We removed "no credible difference" and "fragile" throughout the manuscript, both in the specific passages you quote and elsewhere, replacing them with more calibrated language (in most cases, simply reporting the Bayes factors themselves rather than a categorical verbal gloss), so as to keep this distinction in view rather than collapsing it.

**3.**

> *Report confidence or credible intervals for the PSE differences and clarify block order, counterbalancing, practice, and possible carry-over effects.*

**Response.** We added 95% CIs for both experiments' PSE and slope mean differences in the [Results](./Perception_main_document.md#results), and clarified block order in the [Procedure](./Perception_main_document.md#procedure): block order was fully randomized for each participant, subject only to the constraint that each of the 20 blocks was drawn from a set containing exactly 10 misbinding and 10 control blocks. As noted in response to Major #2, the color–motion pairing was not counterbalanced; we now flag this earlier and more prominently rather than adding it here.

**4.**

> *The discussion should avoid presenting low-level adaptation and higher-level inference as mutually exclusive explanations.*

**Response.** Added to the [Discussion](./Perception_main_document.md#discussion) ("Nor do we intend low-level adaptation and higher-level inference as mutually exclusive explanations: a perceptual process that resolves peripheral ambiguity by borrowing central feature bindings could still leave a residual, low-level adaptation signature...").

### Closing recommendation

> *The question is worthwhile, but the current design does not provide a decisive test of the original finding. I recommend major revision. The conclusions should be substantially moderated, and the authors should provide sensitivity analyses, all-participant results, color-separated analyses, and a clearer treatment of the design confounds. A stronger revision would include a larger preregistered experiment with counterbalanced pairings, fixation monitoring, a manipulation check of misbinding, and a physically matched control condition.*

**Response.** We have provided the sensitivity analyses, all-participant results, color-separated analyses, and clearer treatment of design confounds requested, and moderated our conclusions throughout, all as detailed above. The larger preregistered, counterbalanced, fixation-monitored experiment with a physically matched control is, we agree, the appropriate next step; it was not feasible within the scope of this revision, and we now say so explicitly and frame it as a direction for future work ([Discussion](./Perception_main_document.md#discussion)).

---

## Reviewer 2

> *Reviewer Report*
> *Manuscript PEC-26-0124 — Perception*
> *No Robust Motion Aftereffect Contingent on Misbound Color*
>
> *Summary*
> *I enjoyed reading this manuscript, and I think it addresses a genuinely valuable question. The paper (submitted to Perception, PEC-26-0124) asks whether the colour–motion misbinding illusion seen in peripheral vision (Wu et al., 2004) induces a colour-contingent motion aftereffect (CCMAE), as reported by Zhang et al. (2014). The stated aim is to test this claim across a wider range of motion speeds than previously examined.*
>
> *Experiment 1 closely follows the procedure of Zhang et al. (2014), using test speeds of ±0.6, ±0.3, and 0°/s; of the twelve participants recruited, two were excluded, leaving ten for analysis. Experiment 2 uses slower test speeds (±0.4, ±0.2, and 0°/s); of the twelve participants recruited, five were excluded, leaving seven. In both experiments, psychometric functions were fitted to observers' directional judgments, and the point of subjective equality (PSE) and the slope parameter were compared between the misbinding and control conditions using Bayesian paired t-tests.*
>
> *Neither experiment yields credible evidence for a shift in PSE (Experiment 1: BF₁₀ = 0.37 for PSE and 0.31 for slope; Experiment 2: BF₁₀ = 0.44 for PSE). In Experiment 2 only, the psychometric functions are steeper in the control condition than in the misbinding condition, which the authors read as reduced motion-direction sensitivity following adaptation to the misbinding stimulus (BF₁₀ = 4.14, moderate evidence).*
>
> *The authors conclude that the misbinding-induced CCMAE is more fragile than previously assumed, or alternatively that misbinding arises from a higher-level perceptual inference that does not strongly modulate the motion-selective neurons driving directional aftereffects.*
>
> *A note on scope: the comments below draw on both the main manuscript and the Supplementary file (individual-participant Supplementary Figures 1–4). I found the individual-participant data especially helpful for thinking about the exclusion procedure, and I refer to them where they seem relevant. I hope these suggestions are read in the constructive spirit in which they are intended.*

We thank the reviewer for an unusually thorough and constructive review, including the close reading of the individual-participant Supplementary Figures. We address the review section by section below.

### 1. Appropriateness of the Research Aims

> *The overall aim strikes me as sound and worthwhile: the study revisits a finding that has rarely been replicated (Zhang et al., 2014) and places it within a genuinely interesting theoretical debate about whether peripheral misbinding reflects low-level feature binding or the summary-statistic character of peripheral encoding. I noticed two small places where the stated aim and the actual manipulation could be brought into closer alignment.*
>
> *Point A: The phrase "a broader range of motion speeds" might be worth revisiting.*
> *The Abstract and Introduction both state:*
> *"We tested this claim directly by measuring misbinding CCMAE across a broader range of motion speeds than previously examined."*
> *In practice, Experiment 1 uses speeds identical to those of Zhang et al. (2014) (±0.6, ±0.3, 0°/s), and Experiment 2 uses slower speeds (±0.4, ±0.2, 0°/s), which lowers the maximum tested speed from 0.6 to 0.4°/s. Read this way, the range seems less "broadened" than shifted downward, and Experiment 2 on its own spans a somewhat narrower range than the original. A phrase such as "an extension to slower speeds" might describe the design more precisely, and the authors may wish to adjust the wording accordingly so that it reflects the contribution as closely as possible.*

**Response.** Adopted as suggested. The [Abstract](./Perception_main_document.md#abstract) and [Introduction](./Perception_main_document.md#introduction) no longer describe the design as testing "a broader range" of speeds; the [Introduction](./Perception_main_document.md#introduction) now describes Experiment 1 as following the original speeds and Experiment 2 as "extend[ing] testing to slower speeds that had not previously been examined."

> *Point B: The "direct" test and the change from the original design.*
> *The Methods note:*
> *"The method of this experiment was identical to that used in Experiment 1 of Zhang et al. (2014), except that the color–motion pairing was fixed for simplification."*
> *Since the manuscript describes this as a "direct" test of Zhang et al. (2014), and since the original counterbalancing of colour–motion pairings was not retained, it might help readers to flag this departure early — ideally in the Introduction, where the "direct test" framing first appears — rather than only later in the Results. The authors already acknowledge it as "a genuine limitation," so this is really a matter of signposting it a little sooner.*

**Response.** Adopted. The fixed (non-counterbalanced) color–motion pairing is now flagged in the [Introduction](./Perception_main_document.md#introduction) itself, and we removed "direct" framing from the [Abstract](./Perception_main_document.md#abstract) and [Introduction](./Perception_main_document.md#introduction) entirely.

### 2. Logical Considerations

> *Point A: Aligning the strength of the conclusions with the strength of the evidence.*
> *The authors are admirably careful to describe their evidence as anecdotal:*
> *"These analyses provided anecdotal evidence in favor of the null hypothesis, with Bayes Factors (BF₁₀) of 0.37 for PSE and 0.31 for slope… (Experiment 1)"*
> *"This provided anecdotal evidence in favor of the null hypothesis for PSE (BF₁₀ = 0.44)… (Experiment 2)"*
> *Expressed as BF₀₁, these correspond to about 2.70, 3.23, and 2.27. For a reader starting at even odds, the two PSE results move the posterior probability of the null from 50% to roughly 73% and 69% — a real but modest update that still leaves appreciable probability on the alternative. One of the nice features of the Bayes factor is that it can distinguish evidence of absence from absence of evidence, and here the values sit closer to the latter.*
>
> *With that in mind, a few phrasings read a little more strongly than the numbers might support:*
> *"…indicating no credible difference between the misbinding and control conditions (Results)"*
> *"The absence of a reliable shift in PSE indicates that the color–motion misbinding aftereffect is more fragile than previously assumed. (Abstract)"*
>
> *Two thoughts here. First, "fragile" (or "genuine but weak") is arguably a stronger claim than "no effect," because it asserts both that the effect exists and that it is small — and that combination usually calls for either a precise estimate of a small non-zero effect or an equivalence/ROPE analysis that rules out larger effects. With n = 10 and n = 7 and inconclusive Bayes factors, that may be more than the present data can comfortably deliver. Second, there is a subtlety worth flagging: because the analyses use the default Cauchy prior (r = 1/√2), which places much of its mass on moderate-to-large effects, a BF₀₁ near 2.7 mainly argues against a large effect and says relatively little about small ones — so the very hypothesis the authors are drawn to (a genuine but weak aftereffect) is the one this design is least able to resolve.*
>
> *I recommend either keeping the claims closer to "we found no evidence for a PSE shift, and our data are not well placed to adjudicate small effects," or, if the authors wish to make the stronger claim, bringing in tools better suited to it. For a replication in particular, a replication Bayes factor (Verhagen & Wagenmakers, 2014) — which uses the original study's posterior as the prior — would likely be more informative than the default prior, and a short design analysis showing sensitivity to Zhang et al.'s effect size would add useful reassurance.*
>
> *I would also gently note that the Abstract seems to shift between two registers: the sentence above states that the results "indicate" fragility, while the next sentence hedges more carefully ("These results may reflect … or they may indicate …"). The latter feels well matched to the evidence, and it might be worth letting it set the tone for the former as well.*

**Response.** We removed "no credible difference" and "fragile" as characterizations of the pooled PSE result and replaced them with more calibrated language along the lines the review models directly. We were not able to compute a replication Bayes factor against Zhang et al. (2014)'s effect size, because Zhang et al. (2014) report only p-values for the relevant comparisons, not an effect size or the descriptive statistics needed to derive one (see our response to Reviewer 1, Major #4). We added the design-sensitivity analysis you and Reviewer 1 both suggested instead, which serves the same evidential purpose using conventional effect sizes (Supplementary Table 1).

> *Point B: The cancellation account and the original finding.*
> *To explain a change in slope without a matching PSE shift, the Discussion offers:*
> *"Adaptation driven by the veridical stimulus and adaptation driven by the illusory percept may then have partially cancelled each other… adaptation may have been distributed across both, broadening the psychometric function."*
> *This is an appealing idea, but I found myself wondering how it squares with the earlier result: if such cancellation operates here, one might expect it to have operated in Zhang et al. (2014) too, whose configuration was materially similar and who nonetheless reported a reliable PSE shift. It would strengthen the argument to say a few words about why the same cancellation would not have applied in the original study.*

**Response.** We added the missing sentence to the [Discussion](./Perception_main_document.md#discussion): "If this cancellation account is correct, it should in principle also have applied in Zhang et al. (2014), whose adaptation configuration was materially similar to ours, yet who reported a reliable PSE shift; one candidate disanalogy is that Zhang et al. (2014) counterbalanced the color–motion pairing across participants, whereas the present study fixed it for simplification... We cannot adjudicate between these possibilities with the present data and offer the cancellation account as a tentative conjecture rather than an established explanation." We do not claim to have resolved the puzzle raised here, only to have acknowledged it honestly.

> *Point C: The account and its predictive reach.*
> *"Such a pattern, a shallower slope without a systematic change in the PSE, is consistent with what we observed."*
> *Consistency after the fact is reassuring but not, on its own, very diagnostic, since the account was formed once the pattern was known. Helpfully, it does seem to make a checkable prediction — that a shallower slope should also show up in Experiment 1 — and here the data point the other way (BF₁₀ = 0.31, i.e. BF₀₁ = 3.23, for the slope). It might be worth either engaging with this or presenting the account more explicitly as a tentative conjecture.*

**Response.** We now explicitly connect this account to the Experiment 2 slope finding and its weaker evidential status ("Such a pattern... is consistent with the exploratory Experiment 2 slope result described above, although we did not observe it in Experiment 1"), and present the account as a conjecture rather than a confirmed mechanism throughout, in view of both its failure to replicate in Experiment 1 and the weakened two-stage evidence in Experiment 2 once a non-zero lapse rate is used (see Reviewer 2, Interpretation Point C, below).

### 3. Interpretation of the Results

> *Point A: How cleanly the control condition isolates misbinding (a key point).*
> *The Methods and the caption to Table 1 describe the control condition as follows:*
> *"In the control condition, nothing was presented in the effect area."*
> *"In the control condition, only the induction part was presented during adaptation, and no effect-part stimulus was shown."*
> *Reading this, I realised the two conditions differ not only in whether an illusory colour–motion conjunction is perceived, but also in whether the effect-part region receives any adapting stimulation at all. In the misbinding condition, physically moving dots (red downward, green upward) sit at exactly the retinal location where the test later appears, whereas in the control condition that location is unstimulated during adaptation. Because motion adaptation is retinotopically specific, the test is delivered to an adapted region in one case and an unadapted region in the other. This asymmetry is renewed during every 5-second top-up adaptation.*
>
> *This matters because simple local motion adaptation provides a plausible alternative account of the Experiment 2 pattern. The effect-part stimulus contains balanced opposite directions (red downward plus green upward), which could plausibly produce little net directional bias while reducing direction-discrimination sensitivity. This alternative therefore matches the combination of no PSE shift and a shallower psychometric function observed in Experiment 2, although it does not explain why Experiment 1 yielded moderate evidence against a slope difference. The authors' interpretation is not necessarily wrong, but the misbinding account and this more mundane account are difficult to distinguish with the present control condition.*
>
> *The most decisive way to separate them would be a control in which the effect part is physically stimulated but no misbinding is perceived — for instance, an effect part carrying a colour–motion pairing congruent with the induction part. That would equate adapting stimulation across conditions while varying the veridicality of the binding. I appreciate that the present design was inherited from Zhang et al. (2014), so this is not a fault specific to the authors. Even so, it would help to discuss this confound explicitly and, if feasible, to add such a control.*

**Response.** We agree this is the most important design limitation. In the misbinding condition, physically moving dots occupy the effect-part region throughout adaptation, whereas in the control condition this region receives no stimulation at all — an asymmetry renewed on every 5-s top-up adaptation period. This offers a mundane local-adaptation/masking account of the Experiment 2 slope result that our design cannot rule out: ordinary local motion adaptation or masking from physically stimulating the effect part, rather than the perceived color–motion misbinding itself, could plausibly reduce direction-discrimination sensitivity without producing a PSE shift. The [Discussion](./Perception_main_document.md#discussion) now names this directly as a limitation, and we give the fuller reasoning here rather than in the manuscript itself. We explicitly name the decisive control proposed here — an effect part that is physically stimulated but bound congruently with the induction part, equating adapting stimulation across conditions while varying only the veridicality of the binding — as a priority for future work, and note we were unable to add it to the present experiments.

> *Point B: The slope effect across the two experiments.*
> *The two experiments seem to point in different directions on the slope measure:*
> *● Experiment 1: BF₁₀ = 0.31 (BF₀₁ = 3.23) — moderate evidence against a difference.*
> *● Experiment 2: BF₁₀ = 4.14 — moderate evidence for a difference.*
> *Given that the two experiments share stimuli and procedure and differ only in test speed, this divergence seems worth addressing directly, and at present it passes largely without comment while the Experiment 2 result is treated as substantive:*
> *"This result indicates reduced response sensitivity following adaptation to the misbinding stimulus…"*
> *It would help to address two points. First, it would be useful to say why reduced sensitivity might emerge only at slower test speeds. Second, since BF₁₀ = 4.14 with n = 7 is moderate rather than decisive, the claim is perhaps best qualified: at minimum, it would be worth noting that Experiment 1 gave moderate evidence against a slope difference, and softening the Abstract's statement that "motion-direction sensitivity was reduced in the misbinding condition."*

**Response.** We removed the framing that treated the Experiment 2 slope result as substantive while Experiment 1's non-replication passed without comment, and softened the [Abstract](./Perception_main_document.md#abstract)'s "motion-direction sensitivity was reduced in the misbinding condition" to language conditioned on the exploratory status of the finding. Both experiments' slope BF₁₀ values are reported in their respective [Results](./Perception_main_document.md#results) sections (Experiment 1: 0.31; Experiment 2: 1.84 after the lapse-rate correction described below). We do not have a confident account of why reduced sensitivity, if real, would emerge only at the slower test speeds, and say so rather than speculate.

> *Point C: Other readings of a shallower slope.*
> *A shallower psychometric function need not, of course, mean reduced perceptual sensitivity, and the fitting choices bear on this:*
> *"Fitting was performed using the quickpsy package for R … with both the lapse rate and guessing rate fixed at zero."*
> *With brief (0.2 s) peripheral test stimuli, a non-zero lapse rate seems plausible, and fixing it at zero would tend to fold extra lapses into the slope estimate. Accordingly, the shallower function need not uniquely imply reduced sensory sensitivity; it could partly reflect condition differences in attention, fatigue, fixation stability, or response lapses. I recommend assessing the robustness of the slope effect under alternative lapse assumptions; specific fitting options are noted in Section 5F.*

**Response.** This is effectively what led to the central finding of this revision. Refitting with guess/lapse = 0.03 rather than 0 changed the Experiment 2 slope BF₁₀ from 4.14 to 1.84 (the value now reported in the [Results](./Perception_main_document.md#results)). We also checked robustness under the alternative modeling approach suggested here and by Reviewer 1 (a hierarchical model; see Reviewer 1 Major #7 response above); full results for this check are reported in Supplementary Table 2.

### 4. Use of the Literature

> *On the whole I found the referencing thorough and well judged. The literatures on the binding problem, on crowding and summary-statistic representation, and on motion aftereffects are all well represented, and I did not notice significant omissions. I also appreciated the care taken to signal dissenting views with "but see" (for instance, Di Lollo, 2012, on whether the binding problem is well posed).*
>
> *Two small observations. First, in support of their own reading the authors draw on the supplementary data of Zhang et al. (2014):*
> *"Indeed, supplementary data from Zhang et al. (2014) show that a correctly bound color–motion pairing … produces a stronger aftereffect than the misbinding condition (Zhang et al., 2014; Figure S1)."*
> *Since the present study does not reproduce the principal finding of that same paper, leaning on its supplementary results to support the preferred account felt a little asymmetric to me, and a sentence explaining why the two sets of results are treated differently would be welcome.*
>
> *Second, the studies cited for the "higher-level perceptual inference" account (Wang & Shevell, 2014; Stepien & Shevell, 2015) are apt in themselves, but they carry an interpretation drawn from the prior literature rather than something the present data establish. As written, the passage can read as though the null result were positive evidence for the higher-level account. It might help simply to make explicit that the present results are null and that the account which follows is a conjecture grounded in earlier work.*

**Response.** We added the requested clarifying sentence where the Zhang et al. (2014) supplementary-data citation appears in the [Discussion](./Perception_main_document.md#discussion): "we note that this comparison is drawn from a different manipulation (correctly bound versus misbound pairings) than our own... so we cite it only to illustrate that illusion-driven aftereffects are generally weaker than veridical ones, not as independent support for our own null result, which our study does not otherwise corroborate from Zhang et al.'s data." We also added an explicit hedge on the higher-level account immediately after it is introduced: "We emphasize that our null PSE result does not itself establish this higher-level account: the account is an interpretive hypothesis grounded in prior literature, and our data are equally compatible with a low-level misbinding-induced aftereffect that the present design lacked the power, or the appropriate control condition, to detect with confidence."

### 5. Methods

> *Point A: A word on the sample-size rationale.*
> *"We recruited twelve participants, which is the same sample size as in the previous study (Zhang et al., 2014)."*
> *Matching the original sample size is understandable, though on its own it does not establish adequate power or precision. A replication built around the original n would only be well powered if the original effect-size estimate were essentially unbiased, and that is a difficult assumption for a single published positive finding because statistically significant estimates tend to run high. This is especially relevant here, where the conclusion leans toward the null and therefore requires precision. I recommend including an a priori power analysis, a Bayesian design or sensitivity analysis, or an assessment of the effect sizes the retained samples could realistically detect. If no such analysis was planned, it would be worth stating this limitation clearly and giving it real weight in the Discussion.*

**Response.** Added the design-sensitivity analysis described above ([Results](./Perception_main_document.md#results); Supplementary Table 1). We also revised the [Methods](./Perception_main_document.md#methods) to explain, rather than simply state, why the sample size matches Zhang et al. (2014)'s: they report only *p*-values for the relevant comparisons, not an effect size or the descriptive statistics needed to compute one, so an a priori power analysis anchored to their effect size was not possible, and we matched their sample size instead.

> *Point B: The exclusion criterion, and what the individual data suggest.*
> *"Participants whose responses showed little systematic dependence on test speed were excluded from the analyses due to unreliable task performance. This exclusion criterion was not specified in the preregistration."*
> *A few features of this criterion gave me pause, though I want to stress that the excluded curves really are flat, so the exclusions look reasonable case by case. First, the criterion was not preregistered, as the authors candidly note. Second, it isn't operationally defined — "little systematic dependence on test speed" has no stated quantitative threshold, which makes the procedure hard to reproduce. Third, and most delicately, "dependence on test speed" is essentially what the fitted slope parameter measures, and the slope is the study's one positive dependent variable (in Experiment 2). Excluding participants for visually shallow or irregular speed dependence and then testing a condition difference in slope therefore edges a little toward circularity, since the exclusion rule is reading the very response property that defines the key measure.*
>
> *Looking at the individual-participant Supplementary Figures, my main concern is less about any single case than about the aggregate. In Experiment 2 (Supplementary Figure 4), the retained participants fairly consistently show the control condition to be steeper than the misbinding condition — the very pattern behind the reported slope difference (BF₁₀ = 4.14). At least one excluded participant (Participant 10), by contrast, shows the reverse, with a steeper misbinding function and a flat or slightly negative control function, while a retained participant (Participant 4) shows a shallow misbinding function and a steep control function that fits the effect. I do not think anything untoward is occurring, but a subjective, non-preregistered rule applied to the response property that defines the key measure could unintentionally nudge the slope difference upward if exclusions fall asymmetrically across conditions. It would help to report the analysis with no exclusions alongside the current one, and to define any exclusion rule quantitatively.*

**Response.** The no-exclusion analysis is now reported alongside every excluded-sample analysis throughout the [Results](./Perception_main_document.md#results); for the Experiment 2 slope comparison specifically, the no-exclusion BF₁₀ (0.85) is weaker than the excluded-sample BF₁₀ (1.84), which is at least directionally consistent with the concern raised here that exclusion may inflate the apparent slope difference, though we cannot determine this conclusively from Bayes factors alone. Regarding a quantitative definition of the criterion actually applied: post hoc, it corresponds closely to a fitted slope below approximately 0.2–0.3 in both conditions, a range clearly separated from the slopes of retained participants. We report this quantitative correlate here rather than in the [Methods](./Perception_main_document.md#methods), since it was reconstructed after the fact to answer this comment rather than applied as a formal decision rule at the time.

> *Point C: The exclusion rate in Experiment 2 and its rationale.*
> *Experiment 2 excludes five of twelve participants (about 42%), leaving n = 7. Its stated purpose was:*
> *"Experiment 2 employed slower test speeds in an attempt to increase sensitivity to any adaptation effects arising from color–motion misbinding."*
> *That more than 40% of observers did not show usable speed dependence sits a little uneasily with this rationale. In the colour-separated data (Supplementary Figure 3), the excluded participants seem to fall into two groups: functions hovering flat around 50% (which would be consistent with the slower speeds falling near or below the discrimination threshold, e.g. Participant 5), and saturated or biased responding with the control near ceiling and the misbinding condition near floor (e.g. Participants 8 and 12). Either way, it looks as though, for a sizeable part of the sample, the slower speeds may not have increased sensitivity so much as pushed performance toward threshold or toward response bias. It might therefore be worth discussing the high exclusion rate as a question of stimulus calibration, rather than presenting it only as a data-cleaning step.*

**Response.** We agree this is a fair alternative reading of the exclusion rate, and acknowledge it here even though the manuscript itself does not spell it out: Experiment 2's roughly 40% exclusion rate may indicate that the slower test speeds pushed a substantial fraction of participants toward the edge of their discrimination threshold, which is as much a question of stimulus calibration as of data cleaning.

> *Point D: The confirmatory status of the Experiment 2 result.*
> *Points B and C each stand on their own, but I think it is really their combination that shapes how the Experiment 2 result is best read, and at present that combination passes without comment. Three things coincide here, all noted by the authors themselves: Experiment 2 was not independently preregistered ("Experiment 2 … was not independently preregistered"); the exclusion criterion was likewise not preregistered ("This exclusion criterion was not specified in the preregistration"); and about 42% of participants (5 of 12) were set aside under that criterion, leaving n = 7.*
>
> *Taken together, these features limit the confirmatory status of the study's one positive result — the slope difference (BF₁₀ = 4.14). Experiment 2 was not independently preregistered, the exclusion criterion was not prospectively specified, and the reported analysis depends on a substantially reduced final sample. The concern is compounded by the fact that the exclusion rule reads the same speed-dependent response property that the slope measures and, as the individual data hint (Participant 10), may not have fallen evenly across the two conditions. Selecting on the slope-defining property does not by itself guarantee bias in a condition difference, but in combination with the apparent asymmetry it provides a plausible route by which the estimated difference could be inflated. I'd therefore suggest treating the finding as hypothesis-generating rather than confirmatory: reporting the full Experiment 2 sample as the primary analysis, presenting the excluded-sample result as a clearly labelled sensitivity analysis using a quantitatively defined rule, and keeping the theoretical conclusions that rest on the slope difference tentative until they are confirmed in a preregistered study.*

**Response.** We adopted this framing directly. The [Results](./Perception_main_document.md#results) now state: "We therefore treat the Experiment 2 slope effect as an exploratory, hypothesis-generating finding rather than as confirmed evidence that misbinding reduces motion-direction sensitivity... We also note that Experiment 2 was not independently preregistered, followed from the null result of Experiment 1, and retained only seven of twelve participants after exclusion, all of which further limit the confirmatory status of this finding." We report the excluded-sample analysis as the primary one (matching the original preregistered analysis plan for Experiment 1's structure) but give the no-exclusion result equal visibility rather than relegating it to a footnote, precisely because — as this comment anticipates — it comes out weaker (BF₁₀ = 0.85, inconclusive).

> *Point E: The fixed colour–motion pairing.*
> *"…except that the color–motion pairing was fixed for simplification."*
> *Because the mapping between test colour and the response direction coded as "aftereffect-consistent" reverses across adaptation conditions, a colour-specific directional response bias could contribute to the apparent condition difference. A constant bias of this kind would mainly shift the PSE, so its route to the observed slope difference would run through the pooling of red and green: if the two colours carry asymmetric biases, the pooled psychometric function could flatten a little more in one condition than the other. The colour-separated supplementary figures provide a useful visual check, and the retained participants show the "control-steeper" pattern for both red and green tests. However, those figures cannot fully eliminate the possibility while the colour–motion mapping remains fixed. So it seems worth keeping this limitation explicit, and a formal test of colour symmetry would help here.*

**Response.** We ran the formal color-symmetry test suggested here for both experiments (paired Bayesian t-test comparing the red-color and green-color misbinding-minus-control differences). Results: Experiment 1 PSE, BF₁₀ = 2.15 (anecdotal evidence the colors differ); Experiment 1 slope, BF₁₀ = 0.33 (moderate evidence they do not); Experiment 2 PSE, BF₁₀ = 1.22; Experiment 2 slope, BF₁₀ = 0.96 (both inconclusive). These are reported in the [Results](./Perception_main_document.md#results) alongside the color-separated analysis, and the fixed-pairing limitation is now stated explicitly in the [Introduction](./Perception_main_document.md#introduction) as well as the [Methods](./Perception_main_document.md#methods).

> *Point F: Fixing the lapse and guessing rates at zero.*
> *"…with both the lapse rate and guessing rate fixed at zero."*
> *As above, with brief (0.2 s) peripheral test stimuli a non-zero lapse rate seems plausible, and constraining it to zero would tend to route extra lapses into the slope estimate. The individual-participant figures bring this to life: retained Participant 4's misbinding function rises only to about 52% at the highest test speed, so the zero-lapse fit is pushed toward a very shallow slope whether the underlying cause is reduced sensitivity, response bias, or lapses. Because only five speed levels are available per condition, estimating a completely free lapse rate separately for every participant may itself be unstable. It would be reassuring to assess robustness under alternative lapse assumptions — for example, by allowing a small constrained lapse rate, using a hierarchical fit, or comparing models with and without a lapse parameter.*

**Response.** We did exactly the first of the three suggested checks: refitting with lapse and guessing rates constrained to a small literature-based value (0.03; Wichmann & Hill, 2001) rather than zero. As anticipated here, this changed the Experiment 2 slope result substantially (BF₁₀: 4.14 → 1.84, now only anecdotal). We also implemented the hierarchical-fit suggestion as a supplementary check (see Reviewer 1, Major #7); full results for both the condition and speed-by-condition terms are reported in Supplementary Table 2.

> *Point G: The decision not to record eye movements.*
> *"Eye movements were not recorded because the perception of misbinding was not confined to a small, fixed region but was distributed across the entire display…"*
> *I follow the reasoning, though I'm not sure a spatially distributed illusion guarantees that the test stimulus's retinal position was stable. The effect part is a narrow 4°-wide strip in the right periphery and the test lasts only 0.2 s, so a small rightward eye movement could carry the test out of the adapted region or toward the induction part. It might help to describe whatever safeguards were in place for fixation stability (a fixation task, or a post-hoc report).*

**Response.** We had no additional fixation safeguards beyond the central fixation cross described in the [Procedure](./Perception_main_document.md#procedure), and no post-hoc fixation report. We now say this plainly rather than relying only on the spatial-distribution argument: "we did not verify fixation stability directly, and we treat this as an open limitation, particularly for interpreting the null PSE results" ([Procedure](./Perception_main_document.md#procedure); echoed in [Discussion](./Perception_main_document.md#discussion)).

### 6. Procedure

> *Point A: The order and arrangement of blocks.*
> *"The experiment consisted of 20 blocks of 40 trials, 10 blocks for each adaptor condition (misbinding vs. control)."*
> *I couldn't find how the ten misbinding and ten control blocks were ordered — whether interleaved, blocked, or randomised/counterbalanced. Since motion adaptation can carry over from one block to the next, block order could in principle influence the results, and if the conditions were run in blocked order, condition effects could become entangled with time-related factors such as fatigue and practice. A sentence clarifying this would help with reproducibility.*

**Response.** We checked the original MATLAB experiment code (`CCMAEexp1.m`, `CCMAE_exp2.m`) and confirmed that block order was fully randomized per participant (`blockorder = randperm(length(blockmat))` over all 20 blocks), not blocked by condition. This is now stated in the [Procedure](./Perception_main_document.md#procedure).

> *Point B: The assumption behind colour pooling.*
> *"We pooled the data regarding test stimuli color…"*
> *Pooling the red and green test data assumes that the two colours contribute symmetrically after responses are recoded relative to the inducer direction. Because the colour–motion mapping was fixed, a colour-specific directional bias could be obscured by pooling. A statistical test of colour symmetry before pooling would therefore be a useful addition.*
>
> *A general note: many of these features were inherited from Zhang et al. (2014), so they are not shortcomings specific to this study. I mention them only because a replication-and-extension paper is well placed to make the limitations of the inherited procedure explicit in the Methods and, where feasible, to improve on them.*

**Response.** Addressed via the formal color-symmetry test described under [Methods](./Perception_main_document.md#methods) Point E above. We appreciate the general note and have tried, throughout this revision, to make the inherited procedure's limitations explicit rather than only implicit.

### 7. Discussion

> *Point A: Keeping the Discussion in step with the Results.*
> *The Discussion opens with pleasing caution:*
> *"Across two experiments… we found no clear evidence of a PSE shift in either experiment."*
> *"No clear evidence of a PSE shift" feels nicely matched to anecdotal Bayes factors. A little later, though — and in the Abstract — the language moves toward the stronger claim that the aftereffect is "more fragile than previously assumed." Since the Discussion is where the careful tone of the Results ideally carries through, it might be worth easing this back into line.*

**Response.** The [Discussion](./Perception_main_document.md#discussion)'s opening paragraph was rewritten to match the calibrated tone of the [Results](./Perception_main_document.md#results) throughout, rather than shifting to stronger language partway through.

> *Point B: The weight resting on a single positive finding.*
> *A good part of the Discussion's argument rests on the slope difference from Experiment 2 alone (BF₁₀ = 4.14, n = 7, not replicated in Experiment 1):*
> *"Instead, adaptation to the misbinding stimulus reduced motion-direction sensitivity in Experiment 2…"*
> *As noted under Sections 3 and 5, this finding did not replicate in Experiment 1, is confounded with whether the effect part was adapted at all, and may be sensitive to the non-preregistered exclusion. Given all that, building a fairly specific interpretive frame on it — "sensitivity is reduced but direction is not biased" — feels like a lot to ask of one result, and I'd gently encourage holding this more loosely.*

**Response.** The [Discussion](./Perception_main_document.md#discussion) no longer builds a specific interpretive frame ("sensitivity is reduced but direction is not biased") on the Experiment 2 slope result; it is now introduced, discussed, and revisited consistently as exploratory, and its evidential weakening under the corrected lapse rate is reported alongside it.

> *Point C: Distinguishing what the data show from what the literature suggests.*
> *The "higher-level perceptual inference" account later in the Discussion is a thoughtful conjecture grounded in prior work (Wang & Shevell, 2014; Stepien & Shevell, 2015; Stewart et al., 2020; Toscani et al., 2017), rather than something the present data establish:*
> *"…misbinding may reflect a process that resolves the ambiguity of peripheral information by relying on the feature binding firmly established in central vision…"*
> *The present data do not provide clear evidence that misbinding strongly drove low-level adaptation, but neither do they establish that such adaptation was absent. They also do not by themselves support the positive conclusion that misbinding "arises from higher-level inference." It would read more cleanly to state that the results are inconclusive with respect to a small low-level aftereffect and that the higher-level account is an interpretive hypothesis drawn from the earlier literature.*

**Response.** Addressed via the explicit hedge described under "Use of the Literature" above.

> *Point D: Giving the study's own power its due.*
> *The Discussion does raise, very fairly, the possibility that the aftereffect was present but simply not detected:*
> *"First, a misbinding-induced CCMAE may have been present but gone undetected."*
> *Having raised it, the Discussion then leans toward "fragile." Given the small retained samples, anecdotal Bayes factors, and an original effect-size estimate that may itself run a little high, it may simply be that the present study lacks the precision to tell a genuinely small effect apart from no effect — and a replication can't really be assumed to be well powered just because it matches the earlier sample size. For a replication that did not reproduce the earlier result, it might be safer to foreground the study's own limited sensitivity before drawing a conclusion about the nature of the phenomenon, and to support any null-leaning reading with an explicit design or sensitivity analysis.*

**Response.** Addressed via the design-sensitivity analysis, reported in the [Results](./Perception_main_document.md#results) and referenced in the [Discussion](./Perception_main_document.md#discussion), which foregrounds the study's own limited sensitivity before any claim about the nature of the phenomenon. The word "fragile" itself has been removed from the manuscript.

> *Point E: The reframing of the term "misbinding."*
> *"Wu et al.'s illusion has been labeled 'misbinding', a term that implies a failure of feature binding that alters early sensory representations."*
> *I found this closing reflection genuinely interesting. Since it rests on the present null result together with the prior literature rather than on positive evidence, it reads best as a suggestion — and, to the authors' credit, the manuscript largely already keeps it at that level.*

**Response.** We kept this passage largely as noted here that it already reads appropriately, adding only "we suggest—without claiming to have established—" to make the epistemic status fully explicit.

> *Point F: Acknowledging limitations and, where possible, acting on them.*
> *"…we did not counterbalance the color–motion pairing… This is a genuine limitation…"*
> *I appreciated this candour. The one thing I'd add is that several of the limitations could be partly addressed rather than only noted — for example, reporting the no-exclusion analysis, testing colour symmetry, or adding a matched control condition. Even acting on one or two of these would go a long way.*

**Response.** Of the three concrete suggestions here, we implemented two directly (no-exclusion analysis: done; color-symmetry test: done) and were not able to add a matched physical control within the scope of this revision (would require new data collection); we say so explicitly and flag it as a priority for follow-up work (see Interpretation, Point A above).

### Overall Assessment

> *I think this is a worthwhile study on an important question, and I was glad to see the commitment to transparency (preregistration of Experiment 1, open data and code). My main suggestions concern three areas. The first is the control condition, which I think does not fully separate misbinding from simple retinotopic motion adaptation — a difference that is renewed on each top-up trial.*
>
> *The second is that the study's single positive finding — the slope difference in Experiment 2 — comes from an analysis with limited confirmatory status: Experiment 2 was not independently preregistered, the subjective exclusion criterion was not preregistered, and about 42% of the sample (5 of 12) was set aside, leaving n = 7. Because that rule reads the same speed-dependent response property that the slope measures, and the individual data hint that the exclusions may not have fallen evenly across conditions, a moderate Bayes factor obtained this way may not carry the interpretive weight currently placed on it. I'd suggest framing the result as hypothesis-generating.*
>
> *The third is that some of the stronger phrasings ("fragile," "genuine but weak") rest on anecdotal Bayes factors and on samples whose sensitivity has not yet been established; relatedly, the 42% exclusion rate in Experiment 2 suggests that the slower-speed manipulation may not have worked as intended for a substantial proportion of observers, which seems worth discussing as a calibration issue. The revisions that would add the most value are: adding a physically matched control in the effect part, if feasible; reporting full-sample analyses and defining any exclusion rule quantitatively; assessing the slope result under alternative lapse assumptions, such as constrained or hierarchical lapse models; considering a replication Bayes factor and/or a design, sensitivity, or equivalence analysis suited to a null-oriented replication; and carrying the careful tone of the Results through the Abstract and Discussion.*
>
> *I hope these comments are useful, and I look forward to seeing how the work develops.*

**Response.** We hope this revision demonstrates that we have taken these three concerns seriously rather than only cosmetically — in particular, our decision to report the lapse-rate correction candidly even though it weakens our own positive result, and the color-separated analysis even though it qualifies our headline null finding. Of the value-adding revisions listed here, we implemented all except the physically matched control (would require new data collection; now flagged as the priority next step) and the replication Bayes factor (Zhang et al., 2014, report only p-values for the relevant comparisons, not an effect size we could use to construct one; the design-sensitivity analysis serves an analogous purpose). We were not able to conduct a new preregistered, counterbalanced, fixation-monitored experiment with a physically matched control within the scope of this revision, and we say so plainly; we regard this as the logical next step for a decisive test of the original Zhang et al. (2014) finding.
