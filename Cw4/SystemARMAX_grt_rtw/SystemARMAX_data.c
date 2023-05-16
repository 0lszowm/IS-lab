/*
 * SystemARMAX_data.c
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "SystemARMAX".
 *
 * Model version              : 1.15
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Tue May 16 14:16:15 2023
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "SystemARMAX.h"

/* Block parameters (default storage) */
P_SystemARMAX_T SystemARMAX_P = {
  /* Mask Parameter: BandLimitedWhiteNoise_Cov
   * Referenced by: '<S2>/Output'
   */
  1.0000000000000002E-6,

  /* Mask Parameter: BandLimitedWhiteNoise_seed
   * Referenced by: '<S2>/White Noise'
   */
  23341.0,

  /* Expression: 1
   * Referenced by: '<Root>/Signal Generator'
   */
  1.0,

  /* Expression: 0.025
   * Referenced by: '<Root>/Signal Generator'
   */
  0.025,

  /* Expression: 0
   * Referenced by: '<S2>/White Noise'
   */
  0.0,

  /* Computed Parameter: WhiteNoise_StdDev
   * Referenced by: '<S2>/White Noise'
   */
  1.0,

  /* Expression: 0
   * Referenced by: '<S1>/Unit Delay'
   */
  0.0,

  /* Expression: 0.5
   * Referenced by: '<S1>/Rate Transition'
   */
  0.5,

  /* Expression: 0.1
   * Referenced by: '<S1>/Uniform Random Number'
   */
  0.1,

  /* Expression: 0.8
   * Referenced by: '<S1>/Uniform Random Number'
   */
  0.8,

  /* Expression: 2
   * Referenced by: '<S1>/Uniform Random Number'
   */
  2.0,

  /* Computed Parameter: ManualSwitch_CurrentSetting
   * Referenced by: '<S1>/Manual Switch'
   */
  1U
};
