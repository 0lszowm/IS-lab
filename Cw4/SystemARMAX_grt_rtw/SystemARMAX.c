/*
 * SystemARMAX.c
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
#include "rtwtypes.h"
#include <math.h>
#include "rt_nonfinite.h"
#include "SystemARMAX_private.h"
#include <string.h>

/* Block signals (default storage) */
B_SystemARMAX_T SystemARMAX_B;

/* Block states (default storage) */
DW_SystemARMAX_T SystemARMAX_DW;

/* Real-time model */
static RT_MODEL_SystemARMAX_T SystemARMAX_M_;
RT_MODEL_SystemARMAX_T *const SystemARMAX_M = &SystemARMAX_M_;
static void rate_monotonic_scheduler(void);
time_T rt_SimUpdateDiscreteEvents(
  int_T rtmNumSampTimes, void *rtmTimingData, int_T *rtmSampleHitPtr, int_T
  *rtmPerTaskSampleHits )
{
  rtmSampleHitPtr[1] = rtmStepTask(SystemARMAX_M, 1);
  rtmSampleHitPtr[2] = rtmStepTask(SystemARMAX_M, 2);
  UNUSED_PARAMETER(rtmNumSampTimes);
  UNUSED_PARAMETER(rtmTimingData);
  UNUSED_PARAMETER(rtmPerTaskSampleHits);
  return(-1);
}

/*
 *         This function updates active task flag for each subrate
 *         and rate transition flags for tasks that exchange data.
 *         The function assumes rate-monotonic multitasking scheduler.
 *         The function must be called at model base rate so that
 *         the generated code self-manages all its subrates and rate
 *         transition flags.
 */
static void rate_monotonic_scheduler(void)
{
  /* To ensure a deterministic data transfer between two rates,
   * data is transferred at the priority of a fast task and the frequency
   * of the slow task.  The following flags indicate when the data transfer
   * happens.  That is, a rate interaction flag is set true when both rates
   * will run, and false otherwise.
   */

  /* tid 1 shares data with slower tid rate: 2 */
  if (SystemARMAX_M->Timing.TaskCounters.TID[1] == 0) {
    SystemARMAX_M->Timing.RateInteraction.TID1_2 =
      (SystemARMAX_M->Timing.TaskCounters.TID[2] == 0);

    /* update PerTaskSampleHits matrix for non-inline sfcn */
    SystemARMAX_M->Timing.perTaskSampleHits[5] =
      SystemARMAX_M->Timing.RateInteraction.TID1_2;
  }

  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (SystemARMAX_M->Timing.TaskCounters.TID[2])++;
  if ((SystemARMAX_M->Timing.TaskCounters.TID[2]) > 14999) {/* Sample time: [1500.0s, 0.0s] */
    SystemARMAX_M->Timing.TaskCounters.TID[2] = 0;
  }
}

real_T rt_urand_Upu32_Yd_f_pw_snf(uint32_T *u)
{
  uint32_T hi;
  uint32_T lo;

  /* Uniform random number generator (random number between 0 and 1)

     #define IA      16807                      magic multiplier = 7^5
     #define IM      2147483647                 modulus = 2^31-1
     #define IQ      127773                     IM div IA
     #define IR      2836                       IM modulo IA
     #define S       4.656612875245797e-10      reciprocal of 2^31-1
     test = IA * (seed % IQ) - IR * (seed/IQ)
     seed = test < 0 ? (test + IM) : test
     return (seed*S)
   */
  lo = *u % 127773U * 16807U;
  hi = *u / 127773U * 2836U;
  if (lo < hi) {
    *u = 2147483647U - (hi - lo);
  } else {
    *u = lo - hi;
  }

  return (real_T)*u * 4.6566128752457969E-10;
}

real_T rt_nrand_Upu32_Yd_f_pw_snf(uint32_T *u)
{
  real_T si;
  real_T sr;
  real_T y;

  /* Normal (Gaussian) random number generator */
  do {
    sr = 2.0 * rt_urand_Upu32_Yd_f_pw_snf(u) - 1.0;
    si = 2.0 * rt_urand_Upu32_Yd_f_pw_snf(u) - 1.0;
    si = sr * sr + si * si;
  } while (si > 1.0);

  y = sqrt(-2.0 * log(si) / si) * sr;
  return y;
}

/* Model output function for TID0 */
static void SystemARMAX_output0(void)  /* Sample time: [0.0s, 0.0s] */
{
  real_T rtb_ManualSwitch;

  {                                    /* Sample time: [0.0s, 0.0s] */
    rate_monotonic_scheduler();
  }

  /* SignalGenerator: '<Root>/Signal Generator' */
  rtb_ManualSwitch = SystemARMAX_P.SignalGenerator_Frequency *
    SystemARMAX_M->Timing.t[0];
  if (rtb_ManualSwitch - floor(rtb_ManualSwitch) >= 0.5) {
    /* SignalGenerator: '<Root>/Signal Generator' */
    SystemARMAX_B.SignalGenerator = SystemARMAX_P.SignalGenerator_Amplitude;
  } else {
    /* SignalGenerator: '<Root>/Signal Generator' */
    SystemARMAX_B.SignalGenerator = -SystemARMAX_P.SignalGenerator_Amplitude;
  }

  /* End of SignalGenerator: '<Root>/Signal Generator' */
  /* RandomNumber: '<S2>/White Noise' */
  rtb_ManualSwitch = SystemARMAX_DW.NextOutput;

  /* Sum: '<S1>/Add' incorporates:
   *  Gain: '<S2>/Output'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  SystemARMAX_B.Add = sqrt(SystemARMAX_P.BandLimitedWhiteNoise_Cov) /
    0.31622776601683794 * rtb_ManualSwitch + SystemARMAX_DW.UnitDelay_DSTATE;

  /* RateTransition: '<S1>/Rate Transition' */
  if (SystemARMAX_M->Timing.RateInteraction.TID1_2) {
    /* RateTransition: '<S1>/Rate Transition' */
    SystemARMAX_B.RateTransition = SystemARMAX_DW.RateTransition_Buffer0;
  }

  /* End of RateTransition: '<S1>/Rate Transition' */

  /* ManualSwitch: '<S1>/Manual Switch' */
  if (SystemARMAX_P.ManualSwitch_CurrentSetting == 1) {
    rtb_ManualSwitch = SystemARMAX_B.Add;
  } else {
    rtb_ManualSwitch = SystemARMAX_B.RateTransition;
  }

  /* End of ManualSwitch: '<S1>/Manual Switch' */
}

/* Model update function for TID0 */
static void SystemARMAX_update0(void)  /* Sample time: [0.0s, 0.0s] */
{
  /* Update for RandomNumber: '<S2>/White Noise' */
  SystemARMAX_DW.NextOutput = rt_nrand_Upu32_Yd_f_pw_snf
    (&SystemARMAX_DW.RandSeed) * SystemARMAX_P.WhiteNoise_StdDev +
    SystemARMAX_P.WhiteNoise_Mean;

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  SystemARMAX_DW.UnitDelay_DSTATE = SystemARMAX_B.Add;

  /* Update absolute time */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++SystemARMAX_M->Timing.clockTick0)) {
    ++SystemARMAX_M->Timing.clockTickH0;
  }

  SystemARMAX_M->Timing.t[0] = SystemARMAX_M->Timing.clockTick0 *
    SystemARMAX_M->Timing.stepSize0 + SystemARMAX_M->Timing.clockTickH0 *
    SystemARMAX_M->Timing.stepSize0 * 4294967296.0;

  /* Update absolute time */
  /* The "clockTick1" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick1"
   * and "Timing.stepSize1". Size of "clockTick1" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick1 and the high bits
   * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++SystemARMAX_M->Timing.clockTick1)) {
    ++SystemARMAX_M->Timing.clockTickH1;
  }

  SystemARMAX_M->Timing.t[1] = SystemARMAX_M->Timing.clockTick1 *
    SystemARMAX_M->Timing.stepSize1 + SystemARMAX_M->Timing.clockTickH1 *
    SystemARMAX_M->Timing.stepSize1 * 4294967296.0;
}

/* Model output function for TID2 */
static void SystemARMAX_output2(void)  /* Sample time: [1500.0s, 0.0s] */
{
  real_T rtb_UniformRandomNumber;

  /* UniformRandomNumber: '<S1>/Uniform Random Number' */
  rtb_UniformRandomNumber = SystemARMAX_DW.UniformRandomNumber_NextOutput;

  /* RateTransition: '<S1>/Rate Transition' */
  SystemARMAX_DW.RateTransition_Buffer0 = rtb_UniformRandomNumber;
}

/* Model update function for TID2 */
static void SystemARMAX_update2(void)  /* Sample time: [1500.0s, 0.0s] */
{
  /* Update for UniformRandomNumber: '<S1>/Uniform Random Number' */
  SystemARMAX_DW.UniformRandomNumber_NextOutput =
    (SystemARMAX_P.UniformRandomNumber_Maximum -
     SystemARMAX_P.UniformRandomNumber_Minimum) * rt_urand_Upu32_Yd_f_pw_snf
    (&SystemARMAX_DW.RandSeed_g) + SystemARMAX_P.UniformRandomNumber_Minimum;

  /* Update absolute time */
  /* The "clockTick2" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick2"
   * and "Timing.stepSize2". Size of "clockTick2" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick2 and the high bits
   * Timing.clockTickH2. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++SystemARMAX_M->Timing.clockTick2)) {
    ++SystemARMAX_M->Timing.clockTickH2;
  }

  SystemARMAX_M->Timing.t[2] = SystemARMAX_M->Timing.clockTick2 *
    SystemARMAX_M->Timing.stepSize2 + SystemARMAX_M->Timing.clockTickH2 *
    SystemARMAX_M->Timing.stepSize2 * 4294967296.0;
}

/* Use this function only if you need to maintain compatibility with an existing static main program. */
static void SystemARMAX_output(int_T tid)
{
  switch (tid) {
   case 0 :
    SystemARMAX_output0();
    break;

   case 2 :
    SystemARMAX_output2();
    break;

   default :
    /* do nothing */
    break;
  }
}

/* Use this function only if you need to maintain compatibility with an existing static main program. */
static void SystemARMAX_update(int_T tid)
{
  switch (tid) {
   case 0 :
    SystemARMAX_update0();
    break;

   case 2 :
    SystemARMAX_update2();
    break;

   default :
    /* do nothing */
    break;
  }
}

/* Model initialize function */
static void SystemARMAX_initialize(void)
{
  /* Start for RateTransition: '<S1>/Rate Transition' */
  SystemARMAX_B.RateTransition = SystemARMAX_P.RateTransition_InitialCondition;

  {
    real_T tmp;
    int32_T r;
    int32_T t;
    uint32_T tseed;

    /* InitializeConditions for RandomNumber: '<S2>/White Noise' */
    tmp = floor(SystemARMAX_P.BandLimitedWhiteNoise_seed);
    if (rtIsNaN(tmp) || rtIsInf(tmp)) {
      tmp = 0.0;
    } else {
      tmp = fmod(tmp, 4.294967296E+9);
    }

    tseed = tmp < 0.0 ? (uint32_T)-(int32_T)(uint32_T)-tmp : (uint32_T)tmp;
    r = (int32_T)(tseed >> 16U);
    t = (int32_T)(tseed & 32768U);
    tseed = ((((tseed - ((uint32_T)r << 16U)) + (uint32_T)t) << 16U) + (uint32_T)
             t) + (uint32_T)r;
    if (tseed < 1U) {
      tseed = 1144108930U;
    } else if (tseed > 2147483646U) {
      tseed = 2147483646U;
    }

    SystemARMAX_DW.RandSeed = tseed;
    SystemARMAX_DW.NextOutput = rt_nrand_Upu32_Yd_f_pw_snf
      (&SystemARMAX_DW.RandSeed) * SystemARMAX_P.WhiteNoise_StdDev +
      SystemARMAX_P.WhiteNoise_Mean;

    /* End of InitializeConditions for RandomNumber: '<S2>/White Noise' */

    /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
    SystemARMAX_DW.UnitDelay_DSTATE = SystemARMAX_P.UnitDelay_InitialCondition;

    /* InitializeConditions for RateTransition: '<S1>/Rate Transition' */
    SystemARMAX_DW.RateTransition_Buffer0 =
      SystemARMAX_P.RateTransition_InitialCondition;

    /* InitializeConditions for UniformRandomNumber: '<S1>/Uniform Random Number' */
    tmp = floor(SystemARMAX_P.UniformRandomNumber_Seed);
    if (rtIsNaN(tmp) || rtIsInf(tmp)) {
      tmp = 0.0;
    } else {
      tmp = fmod(tmp, 4.294967296E+9);
    }

    tseed = tmp < 0.0 ? (uint32_T)-(int32_T)(uint32_T)-tmp : (uint32_T)tmp;
    r = (int32_T)(tseed >> 16U);
    t = (int32_T)(tseed & 32768U);
    tseed = ((((tseed - ((uint32_T)r << 16U)) + (uint32_T)t) << 16U) + (uint32_T)
             t) + (uint32_T)r;
    if (tseed < 1U) {
      tseed = 1144108930U;
    } else if (tseed > 2147483646U) {
      tseed = 2147483646U;
    }

    SystemARMAX_DW.RandSeed_g = tseed;
    SystemARMAX_DW.UniformRandomNumber_NextOutput =
      (SystemARMAX_P.UniformRandomNumber_Maximum -
       SystemARMAX_P.UniformRandomNumber_Minimum) * rt_urand_Upu32_Yd_f_pw_snf
      (&SystemARMAX_DW.RandSeed_g) + SystemARMAX_P.UniformRandomNumber_Minimum;

    /* End of InitializeConditions for UniformRandomNumber: '<S1>/Uniform Random Number' */
  }
}

/* Model terminate function */
static void SystemARMAX_terminate(void)
{
  /* (no terminate code required) */
}

/*========================================================================*
 * Start of Classic call interface                                        *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  if (tid == 1)
    tid = 0;
  SystemARMAX_output(tid);
}

void MdlUpdate(int_T tid)
{
  if (tid == 1)
    tid = 0;
  SystemARMAX_update(tid);
}

void MdlInitializeSizes(void)
{
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
}

void MdlStart(void)
{
  SystemARMAX_initialize();
}

void MdlTerminate(void)
{
  SystemARMAX_terminate();
}

/* Registration function */
RT_MODEL_SystemARMAX_T *SystemARMAX(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)SystemARMAX_M, 0,
                sizeof(RT_MODEL_SystemARMAX_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&SystemARMAX_M->solverInfo,
                          &SystemARMAX_M->Timing.simTimeStep);
    rtsiSetTPtr(&SystemARMAX_M->solverInfo, &rtmGetTPtr(SystemARMAX_M));
    rtsiSetStepSizePtr(&SystemARMAX_M->solverInfo,
                       &SystemARMAX_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&SystemARMAX_M->solverInfo, (&rtmGetErrorStatus
      (SystemARMAX_M)));
    rtsiSetRTModelPtr(&SystemARMAX_M->solverInfo, SystemARMAX_M);
  }

  rtsiSetSimTimeStep(&SystemARMAX_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&SystemARMAX_M->solverInfo,"FixedStepDiscrete");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = SystemARMAX_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    mdlTsMap[2] = 2;

    /* polyspace +2 MISRA2012:D4.1 [Justified:Low] "SystemARMAX_M points to
       static memory which is guaranteed to be non-NULL" */
    SystemARMAX_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    SystemARMAX_M->Timing.sampleTimes = (&SystemARMAX_M->
      Timing.sampleTimesArray[0]);
    SystemARMAX_M->Timing.offsetTimes = (&SystemARMAX_M->
      Timing.offsetTimesArray[0]);

    /* task periods */
    SystemARMAX_M->Timing.sampleTimes[0] = (0.0);
    SystemARMAX_M->Timing.sampleTimes[1] = (0.1);
    SystemARMAX_M->Timing.sampleTimes[2] = (1500.0);

    /* task offsets */
    SystemARMAX_M->Timing.offsetTimes[0] = (0.0);
    SystemARMAX_M->Timing.offsetTimes[1] = (0.0);
    SystemARMAX_M->Timing.offsetTimes[2] = (0.0);
  }

  rtmSetTPtr(SystemARMAX_M, &SystemARMAX_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = SystemARMAX_M->Timing.sampleHitArray;
    int_T *mdlPerTaskSampleHits = SystemARMAX_M->Timing.perTaskSampleHitsArray;
    SystemARMAX_M->Timing.perTaskSampleHits = (&mdlPerTaskSampleHits[0]);
    mdlSampleHits[0] = 1;
    SystemARMAX_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(SystemARMAX_M, 1000.0);
  SystemARMAX_M->Timing.stepSize0 = 0.1;
  SystemARMAX_M->Timing.stepSize1 = 0.1;
  SystemARMAX_M->Timing.stepSize2 = 1500.0;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = (NULL);
    SystemARMAX_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(SystemARMAX_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(SystemARMAX_M->rtwLogInfo, (NULL));
    rtliSetLogT(SystemARMAX_M->rtwLogInfo, "tout");
    rtliSetLogX(SystemARMAX_M->rtwLogInfo, "");
    rtliSetLogXFinal(SystemARMAX_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(SystemARMAX_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(SystemARMAX_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(SystemARMAX_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(SystemARMAX_M->rtwLogInfo, 1);
    rtliSetLogY(SystemARMAX_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(SystemARMAX_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(SystemARMAX_M->rtwLogInfo, (NULL));
  }

  SystemARMAX_M->solverInfoPtr = (&SystemARMAX_M->solverInfo);
  SystemARMAX_M->Timing.stepSize = (0.1);
  rtsiSetFixedStepSize(&SystemARMAX_M->solverInfo, 0.1);
  rtsiSetSolverMode(&SystemARMAX_M->solverInfo, SOLVER_MODE_MULTITASKING);

  /* block I/O */
  SystemARMAX_M->blockIO = ((void *) &SystemARMAX_B);

  {
    SystemARMAX_B.SignalGenerator = 0.0;
    SystemARMAX_B.Add = 0.0;
    SystemARMAX_B.RateTransition = 0.0;
  }

  /* parameters */
  SystemARMAX_M->defaultParam = ((real_T *)&SystemARMAX_P);

  /* states (dwork) */
  SystemARMAX_M->dwork = ((void *) &SystemARMAX_DW);
  (void) memset((void *)&SystemARMAX_DW, 0,
                sizeof(DW_SystemARMAX_T));
  SystemARMAX_DW.UnitDelay_DSTATE = 0.0;
  SystemARMAX_DW.NextOutput = 0.0;
  SystemARMAX_DW.RateTransition_Buffer0 = 0.0;
  SystemARMAX_DW.UniformRandomNumber_NextOutput = 0.0;

  /* Initialize Sizes */
  SystemARMAX_M->Sizes.numContStates = (0);/* Number of continuous states */
  SystemARMAX_M->Sizes.numY = (0);     /* Number of model outputs */
  SystemARMAX_M->Sizes.numU = (0);     /* Number of model inputs */
  SystemARMAX_M->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  SystemARMAX_M->Sizes.numSampTimes = (3);/* Number of sample times */
  SystemARMAX_M->Sizes.numBlocks = (11);/* Number of blocks */
  SystemARMAX_M->Sizes.numBlockIO = (3);/* Number of block outputs */
  SystemARMAX_M->Sizes.numBlockPrms = (12);/* Sum of parameter "widths" */
  return SystemARMAX_M;
}

/*========================================================================*
 * End of Classic call interface                                          *
 *========================================================================*/
