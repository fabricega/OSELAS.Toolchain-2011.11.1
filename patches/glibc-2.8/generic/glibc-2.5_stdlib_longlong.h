---
 stdlib/longlong.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: glibc-2.8-20080811/stdlib/longlong.h
===================================================================
--- glibc-2.8-20080811.orig/stdlib/longlong.h
+++ glibc-2.8-20080811/stdlib/longlong.h
@@ -205,6 +205,14 @@ UDItype __umulsidi3 (USItype, USItype);
 	     "rI" ((USItype) (bh)),					\
 	     "r" ((USItype) (al)),					\
 	     "rI" ((USItype) (bl)) __CLOBBER_CC)
+/* v3m and all higher arches have long multiply support.  */
+#if !defined(__ARM_ARCH_2__) && !defined(__ARM_ARCH_3__)
+#define umul_ppmm(xh, xl, a, b) \
+  __asm__ ("umull %0,%1,%2,%3" : "=&r" (xl), "=&r" (xh) : "r" (a), "r" (b))
+#define UMUL_TIME 5
+#define smul_ppmm(xh, xl, a, b) \
+  __asm__ ("smull %0,%1,%2,%3" : "=&r" (xl), "=&r" (xh) : "r" (a), "r" (b))
+#else
 #define umul_ppmm(xh, xl, a, b) \
 {register USItype __t0, __t1, __t2;					\
   __asm__ ("%@ Inlined umul_ppmm\n"					\
@@ -226,7 +234,13 @@ UDItype __umulsidi3 (USItype, USItype);
 	   : "r" ((USItype) (a)),					\
 	     "r" ((USItype) (b)) __CLOBBER_CC );}
 #define UMUL_TIME 20
+#endif
 #define UDIV_TIME 100
+#if defined(__ARM_ARCH_5__) || defined(__ARM_ARCH_5T__) || defined(__ARM_ARCH_5TE__)
+#define count_leading_zeros(COUNT,X)   ((COUNT) = __builtin_clz (X))
+#define COUNT_LEADING_ZEROS_0 32
+#endif
+
 #endif /* __arm__ */
 
 #if defined (__hppa) && W_TYPE_SIZE == 32
