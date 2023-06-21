/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunPro, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice
 * is preserved.
 * ====================================================
 */

/*
 * from: @(#)fdlibm.h 5.1 93/09/24
 * $FreeBSD$
 */

#ifndef _MATH_H_
#define _MATH_H_

#include <sys/cdefs.h>
#include <sys/_types.h>
#include <machine/_limits.h>

#define __ISO_C_VISIBLE 1999
#define __BSD_VISIBLE 1

/*
 * ANSI/POSIX
 */
extern const union __infinity_un {
        unsigned char   __uc[8];
        double          __ud;
} __infinity;

extern const union __nan_un {
        unsigned char   __uc[sizeof(float)];
        float           __uf;
} __nan;

#if (defined(__GNUC__) && __GNUC__ >= 3) || defined(__INTEL_COMPILER)
#define __MATH_BUILTIN_CONSTANTS
#endif

#if (defined(__GNUC__) && __GNUC__ >= 3)
#define __MATH_BUILTIN_RELOPS
#endif

#ifdef __MATH_BUILTIN_CONSTANTS
#define HUGE_VAL        __builtin_huge_val()
#else
#define HUGE_VAL        (__infinity.__ud)
#endif

#if __ISO_C_VISIBLE >= 1999
#define FP_ILOGB0       (-__INT_MAX)
#define FP_ILOGBNAN     __INT_MAX

#ifdef __MATH_BUILTIN_CONSTANTS
#define HUGE_VALF       __builtin_huge_valf()
#define HUGE_VALL       __builtin_huge_vall()
#define INFINITY        __builtin_inf()
#define NAN             __builtin_nan("")
#else
#define HUGE_VALF       (float)HUGE_VAL
#define HUGE_VALL       (long double)HUGE_VAL
#define INFINITY        HUGE_VALF
#define NAN             (__nan.__uf)
#endif /* __MATH_BUILTIN_CONSTANTS */

#define MATH_ERRNO      1
#define MATH_ERREXCEPT  2
#define math_errhandling        0

/* Symbolic constants to classify floating point numbers. */
#define FP_INFINITE     0x01
#define FP_NAN          0x02
#define FP_NORMAL       0x04
#define FP_SUBNORMAL    0x08
#define FP_ZERO         0x10
#define fpclassify(x) \
    ((sizeof (x) == sizeof (float)) ? __fpclassifyf(x) \
    : (sizeof (x) == sizeof (double)) ? __fpclassifyd(x) \
    : __fpclassifyl(x))

#define isfinite(x)     ((fpclassify(x) & (FP_INFINITE|FP_NAN)) == 0)
#define isinf(x)        (fpclassify(x) == FP_INFINITE)
#define isnan(x)        (fpclassify(x) == FP_NAN)
#define isnormal(x)     (fpclassify(x) == FP_NORMAL)

#ifdef __MATH_BUILTIN_RELOPS
#define isgreater(x, y)         __builtin_isgreater((x), (y))
#define isgreaterequal(x, y)    __builtin_isgreaterequal((x), (y))
#define isless(x, y)            __builtin_isless((x), (y))
#define islessequal(x, y)       __builtin_islessequal((x), (y))
#define islessgreater(x, y)     __builtin_islessgreater((x), (y))
#define isunordered(x, y)       __builtin_isunordered((x), (y))
#else
#define isgreater(x, y)         (!isunordered((x), (y)) && (x) > (y))
#define isgreaterequal(x, y)    (!isunordered((x), (y)) && (x) >= (y))
#define isless(x, y)            (!isunordered((x), (y)) && (x) < (y))
#define islessequal(x, y)       (!isunordered((x), (y)) && (x) <= (y))
#define islessgreater(x, y)     (!isunordered((x), (y)) && \
                                        ((x) > (y) || (y) > (x)))
#define isunordered(x, y)       (isnan(x) || isnan(y))
#endif /* __MATH_BUILTIN_RELOPS */

#define signbit(x)      __signbit(x)

#endif /* __ISO_C_VISIBLE >= 1999 */

/*
 * XOPEN/SVID
 */
#if __BSD_VISIBLE || __XSI_VISIBLE
#define M_E             2.7182818284590452354   /* e */
#define M_LOG2E         1.4426950408889634074   /* log 2e */
#define M_LOG10E        0.43429448190325182765  /* log 10e */
#define M_LN2           0.69314718055994530942  /* log e2 */
#define M_LN10          2.30258509299404568402  /* log e10 */
#define M_PI            3.14159265358979323846  /* pi */
#define M_PI_2          1.57079632679489661923  /* pi/2 */
#define M_PI_4          0.78539816339744830962  /* pi/4 */
#define M_1_PI          0.31830988618379067154  /* 1/pi */
#define M_2_PI          0.63661977236758134308  /* 2/pi */
#define M_2_SQRTPI      1.12837916709551257390  /* 2/sqrt(pi) */
#define M_SQRT2         1.41421356237309504880  /* sqrt(2) */
#define M_SQRT1_2       0.70710678118654752440  /* 1/sqrt(2) */
#define M_DEG_TO_RAD 0.01745329251994
#define M_RAD_TO_DEG 57.2957795130823

#define MAXFLOAT        ((float)3.40282346638528860e+38)
extern int signgam;
#endif /* __BSD_VISIBLE || __XSI_VISIBLE */

#if __BSD_VISIBLE
enum fdversion {fdlibm_ieee = -1, fdlibm_svid, fdlibm_xopen, fdlibm_posix};

#define _LIB_VERSION_TYPE enum fdversion
#define _LIB_VERSION _fdlib_version

/* if global variable _LIB_VERSION is not desirable, one may
 * change the following to be a constant by:
 *      #define _LIB_VERSION_TYPE const enum version
 * In that case, after one initializes the value _LIB_VERSION (see
 * s_lib_version.c) during compile time, it cannot be modified
 * in the middle of a program
 */
extern  _LIB_VERSION_TYPE  _LIB_VERSION;

#define _IEEE_  fdlibm_ieee
#define _SVID_  fdlibm_svid
#define _XOPEN_ fdlibm_xopen
#define _POSIX_ fdlibm_posix

/* We have a problem when using C++ since `exception' is a reserved
   name in C++.  */
#ifndef __cplusplus
struct exception {
        int type;
        char *name;
        double arg1;
        double arg2;
        double retval;
};
#endif

#define isnanf(x)       isnan(x)

#if 0
/* Old value from 4.4BSD-Lite math.h; this is probably better. */
#define HUGE            HUGE_VAL
#else
#define HUGE            MAXFLOAT
#endif

#define X_TLOSS         1.41484755040568800000e+16      /* pi*2**52 */

#define DOMAIN          1
#define SING            2
#define OVERFLOW        3
#define UNDERFLOW       4
#define TLOSS           5
#define PLOSS           6

#endif /* __BSD_VISIBLE */

/*
 * Most of these functions have the side effect of setting errno, so they
 * are not declared as __pure2.  (XXX: this point needs to be revisited,
 * since C99 doesn't require the mistake of setting errno, and we mostly
 * don't set it anyway.  In C99, pragmas and functions for changing the
 * rounding mode affect the purity of these functions.)
 */
__BEGIN_DECLS
/*
 * ANSI/POSIX
 */
int     __fpclassifyd(double) __pure2;
int     __fpclassifyf(float) __pure2;
int     __fpclassifyl(long double) __pure2;
int     __signbit(double) __pure2;

double  acos(double);
double  asin(double);
double  atan(double);
double  atan2(double, double);
double  cos(double);
double  sin(double);
double  tan(double);

double  cosh(double);
double  sinh(double);
double  tanh(double);

double  exp(double);
double  frexp(double, int *);   /* fundamentally !__pure2 */
double  ldexp(double, int);
double  log(double);
double  log10(double);
double  modf(double, double *); /* fundamentally !__pure2 */

double  pow(double, double);
double  sqrt(double);

double  ceil(double);
double  fabs(double);
double  floor(double);
double  fmod(double, double);

/*
 * These functions are not in C90 so they can be "right".  The ones that
 * never set errno in lib/msun are declared as __pure2.
 */
#if __BSD_VISIBLE || __ISO_C_VISIBLE >= 1999 || __XSI_VISIBLE
double  acosh(double);
double  asinh(double);
double  atanh(double);
double  cbrt(double) __pure2;
double  erf(double);
double  erfc(double) __pure2;
double  expm1(double) __pure2;
double  fdim(double, double);
double  fmax(double, double) __pure2;
double  fmin(double, double) __pure2;
double  hypot(double, double);
int     ilogb(double);
double  lgamma(double);
double  log1p(double) __pure2;
double  logb(double) __pure2;
double  nearbyint(double) __pure2;
double  nextafter(double, double);
double  remainder(double, double);
double  rint(double) __pure2;
double  round(double);
double  trunc(double);
#endif /* __BSD_VISIBLE || __ISO_C_VISIBLE >= 1999 || __XSI_VISIBLE */

#if __BSD_VISIBLE || __XSI_VISIBLE
double  j0(double);
double  j1(double);
double  jn(int, double);
double  scalb(double, double);
double  y0(double);
double  y1(double);
double  yn(int, double);

#if __XSI_VISIBLE <= 500 || __BSD_VISIBLE
double  gamma(double);
#endif
#endif /* __BSD_VISIBLE || __XSI_VISIBLE */

#if __BSD_VISIBLE || __ISO_C_VISIBLE >= 1999
double  copysign(double, double) __pure2;
double  scalbln(double, long);
double  scalbn(double, int);
double  tgamma(double);
#endif

/*
 * BSD math library entry points
 */
#if __BSD_VISIBLE
double  drem(double, double);
int     finite(double) __pure2;

/*
 * Reentrant version of gamma & lgamma; passes signgam back by reference
 * as the second argument; user must allocate space for signgam.
 */
double  gamma_r(double, int *);
double  lgamma_r(double, int *);

/*
 * IEEE Test Vector
 */
double  significand(double);

#ifndef __cplusplus
int     matherr(struct exception *);
#endif
#endif /* __BSD_VISIBLE */

/* float versions of ANSI/POSIX functions */
float   acosf(float);
float   asinf(float);
float   atanf(float);
float   atan2f(float, float);
float   cosf(float);
float   sinf(float);
float   tanf(float);

float   coshf(float);
float   sinhf(float);
float   tanhf(float);

float   expf(float);
float   expm1f(float) __pure2;
float   frexpf(float, int *);   /* fundamentally !__pure2 */
int     ilogbf(float);
float   ldexpf(float, int);
float   log10f(float);
float   log1pf(float) __pure2;
float   logf(float);
float   modff(float, float *);  /* fundamentally !__pure2 */

float   powf(float, float);
float   sqrtf(float);

float   ceilf(float);
float   fabsf(float);
float   floorf(float);
float   fmodf(float, float);
float   roundf(float);

float   erff(float);
float   erfcf(float) __pure2;
float   hypotf(float, float) __pure2;
float   lgammaf(float);

float   acoshf(float);
float   asinhf(float);
float   atanhf(float);
float   cbrtf(float) __pure2;
float   logbf(float) __pure2;
float   copysignf(float, float) __pure2;
float   nearbyintf(float) __pure2;
float   nextafterf(float, float);
float   remainderf(float, float);
float   rintf(float);
float   scalblnf(float, long);
float   scalbnf(float, int);
float   truncf(float);

float   fdimf(float, float);
float   fmaxf(float, float) __pure2;
float   fminf(float, float) __pure2;

/*
 * float versions of BSD math library entry points
 */
#if __BSD_VISIBLE
float   dremf(float, float);
int     finitef(float) __pure2;
float   gammaf(float);
float   j0f(float);
float   j1f(float);
float   jnf(int, float);
float   scalbf(float, float);
float   y0f(float);
float   y1f(float);
float   ynf(int, float);

/*
 * Float versions of reentrant version of gamma & lgamma; passes
 * signgam back by reference as the second argument; user must
 * allocate space for signgam.
 */
float   gammaf_r(float, int *);
float   lgammaf_r(float, int *);

/*
 * float version of IEEE Test Vector
 */
float   significandf(float);
#endif  /* __BSD_VISIBLE */

/*
 * long double versions of ISO/POSIX math functions
 */
#if __ISO_C_VISIBLE >= 1999
#if 0
long double     acoshl(long double);
long double     acosl(long double);
long double     asinhl(long double);
long double     asinl(long double);
long double     atan2l(long double, long double);
long double     atanhl(long double);
long double     atanl(long double);
long double     cbrtl(long double);
long double     ceill(long double);
#endif
long double     copysignl(long double, long double);
#if 0
long double     coshl(long double);
long double     cosl(long double);
long double     erfcl(long double);
long double     erfl(long double);
long double     exp2l(long double);
long double     expl(long double);
long double     expm1l(long double);
#endif
long double     fabsl(long double);
long double     fdiml(long double, long double);
#if 0
long double     floorl(long double);
long double     fmal(long double, long double, long double);
#endif
long double     fmaxl(long double, long double) __pure2;
long double     fminl(long double, long double) __pure2;
#if 0
long double     fmodl(long double, long double);
long double     frexpl(long double      value, int *);
long double     hypotl(long double, long double);
int             ilogbl(long double);
long double     ldexpl(long double, int);
long double     lgammal(long double);
long long       llrintl(long double);
long long       llroundl(long double);
long double     log10l(long double);
long double     log1pl(long double);
long double     log2l(long double);
long double     logbl(long double);
long double     logl(long double);
long            lrintl(long double);
long            lroundl(long double);
long double     modfl(long double, long double  *);
long double     nanl(const char *);
long double     nearbyintl(long double);
long double     nextafterl(long double, long double);
double          nexttoward(double, long double);
float           nexttowardf(float, long double);
long double     nexttowardl(long double, long double);
long double     powl(long double, long double);
long double     remainderl(long double, long double);
long double     remquol(long double, long double, int *);
long double     rintl(long double);
long double     roundl(long double);
long double     scalblnl(long double, long);
long double     scalbnl(long double, int);
long double     sinhl(long double);
long double     sinl(long double);
long double     sqrtl(long double);
long double     tanhl(long double);
long double     tanl(long double);
long double     tgammal(long double);
long double     truncl(long double);
#endif

#endif /* __ISO_C_VISIBLE >= 1999 */

#define M_E_F  2.7182818284590452354f
#define M_LOG2E_F  1.4426950408889634074f
#define M_LOG10E_F   0.43429448190325182765f
#define M_LN2_F  _M_LN2_F
#define M_LN10_F   2.30258509299404568402f
#define M_PI_F   3.14159265358979323846f
#define M_TWOPI_F       (M_PI_F * 2.0f)
#define M_PI_2_F   1.57079632679489661923f
#define M_PI_4_F   0.78539816339744830962f
#define M_3PI_4_F  2.3561944901923448370E0f
#define M_SQRTPI_F      1.77245385090551602792981f
#define M_1_PI_F   0.31830988618379067154f
#define M_2_PI_F   0.63661977236758134308f
#define M_2_SQRTPI_F  1.12837916709551257390f
#define M_DEG_TO_RAD_F 0.01745329251994f
#define M_RAD_TO_DEG_F 57.2957795130823f
#define M_SQRT2_F  1.41421356237309504880f
#define M_SQRT1_2_F  0.70710678118654752440f
#define M_LN2LO_F       1.9082149292705877000E-10f
#define M_LN2HI_F       6.9314718036912381649E-1f
#define M_SQRT3_F  1.73205080756887719000f
#define M_IVLN10_F      0.43429448190325182765f /* 1 / log(10) */
#define M_LOG2_E_F      _M_LN2_F
#define M_INVLN2_F      1.4426950408889633870E0f  /* 1 / log(2) */

__END_DECLS

#endif /* !_MATH_H_ */