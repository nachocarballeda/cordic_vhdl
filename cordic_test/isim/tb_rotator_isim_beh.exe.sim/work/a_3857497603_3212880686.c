/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/ignatius/Documents/fiuba/SistemasDigitales/proyectos_de_otra_gente/sdigitales-tfinal/rotator/src/cordic_stage.vhdl";
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);
char *ieee_p_1242562249_sub_3525738511873186323_1035706684(char *, char *, char *, char *, char *, char *);
char *ieee_p_1242562249_sub_3525738511873258197_1035706684(char *, char *, char *, char *, char *, char *);
char *ieee_p_1242562249_sub_5461289951233117757_1035706684(char *, char *, char *, char *, int );


static void work_a_3857497603_3212880686_p_0(char *t0)
{
    char t1[16];
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(32, ng0);

LAB3:    t2 = (t0 + 1032U);
    t3 = *((char **)t2);
    t2 = (t0 + 10216U);
    t4 = (t0 + 1672U);
    t5 = *((char **)t4);
    t4 = (t0 + 10280U);
    t6 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t5, t4);
    t7 = ieee_p_1242562249_sub_5461289951233117757_1035706684(IEEE_P_1242562249, t1, t3, t2, t6);
    t8 = (t1 + 12U);
    t9 = *((unsigned int *)t8);
    t9 = (t9 * 1U);
    t10 = (32U != t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t11 = (t0 + 5864);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t7, 32U);
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 5704);
    *((int *)t16) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t9, 0);
    goto LAB6;

}

static void work_a_3857497603_3212880686_p_1(char *t0)
{
    char t1[16];
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(33, ng0);

LAB3:    t2 = (t0 + 1192U);
    t3 = *((char **)t2);
    t2 = (t0 + 10232U);
    t4 = (t0 + 1672U);
    t5 = *((char **)t4);
    t4 = (t0 + 10280U);
    t6 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t5, t4);
    t7 = ieee_p_1242562249_sub_5461289951233117757_1035706684(IEEE_P_1242562249, t1, t3, t2, t6);
    t8 = (t1 + 12U);
    t9 = *((unsigned int *)t8);
    t9 = (t9 * 1U);
    t10 = (32U != t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t11 = (t0 + 5928);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t7, 32U);
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 5720);
    *((int *)t16) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t9, 0);
    goto LAB6;

}

static void work_a_3857497603_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(34, ng0);

LAB3:    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t3 = (24 - 1);
    t4 = (t3 - 23);
    t5 = (t4 * -1);
    t6 = (1U * t5);
    t7 = (0 + t6);
    t1 = (t2 + t7);
    t8 = *((unsigned char *)t1);
    t9 = (t0 + 5992);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t8;
    xsi_driver_first_trans_fast(t9);

LAB2:    t14 = (t0 + 5736);
    *((int *)t14) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3857497603_3212880686_p_3(char *t0)
{
    char t5[16];
    char t19[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned char t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;

LAB0:    xsi_set_current_line(36, ng0);
    t1 = (t0 + 2632U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB7:    t20 = (t0 + 1032U);
    t21 = *((char **)t20);
    t20 = (t0 + 10216U);
    t22 = (t0 + 2472U);
    t23 = *((char **)t22);
    t22 = (t0 + 10360U);
    t24 = ieee_p_1242562249_sub_3525738511873186323_1035706684(IEEE_P_1242562249, t19, t21, t20, t23, t22);
    t25 = (t19 + 12U);
    t26 = *((unsigned int *)t25);
    t27 = (1U * t26);
    t28 = (32U != t27);
    if (t28 == 1)
        goto LAB9;

LAB10:    t29 = (t0 + 6056);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t24, 32U);
    xsi_driver_first_trans_fast_port(t29);

LAB2:    t34 = (t0 + 5752);
    *((int *)t34) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 1032U);
    t6 = *((char **)t1);
    t1 = (t0 + 10216U);
    t7 = (t0 + 2472U);
    t8 = *((char **)t7);
    t7 = (t0 + 10360U);
    t9 = ieee_p_1242562249_sub_3525738511873258197_1035706684(IEEE_P_1242562249, t5, t6, t1, t8, t7);
    t10 = (t5 + 12U);
    t11 = *((unsigned int *)t10);
    t12 = (1U * t11);
    t13 = (32U != t12);
    if (t13 == 1)
        goto LAB5;

LAB6:    t14 = (t0 + 6056);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t9, 32U);
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t12, 0);
    goto LAB6;

LAB8:    goto LAB2;

LAB9:    xsi_size_not_matching(32U, t27, 0);
    goto LAB10;

}

static void work_a_3857497603_3212880686_p_4(char *t0)
{
    char t5[16];
    char t19[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned char t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;

LAB0:    xsi_set_current_line(38, ng0);
    t1 = (t0 + 2632U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB7:    t20 = (t0 + 1192U);
    t21 = *((char **)t20);
    t20 = (t0 + 10232U);
    t22 = (t0 + 2312U);
    t23 = *((char **)t22);
    t22 = (t0 + 10344U);
    t24 = ieee_p_1242562249_sub_3525738511873258197_1035706684(IEEE_P_1242562249, t19, t21, t20, t23, t22);
    t25 = (t19 + 12U);
    t26 = *((unsigned int *)t25);
    t27 = (1U * t26);
    t28 = (32U != t27);
    if (t28 == 1)
        goto LAB9;

LAB10:    t29 = (t0 + 6120);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t24, 32U);
    xsi_driver_first_trans_fast_port(t29);

LAB2:    t34 = (t0 + 5768);
    *((int *)t34) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 1192U);
    t6 = *((char **)t1);
    t1 = (t0 + 10232U);
    t7 = (t0 + 2312U);
    t8 = *((char **)t7);
    t7 = (t0 + 10344U);
    t9 = ieee_p_1242562249_sub_3525738511873186323_1035706684(IEEE_P_1242562249, t5, t6, t1, t8, t7);
    t10 = (t5 + 12U);
    t11 = *((unsigned int *)t10);
    t12 = (1U * t11);
    t13 = (32U != t12);
    if (t13 == 1)
        goto LAB5;

LAB6:    t14 = (t0 + 6120);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t9, 32U);
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t12, 0);
    goto LAB6;

LAB8:    goto LAB2;

LAB9:    xsi_size_not_matching(32U, t27, 0);
    goto LAB10;

}

static void work_a_3857497603_3212880686_p_5(char *t0)
{
    char t5[16];
    char t19[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned char t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;

LAB0:    xsi_set_current_line(40, ng0);
    t1 = (t0 + 2632U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB7:    t20 = (t0 + 1352U);
    t21 = *((char **)t20);
    t20 = (t0 + 10248U);
    t22 = (t0 + 1512U);
    t23 = *((char **)t22);
    t22 = (t0 + 10264U);
    t24 = ieee_p_1242562249_sub_3525738511873186323_1035706684(IEEE_P_1242562249, t19, t21, t20, t23, t22);
    t25 = (t19 + 12U);
    t26 = *((unsigned int *)t25);
    t27 = (1U * t26);
    t28 = (24U != t27);
    if (t28 == 1)
        goto LAB9;

LAB10:    t29 = (t0 + 6184);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t24, 24U);
    xsi_driver_first_trans_fast_port(t29);

LAB2:    t34 = (t0 + 5784);
    *((int *)t34) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 1352U);
    t6 = *((char **)t1);
    t1 = (t0 + 10248U);
    t7 = (t0 + 1512U);
    t8 = *((char **)t7);
    t7 = (t0 + 10264U);
    t9 = ieee_p_1242562249_sub_3525738511873258197_1035706684(IEEE_P_1242562249, t5, t6, t1, t8, t7);
    t10 = (t5 + 12U);
    t11 = *((unsigned int *)t10);
    t12 = (1U * t11);
    t13 = (24U != t12);
    if (t13 == 1)
        goto LAB5;

LAB6:    t14 = (t0 + 6184);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t9, 24U);
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB5:    xsi_size_not_matching(24U, t12, 0);
    goto LAB6;

LAB8:    goto LAB2;

LAB9:    xsi_size_not_matching(24U, t27, 0);
    goto LAB10;

}


extern void work_a_3857497603_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3857497603_3212880686_p_0,(void *)work_a_3857497603_3212880686_p_1,(void *)work_a_3857497603_3212880686_p_2,(void *)work_a_3857497603_3212880686_p_3,(void *)work_a_3857497603_3212880686_p_4,(void *)work_a_3857497603_3212880686_p_5};
	xsi_register_didat("work_a_3857497603_3212880686", "isim/tb_rotator_isim_beh.exe.sim/work/a_3857497603_3212880686.didat");
	xsi_register_executes(pe);
}
