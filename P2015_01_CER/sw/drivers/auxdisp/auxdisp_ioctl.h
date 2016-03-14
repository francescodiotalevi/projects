#ifndef IIT_AUXDISP_IOCTL_H
#define IIT_AUXDISP_IOCTL_H

#define IOC_MAGIC_NUMBER 0x98
#define IOC_GET_VER      _IOR(IOC_MAGIC_NUMBER, 0, unsigned int)
#define IOC_SET_FC       _IOW(IOC_MAGIC_NUMBER, 1, unsigned int)
#define IOC_GET_CTRL     _IOR(IOC_MAGIC_NUMBER, 2, unsigned int)
#define IOC_RESET_IP     _IOW(IOC_MAGIC_NUMBER, 3, unsigned int)
#define IOC_GEN_REG      _IOWR(IOC_MAGIC_NUMBER, 4, struct auxdisp_regs *)
#define IOC_SET_BPP      _IOW(IOC_MAGIC_NUMBER, 5, unsigned int)
#define IOC_GET_VL       _IOW(IOC_MAGIC_NUMBER, 6, unsigned int)
#define IOC_SET_VL       _IOW(IOC_MAGIC_NUMBER, 7, unsigned int)
#define IOC_GET_ENABLE   _IOW(IOC_MAGIC_NUMBER, 8, unsigned int)
#define IOC_SET_ENABLE   _IOW(IOC_MAGIC_NUMBER, 9, unsigned int)

#endif
