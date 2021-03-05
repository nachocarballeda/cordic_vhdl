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
static const char *ng0 = "/home/ignatius/Documents/fiuba/SistemasDigitales/proyectos_de_otra_gente/sdigitales-tfinal/rotator/verification/tb_rotator/tb_rotator.vhdl";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_1242562249;

char *ieee_p_1242562249_sub_17126692536656888728_1035706684(char *, char *, int , int );
unsigned char ieee_p_2592010699_sub_374109322130769762_503743352(char *, unsigned char );


static void work_a_0337178739_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    int64 t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(70, ng0);

LAB3:    t1 = (t0 + 3248U);
    t2 = *((char **)t1);
    t3 = *((int64 *)t2);
    t4 = (t3 / 2);
    t1 = (t0 + 1032U);
    t5 = *((char **)t1);
    t6 = *((unsigned char *)t5);
    t7 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t6);
    t1 = (t0 + 6208);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t7;
    xsi_driver_first_trans_delta(t1, 0U, 1, t4);
    t12 = (t0 + 6208);
    xsi_driver_intertial_reject(t12, t4, t4);

LAB2:    t13 = (t0 + 6032);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_0337178739_3212880686_p_1(char *t0)
{
    char t2[16];
    int64 t1;
    char *t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    xsi_set_current_line(74, ng0);

LAB3:    t1 = (1 * 1000LL);
    t3 = ieee_p_1242562249_sub_17126692536656888728_1035706684(IEEE_P_1242562249, t2, 100, 32);
    t4 = (32U != 32U);
    if (t4 == 1)
        goto LAB5;

LAB6:    t5 = (t0 + 6272);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t3, 32U);
    xsi_driver_first_trans_delta(t5, 0U, 32U, t1);
    t10 = (t0 + 6272);
    xsi_driver_intertial_reject(t10, t1, t1);

LAB2:    t11 = (t0 + 6048);
    *((int *)t11) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(32U, 32U, 0);
    goto LAB6;

}

static void work_a_0337178739_3212880686_p_2(char *t0)
{
    char t2[16];
    int64 t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(75, ng0);

LAB3:    t1 = (1 * 1000LL);
    t3 = ieee_p_1242562249_sub_17126692536656888728_1035706684(IEEE_P_1242562249, t2, 100, 32);
    t4 = (t2 + 12U);
    t5 = *((unsigned int *)t4);
    t5 = (t5 * 1U);
    t6 = (32U != t5);
    if (t6 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 6336);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_delta(t7, 0U, 32U, t1);
    t12 = (t0 + 6336);
    xsi_driver_intertial_reject(t12, t1, t1);

LAB2:    t13 = (t0 + 6064);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t5, 0);
    goto LAB6;

}

static void work_a_0337178739_3212880686_p_3(char *t0)
{
    char t2[16];
    int64 t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(76, ng0);

LAB3:    t1 = (1 * 1000LL);
    t3 = ieee_p_1242562249_sub_17126692536656888728_1035706684(IEEE_P_1242562249, t2, 0, 32);
    t4 = (t2 + 12U);
    t5 = *((unsigned int *)t4);
    t5 = (t5 * 1U);
    t6 = (32U != t5);
    if (t6 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 6400);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 32U);
    xsi_driver_first_trans_delta(t7, 0U, 32U, t1);
    t12 = (t0 + 6400);
    xsi_driver_intertial_reject(t12, t1, t1);

LAB2:    t13 = (t0 + 6080);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(32U, t5, 0);
    goto LAB6;

}

static void work_a_0337178739_3212880686_p_4(char *t0)
{
    char t2[16];
    int64 t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(78, ng0);

LAB3:    t1 = (1 * 1000LL);
    t3 = ieee_p_1242562249_sub_17126692536656888728_1035706684(IEEE_P_1242562249, t2, 90, 8);
    t4 = (t2 + 12U);
    t5 = *((unsigned int *)t4);
    t5 = (t5 * 1U);
    t6 = (8U != t5);
    if (t6 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 6464);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 8U);
    xsi_driver_first_trans_delta(t7, 0U, 8U, t1);
    t12 = (t0 + 6464);
    xsi_driver_intertial_reject(t12, t1, t1);

LAB2:    t13 = (t0 + 6096);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(8U, t5, 0);
    goto LAB6;

}

static void work_a_0337178739_3212880686_p_5(char *t0)
{
    char t2[16];
    int64 t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(79, ng0);

LAB3:    t1 = (1 * 1000LL);
    t3 = ieee_p_1242562249_sub_17126692536656888728_1035706684(IEEE_P_1242562249, t2, 0, 8);
    t4 = (t2 + 12U);
    t5 = *((unsigned int *)t4);
    t5 = (t5 * 1U);
    t6 = (8U != t5);
    if (t6 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 6528);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 8U);
    xsi_driver_first_trans_delta(t7, 0U, 8U, t1);
    t12 = (t0 + 6528);
    xsi_driver_intertial_reject(t12, t1, t1);

LAB2:    t13 = (t0 + 6112);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(8U, t5, 0);
    goto LAB6;

}

static void work_a_0337178739_3212880686_p_6(char *t0)
{
    char t2[16];
    int64 t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(80, ng0);

LAB3:    t1 = (1 * 1000LL);
    t3 = ieee_p_1242562249_sub_17126692536656888728_1035706684(IEEE_P_1242562249, t2, 0, 8);
    t4 = (t2 + 12U);
    t5 = *((unsigned int *)t4);
    t5 = (t5 * 1U);
    t6 = (8U != t5);
    if (t6 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 6592);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t3, 8U);
    xsi_driver_first_trans_delta(t7, 0U, 8U, t1);
    t12 = (t0 + 6592);
    xsi_driver_intertial_reject(t12, t1, t1);

LAB2:    t13 = (t0 + 6128);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(8U, t5, 0);
    goto LAB6;

}


extern void work_a_0337178739_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0337178739_3212880686_p_0,(void *)work_a_0337178739_3212880686_p_1,(void *)work_a_0337178739_3212880686_p_2,(void *)work_a_0337178739_3212880686_p_3,(void *)work_a_0337178739_3212880686_p_4,(void *)work_a_0337178739_3212880686_p_5,(void *)work_a_0337178739_3212880686_p_6};
	xsi_register_didat("work_a_0337178739_3212880686", "isim/tb_rotator_isim_beh.exe.sim/work/a_0337178739_3212880686.didat");
	xsi_register_executes(pe);
}
