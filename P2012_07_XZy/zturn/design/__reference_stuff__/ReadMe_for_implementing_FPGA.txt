Starting from __reference_stuff__ directory:

1) Here we suppose that in ../linux_kernel there is the kernel tree sources
    1) At the end of compiling, the uImage is ready into boot_image directory

2) Create fpga implementation as follow:
    1) Create a new vivado project called 'fpga'
    2) From the 'Project settings/IP' set 'library' as repository directory
    3) Create a new block design called 'system'
    4) from the tcl console source the __reference_stuff__/whole_design.tcl This command recreate the BD design
    5) In the 'Design Sources' of the Block design add the __reference_stuff__/system_wrapper.v
    6) In the 'Constraints' of the Block design add __reference_stuff__/system.xdc
    7) Generare the bitstream
    8) Export the hardware and launch the SDK
    9) Add directory 'repo' as Global repository
    10) Generate the device_tree as Board Support Package (leave default name)
    11) Create a new Application Project called FSBL and choose Zynq FSBL as template
    12) From Xilinx Tools 'create Zynq boot image', select 'Import from existing BIF file' and choose boot_builder.bif as 'Output bif file path'. Then Create Image
    13) BOOT.BIN is now ready into boot_image directory

3) Create device_tree.dtb
    1) Launch start_script_device_tree into boot_image directory
    2) device_tree.dtb is now ready into boot_image directory

4) Import user applications (if any) from __reference_design__/user_apps into SDK



NOTE FOR IMPLEMENTING in ZTurn by Myir.
- After having instanced the Zynq ps7 system, push preset and load ZynqPreset_Myir.tcl
This set most of the features used by Zturn and the correct board delay time for DDR

- When generate the FSBL_bsp, by hands move the version of the sdps driver to 2.2 and xilfs to 3.0.
  Then push "regenerate BSP sources" button

- To compile the u-boot, types the following commands: make zynq_zturn_config; make
