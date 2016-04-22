# P2012_07_XZy for Zturn 7020

## Contents
This project is related to a fully working ZTurn (except HDMI). All the on board features of the ZTurn are correctly managed by the FPGA.

![top-view](http://www.myirtech.com/attached/image/20150129/zturnboard-interface.jpg)

## Installing
The [board definition files] can be copied in the directory <path_to_repo>. For instance, in your home directory, i.e. under: ~/boards/boards/board_files/zturn-7020/2.1/. Then add the following line to your Vivado init script (`~/.Xilinx/Vivado/init.tcl`):
```tcl
set_param board.repoPaths [list "<path_to_repo>/boards/board_files"]
```
For instructions on how to install the board definition files, the following wiki page can be used.
https://reference.digilentinc.com/vivado:boardfiles2015. For a full description of the board definition XML schemas, please consult UG895, Appendix A *Board Interface File*.

### Linux Kernel
The tested linux kernel is from [https://github.com/andreamerello/linux-zynq-stable]

#### Acknowledgements
Thanks to [stv0g] and his useful *zturn-stuff* repository.

[board definition files]: https://github.com/francescodiotalevi/projects/tree/master/P2012_07_XZy/zturn/boards/board_files/zturn-7020/2.1
[https://github.com/andreamerello/linux-zynq-stable]: <https://github.com/andreamerello/linux-zynq-stable/tree/linux-4.1.13-zynq>
[stv0g]: <https://github.com/stv0g>



