#ifndef IIT_AUXDISP_H
#define IIT_AUXDISP_H

#define ENABLE  1
#define DISABLE 0
#define CLEAR   1

#define LINES_PER_ROW     16
#define NUM_ROWS           2
#define NUM_CHIPS_PER_ROW  5


typedef struct uint48 {
    unsigned long long v:48;
} __attribute__((packed)) uint48_t;


typedef struct auxdisp_regs {
    uint32_t reg_offset;
    char rw;
    uint32_t data;
} auxdisp_regs_t;

// Internal registers

#define REG_CONF 0x04
#define DMA_LENGTH	(16)

#define AUXDISP_VER              0x00
#define AUXDISP_CTRL             0x04
#define AUXDISP_INTMSK           0x08
#define AUXDISP_INT              0x0c
#define AUXDISP_RAWSTAT          0x10
#define AUXDISP_TIME             0x14
#define AUXDISP_IMPL             0x18

#define AUXDISP_VER_MSK          0xFFFFFFFF

#define AUXDISP_CTRL_EN          BIT(0)
#define AUXDISP_CTRL_IE          BIT(1)
#define AUXDISP_CTRL_RESETIP     BIT(2)
#define AUXDISP_CTRL_CMD_MSK     ( BIT(7) | BIT(6) | BIT(5) | BIT(4) )
#define AUXDISP_CTRL_BPP_MSK     ( BIT(18) | BIT(17) | BIT(16) )

#define AUXDISP_CTRL_CMD_NULL    (0<<4)
#define AUXDISP_CTRL_CMD_WRTFC   (1<<4)
#define AUXDISP_CTRL_CMD_WRTGS   (4<<4)

#define AUXDISP_CTRL_BPP_48      (0)
#define AUXDISP_CTRL_BPP_24      (1)
#define AUXDISP_CTRL_BPP_16      (2)

#define AUXDISP_INT_FC           BIT(8)
#define AUXDISP_INT_PIXEL        BIT(9)
#define AUXDISP_INT_LINE         BIT(10)
#define AUXDISP_INT_ENDBANK      BIT(11)
#define AUXDISP_INT_ENDVSYNC     BIT(12)

#define AUXDISP_TIME_TSU3        0x000000FF
#define AUXDISP_TIME_IBS         0x00FF0000

#define AUXDISP_IMPL_MSK         0X00003FFF

#endif

