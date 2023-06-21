# ConAttest

set up tftp server to reload optee image through ethernet

Installation
sudo apt-get install tftpd-hpa
sudo service tftpd-hpa status
netstat -a | grep tftp

Configuration
sudo mkdir /tftpboot
sudo cp /etc/default/tftpd-hpa /etc/default/tftpd-hpa.ORIGINAL
sudo vi /etc/default/tftpd-hpa
TFTP_DIRECTORY=”/tftpboot”
TFTP_OPTIONS=”--secure --create”
TFTP_ADDRESS=”:69″

Modify Permissions on TFTP Root Directory
sudo chown -R tftp:nogroup /tftp
service tftpd-hpa restart

Test:

Create a file named test with some content in /tftpboot path of the tftp server
$ ls / > /tftpboot/test
$ sudo chmod -R 777 /tftpboot
$ ls /tftpboot/test -lh
Obtain the ip address of the tftp server using ifconfig command

Now in some other system follow the following steps.
$ tftp 192.168.0.174
tftp> get test
Sent 159 bytes in 0.0 seconds
tftp> quit


SETTING UP NAVIO MAVROS (Download install and open GCS before)
ssh pi@192.168.0.158 // 192.168.0.158 is pi ip

echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
sudo /opt/ros/kinetic/lib/mavros/install_geographiclib_datasets.sh

tmux new -s ros // ctrl b + %; ctrl b + "; ctrl b + o
1st: roscore
2nd: 
sudo vi /etc/default/arducopter // 14550 change to 14650
sudo emlidtool ardupilot // start systemctl service.. OR use sudo systemctl restart arducopter
rosrun mavros mavros_node _fcu_url:=udp://:14650@ _gcs_url:=udp://:14551@192.168.0.146:14550  //192.168.0.146 is my mac ip
3rd:
rostopic echo /mavros/imu/data


BTW: this disables UART, bc UART driver now for other function. changed baud rate also
*** so might be able to directly change the Image and bcmXXX.dtb and include optee? Let's try! NOPE, bcmXXX.dtb does not work, see the snapshot. Image load perfectly though.

let's find out how to enable ardupilot.service

pi@navio:~ $ systemctl status ardupilot.service 
● ardupilot.service - ArduPilot for Linux
   Loaded: error (Reason: Invalid argument)
   Active: inactive (dead)
     Docs: https://docs.emlid.com/navio2/navio-ardupilot/installation-and-running/#autostarting-ardupilot-on-boot

Mar 10 00:09:20 navio systemd[1]: ardupilot.service: Service lacks both ExecStart= and ExecStop= setting. Refusing.
Mar 10 00:09:20 navio systemd[1]: ardupilot.service: Service lacks both ExecStart= and ExecStop= setting. Refusing.
Mar 10 00:09:20 navio systemd[1]: ardupilot.service: Service lacks both ExecStart= and ExecStop= setting. Refusing.

/etc/systemd/system/ardupilot.service
pi@navio:~ $ cat /etc/systemd/system/ardu
arducopter.service  arduplane.service   ardusub.service
ardupilot.service   ardurover.service   

pi@navio:~ $ cat /etc/systemd/system/ardupilot.service 
[Unit]
Description=ArduPilot for Linux
After=systemd-modules-load.service
Documentation=https://docs.emlid.com/navio2/navio-ardupilot/installation-and-running/#autostarting-ardupilot-on-boot
Conflicts=arduplane.service arducopter.service ardurover.service ardusub.service

[Service]
EnvironmentFile=/etc/default/ardupilot

###############################################################################
####### DO NOT EDIT ABOVE THIS LINE UNLESS YOU KNOW WHAT YOU"RE DOING #########
###############################################################################

# Uncomment and modify this line if you want to launch your own binary
#ExecStart=/bin/sh -c "/home/pi/<path>/<to>/<your>/<binary> ${ARDUPILOT_OPTS}"

##### CAUTION ######
# There should be only one uncommented ExecStart in this file

###############################################################################
######## DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU"RE DOING ########
###############################################################################

Restart=on-failure

[Install]
WantedBy=multi-user.target

ExecStart=/bin/sh -c "/usr/bin/arducopter ${ARDUPILOT_OPTS}" for arducopter

tftpboot_bk/Image <- this suppose to be native linux for rpi3 from OPTEE
pi@navio:~ $ uname -a
Linux navio 4.6.3-17583-g7d976fc #1 SMP Thu Feb 7 12:51:46 EST 2019 aarch64 GNU/Linux

raspbian: kernel7.img -> Image <- this suppose to be Kernel was updated to 4.14.95
Linux navio 4.6.3-17583-g7d976fc #1 SMP Thu Feb 7 12:51:46 EST 2019 aarch64 GNU/Linux

so i guess this uname -a reads rootfs?

● systemd-modules-load.service - Load Kernel Modules
   Loaded: loaded (/lib/systemd/system/systemd-modules-load.service; static; vendor preset: enabled)
   Active: failed (Result: exit-code) since Tue 2019-03-12 15:48:52 UTC; 7min ago
     Docs: man:systemd-modules-load.service(8)
           man:modules-load.d(5)
  Process: 132 ExecStart=/lib/systemd/systemd-modules-load (code=exited, status=1/FAILURE)
 Main PID: 132 (code=exited, status=1/FAILURE)

Mar 12 15:48:52 navio systemd[1]: systemd-modules-load.service: Main process exited, code=exited, status=1/FAILURE
Mar 12 15:48:52 navio systemd[1]: Failed to start Load Kernel Modules.
Mar 12 15:48:52 navio systemd[1]: systemd-modules-load.service: Unit entered failed state.
Mar 12 15:48:52 navio systemd[1]: systemd-modules-load.service: Failed with result 'exit-code'.
Warning: Journal has been rotated since unit was started. Log output is incomplete or unavailable.

[FAILED] Failed to start Load Kernel Modules.
See 'systemctl status systemd-modules-load.service' for details.
         Starting Apply Kernel Variables...
         Mounting Configuration File System...
         Starting udev Kernel Device Manager...
         Starting Remount Root and Kernel File Systems...

emlid tool is a wrapper to set up ardu* binaries
ardu* binaries needs kernel module in /sys/class/pmw...
check the requirement of installing ardu* on native raspbian image.


/home/osboxes/devel/optee/linux-rt-rpi/arch/arm/boot/dts/overlays/.rcio.dtbo.cmd:
cmd_arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo := mkdir -p arch/arm64/boot/dts/broadcom/../overlays/ ; /home/osboxes/devel/optee/build/../toolchains/aarch64/bin/aarch64-linux-gnu-gcc -E -Wp,-MD,arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.d.pre.tmp -nostdinc -I./scripts/dtc/include-prefixes -undef -D__DTS__ -x assembler-with-cpp -o arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.dts.tmp arch/arm64/boot/dts/broadcom/../overlays/rcio-overlay.dts ; ./scripts/dtc/dtc -@ -H epapr -O dtb -o arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo -b 0 -i arch/arm64/boot/dts/broadcom/../overlays/ -Wno-unit_address_vs_reg -Wno-simple_bus_reg -Wno-unit_address_format -Wno-pci_bridge -Wno-pci_device_bus_num -Wno-pci_device_reg  -d arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.d.dtc.tmp arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.dts.tmp ; cat arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.d.pre.tmp arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.d.dtc.tmp > arch/arm64/boot/dts/broadcom/../overlays/.rcio.dtbo.d

source_arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo := arch/arm64/boot/dts/broadcom/../overlays/rcio-overlay.dts

deps_arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo := \

arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo: $(deps_arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo)

$(deps_arch/arm64/boot/dts/broadcom/../overlays/rcio.dtbo):

//


/home/osboxes/devel/optee/linux-rt-rpi/arch/arm/boot/dts/overlays/.rcio.dtbo.dts.tmp:
# 1 "arch/arm64/boot/dts/broadcom/../overlays/rcio-overlay.dts"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "arch/arm64/boot/dts/broadcom/../overlays/rcio-overlay.dts"
/dts-v1/;
/plugin/;

/ {
        compatible = "brcm,bcm2709";

        fragment@0 {
                target = <&spi1>;
                __overlay__ {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        status = "okay";

                        rcio@0 {
                                compatible = "rcio";
                                spi-max-frequency = <4000000>;
                                reg = <0>;
                                status = "okay";
                        };
                };
        };
};

dtoverlay=rcio in config.txt

The Raspberry Pi B+ has been designed specifically with add-on boards in mind and today we are introducing ‘HATs’ (Hardware Attached on Top). A HAT is an add-on board for B+ that conforms to a specific set of rules that will make life easier for users. A significant feature of HATs is the inclusion of a system that allows the B+ to identify a connected HAT and automatically configure the GPIOs and drivers for the board, making life for the end user much easier!

In a nutshell a HAT is a rectangular board (65x56mm) that has four mounting holes in the (nicely rounded) corners that align with the mounting holes on the B+, has a 40W GPIO header and supports the special autoconfiguration system that allows automatic GPIO setup and driver setup. The automatic configuration is achieved using 2 dedicated pins (ID_SD and ID_SC) on the 40W B+ GPIO header that are reserved for an I2C EEPROM. The EEPROM holds the board manufacturer information, GPIO setup and a thing called a ‘device tree‘ fragment – basically a description of the attached hardware that allows Linux to automatically load the required drivers.



/home/osboxes/devel/optee/build/rpi3/firmware/config.txt

enable_uart=1
arm_control=0x200
kernel_old=1

kernel=u-boot-rpi.bin
#enable_jtag_gpio=1

disable_commandline_tags=1

# set display mode to 1920x1080
##hdmi_group=2
##hdmi_mode=82




/home/osboxes/devel/optee/build/rpi3/firmware/uboot.env.txt

# generic params
bootdelay=3
stderr=serial,lcd
stdin=serial,usbkbd
stdout=serial,lcd

# CPU config
cpu=armv8
smp=on

# Console config
baudrate=115200
sttyconsole=ttyS0
ttyconsole=tty0

# Kernel/firmware/dtb filenames & load addresses
atf_load_addr=0x08400000
atf_file=optee.bin
boot_it=booti ${kernel_addr_r} - ${fdt_addr_r}
fdt_addr_r=0x1700000
fdtfile=bcm2710-rpi-3-b.dtb
filesize=5a65c
initrd_high=ffffffff
kernel_addr_r=0x10000000

# NFS/TFTP boot configuraton
gatewayip=192.168.0.1
netmask=255.255.255.0
tftpserverip=192.168.0.174
nfspath=/srv/nfs/rpi

# bootcmd & bootargs configuration
preboot=usb start
bootcmd=run mmcboot
load_dtb=fatload mmc 0:1 ${fdt_addr_r} ${fdtfile}
load_firmware=fatload mmc 0:1 ${atf_load_addr} ${atf_file}
load_kernel=fatload mmc 0:1 ${kernel_addr_r} Image
mmcboot=run load_kernel; run load_dtb; run load_firmware; run set_bootargs_tty set_bootargs_mmc set_common_args; run boot_it
nfsboot=usb start; dhcp ${kernel_addr_r} ${tftpserverip}:Image; dhcp ${fdt_addr_r} ${tftpserverip}:${fdtfile}; dhcp ${atf_load_addr} ${tftpserverip}:${atf_file}; run set_bootargs_tty set_bootargs_nfs set_common_args; run boot_it
set_bootargs_tty=setenv bootargs console=${ttyconsole} console=${sttyconsole},${baudrate}
set_bootargs_nfs=setenv bootargs ${bootargs} root=/dev/nfs rw rootfstype=nfs nfsroot=${tftpserverip}:${nfspath},udp,vers=3 ip=dhcp
set_bootargs_mmc=setenv bootargs ${bootargs} root=/dev/mmcblk0p2 rw rootfs=ext4
set_common_args=setenv bootargs ${bootargs} smsc95xx.macaddr=${ethaddr} 'ignore_loglevel dma.dmachans=0x7f35 rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3dc00000 vc_mem.mem_size=0x3f000000'


So when boot, load kernel Image, load .dtb (kernel parse it to know which kernel modules to load), load optee.bin.
then give control to boot_it at boot_it=booti ${kernel_addr_r} - ${fdt_addr_r}.  fdt_addr_r=0x1700000 kernel_addr_r=0x10000000




//
Once the config.txt file has been loaded and parsed, the third stage bootloader will also load cmdline.txt and kernel.img. cmdline.txt is a file containing the kernel command line parameters to be passed to the kernel at boot. It will load kernel.img into the shared memory allocated to the ARM processor, and release the ARM processor from reset. Your kernel should now start booting.

The third stage bootloader - start.elf, also passes extra parameters to the kernel than contained within the cmdline.txt. For example, my Linux Kernel receives the following parameters, specifying DMA channels, GPU parameters, MAC addresses, eMMC clock speeds and allowable Kernel Memory size.

dma.dmachans=0x7f35 
bcm2708_fb.fbwidth=1280 
bcm2708_fb.fbheight=1024 
bcm2708.boardrev=0xe 
bcm2708.serial=0xd9b35572 
smsc95xx.macaddr=B8:27:EB:B3:55:72 
sdhci-bcm2708.emmc_clock_freq=250000000 
vc_mem.mem_base=0xec00000 
vc_mem.mem_size=0x10000000  
console=ttyAMA0,115200 
kgdboc=ttyAMA0,115200 
console=tty1 
root=/dev/mmcblk0p2 
rootfstype=ext4 
rootwait
Mainline Linux Kernels may not parse these extra parameters.
//

/home/osboxes/devel/optee/linux-rt-rpi/arch/arm64/configs/bcmrpi3_defconfig

i guess this set up the .config for making rpi3 kernel.

make distclean
make ARCH=arm64 bcmrpi3_defconfig
ARCH=arm64 CROSS_COMPILE=/home/osboxes/devel/optee/toolchains/aarch64/bin/aarch64-linux-gnu- make all

osboxes@osboxes:~/devel/optee/linux-rt-rpi$ find ./ -name overlays
./arch/arm64/boot/dts/overlays
./arch/arm/boot/dts/overlays
osboxes@osboxes:~/devel/optee/linux-rt-rpi$ find ./ -name *.dtb
./arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dtb
./arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b-plus.dtb
./arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb

i guess vmlinux is the kernel image i want.
No, Image is what i want

LINUX_IMAGE		?= $(LINUX_PATH)/arch/arm64/boot/Image
LINUX_DTB		?= $(LINUX_PATH)/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb

kernel_old = 1 :
device_tree_address=0x200000
device_tree_end=0x208000


U-Boot> md 0x0 20   
00000000: d2a80000 b900001f 52b00001 b9000801    ...........R....
00000010: 58000300 d51be000 d51ce07f d2867fe0    ...X............
00000020: d51e1140 d280b600 d51e1100 d2800800    @...............
00000030: d519f220 d53800a6 924004c6 b40000e6     .....8...@.....
00000040: 100004c5 d503205f f86678a4 b4ffffc4    ...._ ...xf.....
00000050: d2800000 14000003 580003c4 580004e0    ...........X...X
00000060: d2800001 d2800002 d2800003 d61f0080    ................
00000070: 0124f800 00000000 00000000 00000000    ..$.............

start from
U-Boot> md 0x7ff0
00007ff0: 00000000 00000000 00000000 00000000    ................
00008000: 1400000a d503201f 00008000 00000000    ..... ..........
00008010: 000538a0 00000000 000538a0 00000000    .8.......8......
00008020: 000b3088 00000000 10003ec0 d5384241    .0.......>..AB8.
has value until 
U-Boot> md 0x80d0
000080d0: 540000a0 f100203f 540000a0 f100103f    ...T? .....T?...
000080e0: 540000a0 d51ec000 14000004 d51cc000    ...T............
000080f0: 14000002 d518c000 d65f03c0 00000000    .........._.....
00008100: 00000000 00000000 00000000 00000000    ................


start from
U-Boot> md 0x7fff0
0007fff0: 55555555 55555555 55555555 55555555    UUUUUUUUUUUUUUUU
00080000: 0f03130f 0f030f03 0f030f03 0f030f03    ................
00080010: 0f030f03 0f030f03 0f030f03 0f030f03    ................
has value until 
U-Boot> md 0x62000
00062000: 6b006c61 726c7361 6565732d 65760064    al.kaslr-seed.ve
00062010: 726f646e 6f727000 74637564 6f727000    ndor.product.pro
00062020: 74637564 0064695f 646f7270 5f746375    duct_id.product_
00062030: 00726576 64697575 55555500 55555555    ver.uuid.UUUUUUU
00062040: 55555555 55555555 55555555 55555555    UUUUUUUUUUUUUUUU
00062050: 55555555 55555555 55555555 55555555    UUUUUUUUUUUUUUUU


start from
U-Boot> md 0xffff0
000ffff0: 55555555 55555555 55555555 55555555    UUUUUUUUUUUUUUUU
00100000: 464c457f 00010101 00000000 00000000    .ELF............
00100010: 00890002 00000001 fec00200 00000034    ............4...
00100020: 002bc184 00000100 00200034 00280018    ..+.....4. ...(.
00100030: 002b002c 00000001 000004a0 fec00100    ,.+.............
00100040: fec00100 00000100 00000100 00000006    ................
has value until 
U-Boot> md 0x39f600
0039f600: 00000000 00000000 00000000 00000000    ................
0039f610: dc4d1100 00000000 ffffffff ffffffff    ..M.............
0039f620: 00000000 00000000 00000000 00000000    ................

# kernel_old = 1 : does not boot with optee u-boot_rpi.bin

kernel_old = 1 : u-boot-rpi.bin
device_tree_address=0x2000000
device_tree_end=0x2008000

U-Boot> md 0x2000000
02000000: aaaaaaaa aaaaaaaa aaaaaaaa aaaaaaaa    ................
02000010: aaaaaaaa aaaaaaaa aaaaaaaa aaaaaaaa    ................
02000020: aaaaaaaa aaaaaaaa aaaaaaaa aaaaaaaa    ................


kernel_old = 1 : u-boot-rpi.bin
device_tree_address=0x400000
device_tree_end=0x408000

U-Boot> md 0x400000
00400000: 55555555 55555555 55555555 55555555    UUUUUUUUUUUUUUUU
00400010: 55555555 55555555 55555555 55555555    UUUUUUUUUUUUUUUU

QUESTION: 0x100 ~ 0x8000 empty. kernel_old = 1 suppose to load kernel (u-boot.bin, or kernel7.img) to 0x0?

kernel_old = 1 : u-boot-rpi.bin
device_tree_address=0x100
device_tree_end=0x8000 

U-Boot> md 0x7f00
00007f00: 00000000 00000000 00000000 00000000    ................
00007f10: 00000000 00000000 00000000 00000000    ................
U-Boot> md 0x100 
00000100: 00000000 00000000 00000000 00000000    ................
00000110: 00000000 00000000 00000000 00000000    ................

optee rpi3 firmware plus u-boot-2017 does not work
optee rpi3 firmware plus device_tree_address=0x100 device_tree_end=0x8000 does not work.

followed https://dius.com.au/2015/08/19/raspberry-pi-uboot/ for start.elf load dtb and overlay, no luck
followed https://a-delacruz.github.io/ubuntu/rpi3-setup-64bit-uboot.html for updating uboot to load dtb and overlay in uboot, no luck

optee rpi3 firmware plus u-boot-2017 added head.S to be u-boot-rpi3.bin with kernel_old =1 does not work.

currently only optee uboot works:
U-Boot> pri
atf_file=optee.bin
atf_load_addr=0x08400000
baudrate=115200
board_name=3 Model B
board_rev=0x8
board_rev_scheme=1
board_revision=0xA22082
boot_it=booti ${kernel_addr_r} - ${fdt_addr_r}
bootcmd=run mmcboot
bootdelay=5
cpu=armv8
ethact=sms0
ethaddr=b8:27:eb:ec:ce:c2
fdt_addr_r=0x2000000
fdtfile=bcm2837-rpi-3-b.dtb
gatewayip=192.168.0.1
initrd_high=ffffffff
kernel_addr_r=0x10000000
load_firmware=fatload mmc 0:1 ${atf_load_addr} ${atf_file}
load_kernel=fatload mmc 0:1 ${kernel_addr_r} Image
mmcboot=run load_kernel; run load_firmware; run set_bootargs_tty set_bootargs_mmc set_common_args; run boot_it
netmask=255.255.255.0
nfsboot=usb start; dhcp ${kernel_addr_r} ${tftpserverip}:Image; dhcp ${fdt_addr_r} ${tftpserverip}:${fdtfile}; dhcp ${atf_load_addr} ${tftpserverip}:${atf_file}; run set_bootargs_tty set_bootargs_nfs set_common_args; run boot_it
nfspath=/srv/nfs/rpi
preboot=usb start
serial#=0000000031eccec2
set_bootargs_mmc=setenv bootargs ${bootargs} root=/dev/mmcblk0p2 rw rootfs=ext4
set_bootargs_nfs=setenv bootargs ${bootargs} root=/dev/nfs rw rootfstype=nfs nfsroot=${tftpserverip}:${nfspath},udp,vers=3 ip=dhcp
set_bootargs_tty=setenv bootargs console=${ttyconsole} console=${sttyconsole},${baudrate}
set_common_args=setenv bootargs ${bootargs} smsc95xx.macaddr=${ethaddr} 'ignore_loglevel dma.dmachans=0x7f35 rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3dc00000 vc_mem.mem_size=0x3f000000'
smp=on
stderr=serial,lcd
stdin=serial,usbkbd
stdout=serial,lcd
sttyconsole=ttyS0
tftpserverip=192.168.0.174
ttyconsole=tty0
usbethaddr=b8:27:eb:ec:ce:c2

Environment size: 1721/16380 bytes

using Image from linux-rt-kernel and bcm2837-rpi-3-b.dtb leads to kernel panic. 

U-Boot> boot
reading Image
13300224 bytes read in 1195 ms (10.6 MiB/s)
reading optee.bin
419024 bytes read in 134 ms (3 MiB/s)
## Flattened Device Tree blob at 02000000
   Booting using the fdt blob at 0x2000000
   reserving fdt memory region: addr=0 size=1000
   Loading Device Tree to 000000003ab2e000, end 000000003ab35759 ... OK

Starting kernel ...

## Transferring control to ARM TF (at address 8400000) (dtb at 3ab2e000)...
NOTICE:  BL3-1: v1.1(debug):1da4e15
NOTICE:  BL3-1: Built : 12:46:13, Feb  7 2019
INFO:    BL3-1: Initializing runtime services
INFO:    BL3-1: Initializing BL3-2
D/TC:0 add_phys_mem:526 TEE_SHMEM_START type NSEC_SHM 0x08000000 size 0x00400000
D/TC:0 add_phys_mem:526 TA_RAM_START type TA_RAM 0x08800000 size 0x01000000
D/TC:0 add_phys_mem:526 VCORE_UNPG_RW_PA type TEE_RAM_RW 0x08466000 size 0x0039a000
D/TC:0 add_phys_mem:526 VCORE_UNPG_RX_PA type TEE_RAM_RX 0x08420000 size 0x00046000
D/TC:0 add_phys_mem:526 TEE_RAM_START type TEE_RAM_RO 0x08400000 size 0x00020000
D/TC:0 add_phys_mem:526 CONSOLE_UART_BASE type IO_NSEC 0x3f200000 size 0x00200000
D/TC:0 verify_special_mem_areas:464 No NSEC DDR memory area defined
D/TC:0 add_va_space:565 type RES_VASPACE size 0x00a00000
D/TC:0 add_va_space:565 type SHM_VASPACE size 0x02000000
D/TC:0 dump_mmap_table:698 type TEE_RAM_RO   va 0x08400000..0x0841ffff pa 0x08400000..0x0841ffff size 0x00020000 (smallpg)
D/TC:0 dump_mmap_table:698 type TEE_RAM_RX   va 0x08420000..0x08465fff pa 0x08420000..0x08465fff size 0x00046000 (smallpg)
D/TC:0 dump_mmap_table:698 type TEE_RAM_RW   va 0x08466000..0x087fffff pa 0x08466000..0x087fffff size 0x0039a000 (smallpg)
D/TC:0 dump_mmap_table:698 type SHM_VASPACE  va 0x08800000..0x0a7fffff pa 0x00000000..0x01ffffff size 0x02000000 (pgdir)
D/TC:0 dump_mmap_table:698 type NSEC_SHM     va 0x0a800000..0x0abfffff pa 0x08000000..0x083fffff size 0x00400000 (pgdir)
D/TC:0 dump_mmap_table:698 type IO_NSEC      va 0x0ac00000..0x0adfffff pa 0x3f200000..0x3f3fffff size 0x00200000 (pgdir)
D/TC:0 dump_mmap_table:698 type RES_VASPACE  va 0x0ae00000..0x0b7fffff pa 0x00000000..0x009fffff size 0x00a00000 (pgdir)
D/TC:0 dump_mmap_table:698 type TA_RAM       va 0x0b800000..0x0c7fffff pa 0x08800000..0x097fffff size 0x01000000 (pgdir)
D/TC:0 core_mmu_entry_to_finer_grained:653 xlat tables used 1 / 5
D/TC:0 core_mmu_entry_to_finer_grained:653 xlat tables used 2 / 5
I/TC:  
D/TC:0 init_canaries:164 #Stack canaries for stack_tmp[0] with top at 0x849a938
D/TC:0 init_canaries:164 watch *0x849a93c
D/TC:0 init_canaries:164 #Stack canaries for stack_tmp[1] with top at 0x849b178
D/TC:0 init_canaries:164 watch *0x849b17c
D/TC:0 init_canaries:164 #Stack canaries for stack_tmp[2] with top at 0x849b9b8
D/TC:0 init_canaries:164 watch *0x849b9bc
D/TC:0 init_canaries:164 #Stack canaries for stack_tmp[3] with top at 0x849c1f8
D/TC:0 init_canaries:164 watch *0x849c1fc
D/TC:0 init_canaries:165 #Stack canaries for stack_abt[0] with top at 0x849ce38
D/TC:0 init_canaries:165 watch *0x849ce3c
D/TC:0 init_canaries:165 #Stack canaries for stack_abt[1] with top at 0x849da78
D/TC:0 init_canaries:165 watch *0x849da7c
D/TC:0 init_canaries:165 #Stack canaries for stack_abt[2] with top at 0x849e6b8
D/TC:0 init_canaries:165 watch *0x849e6bc
D/TC:0 init_canaries:165 #Stack canaries for stack_abt[3] with top at 0x849f2f8
D/TC:0 init_canaries:165 watch *0x849f2fc
D/TC:0 init_canaries:167 #Stack canaries for stack_thread[0] with top at 0x84a1338
D/TC:0 init_canaries:167 watch *0x84a133c
D/TC:0 init_canaries:167 #Stack canaries for stack_thread[1] with top at 0x84a3378
D/TC:0 init_canaries:167 watch *0x84a337c
D/TC:0 init_canaries:167 #Stack canaries for stack_thread[2] with top at 0x84a53b8
D/TC:0 init_canaries:167 watch *0x84a53bc
D/TC:0 init_canaries:167 #Stack canaries for stack_thread[3] with top at 0x84a73f8
D/TC:0 init_canaries:167 watch *0x84a73fc
I/TC:  OP-TEE version: 3.2.0 #1 Thu Feb  7 17:45:51 UTC 2019 aarch64
D/TC:0 tee_ta_register_ta_store:534 Registering TA store: 'REE' (priority 10)
D/TC:0 tee_ta_register_ta_store:534 Registering TA store: 'Secure Storage TA' (priority 9)
D/TC:0 mobj_mapped_shm_init:559 Shared memory address range: 8800000, a800000
I/TC:  Initialized
D/TC:0 init_primary_helper:917 Primary CPU switching to normal world boot
INFO:    BL3-1: Preparing for EL3 exit to normal world
INFO:    BL3-1: Next image address = 0x80000
INFO:    BL3-1: Next image spsr = 0x3c9
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.14.34-v8+ (osboxes@osboxes) (gcc version 6.2.1 20161016 (Linaro GCC 6.2-2016.11)) #1 SMP PREEMPT Tue Mar 12 19:42:41 EDT 2019
[    0.000000] Boot CPU: AArch64 Processor [410fd034]
[    0.000000] Machine model: Raspberry Pi 3 Model B
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] efi: Getting EFI parameters from FDT:
[    0.000000] efi: UEFI not found.
[    0.000000] cma: Reserved 8 MiB at 0x000000003a000000
[    0.000000] On node 0 totalpages: 241664
[    0.000000]   DMA zone: 3776 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 241664 pages, LIFO batch:31
[    0.000000] random: fast init done
[    0.000000] percpu: Embedded 22 pages/cpu @ffffffc03af81000 s50456 r8192 d31464 u90112
[    0.000000] pcpu-alloc: s50456 r8192 d31464 u90112 alloc=22*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: enabling workaround for ARM erratum 845719
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 237888
[    0.000000] Kernel command line: console=tty0 console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootfs=ext4 smsc95xx.macaddr=b8:27:eb:ec:ce:c2 ignore_loglevel dma.dmachans=0x7f35 rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3dc00000 vc_mem.mem_size=0x3f000000
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Memory: 926280K/966656K available (7036K kernel code, 892K rwdata, 2340K rodata, 2688K init, 689K bss, 32184K reserved, 8192K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     modules : 0xffffff8000000000 - 0xffffff8008000000   (   128 MB)
[    0.000000]     vmalloc : 0xffffff8008000000 - 0xffffffbebfff0000   (   250 GB)
[    0.000000]       .text : 0xffffff8008080000 - 0xffffff8008760000   (  7040 KB)
[    0.000000]     .rodata : 0xffffff8008760000 - 0xffffff80089b0000   (  2368 KB)
[    0.000000]       .init : 0xffffff80089b0000 - 0xffffff8008c50000   (  2688 KB)
[    0.000000]       .data : 0xffffff8008c50000 - 0xffffff8008d2f200   (   893 KB)
[    0.000000]        .bss : 0xffffff8008d2f200 - 0xffffff8008ddb9e8   (   690 KB)
[    0.000000]     fixed   : 0xffffffbefe7fb000 - 0xffffffbefec00000   (  4116 KB)
[    0.000000]     PCI I/O : 0xffffffbefee00000 - 0xffffffbeffe00000   (    16 MB)
[    0.000000]     vmemmap : 0xffffffbf00000000 - 0xffffffc000000000   (     4 GB maximum)
[    0.000000]               0xffffffbf00000000 - 0xffffffbf00ec0000   (    14 MB actual)
[    0.000000]     memory  : 0xffffffc000000000 - 0xffffffc03b000000   (   944 MB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 25282 entries in 99 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] arch_timer: cp15 timer(s) running at 1.20MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x11b661f8e, max_idle_ns: 1763180809113 ns
[    0.000109] sched_clock: 56 bits at 1200kHz, resolution 833ns, wraps every 4398046510838ns
[    0.004362] Console: colour dummy device 80x25
[    0.021732] console [tty0] enabled
[    0.022588] Calibrating delay loop (skipped), value calculated using timer frequency.. 2.40 BogoMIPS (lpj=1200)
[    0.023541] pid_max: default: 32768 minimum: 301
[    0.030544] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.031299] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.051062] Disabling memory control group subsystem
[    0.075456] ASID allocator initialised with 32768 entries
[    0.080574] Hierarchical SRCU implementation.
[    0.095598] EFI services will not be available.
[    0.103970] smp: Bringing up secondary CPUs ...
[    1.296426] CPU1: failed to come online
[    1.296879] CPU1: failed in unknown state : 0x0
[    2.473154] CPU2: failed to come online
[    2.473608] CPU2: failed in unknown state : 0x0
[    3.649334] CPU3: failed to come online
[    3.649785] CPU3: failed in unknown state : 0x0
[    3.651152] smp: Brought up 1 node, 1 CPU
[    3.651849] SMP: Total of 1 processors activated.
[    3.652385] CPU features: detected feature: 32-bit EL0 Support
[    3.653125] CPU features: detected feature: Kernel page table isolation (KPTI)
[    3.697603] CPU: CPUs started in inconsistent modes
[    3.697863] ------------[ cut here ]------------
[    3.698975] WARNING: CPU: 0 PID: 1 at arch/arm64/kernel/smp.c:428 smp_cpus_done+0x90/0xa8
[    3.699518] Modules linked in:
[    3.700100] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.14.34-v8+ #1
[    3.700547] Hardware name: Raspberry Pi 3 Model B (DT)
[    3.700978] task: ffffffc038d30000 task.stack: ffffff8008020000
[    3.701476] PC is at smp_cpus_done+0x90/0xa8
[    3.701917] LR is at smp_cpus_done+0x90/0xa8
[    3.702324] pc : [<ffffff80089b4bc0>] lr : [<ffffff80089b4bc0>] pstate: 60000045
[    3.702827] sp : ffffff8008023de0
[    3.703174] x29: ffffff8008023de0 x28: 0000000000000000 
[    3.703804] x27: 0000000000000000 x26: ffffff8008c71c48 
[    3.704430] x25: 0000000000000040 x24: ffffff8008c58b28 
[    3.705056] x23: ffffff8008c58000 x22: ffffff8008c71000 
[    3.705681] x21: ffffff8008c58b30 x20: ffffff8008c58c64 
[    3.706302] x19: 0000000000000004 x18: 0000000034d5d91d 
[    3.706921] x17: 0000000000000007 x16: 00f80000009fff13 
[    3.707545] x15: 000000003aff7000 x14: 000000003aff7000 
[    3.708174] x13: 0000000000000000 x12: 000000003aff9000 
[    3.708801] x11: 000000003aff9000 x10: 0000000000001980 
[    3.709425] x9 : ffffff8008023b10 x8 : 636e69206e692064 
[    3.710050] x7 : 6574726174732073 x6 : 0000000000000042 
[    3.710676] x5 : 00ffffffffffffff x4 : 0000000000000000 
[    3.711293] x3 : 0000000000000000 x2 : ffffffffffffffff 
[    3.711918] x1 : 0000000000000000 x0 : 0000000000000027 
[    3.712556] Call trace:
[    3.712937] Exception stack(0xffffff8008023ca0 to 0xffffff8008023de0)
[    3.713461] 3ca0: 0000000000000027 0000000000000000 ffffffffffffffff 0000000000000000
[    3.714055] 3cc0: 0000000000000000 00ffffffffffffff 0000000000000042 6574726174732073
[    3.714648] 3ce0: 636e69206e692064 ffffff8008023b10 0000000000001980 000000003aff9000
[    3.715235] 3d00: 000000003aff9000 0000000000000000 000000003aff7000 000000003aff7000
[    3.715822] 3d20: 00f80000009fff13 0000000000000007 0000000034d5d91d 0000000000000004
[    3.716414] 3d40: ffffff8008c58c64 ffffff8008c58b30 ffffff8008c71000 ffffff8008c58000
[    3.717008] 3d60: ffffff8008c58b28 0000000000000040 ffffff8008c71c48 0000000000000000
[    3.717596] 3d80: 0000000000000000 ffffff8008023de0 ffffff80089b4bc0 ffffff8008023de0
[    3.718185] 3da0: ffffff80089b4bc0 0000000060000045 ffffff8008d2e800 0000000000000000
[    3.718775] 3dc0: ffffffffffffffff 0000000000000001 ffffff8008023de0 ffffff80089b4bc0
[    3.719390] [<ffffff80089b4bc0>] smp_cpus_done+0x90/0xa8
[    3.719898] [<ffffff80089c3ba8>] smp_init+0xf0/0x108
[    3.720395] [<ffffff80089b0e18>] kernel_init_freeable+0xec/0x240
[    3.720970] [<ffffff800874ea18>] kernel_init+0x18/0x108
[    3.721522] [<ffffff8008084fe8>] ret_from_fork+0x10/0x18
[    3.722083] ---[ end trace 7c7790e6fcfdf4e2 ]---
[    3.723002] alternatives: patching kernel code
[    3.744410] devtmpfs: initialized
[    3.982132] Enabled cp15_barrier support
[    3.983126] Enabled setend support
[    3.991193] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    3.992379] futex hash table entries: 1024 (order: 5, 131072 bytes)
[    4.007454] pinctrl core: initialized pinctrl subsystem
[    4.013241] DMI not present or invalid.
[    4.020763] NET: Registered protocol family 16
[    4.117000] cpuidle: using governor menu
[    4.125394] vdso: 2 pages (1 code @ ffffff8008767000, 1 data @ ffffff8008c54000)
[    4.126217] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    4.158352] DMA: preallocated 256 KiB pool for atomic allocations
[    4.161138] Serial: AMBA PL011 UART driver
[    4.258112] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
[    4.273154] uart-pl011 3f201000.serial: could not find pctldev for node /soc/gpio@7e200000/uart0_gpio32, deferring probe
[    5.142014] bcm2835-dma 3f007000.dma: DMA legacy API manager at ffffff800801d000, dmachans=0x1
[    5.179535] SCSI subsystem initialized
[    5.185795] usbcore: registered new interface driver usbfs
[    5.187443] usbcore: registered new interface driver hub
[    5.192009] usbcore: registered new device driver usb
[    5.197028] dmi: Firmware registration failed.
[    5.203615] raspberrypi-firmware soc:firmware: Attached to firmware from 2017-02-15 17:14
[    5.206013] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[    5.238031] clocksource: Switched to clocksource arch_sys_counter
[    7.227201] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[    7.261366] VFS: Disk quotas dquot_6.6.0
[    7.264056] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.269411] FS-Cache: Loaded
[    7.275484] CacheFiles: Loaded
[    7.509285] NET: Registered protocol family 2
[    7.527666] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    7.531078] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
[    7.536306] TCP: Hash tables configured (established 8192 bind 8192)
[    7.542046] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    7.543485] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    7.552376] NET: Registered protocol family 1
[    7.571409] RPC: Registered named UNIX socket transport module.
[    7.572192] RPC: Registered udp transport module.
[    7.572584] RPC: Registered tcp transport module.
[    7.573504] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.660702] workingset: timestamp_bits=46 max_order=18 bucket_order=0
[    7.897425] FS-Cache: Netfs 'nfs' registered for caching
[    7.919205] NFS: Registering the id_resolver key type
[    7.920523] Key type id_resolver registered
[    7.921254] Key type id_legacy registered
[    8.020670] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    8.027512] io scheduler noop registered
[    8.028315] io scheduler deadline registered (default)
[    8.036425] io scheduler cfq registered
[    8.037201] io scheduler mq-deadline registered
[    8.037651] io scheduler kyber registered
[    8.107381] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
[    8.132445] console [ttyS0] disabled
[    8.134493] 3f215040.serial: ttyS0 at MMIO 0x0 (irq = 61, base_baud = 31249999) is a 16550
[    9.340065] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   11.480197] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   13.532354] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   15.601271] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   17.672258] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   19.732177] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   21.795198] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   23.846343] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   25.138416] console [ttyS0] enabled
[   25.225142] bcm2835-rng 3f104000.rng: hwrng registered
[   25.312372] vc-mem: phys_addr:0x00000000 mem_base=0x3dc00000 mem_size:0x3f000000(1008 MiB)
[   25.459391] cacheinfo: Unable to detect cache hierarchy for CPU 0
[   25.850591] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   26.008997] brd: module loaded
[   26.328574] loop: module loaded
[   26.381034] Loading iSCSI transport class v2.0-870.
[   26.483467] libphy: Fixed MDIO Bus: probed
[   26.554441] usbcore: registered new interface driver lan78xx
[   26.648511] usbcore: registered new interface driver smsc95xx
[   26.742614] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
[   26.841225] dwc_otg: FIQ enabled
[   26.894171] dwc_otg: NAK holdoff enabled
[   26.958380] dwc_otg: FIQ split-transaction FSM enabled
[   27.042467] Module dwc_common_port init
[   27.236188] dwc2 3f980000.usb: dwc2_wait_for_mode: Couldn't set host mode
[   27.459096] dwc2 3f980000.usb: dwc2_wait_for_mode: Couldn't set host mode
[   27.683441] dwc2 3f980000.usb: dwc2_wait_for_mode: Couldn't set host mode
[   27.926295] dwc2 3f980000.usb: dwc2_check_params: Invalid parameter host_perio_tx_fifo_size=0
[   28.071132] dwc2 3f980000.usb: DWC OTG Controller
[   28.149146] dwc2 3f980000.usb: new USB bus registered, assigned bus number 1
[   28.265217] dwc2 3f980000.usb: irq 41, io mem 0x3f980000
[   28.353364] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   28.498028] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   28.610074] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   28.728122] usb usb1: Product: DWC OTG Controller
[   28.805133] usb usb1: Manufacturer: Linux 4.14.34-v8+ dwc2_hsotg
[   28.903317] usb usb1: SerialNumber: 3f980000.usb
[   28.997412] hub 1-0:1.0: USB hub found
[   29.059705] hub 1-0:1.0: 1 port detected
[   29.141635] usbcore: registered new interface driver usb-storage
[   29.245080] IR NEC protocol handler initialized
[   29.319230] IR RC5(x/sz) protocol handler initialized
[   29.404299] IR RC6 protocol handler initialized
[   29.479364] IR JVC protocol handler initialized
[   29.555185] IR Sony protocol handler initialized
[   29.636202] IR SANYO protocol handler initialized
[   29.715315] IR Sharp protocol handler initialized
[   29.793334] IR MCE Keyboard/mouse protocol handler initialized
[   29.890308] IR XMP protocol handler initialized
[   29.987687] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog timer
[   30.107494] bcm2835-cpufreq: min=600000 max=1200000
[   30.199677] sdhci: Secure Digital Host Controller Interface driver
[   30.302427] sdhci: Copyright(c) Pierre Ossman
[   30.381687] sdhost-bcm2835 3f202000.mmc: /aliases ID not available
[   30.484355] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   30.632146] sdhost: log_buf @ ffffff800806d000 (fa041000)
[   30.721075] usb 1-1: new high-speed USB device number 2 using dwc2
[   30.902305] mmc0: sdhost-bcm2835 loaded - DMA enabled (>1)
[   31.015343] Error: Driver 'sdhost-bcm2835' is already registered, aborting...
[   31.147655] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[   31.148140] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   31.186402] hub 1-1:1.0: USB hub found
[   31.189111] hub 1-1:1.0: 5 ports detected
[   31.723152] mmc0: host does not support reading read-only switch, assuming write-enable
[   31.864452] mmc0: new high speed SDHC card at address 1234
[   31.875395] bounce: isa pool size: 16 pages
[   31.884055] mmcblk0: mmc0:1234 SA04G 3.64 GiB
[   32.082480]  mmcblk0: p1 p2
[   32.231565] sdhci-pltfm: SDHCI platform and OF driver helper
[   32.345390] ledtrig-cpu: registered to indicate activity on CPUs
[   32.444723] usb 1-1.1: new high-speed USB device number 3 using dwc2
[   32.553559] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   32.699978] hidraw: raw HID events driver (C) Jiri Kosina
[   32.795585] usbcore: registered new interface driver usbhid
[   32.890475] usbhid: USB HID core driver
[   32.963176] Initializing XFRM netlink socket
[   33.036993] NET: Registered protocol family 17
[   33.120556] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
[   33.234964] Key type dns_resolver registered
[   33.263575] registered taskstats version 1
[   33.567165] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   33.713198] 3f201000.serial: ttyAMA0 at MMIO 0x3f201000 (irq = 72, base_baud = 0) is a PL011 rev2
[   33.864650] smsc95xx v1.0.6
[   33.982326] of_cfs_init
[   34.035163] of_cfs_init: OK
[   34.347391] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-3f980000.usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:ec:ce:c2
[   34.593630] EXT4-fs (mmcblk0p2): couldn't mount as ext3 due to feature incompatibilities
[   34.728083] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   34.901322] EXT4-fs (mmcblk0p2): couldn't mount as ext2 due to feature incompatibilities
[   36.793515] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   38.969423] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   41.145309] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   43.321320] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   45.497318] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   47.673356] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   49.849313] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   52.025314] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   54.201322] raspberrypi-firmware soc:firmware: Request 0x00030046 returned status 0x80000001
[   55.031951] mmc0: timeout waiting for hardware interrupt.
[   55.119900] [095d16fd] PRD2 1 0
[   55.171048] [095d170c] PRD3 380afd08 

[   70.522500] mmc0: cmd op 25 arg 0x350800 flags 0xb5 - resp 00000900 00000000 00000000 00000000, err 0
[   70.672536] mmc0: data blocks 8 blksz 200 - err 0
[   70.749140] mmc0: stop op 12 arg 0x0 flags 0x49d - resp 00000000 00000000 00000000 00000000, err 0
[   70.894931] mmc0: =========== REGISTER DUMP ===========
[   70.979928] mmc0: SDCMD  0x00000099
[   71.036668] mmc0: SDARG  0x00350800
[   71.093415] mmc0: SDTOUT 0x017d7840
[   71.150157] mmc0: SDCDIV 0x00000003
[   71.206914] mmc0: SDRSP0 0x00000900
[   71.263658] mmc0: SDRSP1 0x00001918
[   71.320409] mmc0: SDRSP2 0xffffffff
[   71.377142] mmc0: SDRSP3 0x0002400f
[   71.433894] mmc0: SDHSTS 0x00000000
[   71.490633] mmc0: SDVDD  0x00000001
[   71.547380] mmc0: SDEDM  0x00010801
[   71.604126] mmc0: SDHCFG 0x0000040e
[   71.660874] mmc0: SDHBCT 0x00000200
[   71.717603] mmc0: SDHBLC 0x00000001
[   71.774325] mmc0: ===========================================
[   71.869024] Unable to handle kernel NULL pointer dereference at virtual address 00000030
[   72.000697] Mem abort info:
[   72.046146]   Exception class = DABT (current EL), IL = 32 bits
[   72.142422]   SET = 0, FnV = 0
[   72.192085]   EA = 0, S1PTW = 0
[   72.243151] Data abort info:
[   72.289985]   ISV = 0, ISS = 0x00000005
[   72.352349]   CM = 0, WnR = 0
[   72.400606] [0000000000000030] user address but active_mm is swapper
[   72.504025] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[   72.594684] Modules linked in:
[   72.644567] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G S              4.14.34-v8+ #1
[   72.767740] Hardware name: Raspberry Pi 3 Model B (DT)
[   72.851329] task: ffffff8008c5eb80 task.stack: ffffff8008c50000
[   72.947910] PC is at bcm2835_sdhost_dma_complete+0xb0/0x1c8
[   73.038608] LR is at bcm2835_sdhost_dma_complete+0x74/0x1c8
[   73.129273] pc : [<ffffff80085e6228>] lr : [<ffffff80085e61ec>] pstate: 800001c5
[   73.249614] sp : ffffff8008003df0
[   73.303527] x29: ffffff8008003df0 x28: ffffff8008c55000 
[   73.390073] x27: ffffff80088e7000 x26: 0000000000000101 
[   73.476600] x25: 0000000000000038 x24: ffffffc038f87218 
[   73.563141] x23: ffffffc038f872a8 x22: dead000000000100 
[   73.649670] x21: 0000000000000000 x20: 0000000000000140 
[   73.736213] x19: ffffffc038013d00 x18: 0000000000000010 
[   73.822742] x17: ffffffbf00e02c00 x16: 0000000000000000 
[   73.909274] x15: 0000000000000006 x14: 0720072007200720 
[   73.995817] x13: 0720072007200720 x12: 0720072007200720 
[   74.082346] x11: 0000000000000001 x10: ffffff8008003e90 
[   74.168885] x9 : ffffffc03af860f0 x8 : 0000000000000000 
[   74.255422] x7 : 0000000000000104 x6 : 00000000fa042000 
[   74.341956] x5 : ffffff800809a8e0 x4 : 000000403252a000 
[   74.428485] x3 : 0000000000000001 x2 : ffffff8008768088 
[   74.515022] x1 : ffffff8008768000 x0 : ffffffc038f07810 
[   74.601595] Process swapper/0 (pid: 0, stack limit = 0xffffff8008c50000)
[   74.710601] Call trace:
[   74.750437] Exception stack(0xffffff8008003cb0 to 0xffffff8008003df0)
[   74.855257] 3ca0:                                   ffffffc038f07810 ffffff8008768000
[   74.982725] 3cc0: ffffff8008768088 0000000000000001 000000403252a000 ffffff800809a8e0
[   75.110192] 3ce0: 00000000fa042000 0000000000000104 0000000000000000 ffffffc03af860f0
[   75.237662] 3d00: ffffff8008003e90 0000000000000001 0720072007200720 0720072007200720
[   75.365140] 3d20: 0720072007200720 0000000000000006 0000000000000000 ffffffbf00e02c00
[   75.492611] 3d40: 0000000000000010 ffffffc038013d00 0000000000000140 0000000000000000
[   75.620087] 3d60: dead000000000100 ffffffc038f872a8 ffffffc038f87218 0000000000000038
[   75.747560] 3d80: 0000000000000101 ffffff80088e7000 ffffff8008c55000 ffffff8008003df0
[   75.875017] 3da0: ffffff80085e61ec ffffff8008003df0 ffffff80085e6228 00000000800001c5
[   76.002476] 3dc0: 0000000000000000 dead000000000100 0000007fffffffff ffffffc038f87218
[   76.129913] 3de0: ffffff8008003df0 ffffff80085e6228
[   76.209351] [<ffffff80085e6228>] bcm2835_sdhost_dma_complete+0xb0/0x1c8
[   76.317100] [<ffffff800848f718>] vchan_complete+0x148/0x1a8
[   76.407855] [<ffffff80080a7c04>] tasklet_action+0xac/0x158
[   76.497173] [<ffffff8008081bfc>] __do_softirq+0x16c/0x3a8
[   76.585040] [<ffffff80080a76a8>] irq_exit+0xb8/0xd0
[   76.664484] [<ffffff80080f90a0>] __handle_domain_irq+0x90/0x100
[   76.760835] [<ffffff80080817f0>] bcm2836_arm_irqchip_handle_irq+0x68/0xc8
[   76.871273] Exception stack(0xffffff8008c53dc0 to 0xffffff8008c53f00)
[   76.976104] 3dc0: 0000000000000000 ffffff8008903740 ffffff8008a57010 0000000000000001
[   77.103571] 3de0: 000000403252a000 00ffffffffffffff 00000000b19614e8 0000000000000002
[   77.231050] 3e00: ffffff8008c60560 ffffff8008c53e80 0000000000001980 0000000000000002
[   77.358503] 3e20: 0000000000000070 0000000000000003 0720072007200720 0000000000000006
[   77.485973] 3e40: 0000000000000000 ffffffbf00e02c00 0000000000000010 ffffff8008c58000
[   77.613446] 3e60: 0000000000000000 ffffff8008a60e80 ffffff80088e2d80 0000000000000000
[   77.740899] 3e80: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   77.868375] 3ea0: 00000000009b0018 ffffff8008c53f00 ffffff8008085970 ffffff8008c53f00
[   77.995853] 3ec0: ffffff8008085974 0000000000000145 ffffff8008a60e80 ffffff80088e2d80
[   78.123332] 3ee0: ffffffffffffffff ffffff8008c58000 ffffff8008c53f00 ffffff8008085974
[   78.250806] [<ffffff8008083134>] el1_irq+0xb4/0x12c
[   78.330235] [<ffffff8008085974>] arch_cpu_idle+0x2c/0x1c0
[   78.418200] [<ffffff8008754894>] default_idle_call+0x24/0x40
[   78.510375] [<ffffff80080e6ea4>] do_idle+0x18c/0x1a0
[   78.591177] [<ffffff80080e708c>] cpu_startup_entry+0x2c/0x30
[   78.683310] [<ffffff800874e9f0>] rest_init+0xd0/0xe0
[   78.764191] [<ffffff80089b0d18>] start_kernel+0x3a8/0x3bc
[   78.852114] Code: 7100087f 540008e8 f9401c25 b40000a5 (b94032a2) 
[   78.951311] ---[ end trace 7c7790e6fcfdf4e4 ]---
[   79.026441] Kernel panic - not syncing: Fatal exception in interrupt
[   79.129911] Kernel Offset: disabled
[   79.186668] CPU features: 0x0802004
[   79.243376] Memory Limit: none
[   79.293174] ---[ end Kernel panic - not syncing: Fatal exception in interrupt




32bit uboot 2016.9 success but does not have fdt apply for overlay, so moving forward to next version


 2111  git clone --depth 1 -b v2016.09.01 git://git.denx.de/u-boot.git
 2114  git clone --depth 1 https://github.com/raspberrypi/firmware

 2131  CROSS_COMPILE=arm-linux-gnueabi- make rpi_3_32b_defconfig
 2132  CROSS_COMPILE=arm-linux-gnueabi- make -j4

script for uboot:
setenv fdt_addr_r 0x2000000
setenv fdtfile bcm2710-rpi-3-b.dtb
atf_load_addr=0x08400000
atf_file=optee.bin
setenv kernel_addr_r 0x10000000
fatload mmc 0:1 ${fdt_addr_r} ${fdtfile}
fatload mmc 0:1 ${atf_load_addr} ${atf_file}
fatload mmc 0:1 ${kernel_addr_r} Image

baudrate=115200
sttyconsole=ttyS0
ttyconsole=tty0

setenv bootargs console=${ttyconsole} console=${sttyconsole},${baudrate}
setenv bootargs ${bootargs} root=/dev/mmcblk0p2 rw rootfs=ext4
setenv bootargs ${bootargs} smsc95xx.macaddr=${ethaddr} 'ignore_loglevel dma.dmachans=0x7f35 rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3dc00000 vc_mem.mem_size=0x3f000000'

booti ${kernel_addr_r} - ${fdt_addr_r}
bootm? seems like bootm is for 32bit kernel image

CROSS_COMPILE=~/devel/optee/toolchains/aarch64/bin/aarch64-linux-gnu- make rpi_3_defconfig
CROSS_COMPILE=~/devel/optee/toolchains/aarch64/bin/aarch64-linux-gnu- make -j4

get 64bit u-boot

optee uboot use old_kernel=1 to load kernel from 0x0 while 
my uboot 64bit cannot use that option.

now need to add overlay


./tools/mkenvimage -s 0x4000 -o uboot.env ./uboot.env.txt

my uboot.bin cannot turn on disable_commandline_tags=1. it needs that to pass ATAGS from start.elf.

2 issues now:
1). kernel doesnot pass control to armtf
2). fdt resize ok, but apply overlay fail. check https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=884003 to resolve this isse.

1)
build linux-rt with optee build does not work
try linux original

   Booting using the fdt blob at 0x2000000
   reserving fdt memory region: addr=0 size=1000
???   reserving fdt memory region: addr=8000000 size=2000000 ??? this is added by dtb!!!!
   Loading Device Tree to 000000003af40000, end 000000003af4643f ... OK

now checking diff between linux-rt dtb and linux dtb

original optee rpi3:
## 6.7 Physical memory map

|Physical address|Component|
|----------------|------|
| 0x0            | Stubs + U-boot, U-boot self-relocates to high memory |
| 0x80000        | Linux image        |
| 0x01700000     | Linux DTS          |
| 0x08000000     | Non-secure SHM     |
| 0x08400000     | BL31               |
| 0x08420000     | BL32 (OP-TEE core) |


U-Boot> setenv kernel_addr_r 80000
U-Boot> run remote_load_kernel    
U-Boot> setenv fdt_addr_r 1700000
U-Boot> dhcp ${fdt_addr_r} 192.168.0.174:bcm2710-rpi-3-b.dtb
reading bcm2710-rpi-3-b.dtb
25311 bytes read in 19 ms (1.3 MiB/s)
U-Boot> run load_firmware 
reading optee.bin
419024 bytes read in 44 ms (9.1 MiB/s)
U-Boot> run manualboot

this does not work so may need stubs!

indeed, stubs start with :

		mov	x0, #0x40000000
		str	wzr, [x0]
		mov	w1, #0x80000000
		str	w1, [x0, #8]

which is the loading addr for optee core.

now adding stub to my uboot.
cat $(RPI3_HEAD_BIN) $(U-BOOT_BIN) > $(U-BOOT_RPI_BIN)
RPI3_HEAD_BIN		?= $(ROOT)/out/head.bin
U-BOOT_BIN		?= $(U-BOOT_PATH)/u-boot.bin
U-BOOT_RPI_BIN		?= $(U-BOOT_PATH)/u-boot-rpi.bin

doesnot work after patch. why?

# 2. Upstream?
This is a working setup, but there are quite a few patches that are put on top
of forks and some of the patches has been put together by just pulling files
instead of (correctly) cherry-pick patches from various projects. For some of
the projects it could take some time to get the work accepted upstream. Due to
this, things might not initially be on official git's and in some cases things
will be kept on a separate branch. But as time goes by we will gradually
move it over to the official gits. We are fully aware that this is not the
optimal way to do this, but we also know that there is a strong interest among
developers, students, researches to start work and learn more about TEE's using
a Raspberry Pi. So instead of delaying this, we have decided to make what we
have available right away. Hopefully there will be some enthusiast that will
help out making proper upstream patches sooner or later.

| Project | Base fork | What to do |
|---------|-----------|------------|
| linux | https://github.com/Electron752/linux.git commit: b48d47a32b2f27f55904e7248dbe5f8ff434db0a | Three things here. 1. The base is a fork itself and should be upstreamed. 2. Apply patch [arm64: dt: RPI3: Add optee node] 3. We have cherry picked the patches from [LSK OP-TEE 4.4] |
| arm-trusted-firmware | https://github.com/96boards-hikey/arm-trusted-firmware commit: bdec62eeb8f3153a4647770e08aafd56a0bcd42b | This should instead be based on the official OP-TEE fork or even better the official ARM repository. The patch itself should also be upstreamed. |
| U-boot | https://github.com:linaro-swg/u-boot.git | This is just a mirror of the official U-boot git. The patches should be upstreamed. |


next step, get commit clone and check what is the patch through diff

You could "reset" your repository to any commit you want (e.g. 1 month ago).

Use git-reset for that:

git clone [remote_address_here] my_repo
cd my_repo
git reset --hard [ENTER HERE THE COMMIT HASH YOU WANT]

-- testing start.elf load device tree and overlay again, suspecting missing config.txt for overlays directory.

enable_uart=1
arm_control=0x200
kernel=u-boot.bin

works and seems to have transfered dtb to u-boot because can see machine name. 
enable_uart=1
arm_control=0x200
kernel=u-boot.bin
dtparam=spi=on

works and and has fdt_addr=2eff9c00 as following

U-Boot> md 2eff9c00
2eff9c00: edfe0dd0 72630000 48000000 94590000    ......cr...H..Y.
2eff9c10: 28000000 11000000 10000000 00000000    ...(............
2eff9c20: de090000 4c590000 00000000 00000000    ......YL........
2eff9c30: 00000000 00100000 00000000 00000000    ................
2eff9c40: 00000000 00000000 01000000 00000000    ................
2eff9c50: 03000000 08000000 81090000 0000403b    ............;@..
2eff9c60: 0000c004 03000000 11000000 73090000    ...............s
2eff9c70: 30303030 30303030 63653133 32636563    0000000031eccec2
2eff9c80: 2d6c6500 03000000 23000000 00000000    .el-.......#....
2eff9c90: 70736172 72726562 2c697079 6f6d2d33    raspberrypi,3-mo
2eff9ca0: 2d6c6564 72620062 622c6d63 38326d63    del-b.brcm,bcm28
2eff9cb0: 00003733 03000000 1f000000 0b000000    37..............
2eff9cc0: 70736152 72726562 69502079 4d203320    Raspberry Pi 3 M
2eff9cd0: 6c65646f 52204220 31207665 0400322e    odel B Rev 1.2..

enable_uart=1
arm_control=0x200
kernel=u-boot.bin
dtparam=spi=on
dtparam=i2c1=on
dtparam=i2c1_baudrate=1000000

also works, and printing
U-Boot 2017.11 (Mar 15 2019 - 11:12:42 -0400)

DRAM:  948 MiB
RPI 3 Model B (0xa22082)
MMC:   sdhci@7e300000: 0
reading uboot.env
In:    serial
Out:   serial
Err:   serial
Net:   No ethernet found.
starting USB...
USB0:   Core Release: 2.80a

turns out pi3-disable-bt.dtbo overlay mess with serial uart0 (maybe disabled it, remember for the raspbian image? No serial after boot.) but dtb and dtbo should be device tree setup sent to kernel, so should not work at this time?
navio rgb overlay works. others work.


Currently:
successfully use:
bootstage 1 & 2: git current master rpi3 firmware: bootcode.bin start.efl to load device tree and overlay (copied from navio image) and transfer control to my 2017.3 uboot
bootstage 3: uboot load kernel(built by navio linux-rt 4.14y) and optee.bin(not useful currently) to memory and pass dtb address and transfer control to kernel
bootstage 4: kernel start and load navio rootfs(copied from navio image)

however, the overlay is not correctly loaded.
still need pi3-disable-bt.dtbo?

fdtdump pi3-disable-bt.dtbo:
osboxes@osboxes:~$ fdtdump /my-rpi3-boot-backup/overlays/pi3-disable-bt.dtbo 
/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x3ba (954)
// off_dt_struct:	0x38
// off_dt_strings:	0x32c
// off_mem_rsvmap:	0x28
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0x8e
// size_dt_struct:	0x2f4

/ {
    compatible = "brcm,bcm2708";
    fragment@0 {
        target = <0xffffffff>;
        __overlay__ {
            status = "disabled";
        };
    };
    fragment@1 {
        target = <0xffffffff>;
        __overlay__ {
            pinctrl-names = "default";
            pinctrl-0 = <0xffffffff>;
            status = "okay";
        };
    };
    fragment@2 {
        target = <0xffffffff>;
        __overlay__ {
            brcm,pins;
            brcm,function;
            brcm,pull;
        };
    };
    fragment@3 {
        target = <0xffffffff>;
        __overlay__ {
            brcm,pins;
            brcm,function;
            brcm,pull;
        };
    };
    fragment@4 {
        target-path = "/aliases";
        __overlay__ {
            serial0 = "/soc/serial@7e201000";
            serial1 = "/soc/serial@7e215040";
        };
    };
    __fixups__ {
        uart1 = "/fragment@0:target:0";
        uart0 = "/fragment@1:target:0";
        uart0_pins = "/fragment@1/__overlay__:pinctrl-0:0", "/fragment@2:target:0";
        bt_pins = "/fragment@3:target:0";
    };
};

osboxes@osboxes:~$ fdtdump /my-rpi3-boot-backup/overlays/spi0-4cs.dtbo 
/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x478 (1144)
// off_dt_struct:	0x38
// off_dt_strings:	0x3e8
// off_mem_rsvmap:	0x28
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0x90
// size_dt_struct:	0x3b0

/ {
    compatible = "brcm,bcm2835", "brcm,bcm2708", "brcm,bcm2709";
    fragment@0 {
        target = <0xffffffff>;
        __overlay__ {
            brcm,pins = <0x00000008 0x00000002 0x6d656e74 0x0000000b>;
        };
    };
    fragment@1 {
        target = <0xffffffff>;
        __overlay__ {
            #size-cells = <0x00000000>;
            #address-cells = <0x00000001>;
            cs-gpios = <0xffffffff 0x00000007 0x00000001 0x00000001 0x00000003 0x65760000 0x00000002 0x00000001 0x00000000 0x0007a120 0x6f6b6179 0x0000005d>;
            spidev@2 {
                compatible = "spidev";
                reg = <0x00000002>;
                #address-cells = <0x00000001>;
                #size-cells = <0x00000000>;
                spi-max-frequency = <0x0007a120>;
                status = "okay";
                phandle = <0x00000001>;
            };
            spidev@3 {
                compatible = "spidev";
                reg = <0x00000003>;
                #address-cells = <0x00000001>;
                #size-cells = <0x00000000>;
                spi-max-frequency = <0x0007a120>;
                status = "okay";
                phandle = <0x00000002>;
            };
        };
    };
    __symbols__ {
        spidev0_2 = "/fragment@1/__overlay__/spidev@2";
        spidev0_3 = "/fragment@1/__overlay__/spidev@3";
    };
    __fixups__ {
        spi0_cs_pins = "/fragment@0:target:0";
        spi0 = "/fragment@1:target:0";
        gpio = "/fragment@1/__overlay__:cs-gpios:0", "/fragment@1/__overlay__:cs-gpios:12", "/fragment@1/__overlay__:cs-gpios:24", "/fragment@1/__overlay__:cs-gpios:36";
    };
};

osboxes@osboxes:~$ fdtdump /my-rpi3-boot-backup/overlays/spi1-1cs.dtbo 
/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x60b (1547)
// off_dt_struct:	0x38
// off_dt_strings:	0x538
// off_mem_rsvmap:	0x28
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0xd3
// size_dt_struct:	0x500

/ {
    compatible = "brcm,bcm2835", "brcm,bcm2708", "brcm,bcm2709";
    fragment@0 {
        target = <0xffffffff>;
        __overlay__ {
            spi1_pins {
                brcm,pins = <0x00000013 0x00000004 0x00000004>;
                brcm,function = <0x00000003>;
                phandle = <0x00000001>;
            };
            spi1_cs_pins {
                brcm,pins = <0x00000012>;
                brcm,function = <0x00000001>;
                phandle = <0x00000002>;
            };
        };
    };
    fragment@1 {
        target = <0xffffffff>;
        __overlay__ {
            #address-cells = <0x00000001>;
            #size-cells = <0x00000000>;
            pinctrl-names = "default";
            pinctrl-0 = <0x00000001 0x00000065>;
            cs-gpios = <0xffffffff 0x00000005 0x00000003>;
            status = "okay";
            phandle = <0x00000003>;
            spidev@0 {
                compatible = "spidev";
                reg = <0x00000000>;
                #address-cells = <0x00000001>;
                #size-cells = <0x00000000>;
                spi-max-frequency = <0x07735940>;
                status = "okay";
                phandle = <0x00000004>;
            };
        };
    };
    fragment@2 {
        target = <0xffffffff>;
        __overlay__ {
            status = "okay";
        };
    };
    __overrides__ {
        cs0_pin = [00 00 00 02 62 72 63 6d 2c 70 69 6e 73 3a 30 00 00 00 00 03 63 73 2d 67 70 69 6f 73 3a 34 00];
        cs0_spidev = [00 00 00 04 73 74 61 74 75 73 00];
    };
    __symbols__ {
        spi1_pins = "/fragment@0/__overlay__/spi1_pins";
        spi1_cs_pins = "/fragment@0/__overlay__/spi1_cs_pins";
        frag1 = "/fragment@1/__overlay__";
        spidev1_0 = "/fragment@1/__overlay__/spidev@0";
    };
    __fixups__ {
        gpio = "/fragment@0:target:0", "/fragment@1/__overlay__:cs-gpios:0";
        spi1 = "/fragment@1:target:0";
        aux = "/fragment@2:target:0";
    };
    __local_fixups__ {
        fragment@1 {
            __overlay__ {
                pinctrl-0 = <0x00000000 0x00000001>;
            };
        };
        __overrides__ {
            cs0_pin = <0x00000000 0x00000093>;
            cs0_spidev = <0x00000000>;
        };
    };
};

osboxes@osboxes:~$ fdtdump /my-rpi3-boot-backup/overlays/rcio.dtbo 
/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x1af (431)
// off_dt_struct:	0x38
// off_dt_strings:	0x160
// off_mem_rsvmap:	0x28
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0x4f
// size_dt_struct:	0x128

/ {
    compatible = "brcm,bcm2709";
    fragment@0 {
        target = <0xffffffff>;
        __overlay__ {
            #address-cells = <0x00000001>;
            #size-cells = <0x00000000>;
            status = "okay";
            rcio@0 {
                compatible = "rcio";
                spi-max-frequency = <0x003d0900>;
                reg = <0x00000000>;
                status = "okay";
            };
        };
    };
    __fixups__ {
        spi1 = "/fragment@0:target:0";
    };
};

osboxes@osboxes:~$ fdtdump /my-rpi3-boot-backup/overlays/navio-rgb.dtbo 
/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x2d8 (728)
// off_dt_struct:	0x38
// off_dt_strings:	0x2a8
// off_mem_rsvmap:	0x28
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0x30
// size_dt_struct:	0x270

/ {
    compatible = "brcm,bcm2835";
    fragment@0 {
        target = <0xffffffff>;
        __overlay__ {
            rgb_led0 {
                gpios = <0xffffffff 0x00000003 0x00000002>;
                default-state = "on";
            };
        };
    };
    fragment@1 {
        target = <0xffffffff>;
        __overlay__ {
            rgb_led1 {
                gpios = <0xffffffff 0x00000003 0x00000002>;
                default-state = "on";
            };
        };
    };
    fragment@2 {
        target = <0xffffffff>;
        __overlay__ {
            rgb_led2 {
                gpios = <0xffffffff 0x00000003 0x00000002>;
                default-state = "on";
            };
        };
    };
    __fixups__ {
        leds = "/fragment@0:target:0", "/fragment@1:target:0", "/fragment@2:target:0";
        gpio = "/fragment@0/__overlay__/rgb_led0:gpios:0", "/fragment@1/__overlay__/rgb_led1:gpios:0", "/fragment@2/__overlay__/rgb_led2:gpios:0";
    };
};


kernel7.img in emild image is bad Linux ARM64 Image magic.
why it does not boot is related to where it is load?

check linux-rt kernel7.img, so that i can load kernel7.img in my uboot

linux-common: linux-defconfig
	$(MAKE) -C $(LINUX_PATH) $(LINUX_COMMON_FLAGS)

$(LINUX_PATH)/.config: $(LINUX_DEFCONFIG_COMMON_FILES)
	cd $(LINUX_PATH) && \
		ARCH=$(LINUX_DEFCONFIG_COMMON_ARCH) \
		scripts/kconfig/merge_config.sh $(LINUX_DEFCONFIG_COMMON_FILES) \
			$(LINUX_DEFCONFIG_BENCH)

LINUX_COMMON_FLAGS ?= LOCALVERSION= CROSS_COMPILE=$(CROSS_COMPILE_NS_KERNEL) // i guess use toolchain here

LINUX_DEFCONFIG_COMMON_ARCH := arm64
LINUX_DEFCONFIG_COMMON_FILES := \
		$(LINUX_PATH)/arch/arm64/configs/bcmrpi3_defconfig \
		$(CURDIR)/kconfigs/rpi3.conf

linux-defconfig: $(LINUX_PATH)/.config

LINUX_COMMON_FLAGS += ARCH=arm64

linux: linux-common
	$(MAKE) -C $(LINUX_PATH) $(LINUX_COMMON_FLAGS) INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=$(MODULE_OUTPUT) modules_install

cd $(LINUX_PATH) && ARCH=arm64 scripts/kconfig/merge_config.sh $(LINUX_PATH)/arch/arm64/configs/bcmrpi3_defconfig $(CURDIR)/kconfigs/rpi3.conf  $(CURDIR)/kconfigs/tee_bench.conf -> so basically what i want is simply bcmrpi3_defconfig for generating .config.

curdir is CONFIG_TEE=y CONFIG_OPTEE=y, so merge is not important for now

LINUX_DEFCONFIG_BENCH ?= $(CURDIR)/kconfigs/tee_bench.conf

tee benchmark is also not important for now.

so full compile command is go to linux-rt directory and run:
ARCH=arm64 CROSS_COMPILE=arm-linux-gnueabi- make ./arch/arm64/configs/bcmrpi3_defconfig

CROSS_COMPILE=../toolchains/aarch64/bin/aarch64-linux-gnu-

make= "CROSS_COMPILE ..."

ARCH=arm64 scripts/kconfig/merge_config.sh arch/arm64/configs/bcmrpi3_defconfig

make -C /home/osboxes/devel/optee/build/../linux LOCALVERSION= CROSS_COMPILE=" /home/osboxes/devel/optee/build/../toolchains/aarch64/bin/aarch64-linux-gnu-" ARCH=arm64
make -C /home/osboxes/devel/optee/build/../linux LOCALVERSION= CROSS_COMPILE=" /home/osboxes/devel/optee/build/../toolchains/aarch64/bin/aarch64-linux-gnu-" ARCH=arm64 INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=/home/osboxes/devel/optee/build/../module_output modules_install

uboot:
CROSS_COMPILE=/home/osboxes/devel/optee/build/../toolchains/aarch64/bin/aarch64-linux-gnu- ARCH=arm64 make -C /home/osboxes/Desktop/my_rpi_boot/u-boot rpi_3_defconfig
CROSS_COMPILE=/home/osboxes/devel/optee/build/../toolchains/aarch64/bin/aarch64-linux-gnu- ARCH=arm64 make -C /home/osboxes/Desktop/my_rpi_boot/u-boot all

'/home/osboxes/devel/optee/build/../linux/arch/arm64/boot/Image' -> '/home/osboxes/devel/optee/build/../out-br/target/boot/Image'

show make commands:
make -n does not execute the commands. Thus correct answer is make V=1


mkimage -A arm -O linux -T kernel -C none -a 0x80008000 -e 0x80008000 -n "Linux kernel" -d arch/arm/boot/zImage uImage
 1230  mkimage -A arm -O linux -T kernel -C none -a 0x80008000 -e 0x80008000 -n "Linux kernel" -d navio_kernel.img uImage

root@osboxes:/media/boot# mkimage -A arm -O linux -T kernel -C none -a 0x10000000 -e 0x10000000 -n "Linux kernel" -d navio_kernel.img uImage

U-Boot> fatload mmc 0:1 ${kernel_addr_r} uImage
reading uImage
4992748 bytes read in 383 ms (12.4 MiB/s)
U-Boot> run set_bootargs_tty 
U-Boot> run set_bootargs_mmc 
U-Boot> run set_common_args 
U-Boot> run bo
  board_name board_rev board_rev_scheme board_revision boot_it bootargs
  bootcmd bootdelay
U-Boot> run boot_it
Bad Linux ARM64 Image magic!
U-Boot>bootm ${kernel_addr_r} - ${fdt_addr}
## Booting kernel from Legacy Image at 10000000 ...
   Image Name:   Linux kernel
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4992684 Bytes = 4.8 MiB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 2eff9400
   Booting using the fdt blob at 0x2eff9400
   Loading Kernel Image ... "Synchronous Abort" handler, esr 0x96000045
ELR:     3b38bdcc
LR:      3b35dedc
x0 : 000000000000004c x1 : 0000000010000040
x2 : 00000000004c2eac x3 : 00000000004c2eab
x4 : 0000000010000040 x5 : 0000000000000000
x6 : 00000000ffffffd8 x7 : 0000000080008000
x8 : 000000003af48700 x9 : 0000000000000008
x10: 000000003af4d8b0 x11: 000000003af514f8
x12: 0000000000000000 x13: 0000000000000200
x14: 0000000000000000 x15: 00000000ffffffff
x16: 0000000000004110 x17: fe6ee101dfd9659a
x18: 000000003af48e00 x19: 0000000000000000
x20: 0000000080008000 x21: 0000000000000001
x22: 0000000000800000 x23: 0000000080008000
x24: 0000000010000040 x25: 000000003af48948
x26: 0000000000000000 x27: 0000000080008000
x28: 0000000000000000 x29: 000000003af48840

Resetting CPU ...

resetting ...

U-Boot> fatload mmc 0:1 ${kernel_addr_r} uImage
reading uImage
4992748 bytes read in 378 ms (12.6 MiB/s)
U-Boot> run set_bootargs_tty 
U-Boot> run set_bootargs_mmc 
U-Boot> run set_common_args 
U-Boot> bootm ${kernel_addr_r} - ${fdt_addr}
## Booting kernel from Legacy Image at 10000000 ...
   Image Name:   Linux kernel
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4992684 Bytes = 4.8 MiB
   Load Address: 10000000
   Entry Point:  10000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 2eff9400
   Booting using the fdt blob at 0x2eff9400
   Loading Kernel Image ... OK
   reserving fdt memory region: addr=0 size=1000
   Loading Device Tree to 000000003af3d000, end 000000003af46b5e ... OK

Starting kernel ...

"Synchronous Abort" handler, esr 0x02000000
ELR:     10000000
LR:      3b34ede8
x0 : 0000000000000000 x1 : 0000000000000000
x2 : 000000003af3d000 x3 : 0000000000000000
x4 : 0000000010000000 x5 : 0000000000000000
x6 : 0000000000000008 x7 : 0000000000000000
x8 : 000000003b3a81b0 x9 : 0000000000000002
x10: 000000000a200023 x11: 0000000000000002
x12: 0000000000000002 x13: 00000000000000c8
x14: 000000003af486ec x15: 000000003b34e7b8
x16: 0000000000000002 x17: 000000003af46b5f
x18: 000000003af48e00 x19: 000000003b3b4e20
x20: 0000000000000000 x21: 0000000000000000
x22: 0000000000000003 x23: 000000003af4a7a8
x24: 000000003b3a92a0 x25: 0000000010000040
x26: 000000003b34f28c x27: 0000000010000000
x28: 0000000000000400 x29: 000000003af48820


NOW i want to use linux-rt Image built by navio instead of Image built by optee chain.

turns out linux-rt kernel Image is actually a 32bit image. (should have noticed that earlier because no ARM64bit in config.txt)

osboxes@osboxes:~/devel/optee/linux-rt-rpi$ KERNEL=kernel7
osboxes@osboxes:~/devel/optee/linux-rt-rpi$ make ARCH=arm CROSS_COMPILE=~/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf- bcm2709_navio2_defconfig
osboxes@osboxes:~/devel/optee/linux-rt-rpi$ make ARCH=arm CROSS_COMPILE=~/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf- -j4 zImage modules dtbs
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img

change to support linux-rt
in Makefile line 124 change bcm2709_defconfig to bcm2709_navio2_defconfig.
in uboot.env.txt line 31
---load_fdt=fatload mmc 0:1 ${fdt_addr_r} bcm2710-rpi-3-b-plus.dtb
+++load_fdt=fatload mmc 0:1 ${fdt_addr_r} bcm2710-rpi-3-b.dtb

change linux to linux-rt folder (use absolute address to avoid recompiling .o files)

make patch to add optee device tree node to linux kernel dts.


CONFIG_TEE=y
CONFIG_OPTEE=y

for now

CONFIG_TEE=m
CONFIG_OPTEE=m

if i want to change the driver in the future

Currently use uboot to load dts
load_fdt=fatload mmc 0:1 ${fdt_addr_r} bcm2710-rpi-3-b.dtb
mmcboot=run load_kernel; run load_fdt; run set_bootargs_tty set_bootargs_mmc set_common_args; run boot_m

I either:
1. fdt apply overlay
2. change it to pass fdt dts addr with start.elf


after checking dmesg log between emlid image and my compiled:

also kernel commands are different, shall i copy?

my commands:
[    0.000000] Kernel command line: console=tty0 console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootfs=ext4 smsc95xx.macaddr=b8:27:eb:ec:ce:c2 ignore_loglevel dma.dmachans=0x7f35 memmap=16M$256M rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000 dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 dwc_otg.nak_holdoff=0




my cpu only come online one

and disable bt does not affect booting and loading overlay.

but my kernel does not load overlay? lets check

my log

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.14.34-emlid-v7+ (osboxes@osboxes) (gcc version 6.2.1 20161016 (Linaro GCC 6.2-2016.11)) #4 SMP PREEMPT Sat Mar 16 00:06:37 EDT 2019
[    0.000000] CPU: ARMv7 Processor [410fd034] revision 4 (ARMv7), cr=10c5383d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt: Machine model: Raspberry Pi 3 Model B Rev 1.2
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 8 MiB at 0x3a400000
[    0.000000] On node 0 totalpages: 242688
[    0.000000] free_area_init_node: node 0, pgdat 80c86f40, node_mem_map b9bab000
[    0.000000]   Normal zone: 2133 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 242688 pages, LIFO batch:31
[    0.000000] random: fast init done
[    0.000000] percpu: Embedded 16 pages/cpu @bb3a2000 s36812 r8192 d20532 u65536
[    0.000000] pcpu-alloc: s36812 r8192 d20532 u65536 alloc=16*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 240555
[    0.000000] Kernel command line: console=tty0 console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootfs=ext4 smsc95xx.macaddr=b8:27:eb:ec:ce:c2 ignore_loglevel dma.dmachans=0x7f35 memmap=16M$256M rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000 dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 dwc_otg.nak_holdoff=0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 940184K/970752K available (7168K kernel code, 636K rwdata, 2188K rodata, 1024K init, 706K bss, 22376K reserved, 8192K cma-reserved)
[    0.000000] Virtual kernel memory layout:
                   vector  : 0xffff0000 - 0xffff1000   (   4 kB)
                   fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
                   vmalloc : 0xbb800000 - 0xff800000   (1088 MB)
                   lowmem  : 0x80000000 - 0xbb400000   ( 948 MB)
                   modules : 0x7f000000 - 0x80000000   (  16 MB)
                     .text : 0x80008000 - 0x80800000   (8160 kB)
                     .init : 0x80b00000 - 0x80c00000   (1024 kB)
                     .data : 0x80c00000 - 0x80c9f370   ( 637 kB)
                      .bss : 0x80ca71f8 - 0x80d57a64   ( 707 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 24636 entries in 73 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] arch_timer: cp15 timer(s) running at 19.20MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
[    0.000007] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps every 4398046511078ns
[    0.000023] Switching to timer-based delay loop, resolution 52ns
[    0.000259] Console: colour dummy device 80x30
[    0.001278] console [tty0] enabled
[    0.001320] Calibrating delay loop (skipped), value calculated using timer frequency.. 38.40 BogoMIPS (lpj=192000)
[    0.001373] pid_max: default: 32768 minimum: 301
[    0.001692] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001733] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.002680] Disabling memory control group subsystem
[    0.002777] CPU: Testing write buffer coherency: ok
[    0.003210] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.040020] Setting up static identity map for 0x100000 - 0x10003c
[    0.060009] Hierarchical SRCU implementation.
[    0.100077] smp: Bringing up secondary CPUs ...
[    1.201159] CPU1: failed to come online
[    2.322250] CPU2: failed to come online
[    3.443340] CPU3: failed to come online
[    3.443399] smp: Brought up 1 node, 1 CPU
[    3.443428] SMP: Total of 1 processors activated (38.40 BogoMIPS).
[    3.443458] CPU: All CPU(s) started in HYP mode.
[    3.443483] CPU: Virtualization extensions available.
[    3.444194] devtmpfs: initialized
[    3.463989] VFP support v0.3: implementor 41 architecture 3 part 40 variant 3 rev 4
[    3.464355] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    3.464412] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.465110] pinctrl core: initialized pinctrl subsystem
[    3.465968] NET: Registered protocol family 16
[    3.468596] DMA: preallocated 1024 KiB pool for atomic coherent allocations
[    3.473736] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    3.473778] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    3.474001] Serial: AMBA PL011 UART driver
[    3.476077] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
[    3.476641] uart-pl011 3f201000.serial: could not find pctldev for node /soc/gpio@7e200000/uart0_pins, deferring probe
[    3.533997] bcm2835-dma 3f007000.dma: DMA legacy API manager at bb813000, dmachans=0x1
[    3.535590] SCSI subsystem initialized
[    3.535861] usbcore: registered new interface driver usbfs
[    3.535945] usbcore: registered new interface driver hub
[    3.536146] usbcore: registered new device driver usb
[    3.543630] raspberrypi-firmware soc:firmware: Attached to firmware from 2019-03-06 14:43
[    3.554321] clocksource: Switched to clocksource arch_sys_counter
[    3.672495] VFS: Disk quotas dquot_6.6.0
[    3.672620] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.672871] FS-Cache: Loaded
[    3.673096] CacheFiles: Loaded
[    3.682055] NET: Registered protocol family 2
[    3.682919] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    3.683059] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    3.683270] TCP: Hash tables configured (established 8192 bind 8192)
[    3.683435] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    3.683505] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    3.683788] NET: Registered protocol family 1
[    3.704445] RPC: Registered named UNIX socket transport module.
[    3.704478] RPC: Registered udp transport module.
[    3.704503] RPC: Registered tcp transport module.
[    3.704529] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.716249] hw perfevents: enabled with armv7_cortex_a7 PMU driver, 7 counters available
[    3.717976] workingset: timestamp_bits=14 max_order=18 bucket_order=4
[    3.726632] FS-Cache: Netfs 'nfs' registered for caching
[    3.737366] NFS: Registering the id_resolver key type
[    3.737427] Key type id_resolver registered
[    3.737453] Key type id_legacy registered
[    3.739904] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    3.750165] io scheduler noop registered
[    3.750194] io scheduler deadline registered (default)
[    3.750517] io scheduler cfq registered
[    3.750545] io scheduler mq-deadline registered
[    3.750572] io scheduler kyber registered
[    3.753595] BCM2708FB: allocated DMA memory fa510000
[    3.753650] BCM2708FB: allocated DMA channel 0 @ bb813000
[    3.805939] Console: switching to colour frame buffer device 240x67
[    3.833450] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
[    3.835221] bcm2835-rng 3f104000.rng: hwrng registered
[    3.835511] vc-mem: phys_addr:0x00000000 mem_base=0x3ec00000 mem_size:0x40000000(1024 MiB)
[    3.836234] vc-sm: Videocore shared memory driver
[    3.846920] brd: module loaded
[    3.857289] loop: module loaded
[    3.857423] Loading iSCSI transport class v2.0-870.
[    3.868308] libphy: Fixed MDIO Bus: probed
[    3.868517] usbcore: registered new interface driver lan78xx
[    3.868733] usbcore: registered new interface driver smsc95xx
[    3.868898] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
[    4.079565] Core Release: 2.80a
[    4.079669] Setting default values for core params
[    4.079815] Finished setting default values for core params
[    4.280200] Using Buffer DMA mode
[    4.280295] Periodic Transfer Interrupt Enhancement - disabled
[    4.280441] Multiprocessor Interrupt Enhancement - disabled
[    4.280582] OTG VER PARAM: 0, OTG VER FLAG: 0
[    4.280699] Dedicated Tx FIFOs mode
[    4.281039] dwc_otg: Microframe scheduler enabled
[    4.281227] dwc_otg 3f980000.usb: DWC OTG Controller
[    4.281381] dwc_otg 3f980000.usb: new USB bus registered, assigned bus number 1
[    4.281587] dwc_otg 3f980000.usb: irq 39, io mem 0x00000000
[    4.281768] Init: Port Power? op_state=1
[    4.281872] Init: Power Port (0)
[    4.282198] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.282373] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.282552] usb usb1: Product: DWC OTG Controller
[    4.282677] usb usb1: Manufacturer: Linux 4.14.34-emlid-v7+ dwc_otg_hcd
[    4.282842] usb usb1: SerialNumber: 3f980000.usb
[    4.283580] hub 1-0:1.0: USB hub found
[    4.283725] hub 1-0:1.0: 1 port detected
[    4.290491] dwc_otg: FIQ disabled
[    4.296614] dwc_otg: NAK holdoff disabled
[    4.302608] dwc_otg: FIQ split-transaction FSM disabled
[    4.308687] Module dwc_common_port init
[    4.324929] usbcore: registered new interface driver usb-storage
[    4.331108] mousedev: PS/2 mouse device common for all mice
[    4.337694] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog timer
[    4.344020] bcm2835-cpufreq: min=600000 max=1200000
[    4.351909] sdhci: Secure Digital Host Controller Interface driver
[    4.355126] sdhci: Copyright(c) Pierre Ossman
[    4.358492] mmc-bcm2835 3f300000.mmc: could not get clk, deferring probe
[    4.361938] sdhost-bcm2835 3f202000.mmc: could not get clk, deferring probe
[    4.365183] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.369641] ledtrig-cpu: registered to indicate activity on CPUs
[    4.373011] hidraw: raw HID events driver (C) Jiri Kosina
[    4.376357] usbcore: registered new interface driver usbhid
[    4.379565] usbhid: USB HID core driver
[    4.383044] vchiq: vchiq_init_state: slot_zero = ba580000, is_master = 0
[    4.387643] [vc_sm_connected_init]: start
[    4.397315] [vc_sm_connected_init]: end - returning 0
[    4.400585] optee: probing for conduit method from DT.
[    4.407605] optee: initialized driver
[    4.411012] Initializing XFRM netlink socket
[    4.414168] NET: Registered protocol family 17
[    4.417291] Key type dns_resolver registered
[    4.420816] Registering SWP/SWPB emulation handler
[    4.424437] registered taskstats version 1
[    4.431682] uart-pl011 3f201000.serial: cts_event_workaround enabled
[    4.435013] 3f201000.serial: ttyAMA0 at MMIO 0x3f201000 (irq = 87, base_baud = 0) is a PL011 rev2
[    4.439360] console [ttyS0] disabled
[    4.442670] 3f215040.serial: ttyS0 at MMIO 0x0 (irq = 166, base_baud = 31250000) is a 16550
[    5.454938] console [ttyS0] enabled
[    5.462182] mmc-bcm2835 3f300000.mmc: mmc_debug:0 mmc_debug2:0
[    5.471410] mmc-bcm2835 3f300000.mmc: Forcing PIO mode
[    5.490410] Indeed it is in host mode hprt0 = 00021501
[    5.579128] sdhost: log_buf @ ba504000 (fa504000)
[    5.595572] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    5.615816] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    5.626306] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    5.637754] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    5.684319] mmc0: sdhost-bcm2835 loaded - DMA enabled (>1)
[    5.693914] of_cfs_init
[    5.719595] usb 1-1: new high-speed USB device number 2 using dwc_otg
[    5.719684] Indeed it is in host mode hprt0 = 00001101
[    5.760345] of_cfs_init: OK
[    5.781952] Waiting for root device /dev/mmcblk0p2...
[    5.805494] mmc1: new high speed SDIO card at address 0001
[    5.821707] mmc0: host does not support reading read-only switch, assuming write-enable
[    5.840751] mmc0: new high speed SDHC card at address 1234
[    5.849855] mmcblk0: mmc0:1234 SA04G 3.64 GiB
[    5.859422]  mmcblk0: p1 p2
[    5.885906] EXT4-fs (mmcblk0p2): couldn't mount as ext3 due to feature incompatibilities
[    5.898912] EXT4-fs (mmcblk0p2): couldn't mount as ext2 due to feature incompatibilities
[    5.943261] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    5.954884] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    5.965961] devtmpfs: mounted
[    5.974778] Freeing unused kernel memory: 1024K
[    6.014528] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[    6.024906] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.036034] hub 1-1:1.0: USB hub found
[    6.043471] hub 1-1:1.0: 5 ports detected
[    6.364393] usb 1-1.1: new high-speed USB device number 3 using dwc_otg
[    6.467945] systemd[1]: System time before build time, advancing clock.
[    6.504986] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
[    6.519055] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.539821] smsc95xx v1.0.6
[    6.572179] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    6.598669] systemd[1]: Detected architecture arm.
[    6.646265] systemd[1]: Set hostname to <navio>.
[    6.669759] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-3f980000.usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:ec:ce:c2
[    7.363027] systemd[1]: Listening on Journal Socket (/dev/log).
[    7.404880] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    7.454696] systemd[1]: Listening on udev Kernel Socket.
[    7.494660] systemd[1]: Listening on fsck to fsckd communication Socket.
[    7.544824] systemd[1]: Listening on Journal Socket.
[    7.584780] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    7.634751] systemd[1]: Listening on udev Control Socket.
[    7.684433] Under-voltage detected! (0x00050005)
[    7.938867] random: crng init done
[    9.108261] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[    9.442784] systemd-journald[107]: Received request to flush runtime journal from PID 1
[   11.801795] smsc95xx 1-1.1:1.0 enxb827ebeccec2: renamed from eth0
[   13.718062] smsc95xx 1-1.1:1.0 enxb827ebeccec2: hardware isn't capable of remote wakeup
[   14.050077] Adding 102396k swap on /var/swap.  Priority:-2 extents:1 across:102396k SSFS
[   15.317914] smsc95xx 1-1.1:1.0 enxb827ebeccec2: link up, 100Mbps, full-duplex, lpa 0xCDE1
[   16.004850] Voltage normalised (0x00000000)
[   36.804556] Under-voltage detected! (0x00050005)
[   49.284567] Voltage normalised (0x00000000)
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Encrypted Volumes.
[  OK  ] Found device /dev/ttyS0.
[  OK  ] Found device /dev/disk/by-partuuid/9f8abb05-01.
         Starting File System Check on /dev/disk/by-partuuid/9f8abb05-01...
[  OK  ] Started File System Check Daemon to report status.
[  OK  ] Started File System Check on /dev/disk/by-partuuid/9f8abb05-01.
         Mounting /boot...
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Create Volatile Files and Directories...
         Starting Raise network interfaces...
         Starting Preprocess NFS configuration...
         Starting Set console font and keymap...
         Starting Tell Plymouth To Write Out Runtime Data...
         Starting Enable support for additional executable binary formats...
[  OK  ] Started Preprocess NFS configuration.
[  OK  ] Started Create Volatile Files and Directories.
[  OK  ] Started Set console font and keymap.
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
         Mounting Arbitrary Executable File Formats File System...
         Starting Update UTMP about System Boot/Shutdown...
         Starting Network Time Synchronization...
[  OK  ] Reached target NFS client services.
[  OK  ] Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems.
[FAILED] Failed to mount Arbitrary Executable File Formats File System.
See 'systemctl status proc-sys-fs-binfmt_misc.mount' for details.
[  OK  ] Started Enable support for additional executable binary formats.
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Initialization.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on triggerhappy.socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
[  OK  ] Started D-Bus System Message Bus.
         Starting System Logging Service...
         Starting triggerhappy global hotkey daemon...
         Starting Login Service...
         Starting LSB: Switch to ondemand cp…r (unless shift key is pressed)...
         Starting LSB: Autogenerate and use a swap file...
[  OK  ] Started Regular background program processing daemon.
         Starting Avahi mDNS/DNS-SD Stack...
         Starting Disable WiFi if country not set...
         Starting dhcpcd on all interfaces...
[  OK  ] Reached target System Time Synchronized.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Reached target Timers.
[  OK  ] Started triggerhappy global hotkey daemon.
[  OK  ] Started System Logging Service.
[  OK  ] Started Disable WiFi if country not set.
[  OK  ] Started Raise network interfaces.
[  OK  ] Started Avahi mDNS/DNS-SD Stack.
[  OK  ] Started LSB: Switch to ondemand cpu…nor (unless shift key is pressed).
[  OK  ] Started Login Service.
[  OK  ] Started LSB: Autogenerate and use a swap file.
[  OK  ] Started dhcpcd on all interfaces.
[  OK  ] Reached target Network.
         Starting dnsmasq - A lightweight DHCP and caching DNS server...
         Starting OpenBSD Secure Shell server...
         Starting Permit User Sessions...
[  OK  ] Reached target Network is Online.
         Starting /etc/rc.local Compatibility...
         Starting LSB: Advanced IEEE 802.11 management daemon...
My IP address is 192.168.0.158 
[  OK  ] Started Permit User Sessions.
[  OK  ] Started /etc/rc.local Compatibility.
[  OK  ] Started LSB: Advanced IEEE 802.11 management daemon.
         Starting Terminate Plymouth Boot Screen...
         Starting Hold until boot process finishes up...

emlid image log:
pi@navio:~ $ dmesg
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.14.95-emlid-v7+ (alexander.dranitsa@continuous-disintegrator) (gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9)) #1 SMP PREEMPT Mon Feb 4 15:59:56 MSK 2019
[    0.000000] CPU: ARMv7 Processor [410fd034] revision 4 (ARMv7), cr=10c5383d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt: Machine model: Raspberry Pi 3 Model B Rev 1.2
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 8 MiB at 0x37800000
[    0.000000] On node 0 totalpages: 229376
[    0.000000] free_area_init_node: node 0, pgdat 80c87500, node_mem_map b7014000
[    0.000000]   Normal zone: 2016 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 229376 pages, LIFO batch:31
[    0.000000] percpu: Embedded 16 pages/cpu @b6fc0000 s36812 r8192 d20532 u65536
[    0.000000] pcpu-alloc: s36812 r8192 d20532 u65536 alloc=16*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 227360
[    0.000000] Kernel command line: 8250.nr_uarts=0 bcm2708_fb.fbwidth=656 bcm2708_fb.fbheight=416 bcm2708_fb.fbswap=1 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000  dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 887404K/917504K available (7168K kernel code, 638K rwdata, 2236K rodata, 1024K init, 698K bss, 21908K reserved, 8192K cma-reserved)
[    0.000000] Virtual kernel memory layout:
                   vector  : 0xffff0000 - 0xffff1000   (   4 kB)
                   fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
                   vmalloc : 0xb8800000 - 0xff800000   (1136 MB)
                   lowmem  : 0x80000000 - 0xb8000000   ( 896 MB)
                   modules : 0x7f000000 - 0x80000000   (  16 MB)
                     .text : 0x80008000 - 0x80800000   (8160 kB)
                     .init : 0x80b00000 - 0x80c00000   (1024 kB)
                     .data : 0x80c00000 - 0x80c9f8f0   ( 639 kB)
                      .bss : 0x80ca7048 - 0x80d55920   ( 699 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 24648 entries in 73 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] arch_timer: cp15 timer(s) running at 19.20MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
[    0.000007] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps every 4398046511078ns
[    0.000025] Switching to timer-based delay loop, resolution 52ns
[    0.000284] Console: colour dummy device 80x30
[    0.001139] console [tty1] enabled
[    0.001178] Calibrating delay loop (skipped), value calculated using timer frequency.. 38.40 BogoMIPS (lpj=192000)
[    0.001233] pid_max: default: 32768 minimum: 301
[    0.001559] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001602] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.002595] Disabling memory control group subsystem
[    0.002697] CPU: Testing write buffer coherency: ok
[    0.003169] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.040015] Setting up static identity map for 0x100000 - 0x10003c
[    0.060008] Hierarchical SRCU implementation.
[    0.100080] smp: Bringing up secondary CPUs ...
[    0.170565] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.240613] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.310740] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.310880] smp: Brought up 1 node, 4 CPUs
[    0.310987] SMP: Total of 4 processors activated (153.60 BogoMIPS).
[    0.311018] CPU: All CPU(s) started in HYP mode.
[    0.311044] CPU: Virtualization extensions available.
[    0.311975] devtmpfs: initialized
[    0.323095] random: get_random_u32 called from bucket_table_alloc+0xfc/0x24c with crng_init=0
[    0.323784] VFP support v0.3: implementor 41 architecture 3 part 40 variant 3 rev 4
[    0.324062] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.324119] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.324737] pinctrl core: initialized pinctrl subsystem
[    0.325577] NET: Registered protocol family 16
[    0.342638] DMA: preallocated 1024 KiB pool for atomic coherent allocations
[    0.347581] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    0.347625] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.347834] Serial: AMBA PL011 UART driver
[    0.349823] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
[    0.350381] uart-pl011 3f201000.serial: could not find pctldev for node /soc/gpio@7e200000/uart0_pins, deferring probe
[    0.384389] bcm2835-dma 3f007000.dma: DMA legacy API manager at b8813000, dmachans=0x1
[    0.386001] SCSI subsystem initialized
[    0.386270] usbcore: registered new interface driver usbfs
[    0.386357] usbcore: registered new interface driver hub
[    0.386477] usbcore: registered new device driver usb
[    0.390692] raspberrypi-firmware soc:firmware: Attached to firmware from 2019-02-12 19:46
[    0.392065] clocksource: Switched to clocksource arch_sys_counter
[    0.512260] VFS: Disk quotas dquot_6.6.0
[    0.512400] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.512665] FS-Cache: Loaded
[    0.512896] CacheFiles: Loaded
[    0.521817] NET: Registered protocol family 2
[    0.522730] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.522870] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.523083] TCP: Hash tables configured (established 8192 bind 8192)
[    0.523247] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.523318] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.523593] NET: Registered protocol family 1
[    0.524083] RPC: Registered named UNIX socket transport module.
[    0.524117] RPC: Registered udp transport module.
[    0.524144] RPC: Registered tcp transport module.
[    0.524171] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.525752] hw perfevents: enabled with armv7_cortex_a7 PMU driver, 7 counters available
[    0.527504] workingset: timestamp_bits=14 max_order=18 bucket_order=4
[    0.535902] FS-Cache: Netfs 'nfs' registered for caching
[    0.536561] NFS: Registering the id_resolver key type
[    0.536613] Key type id_resolver registered
[    0.536640] Key type id_legacy registered
[    0.538702] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.538876] io scheduler noop registered
[    0.538906] io scheduler deadline registered (default)
[    0.539102] io scheduler cfq registered
[    0.539130] io scheduler mq-deadline registered
[    0.539158] io scheduler kyber registered
[    0.542486] BCM2708FB: allocated DMA memory f7910000
[    0.542541] BCM2708FB: allocated DMA channel 0 @ b8813000
[    0.551134] Console: switching to colour frame buffer device 82x26
[    0.559703] bcm2835-rng 3f104000.rng: hwrng registered
[    0.562086] vc-mem: phys_addr:0x00000000 mem_base=0x3ec00000 mem_size:0x40000000(1024 MiB)
[    0.567246] vc-sm: Videocore shared memory driver
[    0.580038] brd: module loaded
[    0.592352] loop: module loaded
[    0.594549] Loading iSCSI transport class v2.0-870.
[    0.597417] libphy: Fixed MDIO Bus: probed
[    0.599652] usbcore: registered new interface driver lan78xx
[    0.601900] usbcore: registered new interface driver smsc95xx
[    0.604137] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
[    0.634194] dwc_otg 3f980000.usb: base=0xf0980000
[    0.836432] Core Release: 2.80a
[    0.838468] Setting default values for core params
[    0.840576] Finished setting default values for core params
[    1.042978] Using Buffer DMA mode
[    1.045127] Periodic Transfer Interrupt Enhancement - disabled
[    1.047396] Multiprocessor Interrupt Enhancement - disabled
[    1.049676] OTG VER PARAM: 0, OTG VER FLAG: 0
[    1.051978] Dedicated Tx FIFOs mode
[    1.054600] WARN::dwc_otg_hcd_init:1046: FIQ DMA bounce buffers: virt = 0xb7904000 dma = 0xf7904000 len=9024
[    1.059215] FIQ FSM acceleration enabled for :
               Non-periodic Split Transactions
               Periodic Split Transactions
               High-Speed Isochronous Endpoints
               Interrupt/Control Split Transaction hack enabled
[    1.070157] dwc_otg: Microframe scheduler enabled
[    1.070217] WARN::hcd_init_fiq:459: FIQ on core 1 at 0x805f55e0
[    1.072496] WARN::hcd_init_fiq:460: FIQ ASM at 0x805f593c length 36
[    1.074740] WARN::hcd_init_fiq:486: MPHI regs_base at 0xf0006000
[    1.077073] dwc_otg 3f980000.usb: DWC OTG Controller
[    1.079364] dwc_otg 3f980000.usb: new USB bus registered, assigned bus number 1
[    1.081715] dwc_otg 3f980000.usb: irq 62, io mem 0x00000000
[    1.084069] Init: Port Power? op_state=1
[    1.086336] Init: Power Port (0)
[    1.088767] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.091086] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.093418] usb usb1: Product: DWC OTG Controller
[    1.095675] usb usb1: Manufacturer: Linux 4.14.95-emlid-v7+ dwc_otg_hcd
[    1.097985] usb usb1: SerialNumber: 3f980000.usb
[    1.100876] hub 1-0:1.0: USB hub found
[    1.103178] hub 1-0:1.0: 1 port detected
[    1.105836] dwc_otg: FIQ enabled
[    1.105843] dwc_otg: NAK holdoff enabled
[    1.105849] dwc_otg: FIQ split-transaction FSM enabled
[    1.105860] Module dwc_common_port init
[    1.106119] usbcore: registered new interface driver usb-storage
[    1.108453] mousedev: PS/2 mouse device common for all mice
[    1.111160] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog timer
[    1.113752] bcm2835-cpufreq: min=600000 max=1200000
[    1.117931] sdhci: Secure Digital Host Controller Interface driver
[    1.119112] sdhci: Copyright(c) Pierre Ossman
[    1.120454] mmc-bcm2835 3f300000.mmc: could not get clk, deferring probe
[    1.121870] sdhost-bcm2835 3f202000.mmc: could not get clk, deferring probe
[    1.123237] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.125743] ledtrig-cpu: registered to indicate activity on CPUs
[    1.127093] hidraw: raw HID events driver (C) Jiri Kosina
[    1.128434] usbcore: registered new interface driver usbhid
[    1.129688] usbhid: USB HID core driver
[    1.131296] vchiq: vchiq_init_state: slot_zero = b7980000, is_master = 0
[    1.133600] [vc_sm_connected_init]: start
[    1.140603] [vc_sm_connected_init]: end - returning 0
[    1.142198] Initializing XFRM netlink socket
[    1.143439] NET: Registered protocol family 17
[    1.144716] Key type dns_resolver registered
[    1.146123] Registering SWP/SWPB emulation handler
[    1.147699] registered taskstats version 1
[    1.152797] uart-pl011 3f201000.serial: cts_event_workaround enabled
[    1.154106] 3f201000.serial: ttyAMA0 at MMIO 0x3f201000 (irq = 87, base_baud = 0) is a PL011 rev2
[    1.157471] mmc-bcm2835 3f300000.mmc: mmc_debug:0 mmc_debug2:0
[    1.158749] mmc-bcm2835 3f300000.mmc: Forcing PIO mode
[    1.212505] sdhost: log_buf @ b7907000 (f7907000)
[    1.244724] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    1.247445] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    1.250102] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    1.253904] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    1.292063] mmc0: sdhost-bcm2835 loaded - DMA enabled (>1)
[    1.293864] of_cfs_init
[    1.294930] of_cfs_init: OK
[    1.296262] Waiting for root device /dev/mmcblk0p2...
[    1.322150] Indeed it is in host mode hprt0 = 00021501
[    1.334452] random: fast init done
[    1.369942] mmc0: host does not support reading read-only switch, assuming write-enable
[    1.374431] mmc0: new high speed SDHC card at address 0007
[    1.375831] mmcblk0: mmc0:0007 SD16G 14.5 GiB
[    1.380164] mmc1: new high speed SDIO card at address 0001
[    1.396179]  mmcblk0: p1 p2
[    1.432222] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    1.434365] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
[    1.437241] devtmpfs: mounted
[    1.440530] Freeing unused kernel memory: 1024K
[    1.542086] usb 1-1: new high-speed USB device number 2 using dwc_otg
[    1.543425] Indeed it is in host mode hprt0 = 00001101
[    1.782249] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[    1.783616] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.785307] hub 1-1:1.0: USB hub found
[    1.786663] hub 1-1:1.0: 5 ports detected
[    1.817110] systemd[1]: System time before build time, advancing clock.
[    1.906281] NET: Registered protocol family 10
[    1.908318] Segment Routing with IPv6
[    1.924654] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.940447] random: systemd: uninitialized urandom read (16 bytes read)
[    1.945234] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    1.949693] systemd[1]: Detected architecture arm.
[    1.957672] systemd[1]: Set hostname to <navio>.
[    1.986228] random: systemd: uninitialized urandom read (16 bytes read)
[    2.003762] random: systemd-sysv-ge: uninitialized urandom read (16 bytes read)
[    2.102100] usb 1-1.1: new high-speed USB device number 3 using dwc_otg
[    2.232291] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
[    2.233652] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.237452] smsc95xx v1.0.6
[    2.280476] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    2.283994] systemd[1]: Listening on Syslog Socket.
[    2.287317] systemd[1]: Created slice User and Session Slice.
[    2.290790] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    2.295592] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    2.300290] systemd[1]: Listening on Journal Socket (/dev/log).
[    2.303706] systemd[1]: Listening on Journal Socket.
[    2.324396] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-3f980000.usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:ec:ce:c2
[    2.412814] i2c /dev entries driver
[    2.482239] Under-voltage detected! (0x00050005)
[    2.862181] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[    2.969334] systemd-journald[92]: Received request to flush runtime journal from PID 1
[    3.352266] gpiomem-bcm2835 3f200000.gpiomem: Initialised: Registers at 0x3f200000
[    3.661775] brcmfmac: F1 signature read @0x18000000=0x1541a9a6
[    3.671061] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac43430-sdio.bin for chip 0x00a9a6(43430) rev 0x000001
[    3.671304] usbcore: registered new interface driver brcmfmac
[    3.754194] smsc95xx 1-1.1:1.0 enxb827ebeccec2: renamed from eth0
[    3.909402] rcio_core: loading out-of-tree module taints kernel.
[    3.918594] rcio spi1.0: rcio_status: Firmware CRC: 0xb09979ae
[    3.919520] rcio spi1.0: rcio_status: Board type: 0x0 (navio2)
[    3.920684] rcio spi1.0: rcio_status: Git hash: dae830a
[    3.926283] rcio spi1.0: rcio_pwm: Advanced frequency configuration is supported on this firmware
[    3.934841] rcio spi1.0: rcio_pwm: updated freq on grp 0 to 50
[    3.935790] rcio spi1.0: rcio_pwm: updated freq on grp 1 to 50
[    3.936801] rcio spi1.0: rcio_pwm: updated freq on grp 2 to 50
[    3.937789] rcio spi1.0: rcio_pwm: updated freq on grp 3 to 50
[    3.938813] RC config 0 set successfully
[    3.939784] RC config 1 set successfully
[    3.940693] RC config 2 set successfully
[    3.941644] RC config 3 set successfully
[    3.942595] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 23 2017 03:55:53 version 7.45.98.38 (r674442 CY) FWID 01-e58d219f
[    3.942865] RC config 4 set successfully
[    3.943791] RC config 5 set successfully
[    3.944494] brcmfmac: brcmf_c_preinit_dcmds: CLM version = API: 12.2 Data: 7.11.15 Compiler: 1.24.2 ClmImport: 1.24.1 Creation: 2014-05-26 10:53:55 Inc Data: 9.10.39 Inc Compiler: 1.29.4 Inc ClmImport: 1.36.3 Creation: 2017-10-23 03:47:14 
[    3.946239] RC config 6 set successfully
[    3.951814] RC config 7 set successfully
[    3.952834] RC config 8 set successfully
[    3.953810] RC config 9 set successfully
[    3.954765] RC config 10 set successfully
[    3.955738] RC config 11 set successfully
[    3.956690] RC config 12 set successfully
[    3.957639] RC config 13 set successfully
[    3.958700] RC config 14 set successfully
[    3.972596] RC config 15 set successfully
[    3.972657] rcio spi1.0: rcio_pwm: PWM probe success
[    3.975087] rcio spi1.0: rcio_gpio: GPIO is supported on this firmware
[    3.975125] rcio spi1.0: rcio_gpio: registered gpio module
[    3.977588] rcio spi1.0: rcio_gpio: gpiochip added successfully under gpio500
[    4.236069] random: crng init done
[    4.236088] random: 7 urandom warning(s) missed due to ratelimiting
[    4.730161] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    4.730181] brcmfmac: power management disabled
[    5.234941] smsc95xx 1-1.1:1.0 enxb827ebeccec2: hardware isn't capable of remote wakeup
[    5.235191] IPv6: ADDRCONF(NETDEV_UP): enxb827ebeccec2: link is not ready
[    5.353377] Adding 102396k swap on /var/swap.  Priority:-2 extents:1 across:102396k SSFS
[    6.758685] smsc95xx 1-1.1:1.0 enxb827ebeccec2: link up, 100Mbps, full-duplex, lpa 0xCDE1
[    6.760927] IPv6: ADDRCONF(NETDEV_CHANGE): enxb827ebeccec2: link becomes ready

[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Encrypted Volumes.
[  OK  ] Reached target Paths.
[  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
[  OK  ] Found device /dev/disk/by-partuuid/9f8abb05-01.
         Starting File System Check on /dev/disk/by-partuuid/9f8abb05-01...
[  OK  ] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
[  OK  ] Started File System Check on /dev/disk/by-partuuid/9f8abb05-01.
         Mounting /boot...
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Set console font and keymap...
         Starting Enable support for additional executable binary formats...
         Starting Create Volatile Files and Directories...
         Starting Tell Plymouth To Write Out Runtime Data...
         Starting Raise network interfaces...
         Starting Preprocess NFS configuration...
[  OK  ] Started Set console font and keymap.
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
         Mounting Arbitrary Executable File Formats File System...
[  OK  ] Started Create Volatile Files and Directories.
         Starting Update UTMP about System Boot/Shutdown...
         Starting Network Time Synchronization...
[  OK  ] Started Preprocess NFS configuration.
[  OK  ] Mounted Arbitrary Executable File Formats File System.
[  OK  ] Reached target NFS client services.
[  OK  ] Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems.
[  OK  ] Started Enable support for additional executable binary formats.
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Found device /sys/subsystem/net/devices/wlan0.
[  OK  ] Started ifup for wlan0.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Initialization.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on triggerhappy.socket.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
         Starting dhcpcd on all interfaces...
         Starting Login Service...
[  OK  ] Started Regular background program processing daemon.
         Starting Disable WiFi if country not set...
         Starting LSB: Switch to ondemand cpu…or (unless shift key is pressed)...
         Starting LSB: Autogenerate and use a swap file...
         Starting Avahi mDNS/DNS-SD Stack...
         Starting System Logging Service...
[  OK  ] Started D-Bus System Message Bus.
[  OK  ] Started Avahi mDNS/DNS-SD Stack.
         Starting triggerhappy global hotkey daemon...
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target System Time Synchronized.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Reached target Timers.
[  OK  ] Started System Logging Service.
[  OK  ] Started triggerhappy global hotkey daemon.
[  OK  ] Started Disable WiFi if country not set.
         Starting Load/Save RF Kill Switch Status...
[  OK  ] Started Login Service.
[  OK  ] Started Load/Save RF Kill Switch Status.
[  OK  ] Started Raise network interfaces.
[  OK  ] Started LSB: Switch to ondemand cpu …rnor (unless shift key is pressed).
[  OK  ] Started LSB: Autogenerate and use a swap file.
[  OK  ] Started dhcpcd on all interfaces.
[  OK  ] Reached target Network.
         Starting OpenBSD Secure Shell server...
         Starting Permit User Sessions...
         Starting dnsmasq - A lightweight DHCP and caching DNS server...
[  OK  ] Reached target Network is Online.
         Starting /etc/rc.local Compatibility...
         Starting LSB: Advanced IEEE 802.11 management daemon...
My IP address is 192.168.0.158 
[  OK  ] Started Permit User Sessions.
[  OK  ] Started /etc/rc.local Compatibility.
[  OK  ] Started LSB: Advanced IEEE 802.11 management daemon.
         Starting Terminate Plymouth Boot Screen...
         Starting Hold until boot process finishes up...


tranform to uboot acceptable image.
mkimage -A arm -O linux -T kernel -C none -a 0x02000000 -e 0x02000000 -n "linux kernel image" -d ${NAVIO_LINUX}/arch/arm/boot/zImage ${NAVIO_LINUX}/arch/arm/boot/uImage

Turns out using emlid Image works (only 1 cpu online also). But my built from source emlid Image does not work. 


my errors:

pi@navio:~$ sudo emlidtool test
[   49.284566] Under-voltage detected! (0x00050005)
2019-03-16 16:17:09 navio root[551] ERROR lsm9ds1: Failed
 -- Reason: Bus error on LSM9DS1
2019-03-16 16:17:09 navio root[551] ERROR rcio_firmware: Failed
 -- Reason: Please verify that rcio_spi is loaded and /sys/kernel/rcio/status/crc exists
2019-03-16 16:17:09 navio root[551] ERROR adc: Failed
 -- Reason: rcio_adc module wasn't loaded
2019-03-16 16:17:09 navio root[551] ERROR rcio_status_alive: Failed
 -- Reason: rcio_status wasn't loaded
2019-03-16 16:17:09 navio root[551] ERROR mpu9250: Failed
 -- Reason: Bus error on MPU9250
2019-03-16 16:17:09 navio root[551] ERROR ms5611: Failed
 -- Reason: Failed to create MS5611
2019-03-16 16:17:09 navio root[551] ERROR pwm: Failed
 -- Reason: rcio_pwm module wasn't loaded
2019-03-16 16:17:09 navio root[551] ERROR gps: Failed
 -- Reason: [Errno 2] No such file or directory

 let me check boot log with emlid image.

 osboxes@osboxes:~$ ./connect_to_pi.sh 
picocom v1.7

port is        : /dev/ttyUSB0
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv
imap is        : 
omap is        : 
emap is        : crcrlf,delbs,

Terminal ready
NOTICE:  Booting Trusted Firmware
NOTICE:  BL1: v2.0(debug):5ca7b92-dirty
NOTICE:  BL1: Built : 23:26:12, Mar 15 2019
INFO:    BL1: RAM 0x100ee000 - 0x100f7000
INFO:    BL1: cortex_a53: CPU workaround for 843419 was applied
INFO:    BL1: cortex_a53: CPU workaround for 855873 was applied
NOTICE:  rpi3: Detected: Raspberry Pi 3 Model B (1GB, Embest, China) [0x00a22082]
INFO:    BL1: Loading BL2
INFO:    Loading image id=1 at address 0x100b4000
INFO:    Image id=1 loaded: 0x100b4000 - 0x100b9419
NOTICE:  BL1: Booting BL2
INFO:    Entry point address = 0x100b4000
INFO:    SPSR = 0x3c5
NOTICE:  BL2: v2.0(debug):5ca7b92-dirty
NOTICE:  BL2: Built : 23:26:13, Mar 15 2019
INFO:    BL2: Doing platform setup
INFO:    BL2: Loading image id 3
INFO:    Loading image id=3 at address 0x100e0000
INFO:    Image id=3 loaded: 0x100e0000 - 0x100e9081
INFO:    BL2: Loading image id 4
INFO:    Loading image id=4 at address 0x10100000
INFO:    Image id=4 loaded: 0x10100000 - 0x1010001c
INFO:    OPTEE ep=0x10100000
INFO:    OPTEE header info:
INFO:          magic=0x4554504f
INFO:          version=0x2
INFO:          arch=0x0
INFO:          flags=0x0
INFO:          nb_images=0x1
INFO:    BL2: Loading image id 21
INFO:    Loading image id=21 at address 0x10100000
INFO:    Image id=21 loaded: 0x10100000 - 0x1012f1f0
INFO:    BL2: Skip loading image id 22
INFO:    BL2: Loading image id 5
INFO:    Loading image id=5 at address 0x11000000
INFO:    Image id=5 loaded: 0x11000000 - 0x1106cec0
INFO:    BL33 will boot in Non-secure AArch32 Hypervisor mode
NOTICE:  BL1: Booting BL31
INFO:    Entry point address = 0x100e0000
INFO:    SPSR = 0x3cd
NOTICE:  BL31: v2.0(debug):5ca7b92-dirty
NOTICE:  BL31: Built : 23:26:13, Mar 15 2019
INFO:    BL31: Initializing runtime services
INFO:    BL31: cortex_a53: CPU workaround for 843419 was applied
INFO:    BL31: cortex_a53: CPU workaround for 855873 was applied
INFO:    BL31: Initializing BL32
D/TC:0 0 add_phys_mem:536 TEE_SHMEM_START type NSEC_SHM 0x08000000 size 0x00400000
D/TC:0 0 add_phys_mem:536 TA_RAM_START type TA_RAM 0x10800000 size 0x00800000
D/TC:0 0 add_phys_mem:536 VCORE_UNPG_RW_PA type TEE_RAM_RW 0x1012f000 size 0x006d1000
D/TC:0 0 add_phys_mem:536 VCORE_UNPG_RX_PA type TEE_RAM_RX 0x10100000 size 0x0002f000
D/TC:0 0 add_phys_mem:536 CONSOLE_UART_BASE type IO_NSEC 0x3f200000 size 0x00100000
D/TC:0 0 verify_special_mem_areas:474 No NSEC DDR memory area defined
D/TC:0 0 add_va_space:575 type RES_VASPACE size 0x00a00000
D/TC:0 0 add_va_space:575 type SHM_VASPACE size 0x02000000
D/TC:0 0 dump_mmap_table:708 type TEE_RAM_RX   va 0x10100000..0x1012efff pa 0x10100000..0x1012efff size 0x0002f000 (smallpg)
D/TC:0 0 dump_mmap_table:708 type TEE_RAM_RW   va 0x1012f000..0x107fffff pa 0x1012f000..0x107fffff size 0x006d1000 (smallpg)
D/TC:0 0 dump_mmap_table:708 type NSEC_SHM     va 0x10800000..0x10bfffff pa 0x08000000..0x083fffff size 0x00400000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type RES_VASPACE  va 0x10c00000..0x115fffff pa 0x00000000..0x009fffff size 0x00a00000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type SHM_VASPACE  va 0x11600000..0x135fffff pa 0x00000000..0x01ffffff size 0x02000000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type TA_RAM       va 0x13600000..0x13dfffff pa 0x10800000..0x10ffffff size 0x00800000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type IO_NSEC      va 0x13e00000..0x13efffff pa 0x3f200000..0x3f2fffff size 0x00100000 (pgdir)
D/TC:0 0 core_mmu_alloc_l2:238 L2 table used: 1/4
I/TC: 
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[0] with top at 0x10161a38
D/TC:0 0 init_canaries:166 watch *0x10161a3c
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[1] with top at 0x10162078
D/TC:0 0 init_canaries:166 watch *0x1016207c
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[2] with top at 0x101626b8
D/TC:0 0 init_canaries:166 watch *0x101626bc
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[3] with top at 0x10162cf8
D/TC:0 0 init_canaries:166 watch *0x10162cfc
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[0] with top at 0x10157a38
D/TC:0 0 init_canaries:167 watch *0x10157a3c
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[1] with top at 0x10158278
D/TC:0 0 init_canaries:167 watch *0x1015827c
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[2] with top at 0x10158ab8
D/TC:0 0 init_canaries:167 watch *0x10158abc
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[3] with top at 0x101592f8
D/TC:0 0 init_canaries:167 watch *0x101592fc
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[0] with top at 0x1015b338
D/TC:0 0 init_canaries:169 watch *0x1015b33c
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[1] with top at 0x1015d378
D/TC:0 0 init_canaries:169 watch *0x1015d37c
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[2] with top at 0x1015f3b8
D/TC:0 0 init_canaries:169 watch *0x1015f3bc
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[3] with top at 0x101613f8
D/TC:0 0 init_canaries:169 watch *0x101613fc
I/TC: OP-TEE version: 5ca7b92-dev #2 Sat Mar 16 03:41:31 UTC 2019 arm
D/TC:0 0 check_ta_store:533 TA store: "Secure Storage TA"
D/TC:0 0 check_ta_store:533 TA store: "REE"
D/TC:0 0 mobj_mapped_shm_init:709 Shared memory address range: 11600000, 13600000
I/TC: Initialized
D/TC:0 0 init_primary_helper:1033 Primary CPU switching to normal world boot
INFO:    BL31: Preparing for EL3 exit to normal world
INFO:    Entry point address = 0x11000000
INFO:    SPSR = 0x1da


U-Boot 2018.11 (Mar 16 2019 - 00:18:56 -0400)

DRAM:  948 MiB
RPI 3 Model B (0xa22082)
MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
Loading Environment from FAT... OK
In:    serial
Out:   serial
Err:   serial
Net:   No ethernet found.
starting USB...
USB0:   scanning bus 0 for devices... 3 USB Device(s) found
       scanning usb for storage devices... 0 Storage Device(s) found
Hit any key to stop autoboot:  0 
4992748 bytes read in 222 ms (21.4 MiB/s)
## Booting kernel from Legacy Image at 02000000 ...
   Image Name:   linux kernel image
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4992684 Bytes = 4.8 MiB
   Load Address: 02000000
   Entry Point:  02000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 01000000
   Booting using the fdt blob at 0x1000000
   Loading Kernel Image ... OK
   reserving fdt memory region: addr=0 size=1000
   Loading Device Tree to 3af53000, end 3af5c7a2 ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.14.95-emlid-v7+ (alexander.dranitsa@continuous-disintegrator) (gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9)) #1 SMP PREEMPT Mon Feb 4 15:59:56 MSK 2019
[    0.000000] CPU: ARMv7 Processor [410fd034] revision 4 (ARMv7), cr=10c5383d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt: Machine model: Raspberry Pi 3 Model B Rev 1.2
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 8 MiB at 0x3a400000
[    0.000000] On node 0 totalpages: 242688
[    0.000000] free_area_init_node: node 0, pgdat 80c87500, node_mem_map b9bab000
[    0.000000]   Normal zone: 2133 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 242688 pages, LIFO batch:31
[    0.000000] percpu: Embedded 16 pages/cpu @bb3a0000 s36812 r8192 d20532 u65536
[    0.000000] pcpu-alloc: s36812 r8192 d20532 u65536 alloc=16*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 240555
[    0.000000] Kernel command line: console=tty0 console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootfs=ext4 smsc95xx.macaddr=b8:27:eb:ec:ce:c2 ignore_loglevel dma.dmachans=0x7f35 memmap=16M$256M rootwait 8250.nr_uarts=1 elevator=deadline fsck.repair=yes bcm2708_fb.fbwidth=1920 bcm2708_fb.fbheight=1080 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000 dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 dwc_otg.nak_holdoff=0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 940184K/970752K available (7168K kernel code, 638K rwdata, 2236K rodata, 1024K init, 698K bss, 22376K reserved, 8192K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
[    0.000000]     vmalloc : 0xbb800000 - 0xff800000   (1088 MB)
[    0.000000]     lowmem  : 0x80000000 - 0xbb400000   ( 948 MB)
[    0.000000]     modules : 0x7f000000 - 0x80000000   (  16 MB)
[    0.000000]       .text : 0x80008000 - 0x80800000   (8160 kB)
[    0.000000]       .init : 0x80b00000 - 0x80c00000   (1024 kB)
[    0.000000]       .data : 0x80c00000 - 0x80c9f8f0   ( 639 kB)
[    0.000000]        .bss : 0x80ca7048 - 0x80d55920   ( 699 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 24648 entries in 73 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] arch_timer: cp15 timer(s) running at 19.20MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
[    0.000007] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps every 4398046511078ns
[    0.000024] Switching to timer-based delay loop, resolution 52ns
[    0.000271] Console: colour dummy device 80x30
[    0.001327] console [tty0] enabled
[    0.001370] Calibrating delay loop (skipped), value calculated using timer frequency.. 38.40 BogoMIPS (lpj=192000)
[    0.001425] pid_max: default: 32768 minimum: 301
[    0.001754] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001796] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.002745] Disabling memory control group subsystem
[    0.002846] CPU: Testing write buffer coherency: ok
[    0.003300] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.040020] Setting up static identity map for 0x100000 - 0x10003c
[    0.060016] Hierarchical SRCU implementation.
[    0.100084] smp: Bringing up secondary CPUs ...
[    1.201187] CPU1: failed to come online
[    2.322299] CPU2: failed to come online
[    3.443410] CPU3: failed to come online
[    3.443471] smp: Brought up 1 node, 1 CPU
[    3.443501] SMP: Total of 1 processors activated (38.40 BogoMIPS).
[    3.443532] CPU: All CPU(s) started in HYP mode.
[    3.443558] CPU: Virtualization extensions available.
[    3.444358] devtmpfs: initialized
[    3.455613] random: get_random_u32 called from bucket_table_alloc+0xfc/0x24c with crng_init=0
[    3.464079] VFP support v0.3: implementor 41 architecture 3 part 40 variant 3 rev 4
[    3.464442] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    3.464500] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.465200] pinctrl core: initialized pinctrl subsystem
[    3.466065] NET: Registered protocol family 16
[    3.468724] DMA: preallocated 1024 KiB pool for atomic coherent allocations
[    3.473833] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    3.473877] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    3.474101] Serial: AMBA PL011 UART driver
[    3.476201] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
[    3.476770] uart-pl011 3f201000.serial: could not find pctldev for node /soc/gpio@7e200000/uart0_pins, deferring probe
[    3.534089] bcm2835-dma 3f007000.dma: DMA legacy API manager at bb813000, dmachans=0x1
[    3.535740] SCSI subsystem initialized
[    3.536005] usbcore: registered new interface driver usbfs
[    3.536087] usbcore: registered new interface driver hub
[    3.536298] usbcore: registered new device driver usb
[    3.543708] raspberrypi-firmware soc:firmware: Attached to firmware from 2019-03-06 14:43
[    3.554420] clocksource: Switched to clocksource arch_sys_counter
[    3.674733] VFS: Disk quotas dquot_6.6.0
[    3.674860] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.675114] FS-Cache: Loaded
[    3.675351] CacheFiles: Loaded
[    3.684261] NET: Registered protocol family 2
[    3.685187] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    3.685330] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    3.685541] TCP: Hash tables configured (established 8192 bind 8192)
[    3.685706] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    3.685776] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    3.686054] NET: Registered protocol family 1
[    3.706708] RPC: Registered named UNIX socket transport module.
[    3.706742] RPC: Registered udp transport module.
[    3.706769] RPC: Registered tcp transport module.
[    3.706796] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.718569] hw perfevents: enabled with armv7_cortex_a7 PMU driver, 7 counters available
[    3.720350] workingset: timestamp_bits=14 max_order=18 bucket_order=4
[    3.728819] FS-Cache: Netfs 'nfs' registered for caching
[    3.739554] NFS: Registering the id_resolver key type
[    3.739607] Key type id_resolver registered
[    3.739635] Key type id_legacy registered
[    3.742205] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    3.752485] io scheduler noop registered
[    3.752515] io scheduler deadline registered (default)
[    3.752708] io scheduler cfq registered
[    3.752736] io scheduler mq-deadline registered
[    3.752764] io scheduler kyber registered
[    3.755893] BCM2708FB: allocated DMA memory fa510000
[    3.755948] BCM2708FB: allocated DMA channel 0 @ bb813000
[    3.813419] Console: switching to colour frame buffer device 240x67
[    3.846222] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
[    3.847950] bcm2835-rng 3f104000.rng: hwrng registered
[    3.848267] vc-mem: phys_addr:0x00000000 mem_base=0x3ec00000 mem_size:0x40000000(1024 MiB)
[    3.849027] vc-sm: Videocore shared memory driver
[    3.859763] brd: module loaded
[    3.870195] loop: module loaded
[    3.870349] Loading iSCSI transport class v2.0-870.
[    3.881247] libphy: Fixed MDIO Bus: probed
[    3.881489] usbcore: registered new interface driver lan78xx
[    3.881718] usbcore: registered new interface driver smsc95xx
[    3.881901] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
[    3.882387] dwc_otg 3f980000.usb: base=0xf0980000
[    4.092742] Core Release: 2.80a
[    4.092853] Setting default values for core params
[    4.093019] Finished setting default values for core params
[    4.293479] Using Buffer DMA mode
[    4.293588] Periodic Transfer Interrupt Enhancement - disabled
[    4.293761] Multiprocessor Interrupt Enhancement - disabled
[    4.293927] OTG VER PARAM: 0, OTG VER FLAG: 0
[    4.294064] Dedicated Tx FIFOs mode
[    4.294469] dwc_otg: Microframe scheduler enabled
[    4.294680] dwc_otg 3f980000.usb: DWC OTG Controller
[    4.294863] dwc_otg 3f980000.usb: new USB bus registered, assigned bus number 1
[    4.295107] dwc_otg 3f980000.usb: irq 39, io mem 0x00000000
[    4.295313] Init: Port Power? op_state=1
[    4.295435] Init: Power Port (0)
[    4.295776] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.295979] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.296190] usb usb1: Product: DWC OTG Controller
[    4.296335] usb usb1: Manufacturer: Linux 4.14.95-emlid-v7+ dwc_otg_hcd
[    4.296529] usb usb1: SerialNumber: 3f980000.usb
[    4.297289] hub 1-0:1.0: USB hub found
[    4.304472] hub 1-0:1.0: 1 port detected
[    4.312105] dwc_otg: FIQ disabled
[    4.319182] dwc_otg: NAK holdoff disabled
[    4.326188] dwc_otg: FIQ split-transaction FSM disabled
[    4.333128] Module dwc_common_port init
[    4.350330] usbcore: registered new interface driver usb-storage
[    4.357509] mousedev: PS/2 mouse device common for all mice
[    4.364996] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog timer
[    4.372282] bcm2835-cpufreq: min=600000 max=1200000
[    4.381142] sdhci: Secure Digital Host Controller Interface driver
[    4.384781] sdhci: Copyright(c) Pierre Ossman
[    4.388677] mmc-bcm2835 3f300000.mmc: could not get clk, deferring probe
[    4.392622] sdhost-bcm2835 3f202000.mmc: could not get clk, deferring probe
[    4.396383] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.401311] ledtrig-cpu: registered to indicate activity on CPUs
[    4.405148] hidraw: raw HID events driver (C) Jiri Kosina
[    4.408937] usbcore: registered new interface driver usbhid
[    4.412591] usbhid: USB HID core driver
[    4.416727] vchiq: vchiq_init_state: slot_zero = ba580000, is_master = 0
[    4.421848] [vc_sm_connected_init]: start
[    4.431311] [vc_sm_connected_init]: end - returning 0
[    4.435381] Initializing XFRM netlink socket
[    4.439062] NET: Registered protocol family 17
[    4.442794] Key type dns_resolver registered
[    4.446742] Registering SWP/SWPB emulation handler
[    4.450734] registered taskstats version 1
[    4.458633] uart-pl011 3f201000.serial: cts_event_workaround enabled
[    4.462462] 3f201000.serial: ttyAMA0 at MMIO 0x3f201000 (irq = 87, base_baud = 0) is a PL011 rev2
[    4.467318] console [ttyS0] disabled
[    4.471162] 3f215040.serial: ttyS0 at MMIO 0x0 (irq = 166, base_baud = 31250000) is a 16550
[    5.488760] console [ttyS0] enabled
[    5.496543] mmc-bcm2835 3f300000.mmc: mmc_debug:0 mmc_debug2:0
[    5.506314] mmc-bcm2835 3f300000.mmc: Forcing PIO mode
[    5.525711] Indeed it is in host mode hprt0 = 00021501
[    5.614964] sdhost: log_buf @ ba504000 (fa504000)
[    5.631128] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    5.655201] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    5.666027] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    5.678110] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    5.714414] mmc0: sdhost-bcm2835 loaded - DMA enabled (>1)
[    5.724547] of_cfs_init
[    5.730766] of_cfs_init: OK
[    5.757340] usb 1-1: new high-speed USB device number 2 using dwc_otg
[    5.768109] Waiting for root device /dev/mmcblk0p2...
[    5.777159] Indeed it is in host mode hprt0 = 00001101
[    5.805885] random: fast init done
[    5.831802] mmc0: host does not support reading read-only switch, assuming write-enable
[    5.856776] mmc0: new high speed SDHC card at address 1234
[    5.876781] mmc1: new high speed SDIO card at address 0001
[    5.891107] mmcblk0: mmc0:1234 SA04G 3.64 GiB
[    5.901242]  mmcblk0: p1 p2
[    6.056621] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    6.068697] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    6.078835] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[    6.089600] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.100713] devtmpfs: mounted
[    6.107954] hub 1-1:1.0: USB hub found
[    6.117890] Freeing unused kernel memory: 1024K
[    6.126379] hub 1-1:1.0: 5 ports detected
[    6.454480] usb 1-1.1: new high-speed USB device number 3 using dwc_otg
[    6.594925] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
[    6.609691] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.625198] systemd[1]: System time before build time, advancing clock.
[    6.642488] smsc95xx v1.0.6
[    6.740137] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-3f980000.usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:ec:ce:c2
[    6.779246] NET: Registered protocol family 10
[    6.803621] Segment Routing with IPv6
[    6.835818] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.871931] random: systemd: uninitialized urandom read (16 bytes read)
[    6.894627] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    6.922154] systemd[1]: Detected architecture arm.

Welcome to Raspbian GNU/Linux 9 (stretch)!

[    6.966468] systemd[1]: Set hostname to <navio>.
[    7.022785] random: systemd: uninitialized urandom read (16 bytes read)
[    7.185856] random: systemd-sysv-ge: uninitialized urandom read (16 bytes read)
[    7.684575] Under-voltage detected! (0x00050005)
[    7.720968] systemd[1]: Created slice System Slice.
[  OK  ] Created slice System Slice.
[    7.766051] systemd[1]: Created slice system-getty.slice.
[  OK  ] Created slice system-getty.slice.
[    7.814940] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[    7.879465] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[    7.927775] systemd[1]: Mounting RPC Pipe File System...
         Mounting RPC Pipe File System...
[    7.978604] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[    8.035073] systemd[1]: Listening on fsck to fsckd communication Socket.
[  OK  ] Listening on fsck to fsckd communication Socket.
         Mounting Debug File System...
[  OK  ] Created slice system-systemd\x2dfsck.slice.
[  OK  ] Reached target Slices.
[    8.173257] random: crng init done
[    8.184935] random: 7 urandom warning(s) missed due to ratelimiting
[  OK  ] Set up automount Arbitrary Executab…rmats File System Automount Point.
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
[  OK  ] Reached target Swap.
[  OK  ] Listening on Journal Socket.
         Starting Create list of required st…ce nodes for the current kernel...
         Starting Restore / save the current clock...
[  OK  ] Created slice system-serial\x2dgetty.slice.
         Starting Set the console keyboard layout...
[  OK  ] Listening on Syslog Socket.
[  OK  ] Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Listening on Journal Socket (/dev/log).
         Starting Journal Service...
         Starting Load Kernel Modules...
[  OK  ] Mounted RPC Pipe File System.
[  OK  ] Mounted Debug File System.
[    8.661653] i2c /dev entries driver
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Started Create list of required sta…vice nodes for the current kernel.
[  OK  ] Started Restore / save the current clock.
[  OK  ] Started Load Kernel Modules.
         Mounting Configuration File System...
         Starting Apply Kernel Variables...
         Starting Remount Root and Kernel File Systems...
         Starting Create Static Device Nodes in /dev...
[  OK  ] Mounted Configuration File System.
[  OK  ] Started Journal Service.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started Create Static Device Nodes in /dev.
         Starting udev Kernel Device Manager...
[    9.400138] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[  OK  ] Started Remount Root and Kernel File Systems.
         Starting Flush Journal to Persistent Storage...
         Starting Load/Save Random Seed...
         Starting udev Coldplug all Devices...
[  OK  ] Started Load/Save Random Seed.
[  OK  ] Started udev Kernel Device Manager.
[    9.729070] systemd-journald[102]: Received request to flush runtime journal from PID 1
[  OK  ] Started Flush Journal to Persistent Storage.
[  OK  ] Started Set the console keyboard layout.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Started udev Coldplug all Devices.
         Starting Show Plymouth Boot Screen...
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Encrypted Volumes.
[  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
[   10.455769] gpiomem-bcm2835 3f200000.gpiomem: Initialised: Registers at 0x3f200000
[  OK  ] Found device /dev/ttyS0.
[  OK  ] Found device /dev/disk/by-partuuid/9f8abb05-01.
         Starting File System Check on /dev/disk/by-partuuid/9f8abb05-01...
[  OK  ] Started File System Check Daemon to report status.
[  OK  ] Started File System Check on /dev/disk/by-partuuid/9f8abb05-01.
         Mounting /boot...
[  OK  ] Mounted /boot.
[   11.317485] brcmfmac: F1 signature read @0x18000000=0x1541a9a6
[   11.354801] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac43430-sdio.bin for chip 0x00a9a6(43430) rev 0x000001
[   11.355073] usbcore: registered new interface driver brcmfmac
[  OK  ] Reached target Local File Systems.
         Starting Tell Plymouth To Write Out Runtime Data...
[   11.771066] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 23 2017 03:55:53 version 7.45.98.38 (r674442 CY) FWID 01-e58d219f
[   11.822401] brcmfmac: brcmf_c_preinit_dcmds: CLM version = API: 12.2 Data: 7.11.15 Compiler: 1.24.2 ClmImport: 1.24.1 Creation: 2014-05-26 10:53:55 Inc Data: 9.10.39 Inc Compiler: 1.29.4 Inc ClmImport: 1.36.3 Creation: 2017-10-23 03:47:14 
         Starting Preprocess NFS configuration...
         Starting Raise network interfaces...
         Starting Create Volatile Files and Directories...
         Starting Enable support for additional executable binary formats...
         Starting Set console font and keymap...
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
[  OK  ] Started Preprocess NFS configuration.
[  OK  ] Started Set console font and keymap.
[  OK  ] Started Create Volatile Files and Directories.
         Starting Network Time Synchronization...
         Starting Update UTMP about System Boot/Shutdown...
         Mounting Arbitrary Executable File Formats File System...
[  OK  ] Reached target NFS client services.
[  OK  ] Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems.
[  OK  ] Mounted Arbitrary Executable File Formats File System.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Started Enable support for additional executable binary formats.
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Reached target System Time Synchronized.
[  OK  ] Reached target System Initialization.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Listening on triggerhappy.socket.
[  OK  ] Reached target Sockets.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Reached target Timers.
[  OK  ] Reached target Basic System[   13.547966] rcio_core: loading out-of-tree module taints kernel.
.
         [   13.711314] rcio spi1.0: rcio_status: Firmware CRC: 0xb09979ae
[   13.714874] rcio spi1.0: rcio_status: Board type: 0x0 (navio2)
[   13.738645] rcio spi1.0: rcio_status: Git hash: dae830a
[   13.762280] rcio spi1.0: rcio_pwm: Advanced frequency configuration is supported on this firmware
[   13.772618] rcio spi1.0: rcio_pwm: updated freq on grp 0 to 50
[   13.773403] rcio spi1.0: rcio_pwm: updated freq on grp 1 to 50
[   13.774357] rcio spi1.0: rcio_pwm: updated freq on grp 2 to 50
[   13.775134] rcio spi1.0: rcio_pwm: updated freq on grp 3 to 50
[   13.796028] RC config 0 set successfully
[   13.797272] RC config 1 set successfully
[   13.800411] RC config 2 set successfully
[   13.802544] RC config 3 set successfully
[   13.803641] RC config 4 set successfully
[   13.807788] RC config 5 set successfully
[   13.809943] RC config 6 set successfully
[   13.810889] RC config 7 set successfully
[   13.811942] RC config 8 set successfully
[   13.813006] RC config 9 set successfully
[   13.819486] RC config 10 set successfully
[   13.822301] RC config 11 set successfully
[   13.823110] RC config 12 set successfully
[   13.824527] RC config 13 set successfully
[   13.825472] RC config 14 set successfully
[   13.830667] RC config 15 set successfully
[   13.830682] rcio spi1.0: rcio_pwm: PWM probe success
[   13.831769] rcio spi1.0: rcio_gpio: GPIO is supported on this firmware
[   13.831798] rcio spi1.0: rcio_gpio: registered gpio module
[   13.833305] rcio spi1.0: rcio_gpio: gpiochip added successfully under gpio500
[   13.852380] smsc95xx 1-1.1:1.0 enxb827ebeccec2: renamed from eth0
[   14.568398] smsc95xx 1-1.1:1.0 enxb827ebeccec2: hardware isn't capable of remote wakeup
Starting LSB: Autogenerate and use a swap file...
         Starting System Logging Service...
         Starting dhcpcd on all interfaces...
         Starting Avahi mDNS/DNS-SD Stack...
[  OK  ] Started D-Bus System Message Bus.
[  OK  ] Started Avahi mDNS/DNS-SD Stack.
         Starting LSB: Switch to ondemand cp…r (unless shift key is pressed)...
         Starting triggerhappy global hotkey daemon...
         Starting Disable WiFi if country not set...
         Starting Login Service...
[  OK  ] Started Regular background program processing daemon.
[  OK  ] Started System Logging Service.
[  OK  ] Started triggerhappy global hotkey daemon.
[  OK  ] Started Disable WiFi if country not set.
[  OK  ] Started Login Service.
[  OK  ] Started ifup for wlan0.
[  OK  ] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
[  OK  ] Started LSB: Switch to ondemand cpu…nor (unless shift key is pressed).
         Starting Load/Save RF Kill Switch Status...
[  OK  ] Started Load/Save RF Kill Switch Status.
[  OK  ] Started Raise network interfaces.
[   15.647299] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   15.665306] brcmfmac: power management disabled
[   15.678463] Adding 102396k swap on /var/swap.  Priority:-2 extents:1 across:102396k SSFS
[  OK  ] Started LSB: Autogenerate and use a swap file.
[   16.060915] smsc95xx 1-1.1:1.0 enxb827ebeccec2: link up, 100Mbps, full-duplex, lpa 0xCDE1
[   22.244481] Voltage normalised (0x00000000)
[  OK  ] Started dhcpcd on all interfaces.
[  OK  ] Reached target Network.
         Starting dnsmasq - A lightweight DHCP and caching DNS server...
         Starting OpenBSD Secure Shell server...
[  OK  ] Reached target Network is Online.
         Starting LSB: Advanced IEEE 802.11 management daemon...
         Starting /etc/rc.local Compatibility...
         Starting Permit User Sessions...
My IP address is 192.168.0.158 
[  OK  ] Started LSB: Advanced IEEE 802.11 management daemon.
[  OK  ] Started /etc/rc.local Compatibility.
[  OK  ] Started Permit User Sessions.
         Starting Terminate Plymouth Boot Screen...
         Starting Hold until boot process finishes up...

Raspbian GNU/Linux 9 navio ttyS0
navio login: 

emlid image is using
Linux navio 4.14.95-emlid-v7+ #1 SMP PREEMPT Mon Feb 4 15:59:56 MSK 2019 armv7l GNU/Linux

however my source is 4.14.34

Now to do:
either
1. wait for navio support 
2. patch upstream linux 4.14.95 to navio 4.14.34

the module load bin is the reason for not loading kernel modules?

patch 4.14.y upstream rpi3-linux
1. added navio_defconfig
2. added 
dtbo-$(CONFIG_ARCH_BCM2835) += spi0-4cs.dtbo
dtbo-$(CONFIG_ARCH_BCM2835) += navio-rgb.dtbo
dtbo-$(CONFIG_ARCH_BCM2835) += rcio.dtbo
into Makefile and added corresponding overlay files
3. patch pwm
drivers/pwm/core.c

change Makefile path to this new 4.14.98 upstream.
add patch in raspbian-optee
(1. platfrom armtf patch arch32, not needed)
2. optee subtree into firmware bcm2710.dtsi
3. add config_tee/optee=y to navio_defconfig

and make -j4.

now transfering the generated uIamge to rpi3 sd card.

● systemd-modules-load.service - Load Kernel Modules
   Loaded: loaded (/lib/systemd/system/systemd-modules-load.service; static; vendor preset: enabled)
   Active: failed (Result: exit-code) since Sun 2019-03-17 04:17:02 UTC; 3 days ago
     Docs: man:systemd-modules-load.service(8)
           man:modules-load.d(5)
  Process: 85 ExecStart=/lib/systemd/systemd-modules-load (code=exited, status=1/FAILURE)
 Main PID: 85 (code=exited, status=1/FAILURE)

Nov 03 17:16:43 navio systemd-modules-load[85]: could not open moddep file '/lib/modules/4.14.98-emlid-v7+/modules.dep.bin'
Mar 17 04:17:02 navio systemd[1]: systemd-modules-load.service: Main process exited, code=exited, status=1/FAILURE
Mar 17 04:17:02 navio systemd[1]: Failed to start Load Kernel Modules.
Mar 17 04:17:02 navio systemd[1]: systemd-modules-load.service: Unit entered failed state.
Mar 17 04:17:02 navio systemd[1]: systemd-modules-load.service: Failed with result 'exit-code'.


/lib/systemd/system/systemd-modules-load.service
pi@navio:/lib/systemd/system $ cat systemd-modules-load.service 
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=Load Kernel Modules
Documentation=man:systemd-modules-load.service(8) man:modules-load.d(5)
DefaultDependencies=no
Conflicts=shutdown.target
Before=sysinit.target shutdown.target
ConditionCapability=CAP_SYS_MODULE
ConditionDirectoryNotEmpty=|/lib/modules-load.d
ConditionDirectoryNotEmpty=|/usr/lib/modules-load.d
ConditionDirectoryNotEmpty=|/usr/local/lib/modules-load.d
ConditionDirectoryNotEmpty=|/etc/modules-load.d
ConditionDirectoryNotEmpty=|/run/modules-load.d
ConditionKernelCommandLine=|modules-load
ConditionKernelCommandLine=|rd.modules-load

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/lib/systemd/systemd-modules-load
TimeoutSec=90s
pi@navio:/lib/systemd/system $ ls

ConditionKernelCommandLine=|modules-load
ConditionKernelCommandLine=|rd.modules-load
ExecStart=/lib/systemd/systemd-modules-load

cat /lib/systemd/systemd-modules-load

change Makefile 4.14.98 to 4.14.95 and rebuild

● systemd-modules-load.service - Load Kernel Modules
   Loaded: loaded (/lib/systemd/system/systemd-modules-load.service; static; vendor preset: enabled)
   Active: failed (Result: exit-code) since Wed 2019-03-20 19:17:01 UTC; 25min ago
     Docs: man:systemd-modules-load.service(8)
           man:modules-load.d(5)
  Process: 81 ExecStart=/lib/systemd/systemd-modules-load (code=exited, status=1/FAILURE)
 Main PID: 81 (code=exited, status=1/FAILURE)

still fail.

change Makefile of 4.14.34 to 4.14.95 and rebuild

binary location /lib/systemd/systemd-modules-load


now trying to find 4.14.95 upstream.

4.14.95 upstream after patch works on preconfigure Navio image!

now use raspbian image to overwrite navio image to test optee.

sudo tee-supplicant &
sudo ./helloworld

pi@navio:~$ sudo ./hello_world 
InitialiD/TC:? 0 tee_ta_init_pseudo_ta_session:276 Lookup pseudo TA d96a5b40-c3e5-21e3-8794-1002a5d5c61b
ze a conD/TC:? 0 tee_ta_init_pseudo_ta_session:289 Open invoke_tests.pta
text froD/TC:? 0 tee_ta_init_pseudo_ta_session:303 invoke_tests.pta : d96a5b40-c3e5-21e3-8794-1002a5d5c61b
m user sD/TC:? 0 create_ta:364 create entry point for pseudo TA "invoke_tests.pta"
pace! 
D/TC:? 0 open_session:377 open entry point for pseudo ta "invoke_tests.pta"
Open sesF/TC:? 0 plat_prng_add_jitter_entropy:73 plat_prng_add_jitter_entropy: 0xF6F8
sion froF/TC:? 0 invoke_command:390 command entry point for pseudo ta "invoke_tests.pta"
m user sI/TC: pseudo TA "invoke_tests.pta" says "Hello world !"
pace! 
D/TC:? 0 tee_ta_close_session:380 tee_ta_close_session(0x10149fa8)
Setting D/TC:? 0 tee_ta_close_session:399 Destroy session
op.paramD/TC:? 0 close_session:383 close entry point for pseudo ta "invoke_tests.pta"
s[0].valD/TC:? 0 destroy_ta:370 destroy entry point for pseudo ta "invoke_tests.pta"
ue.a to fffd in user space 
Invoking PTA to increment op.params[0].value.a: fffa
 in user spacePTA incremented value to fffa
 in user spaceClose session from user space! 
Finalize context from user space! 
pi@navio:~$ ls

[  363.364402] Under-voltage detected! (0x00070007)
2019-03-20 22:49:08 navio root[617] INFO ms5611: Passed
2019-03-20 22:49:08 navio root[617] INFO lsm9ds1: Passed
2019-03-20 22:49:08 navio root[617] INFO gps: Passed
2019-03-20 22:49:08 navio root[617] INFO mpu9250: Passed
2019-03-20 22:49:08 navio root[617] ERROR rcio_firmware: Failed
 -- Reason: Please verify that rcio_spi is loaded and /sys/kernel/rcio/status/crc exists
2019-03-20 22:49:08 navio root[617] ERROR pwm: Failed
 -- Reason: rcio_pwm module wasn't loaded
2019-03-20 22:49:08 navio root[617] ERROR rcio_status_alive: Failed
 -- Reason: rcio_status wasn't loaded
2019-03-20 22:49:08 navio root[617] ERROR adc: Failed
 -- Reason: rcio_adc module wasn't loaded

this is image from generic raspian image

now trying navio preconfigured image. (40min with cp)

[  OK  ] Started File System Check Daemon to report status.
[  OK  ] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
[   14.597995] rcio_core: loading out-of-tree module taints kernel.
[   14.627805] rcio spi1.0: rcio_status: Firmware CRC: 0xb09979ae
[   14.638945] rcio spi1.0: rcio_status: Board type: 0x0 (navio2)
[   14.667083] rcio spi1.0: rcio_status: Git hash: dae830a
[   14.685584] rcio spi1.0: rcio_pwm: Advanced frequency configuration is supported on this firmware
[   14.700462] brcmfmac: F1 signature read @0x18000000=0x1541a9a6
[   14.737556] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac43430-sdio.bin for chip 0x00a9a6(43430) rev 0x000001
[   14.755196] rcio spi1.0: rcio_pwm: updated freq on grp 0 to 50
[   14.767404] usbcore: registered new interface driver brcmfmac
[   14.792082] rcio spi1.0: rcio_pwm: updated freq on grp 1 to 50
[   14.803400] rcio spi1.0: rcio_pwm: updated freq on grp 2 to 50
[   14.815897] rcio spi1.0: rcio_pwm: updated freq on grp 3 to 50
[   14.827011] RC config 0 set successfully
[   14.827869] RC config 1 set successfully
[   14.838151] RC config 2 set successfully
[   14.849378] smsc95xx 1-1.1:1.0 enxb827ebeccec2: renamed from eth0
[   14.871403] RC config 3 set successfully
[   14.872097] RC config 4 set successfully
[   14.881418] RC config 5 set successfully
[  OK  ] Started File System Check on /dev/disk/by-partuuid/9f8abb05-01.
         Mounting /boot...
[   14.943674] RC config 6 set successfully
[   15.036515] RC config 7 set successfully
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Tell Plymouth To Write Out Runtime Data...
[   15.058444] RC config 8 set successfully
[   15.143228] RC config 9 set successfully
[   15.144088] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 23 2017 03:55:53 version 7.45.98.38 (r674442 CY) FWID 01-e58d219f
[   15.144804] brcmfmac: brcmf_c_preinit_dcmds: CLM version = API: 12.2 Data: 7.11.15 Compiler: 1.24.2 ClmImport: 1.24.1 Creation: 2014-05-26 10:53:55 Inc Data: 9.10.39 Inc Compiler: 1.29.4 Inc ClmImport: 1.36.3 Creation: 2017-10-23 03:47:14 
[   15.176523] RC config 10 set successfully
[   15.177495] RC config 11 set successfully
[   15.182484] RC config 12 set successfully
[   15.183528] RC config 13 set successfully
[   15.187014] RC config 14 set successfully
[   15.188384] RC config 15 set successfully
[   15.188395] rcio spi1.0: rcio_pwm: PWM probe success
[   15.190124] rcio spi1.0: rcio_gpio: GPIO is supported on this firmware
[   15.190413] rcio spi1.0: rcio_gpio: registered gpio module
[   15.200806] rcio spi1.0: rcio_gpio: gpiochip added successfully under gpio500
         Starting Enable support for additional executable binary formats...
         Starting Raise network interfaces...
         Starting Create Volatile Files and Directories...
         Starting Preprocess NFS configuration...
         Starting Set console font and keymap...

pi@navio:~$ sudo emlidtool test
2019-03-20 23:53:21 navio root[810] INFO rcio_status_alive: Passed
2019-03-20 23:53:21 navio root[810] INFO ms5611: Passed
2019-03-20 23:53:21 navio root[810] INFO adc: Passed
2019-03-20 23:53:21 navio root[810] INFO mpu9250: Passed
2019-03-20 23:53:21 navio root[810] INFO pwm: Passed
2019-03-20 23:53:21 navio root[810] INFO lsm9ds1: Passed
2019-03-20 23:53:21 navio root[810] INFO rcio_firmware: Passed
2019-03-20 23:53:21 navio root[810] INFO gps: Passed

Success:
sudo tee-supplicant &
sudo ./helloworld 
sudo emlidtool test
sudo emlidtool ardupilot <- apply configuration for arducopter success

Turns out ko modules are in filesystem and dts/overlay specifies what ko modules to load.

backup:
osboxes@osboxes:~/Desktop$ sudo dd if=/dev/sdd of=/home/osboxes/Desktop/my-working-img/rpi3_optee_navio_41495.img
7626752+0 records in
7626752+0 records out
3904897024 bytes (3.9 GB, 3.6 GiB) copied, 283.807 s, 13.8 MB/s

cool demo: http://ardupilot.org/dev/docs/ros.html

cmake in llvm build

cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=OFF V=1\
            -DCMAKE_C_FLAGS="-O3" -DCMAKE_CXX_FLAGS="-O3" \
            -DLLVM_BINUTILS_INCDIR=/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/include \
            -DCMAKE_TOOLCHAIN_FILE=../Toolchain-rpi.cmake ../


            ./prebuilt-inst/bin/clang --target=arm-linux-gnueabihf \
                     --sysroot=./sysroot \
                     -isysroot ./sysroot \
                     -L${COMPILER_PATH} \
                     --gcc-toolchain=./prebuilt-inst/bin \
                     -o hello hello.c


compiler-rt cross build: https://bcain-llvm.readthedocs.io/projects/llvm/en/latest/HowToCrossCompileBuiltinsOnArm/

original:

path/to/llvm/projects/compiler-rt
-DCOMPILER_RT_BUILD_BUILTINS=ON
-DCOMPILER_RT_BUILD_SANITIZERS=OFF
-DCOMPILER_RT_BUILD_XRAY=OFF
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
-DCOMPILER_RT_BUILD_PROFILE=OFF
-DCMAKE_C_COMPILER=/path/to/clang
-DCMAKE_AR=/path/to/llvm-ar
-DCMAKE_NM=/path/to/llvm-nm
-DCMAKE_RANLIB=/path/to/llvm-ranlib
-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"
-DCMAKE_C_COMPILER_TARGET="arm-linux-gnueabihf"
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON
-DLLVM_CONFIG_PATH=/path/to/llvm-config
-DCMAKE_C_FLAGS="build-c-flags"

c-flags:
--target=arm-linux-gnueabihf
--march=armv7a
--gcc-toolchain=/path/to/dir/toolchain
--sysroot=/path/to/toolchain/arm-linux-gnueabihf/libc

my ver. use clang

cmake -G Ninja ../ \
-DCOMPILER_RT_BUILD_BUILTINS=ON \
-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
-DCOMPILER_RT_BUILD_XRAY=OFF \
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
-DCOMPILER_RT_BUILD_PROFILE=OFF \
-DCMAKE_C_COMPILER=/home/osboxes/Desktop/llvm/build/bin/clang \
-DCMAKE_AR=/home/osboxes/Desktop/llvm/build/bin/llvm-ar \
-DCMAKE_NM=/home/osboxes/Desktop/llvm/build/bin/llvm-nm \
-DCMAKE_RANLIB=/home/osboxes/Desktop/llvm/build/bin/llvm-ranlib \
-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
-DCMAKE_C_COMPILER_TARGET="arm-linux-gnueabihf" \
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
-DLLVM_CONFIG_PATH=/home/osboxes/Desktop/llvm/build/bin/llvm-config \
-DCMAKE_C_FLAGS="--sysroot=/media/rpi"

c-flags:
--target=arm-linux-gnueabihf
--march=armv7a
--gcc-toolchain=/path/to/dir/toolchain
--sysroot=/path/to/toolchain/arm-linux-gnueabihf/libc

my ver. use linaro gcc

path/to/llvm/projects/compiler-rt
-DCOMPILER_RT_BUILD_BUILTINS=ON
-DCOMPILER_RT_BUILD_SANITIZERS=OFF
-DCOMPILER_RT_BUILD_XRAY=OFF
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
-DCOMPILER_RT_BUILD_PROFILE=OFF
-DCMAKE_C_COMPILER=/path/to/clang
-DCMAKE_AR=/path/to/llvm-ar
-DCMAKE_NM=/path/to/llvm-nm
-DCMAKE_RANLIB=/path/to/llvm-ranlib
-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"
-DCMAKE_C_COMPILER_TARGET="arm-linux-gnueabihf"
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON
-DLLVM_CONFIG_PATH=/path/to/llvm-config
-DCMAKE_C_FLAGS="build-c-flags"

c-flags:
--target=arm-linux-gnueabihf
--march=armv7a
--gcc-toolchain=/path/to/dir/toolchain
--sysroot=/path/to/toolchain/arm-linux-gnueabihf/libc





cmake -G Ninja \
-DCMAKE_CROSSCOMPILING=True \
-DCOMPILER_RT_BUILD_BUILTINS=ON \
-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
-DCOMPILER_RT_BUILD_XRAY=OFF \
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
-DCOMPILER_RT_BUILD_PROFILE=OFF \
-DCMAKE_C_COMPILER=/home/osboxes/Desktop/llvm/build/bin/clang \
-DCMAKE_AR=/home/osboxes/Desktop/llvm/build/bin/llvm-ar \
-DCMAKE_NM=/home/osboxes/Desktop/llvm/build/bin/llvm-nm \
-DCMAKE_RANLIB=/home/osboxes/Desktop/llvm/build/bin/llvm-ranlib \
-DCMAKE_C_COMPILER_TARGET="arm-linux-gnueabihf" \
-DCMAKE_ASM_COMPILER_TARGET="arm-linux-gnueabihf" \
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
-DLLVM_CONFIG_PATH=/home/osboxes/Desktop/llvm/build/tools/llvm-config \
-DCMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN=/media/rpi/usr/bin \
-DCMAKE_SYSROOT=/media/rpi \
-DCMAKE_C_FLAGS="-L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6 -isysroot /media/rpi" \
-DCMAKE_ASM_FLAGS="-L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6 -isysroot /media/rpi" \
-DLLVM_BINUTILS_INCDIR=/media/rpi \
../


-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \



/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/lib/gcc/arm-linux-gnueabihf/6/

cmake -G Ninja \
-DCOMPILER_RT_BUILD_BUILTINS=ON \
-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
-DCOMPILER_RT_BUILD_XRAY=OFF \
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
-DCOMPILER_RT_BUILD_PROFILE=OFF \
-DCMAKE_C_COMPILER=/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-gcc \
-DCMAKE_AR=/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-ar \
-DCMAKE_NM=/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-gcc-nm \
-DCMAKE_RANLIB=/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-ranlib \
-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" \
-DCMAKE_C_COMPILER_TARGET="arm-linux-gnueabihf" \
-DCMAKE_ASM_COMPILER_TARGET="arm-linux-gnueabihf" \
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
-DLLVM_CONFIG_PATH=/home/osboxes/Desktop/llvm/build/tools/llvm-config \
-DCMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN=/home/osboxes/devel/optee/toolchains/aarch32 \
-DCMAKE_SYSROOT=/home/osboxes/devel/optee/toolchains/aarch32/arm-linux-gnueabihf/libc \
-DLLVM_BINUTILS_INCDIR=/media/rpi
../



cmake -G Ninja \
-DCOMPILER_RT_BUILD_BUILTINS=ON \
-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
-DCOMPILER_RT_BUILD_XRAY=OFF \
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
-DCOMPILER_RT_BUILD_PROFILE=OFF \
-DLLVM_CONFIG_PATH=/home/osboxes/Desktop/llvm/build/bin/llvm-config \
-DCMAKE_TOOLCHAIN_FILE=Toolchain.cmake \
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
-DCMAKE_C_COMPILER_TARGET="arm-linux-gnueabihf" \
-DCMAKE_ASM_COMPILER_TARGET="arm-linux-gnueabihf" \
-DLLVM_BINUTILS_INCDIR=/media/rpi \
../

-DCMAKE_LINKER=


sudo mount -o loop,offset=40894464 rpi3_optee_navio_41495.img /media/rpi/

SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_VERSION 1)
# Define the cross compiler locations
SET(CMAKE_C_COMPILER /home/osboxes/Desktop/raspbian-sdk/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-gcc)
SET(CMAKE_CXX_COMPILER /home/osboxes/Desktop/raspbian-sdk/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-g++)
SET(CMAKE_FIND_ROOT_PATH /media/rpi)
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --sysroot=${CMAKE_FIND_ROOT_PATH}")
SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} --sysroot=${CMAKE_FIND_ROOT_PATH}")
SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} --sysroot=${CMAKE_FIND_ROOT_PATH}")
# Use our definitions for compiler tools
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Search for libraries and headers in the target directories only
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

cmake -D CMAKE_BUILD_TYPE=Debug -D CMAKE_TOOLCHAIN_FILE=$HOME/rpi/Toolchain-RaspberryPi.cmake path/to/your/project


-DCMAKE_CROSSCOMPILING=True
-DCMAKE_INSTALL_PREFIX=<install-dir>
-DLLVM_TABLEGEN=<path-to-host-bin>/llvm-tblgen
-DCLANG_TABLEGEN=<path-to-host-bin>/clang-tblgen
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf
-DLLVM_TARGET_ARCH=ARM
-DLLVM_TARGETS_TO_BUILD=ARM

/home/osboxes/Desktop/llvm/build/bin/llvm-config

-DCMAKE_CXX_FLAGS='-march=armv7-a -mcpu=cortex-a9 -mfloat-abi=hard'
'-target arm-linux-gnueabihf'
'--sysroot=/usr/arm-linux-gnueabihf'




-DCMAKE_CROSSCOMPILING=True
-DCMAKE_INSTALL_PREFIX=/test
-DLLVM_TABLEGEN=<path-to-host-bin>/llvm-tblgen
-DCLANG_TABLEGEN=<path-to-host-bin>/clang-tblgen
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf
-DLLVM_TARGET_ARCH=ARM
-DLLVM_TARGETS_TO_BUILD=ARM

/home/osboxes/Desktop/llvm/build/bin/llvm-config

-DCMAKE_CXX_FLAGS='-march=armv7-a -mcpu=cortex-a9 -mfloat-abi=hard'
'-target arm-linux-gnueabihf'
'--sysroot=/usr/arm-linux-gnueabihf'

  Run Build Command:"/usr/bin/ninja" "cmTC_80d2c"

  [1/2] Building C object CMakeFiles/cmTC_80d2c.dir/testCCompiler.c.o

  clang-3.9: warning: argument unused during compilation:
  '-L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6'

  [2/2] Linking C executable cmTC_80d2c

  FAILED: : && /home/osboxes/Desktop/llvm/build/bin/clang
  --target=arm-linux-gnueabihf --gcc-toolchain=/media/rpi/usr/bin --sysroot=/media/rpi -isysroot /media/rpi
   -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6
   CMakeFiles/cmTC_80d2c.dir/testCCompiler.c.o -o
  cmTC_80d2c -rdynamic && :

  /usr/bin/ld: unrecognised emulation mode: armelf_linux_eabi

  Supported emulations: elf_x86_64 elf32_x86_64 elf_i386 elf_iamcu i386linux
  elf_l1om elf_k1om i386pep i386pe

  clang-3.9: error: linker command failed with exit code 1 (use -v to see
  invocation)

  ninja: build stopped: subcommand failed.


cmake -G Ninja ../ \
-DCMAKE_CROSSCOMPILING=True \
-DLLVM_TABLEGEN=/home/osboxes/Desktop/llvm/build/bin/llvm-tblgen \
-DCLANG_TABLEGEN=/home/osboxes/Desktop/llvm/build/bin/clang-tblgen \
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf \
-DLLVM_TARGET_ARCH=ARM \
-DLLVM_TARGETS_TO_BUILD=ARM \
-DCMAKE_CXX_FLAGS='-march=armv7-a -mcpu=cortex-a9 -mfloat-abi=hard' \
-DLLVM_ENABLE_PIC=False

--trace-expand


llvm https://llvm.org/docs/HowToCrossCompileLLVM.html

The packages you’ll need are:

cmake
ninja-build (from backports in Ubuntu)
gcc-4.7-arm-linux-gnueabihf
gcc-4.7-multilib-arm-linux-gnueabihf
binutils-arm-linux-gnueabihf
libgcc1-armhf-cross
libsfgcc1-armhf-cross
libstdc++6-armhf-cross
libstdc++6-4.7-dev-armhf-cross 

Configuring CMake
For more information on how to configure CMake for LLVM/Clang, see Building LLVM with CMake.

The CMake options you need to add are:

-DCMAKE_CROSSCOMPILING=True
-DCMAKE_INSTALL_PREFIX=<install-dir>
-DLLVM_TABLEGEN=<path-to-host-bin>/llvm-tblgen
-DCLANG_TABLEGEN=<path-to-host-bin>/clang-tblgen
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf
-DLLVM_TARGET_ARCH=ARM
-DLLVM_TARGETS_TO_BUILD=ARM

If you’re compiling with GCC, you can use architecture options for your target, and the compiler driver will detect everything that it needs:

-DCMAKE_CXX_FLAGS='-march=armv7-a -mcpu=cortex-a9 -mfloat-abi=hard'
However, if you’re using Clang, the driver might not be up-to-date with your specific Linux distribution, version or GCC layout, so you’ll need to fudge.

In addition to the ones above, you’ll also need:

'-target arm-linux-gnueabihf' or whatever is the triple of your cross GCC.
'--sysroot=/usr/arm-linux-gnueabihf', '--sysroot=/opt/gcc/arm-linux-gnueabihf' or whatever is the location of your GCC’s sysroot (where /lib, /bin etc are).
Appropriate use of -I and -L, depending on how the cross GCC is installed, and where are the libraries and headers.
The TableGen options are required to compile it with the host compiler, so you’ll need to compile LLVM (or at least llvm-tblgen) to your host platform before you start. The CXX flags define the target, cpu (which in this case defaults to fpu=VFP3 with NEON), and forcing the hard-float ABI. If you’re using Clang as a cross-compiler, you will also have to set --sysroot to make sure it picks the correct linker.

When using Clang, it’s important that you choose the triple to be identical to the GCC triple and the sysroot. This will make it easier for Clang to find the correct tools and include headers. But that won’t mean all headers and libraries will be found. You’ll still need to use -I and -L to locate those extra ones, depending on your distribution.

Most of the time, what you want is to have a native compiler to the platform itself, but not others. So there’s rarely a point in compiling all back-ends. For that reason, you should also set the TARGETS_TO_BUILD to only build the back-end you’re targeting to.

You must set the CMAKE_INSTALL_PREFIX, otherwise a ninja install will copy ARM binaries to your root filesystem, which is not what you want.

Hacks
There are some bugs in current LLVM, which require some fiddling before running CMake:

If you’re using Clang as the cross-compiler, there is a problem in the LLVM ARM back-end that is producing absolute relocations on position-independent code (R_ARM_THM_MOVW_ABS_NC), so for now, you should disable PIC:

-DLLVM_ENABLE_PIC=False
This is not a problem, since Clang/LLVM libraries are statically linked anyway, it shouldn’t affect much.

The ARM libraries won’t be installed in your system. But the CMake prepare step, which checks for dependencies, will check the host libraries, not the target ones. Below there’s a list of some dependencies, but your project could have more, or this document could be outdated. You’ll see the errors while linking as an indication of that.

Debian based distros have a way to add multiarch, which adds a new architecture and allows you to install packages for those systems. See https://wiki.debian.org/Multiarch/HOWTO for more info.

But not all distros will have that, and possibly not an easy way to install them in any anyway, so you’ll have to build/download them separately.

A quick way of getting the libraries is to download them from a distribution repository, like Debian (http://packages.debian.org/jessie/), and download the missing libraries. Note that the libXXX will have the shared objects (.so) and the libXXX-dev will give you the headers and the static (.a) library. Just in case, download both.

The ones you need for ARM are: libtinfo, zlib1g, libxml2 and liblzma. In the Debian repository you’ll find downloads for all architectures.

After you download and unpack all .deb packages, copy all .so and .a to a directory, make the appropriate symbolic links (if necessary), and add the relevant -L and -I paths to -DCMAKE_CXX_FLAGS above.

Running CMake and Building
Finally, if you’re using your platform compiler, run:

$ cmake -G Ninja <source-dir> <options above>
If you’re using Clang as the cross-compiler, run:

$ CC='clang' CXX='clang++' cmake -G Ninja <source-dir> <options above>
If you have clang/clang++ on the path, it should just work, and special Ninja files will be created in the build directory. I strongly suggest you to run cmake on a separate build directory, not inside the source tree.

To build, simply type:

$ ninja
It should automatically find out how many cores you have, what are the rules that needs building and will build the whole thing.

You can’t run ninja check-all on this tree because the created binaries are targeted to ARM, not x86_64.



cmake -G Ninja ../ -DCMAKE_CROSSCOMPILING=True \
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf \
-DCMAKE_C_COMPILER=/usr/bin/arm-linux-gnueabihf-gcc-4.7 \
-DCMAKE_CXX_COMPILER=/usr/bin/arm-linux-gnueabihf-g++-4.7 \
-DCMAKE_AR=/usr/bin/arm-linux-gnueabihf-gcc-ar-4.7 \
-DCMAKE_NM=/usr/bin/arm-linux-gnueabihf-gcc-nm-4.7 \
-DLLVM_TABLEGEN=/home/osboxes/Desktop/llvm/build/bin/llvm-tblgen \
-DCLANG_TABLEGEN=/home/osboxes/Desktop/llvm/build/bin/clang-tblgen \
-DCMAKE_RANLIB=/usr/bin/arm-linux-gnueabihf-gcc-ranlib-4.7 \
-DLLVM_TARGET_ARCH=ARM \
-DLLVM_TARGETS_TO_BUILD=ARM \
-DCMAKE_CXX_FLAGS='-march=armv7-a -mcpu=cortex-a9 -mfloat-abi=hard'


[1136/2342] Building C object projects..._rt.builtins-armhf.dir/clear_cache.c.o
FAILED: /usr/bin/arm-linux-gnueabihf-gcc-4.7  -D_DEBUG -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -Iprojects/compiler-rt/lib/builtins -I../projects/compiler-rt/lib/builtins -Iinclude -I../include -fPIC -Wall -W -Wno-unused-parameter -Wwrite-strings -Wno-missing-field-initializers -pedantic -Wno-long-long -Wno-comment -Wall -Wno-unused-parameter -g    -march=armv7-a -mfloat-abi=hard  -std=c99 -MMD -MT projects/compiler-rt/lib/builtins/CMakeFiles/clang_rt.builtins-armhf.dir/clear_cache.c.o -MF projects/compiler-rt/lib/builtins/CMakeFiles/clang_rt.builtins-armhf.dir/clear_cache.c.o.d -o projects/compiler-rt/lib/builtins/CMakeFiles/clang_rt.builtins-armhf.dir/clear_cache.c.o   -c ../projects/compiler-rt/lib/builtins/clear_cache.c
../projects/compiler-rt/lib/builtins/clear_cache.c: In function ‘__clear_cache’:
../projects/compiler-rt/lib/builtins/clear_cache.c:112:10: warning: ‘register’ is not at beginning of declaration [-Wold-style-declaration]
../projects/compiler-rt/lib/builtins/clear_cache.c:113:10: warning: ‘register’ is not at beginning of declaration [-Wold-style-declaration]
../projects/compiler-rt/lib/builtins/clear_cache.c:169:1: error: r7 cannot be used in asm here
[1136/2342] Building CXX object lib/Pa...Files/LLVMPasses.dir/PassBuilder.cpp.o
ninja: build stopped: subcommand failed.





2. another route. use qemu to emulate rpi3 and build

$ qemu-system-arm \
   -kernel boot/kernel-qemu-4.14.50-stretch \
   -dtb boot/versatile-pb.dtb \
   -m 256 -M versatilepb -cpu arm1176 \
   -serial stdio \
   -append "rw console=ttyAMA0 root=/dev/sda2 rootfstype=ext4  loglevel=8 rootwait fsck.repair=yes memtest=1" \
   -drive file=2018-11-13-raspbian-stretch-lite.img,format=raw \
   -no-reboot


   -netdev user,id=unknown,hostfwd=tcp::5022-:22 \

3. write makefile to build libclang_builtin.a

cross compiler every 


osboxes@osboxes:~/Desktop/llvm/projects/compiler-rt/build/lib/csi$ make VERBOSE=1
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build && /usr/bin/cmake -H/home/osboxes/Desktop/llvm/projects/compiler-rt -B/home/osboxes/Desktop/llvm/projects/compiler-rt/build --check-build-system CMakeFiles/Makefile.cmake 0
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build && /usr/bin/cmake -E cmake_progress_start /home/osboxes/Desktop/llvm/projects/compiler-rt/build/CMakeFiles /home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi/CMakeFiles/progress.marks
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build && make -f CMakeFiles/Makefile2 lib/csi/all
make[1]: Entering directory '/home/osboxes/Desktop/llvm/projects/compiler-rt/build'
make -f lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/build.make lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/depend
make[2]: Entering directory '/home/osboxes/Desktop/llvm/projects/compiler-rt/build'
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build && /usr/bin/cmake -E cmake_depends "Unix Makefiles" /home/osboxes/Desktop/llvm/projects/compiler-rt /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi /home/osboxes/Desktop/llvm/projects/compiler-rt/build /home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi /home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/DependInfo.cmake --color=
Dependee "/home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/DependInfo.cmake" is newer than depender "/home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/depend.internal".
Dependee "/home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi/CMakeFiles/CMakeDirectoryInformation.cmake" is newer than depender "/home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/depend.internal".
Scanning dependencies of target clang_rt.csi-x86_64
make[2]: Leaving directory '/home/osboxes/Desktop/llvm/projects/compiler-rt/build'
make -f lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/build.make lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/build
make[2]: Entering directory '/home/osboxes/Desktop/llvm/projects/compiler-rt/build'
Building C object lib/csi/CMakeFiles/clang_rt.csi-x86_64.dir/csirt.c.o
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi && /usr/bin/cc   -I/home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/..  -Wall -Wno-unused-parameter    -m64 -fPIC -fno-builtin -fno-exceptions -fomit-frame-pointer -funwind-tables -fno-stack-protector -fvisibility=hidden -fvisibility-inlines-hidden -fno-function-sections -fno-lto -O3 -g -Wno-variadic-macros -Wno-non-virtual-dtor -std=c11 -fno-rtti -o CMakeFiles/clang_rt.csi-x86_64.dir/csirt.c.o   -c /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c
cc1: warning: command line option ‘-Wno-non-virtual-dtor’ is valid for C++/ObjC++ but not for C
cc1: warning: command line option ‘-fvisibility-inlines-hidden’ is valid for C++/ObjC++ but not for C
cc1: warning: command line option ‘-fno-rtti’ is valid for C++/ObjC++ but not for C
Linking C static library ../linux/libclang_rt.csi-x86_64.a
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi && /usr/bin/cmake -P CMakeFiles/clang_rt.csi-x86_64.dir/cmake_clean_target.cmake
cd /home/osboxes/Desktop/llvm/projects/compiler-rt/build/lib/csi && /usr/bin/cmake -E cmake_link_script CMakeFiles/clang_rt.csi-x86_64.dir/link.txt --verbose=1
/usr/bin/ar qc ../linux/libclang_rt.csi-x86_64.a  CMakeFiles/clang_rt.csi-x86_64.dir/csirt.c.o
/usr/bin/ranlib ../linux/libclang_rt.csi-x86_64.a
make[2]: Leaving directory '/home/osboxes/Desktop/llvm/projects/compiler-rt/build'
Built target clang_rt.csi-x86_64
make[1]: Leaving directory '/home/osboxes/Desktop/llvm/projects/compiler-rt/build'
/usr/bin/cmake -E cmake_progress_start /home/osboxes/Desktop/llvm/projects/compiler-rt/build/CMakeFiles 0




/home/osboxes/Desktop/raspbian-sdk/prebuilt-inst/bin/clang -v --target=arm-linux-gnueabihf --sysroot=/home/osboxes/Desktop/raspbian-sdk/sysroot -isysroot /home/osboxes/Desktop/raspbian-sdk/sysroot --gcc-toolchain=/home/osboxes/Desktop/raspbian-sdk/prebuilt-inst/bin -fcsi -emit-llvm -c main.cpp -o main.o

/home/osboxes/Desktop/raspbian-sdk/prebuilt-inst/bin/clang -v --target=arm-linux-gnueabihf --sysroot=/home/osboxes/Desktop/raspbian-sdk/sysroot -isysroot /home/osboxes/Desktop/raspbian-sdk/sysroot --gcc-toolchain=/home/osboxes/Desktop/raspbian-sdk/prebuilt-inst/bin -I/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/include/c++/6 -I/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/include/arm-linux-gnueabihf/c++/6 -fcsi -emit-llvm -c main.cpp -o main.o 

osboxes@osboxes:~/Desktop/raspbian-sdk/prebuilt-inst/csi/example$ /home/osboxes/Desktop/raspbian-sdk/prebuilt-inst/bin/clang -v --target=arm-linux-gnueabihf --sysroot=/home/osboxes/Desktop/raspbian-sdk/sysroot -isysroot /home/osboxes/Desktop/raspbian-sdk/sysroot --gcc-toolchain=/home/osboxes/Desktop/raspbian-sdk/prebuilt-inst/bin -I/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/include/c++/6 -I/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/include/arm-linux-gnueabihf/c++/6 -L/home/osboxes/Desktop/raspbian-sdk/sysroot/usr/lib/gcc/arm-linux-gnueabihf/6 -fuse-ld=gold -flto main.o /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/libclang_rt.builtins.a -o main


osboxes@osboxes:~/Desktop/raspbian-sdk/prebuilt-inst/csi/example$ cat ~/Desktop/raspbian-sdk/prebuilt-inst/bin/arm-linux-gnueabihf-clang 
#!/bin/bash
BASE=$(dirname $0)
SYSROOT="${BASE}/../../sysroot"
TARGET=arm-linux-gnueabihf
COMPILER_PATH="${SYSROOT}/usr/lib/gcc/${TARGET}/6"
exec env COMPILER_PATH="${COMPILER_PATH}" \
     "${BASE}/clang" --target=${TARGET} \
                     --sysroot="${SYSROOT}" \
                     -isysroot "${SYSROOT}" \
                     -L"${COMPILER_PATH}" \
                     --gcc-toolchain="${BASE}" \
                     "$@"

for some reason: only one core is up on rpi3

qemu-user-static to build and chroot and compile? will this work? try on ubuntu.

http://sentryytech.blogspot.com/2013/02/faster-compiling-on-emulated-raspberry.html

NAVIO original image can turn up 4 cores. use that later?


[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/MIRPrinter.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/MIRPrintingPass.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/OptimizePHIs.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ParallelCG.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PeepholeOptimizer.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PHIElimination.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PHIEliminationUtils.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PostRAHazardRecognizer.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PostRASchedulerList.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PreISelIntrinsicLowering.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ProcessImplicitDefs.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PrologEpilogInserter.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/PseudoSourceValue.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegAllocBase.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegAllocBasic.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegAllocFast.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegAllocGreedy.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegAllocPBQP.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegisterClassInfo.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegisterCoalescer.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegisterPressure.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegisterScavenging.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RenameIndependentSubregs.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegisterUsageInfo.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegUsageInfoCollector.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/RegUsageInfoPropagate.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SafeStack.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SafeStackColoring.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SafeStackLayout.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ScheduleDAG.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ScheduleDAGInstrs.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ScheduleDAGPrinter.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ScoreboardHazardRecognizer.cpp.o
[ 11%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ShadowStackGCLowering.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ShrinkWrap.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SjLjEHPrepare.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SlotIndexes.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SpillPlacement.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/SplitKit.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/StackColoring.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/StackMapLivenessAnalysis.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/StackMaps.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/StackProtector.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/StackSlotColoring.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TailDuplication.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TailDuplicator.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetFrameLoweringImpl.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetInstrInfo.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetLoweringBase.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetLoweringObjectFileImpl.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetOptionsImpl.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetPassConfig.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetRegisterInfo.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetSchedule.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TwoAddressInstructionPass.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/UnreachableBlockElim.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/VirtRegMap.cpp.o
[ 13%] Building CXX object lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/WinEHPrepare.cpp.o
/home/pi/llvm/lib/CodeGen/WinEHPrepare.cpp:1017:6: warning: ‘void {anonymous}::WinEHPrepare::verifyPreparedFunclets(llvm::Function&)’ defined but not used [-Wunused-function]
 void WinEHPrepare::verifyPreparedFunclets(Function &F) {
      ^~~~~~~~~~~~
[ 13%] Linking CXX static library ../libLLVMCodeGen.a
[ 13%] Built target LLVMCodeGen
Scanning dependencies of target LLVMSelectionDAG
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/DAGCombiner.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/FastISel.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/FunctionLoweringInfo.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/InstrEmitter.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeDAG.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeFloatTypes.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeIntegerTypes.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeTypes.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeTypesGeneric.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeVectorOps.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/LegalizeVectorTypes.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/ResourcePriorityQueue.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/ScheduleDAGFast.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/ScheduleDAGRRList.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/ScheduleDAGSDNodes.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/ScheduleDAGVLIW.cpp.o
[ 13%] Building CXX object lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/SelectionDAGBuilder.cpp.o
In file included from /usr/include/c++/6/bits/stl_algo.h:61:0,
                 from /usr/include/c++/6/algorithm:62,
                 from /home/pi/llvm/include/llvm/ADT/StringRef.h:15,
                 from /home/pi/llvm/include/llvm/ADT/StringMap.h:17,
                 from /home/pi/llvm/include/llvm/Support/Host.h:17,
                 from /home/pi/llvm/include/llvm/ADT/Hashing.h:49,
                 from /home/pi/llvm/include/llvm/ADT/ArrayRef.h:13,
                 from /home/pi/llvm/include/llvm/ADT/DenseMapInfo.h:17,
                 from /home/pi/llvm/include/llvm/ADT/DenseMap.h:17,
                 from /home/pi/llvm/lib/CodeGen/SelectionDAG/StatepointLowering.h:18,
                 from /home/pi/llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.h:17,
                 from /home/pi/llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.cpp:14:
/usr/include/c++/6/bits/stl_heap.h: In function ‘void std::__adjust_heap(_RandomAccessIterator, _Distance, _Distance, _Tp, _Compare) [with _RandomAccessIterator = __gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >; _Distance = int; _Tp = llvm::SelectionDAGBuilder::CaseBits; _Compare = __gnu_cxx::__ops::_Iter_comp_iter<llvm::SelectionDAGBuilder::buildBitTests(llvm::SelectionDAGBuilder::CaseClusterVector&, unsigned int, unsigned int, const llvm::SwitchInst*, llvm::SelectionDAGBuilder::CaseCluster&)::<lambda(const llvm::SelectionDAGBuilder::CaseBits&, const llvm::SelectionDAGBuilder::CaseBits&)> >]’:
/usr/include/c++/6/bits/stl_heap.h:209:5: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
     __adjust_heap(_RandomAccessIterator __first, _Distance __holeIndex,
     ^~~~~~~~~~~~~
In file included from /usr/include/c++/6/algorithm:62:0,
                 from /home/pi/llvm/include/llvm/ADT/StringRef.h:15,
                 from /home/pi/llvm/include/llvm/ADT/StringMap.h:17,
                 from /home/pi/llvm/include/llvm/Support/Host.h:17,
                 from /home/pi/llvm/include/llvm/ADT/Hashing.h:49,
                 from /home/pi/llvm/include/llvm/ADT/ArrayRef.h:13,
                 from /home/pi/llvm/include/llvm/ADT/DenseMapInfo.h:17,
                 from /home/pi/llvm/include/llvm/ADT/DenseMap.h:17,
                 from /home/pi/llvm/lib/CodeGen/SelectionDAG/StatepointLowering.h:18,
                 from /home/pi/llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.h:17,
                 from /home/pi/llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.cpp:14:
/usr/include/c++/6/bits/stl_algo.h: In function ‘void std::__introsort_loop(_RandomAccessIterator, _RandomAccessIterator, _Size, _Compare) [with _RandomAccessIterator = __gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >; _Size = int; _Compare = __gnu_cxx::__ops::_Iter_comp_iter<llvm::SelectionDAGBuilder::buildBitTests(llvm::SelectionDAGBuilder::CaseClusterVector&, unsigned int, unsigned int, const llvm::SwitchInst*, llvm::SelectionDAGBuilder::CaseCluster&)::<lambda(const llvm::SelectionDAGBuilder::CaseBits&, const llvm::SelectionDAGBuilder::CaseBits&)> >]’:
/usr/include/c++/6/bits/stl_algo.h:1937:5: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
     __introsort_loop(_RandomAccessIterator __first,
     ^~~~~~~~~~~~~~~~
/usr/include/c++/6/bits/stl_algo.h:1937:5: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
/usr/include/c++/6/bits/stl_algo.h:1937:5: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
/usr/include/c++/6/bits/stl_algo.h:1951:4: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
    std::__introsort_loop(__cut, __last, __depth_limit, __comp);
    ^~~
/usr/include/c++/6/bits/stl_algo.h: In function ‘void std::__insertion_sort(_RandomAccessIterator, _RandomAccessIterator, _Compare) [with _RandomAccessIterator = __gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >; _Compare = __gnu_cxx::__ops::_Iter_comp_iter<llvm::SelectionDAGBuilder::buildBitTests(llvm::SelectionDAGBuilder::CaseClusterVector&, unsigned int, unsigned int, const llvm::SwitchInst*, llvm::SelectionDAGBuilder::CaseCluster&)::<lambda(const llvm::SelectionDAGBuilder::CaseBits&, const llvm::SelectionDAGBuilder::CaseBits&)> >]’:
/usr/include/c++/6/bits/stl_algo.h:1837:5: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
     __insertion_sort(_RandomAccessIterator __first,
     ^~~~~~~~~~~~~~~~
/usr/include/c++/6/bits/stl_algo.h:1837:5: note: parameter passing for argument of type ‘__gnu_cxx::__normal_iterator<llvm::SelectionDAGBuilder::CaseBits*, std::vector<llvm::SelectionDAGBuilder::CaseBits> >’ will change in GCC 7.1
virtual memory exhausted: Cannot allocate memory
lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/build.make:446: recipe for target 'lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/SelectionDAGBuilder.cpp.o' failed
make[2]: *** [lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/SelectionDAGBuilder.cpp.o] Error 1
CMakeFiles/Makefile2:1033: recipe for target 'lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/all' failed
make[1]: *** [lib/CodeGen/SelectionDAG/CMakeFiles/LLVMSelectionDAG.dir/all] Error 2
Makefile:149: recipe for target 'all' failed
make: *** [all] Error 2


reason for qemu fail: virtual memory exhausted: Cannot allocate memory

solution? try another armhf distribution? 

qemu failed by rpi3 still working, now 73 percents


Breakpoint 1, (anonymous namespace)::report () at code-coverage.cpp:14
14	    uint64_t num_covered = bitset->count();
(gdb) n
15	    printf("Code coverage summary:\n");
(gdb) info locals
num_covered = 4
(gdb) p total_num_basic_blocks
$1 = 6
(gdb) p (float)num_covered
$2 = 4
(gdb) p (float)num_covered/total_num_basic_blocks
$3 = 0.666666627
(gdb) p ((float)num_covered/total_num_basic_blocks)*100
$4 = 66.6666565


Environment Variables
Some environment variables also affect the behavior of the configure command. By default, the configure command tries to determine a suitable C and C++ compiler from the PATH environment variable. You can override the compilers used by setting the CC and CXX environment variables. Other environment variables can be used to add additional preprocessor flags, compiler flags, linker flags, and the installation prefix.

CC

Set the C compiler that will be used instead of the platform default, e.g., CC=/usr/bin/gcc-4.8.1. Note that this environment variable is not applicable when building using Visual Studio on Windows; To select from multiple visual studio compilers installed on the system, use the --msvc_version option instead.

CXX

Set the C++ compiler that will be used instead of the platform default, e.g., CXX=/usr/bin/g++-4.8.1. Note that this environment variable is not applicable when building using Visual Studio on Windows; To select from multiple visual studio compilers installed on the system, use the --msvc_version option instead.

AR

Set the archive-maintaining program.

CFLAGS

Set extra C compiler options, e.g., “-O3”.

CXXFLAGS

Set extra C++ compiler options, e.g., “-O3”.

CPPFLAGS

Set extra preprocessor options, e.g., “-DFOO=bar”.

LINKFLAGS or LDFLAGS

Set extra linker options, e.g., “-L/usr/local -lsome-library”.

PREFIX

Set the installation prefix to use, if --prefix option is not specified. This is the directory where the install command will install the headers and built libraries.

Successful execution of the configure command creates a build output sub-directory, named ‘build’ by default (can be set using the -o option), that will contain any future build artifacts.


change CC and CXX through env params.
change linker through symbolic link to ld.gold.

i believe in cross compile! https://llvm.org/docs/HowToCrossCompileLLVM.html

In this use case, we’ll be using CMake and Ninja, on a Debian-based Linux system, cross-compiling from an x86_64 host (most Intel and AMD chips nowadays) to a hard-float ARM target (most ARM targets nowadays).

The packages you’ll need are:

cmake
ninja-build (from backports in Ubuntu)
gcc-4.7-arm-linux-gnueabihf
gcc-4.7-multilib-arm-linux-gnueabihf
binutils-arm-linux-gnueabihf
libgcc1-armhf-cross
libsfgcc1-armhf-cross
libstdc++6-armhf-cross
libstdc++6-4.7-dev-armhf-cross

For more information on how to configure CMake for LLVM/Clang, see Building LLVM with CMake.

The CMake options you need to add are:

-DCMAKE_CROSSCOMPILING=True
-DCMAKE_INSTALL_PREFIX=/home/osboxes/Desktop/llvm/install
-DLLVM_TABLEGEN=/home/osboxes/Desktop/llvm/build/bin/llvm-tblgen
-DCLANG_TABLEGEN=/home/osboxes/Desktop/llvm/build/bin/clang-tblgen
-DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf
-DLLVM_TARGET_ARCH=ARM
-DLLVM_TARGETS_TO_BUILD=ARM

However, if you’re using Clang, the driver might not be up-to-date with your specific Linux distribution, version or GCC layout, so you’ll need to fudge.

In addition to the ones above, you’ll also need:

'-target arm-linux-gnueabihf' or whatever is the triple of your cross GCC.
'--sysroot=/usr/arm-linux-gnueabihf', '--sysroot=/opt/gcc/arm-linux-gnueabihf' or whatever is the location of your GCC’s sysroot (where /lib, /bin etc are).
Appropriate use of -I and -L, depending on how the cross GCC is installed, and where are the libraries and headers.
The TableGen options are required to compile it with the host compiler, so you’ll need to compile LLVM (or at least llvm-tblgen) to your host platform before you start. The CXX flags define the target, cpu (which in this case defaults to fpu=VFP3 with NEON), and forcing the hard-float ABI. If you’re using Clang as a cross-compiler, you will also have to set --sysroot to make sure it picks the correct linker.

When using Clang, it’s important that you choose the triple to be identical to the GCC triple and the sysroot. This will make it easier for Clang to find the correct tools and include headers. But that won’t mean all headers and libraries will be found. You’ll still need to use -I and -L to locate those extra ones, depending on your distribution.

Most of the time, what you want is to have a native compiler to the platform itself, but not others. So there’s rarely a point in compiling all back-ends. For that reason, you should also set the TARGETS_TO_BUILD to only build the back-end you’re targeting to.

You must set the CMAKE_INSTALL_PREFIX, otherwise a ninja install will copy ARM binaries to your root filesystem, which is not what you want.

Hacks
There are some bugs in current LLVM, which require some fiddling before running CMake:

If you’re using Clang as the cross-compiler, there is a problem in the LLVM ARM back-end that is producing absolute relocations on position-independent code (R_ARM_THM_MOVW_ABS_NC), so for now, you should disable PIC:

-DLLVM_ENABLE_PIC=False
This is not a problem, since Clang/LLVM libraries are statically linked anyway, it shouldn’t affect much.





  571  export PATH=/home/pi/llvm/build/bin:$PATH
  572  CC=clang CXX=clang++ configure --board=navio2
  567  waf --targets bin/arducopter -v


cross compile:
CC=clang CXX=clang++ CXXFLAGS="--sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6" waf configure --board=navio2 -v

what i want: 
alias waf="$PWD/modules/waf/waf-light"
export PATH=/home/osboxes/Desktop/llvm/build/bin:$PATH / export PATH=/home/pi/llvm/build/bin:$PATH
osboxes@osboxes:~/Desktop/ardupilot$ 
CC=clang CXX=clang++ CXXFLAGS="--sysroot=/media/rpi --gcc-toolchain=/usr" waf configure --board=navio2 -v / CC=clang CXX=clang++ CXXFLAGS="--sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6" waf configure --board=navio2 -v


sudo mount -o loop,offset=40894464 rpi3_optee_navio_41495.img /media/rpi/


waf --targets bin/arducopter -v

build commands:
cat build/navio2/compile_commands.json

./Tools/ardupilotwaf/cxx_checks.py:144:        msg='Checking for need to link with librt',
./Tools/ardupilotwaf/boards.py:458:        cfg.check_librt(env)


"directory": "/home/osboxes/Desktop/ardupilot/build/navio2", 

"command": "clang++ -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-codmpare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6 -MMD --target=arm-linux-gnueabihf -B/usr/bin -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing '-DSKETCHBOOK=\"/home/osboxes/Desktop/ardupilot\"' -DCONFIG_HAL_BOARD=HAL_BOARD_LINUX -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2 ../../libraries/AP_BoardConfig/canbus.cpp -c -olibraries/AP_BoardConfig/canbus.cpp.0.o", 
"file": "../../libraries/AP_BoardConfig/canbus.cpp"

cat build/navio2/compile_commands.json | grep file
    "file": "../../libraries/AP_NavEKF2/AP_NavEKF2_MagFusion.cpp"
    "file": "../../libraries/AP_OSD/AP_OSD_MAX7456.cpp"
    "file": "../../libraries/AP_BoardConfig/canbus_driver.cpp"
    "file": "../../ArduCopter/inertia.cpp"
    ...


I want:

clang++ -std=gnu++11 -fcsi -emit-llvm -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6 -MMD --target=arm-linux-gnueabihf -B/usr/bin -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing '-DSKETCHBOOK=\"/home/osboxes/Desktop/ardupilot\"' -DCONFIG_HAL_BOARD=HAL_BOARD_LINUX -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2 ../../libraries/AP_BoardConfig/canbus.cpp -c -olibraries/AP_BoardConfig/canbus.cpp.0.o

2 ways:
1. use waf build and add -fcsi -emit-llvm, but need to get around tests (vim wscript)
2. use python to write script which take file name and replace -c xxxx.cpp and xxxx.o to generate all .o files

after that, use ld.gold to link them.

1. 
cat build/config.log

git revert:
osboxes@osboxes:~/Desktop/ardupilot$ git checkout -- Tools/ardupilotwaf/boards.py
osboxes@osboxes:~/Desktop/ardupilot$ git checkout -- ./wscript

link command:
18:17:17 runner ['clang++', '-Wl,--gc-sections', '-pthread', '--target=arm-linux-gnueabihf', '--gcc-toolchain=/usr', '--sysroot=/', '-B/usr/bin', 'ArduCopter/AP_Arming.cpp.22.o', 'ArduCopter/AP_Rally.cpp.22.o', 'ArduCopter/AP_State.cpp.22.o', 'ArduCopter/ArduCopter.cpp.22.o', 'ArduCopter/Attitude.cpp.22.o', 'ArduCopter/Copter.cpp.22.o', 'ArduCopter/GCS_Mavlink.cpp.22.o', 'ArduCopter/Log.cpp.22.o', 'ArduCopter/Parameters.cpp.22.o', 'ArduCopter/UserCode.cpp.22.o', 'ArduCopter/afs_copter.cpp.22.o', 'ArduCopter/autoyaw.cpp.22.o', 'ArduCopter/avoidance_adsb.cpp.22.o', 'ArduCopter/baro_ground_effect.cpp.22.o', 'ArduCopter/capabilities.cpp.22.o', 'ArduCopter/commands.cpp.22.o', 'ArduCopter/compassmot.cpp.22.o', 'ArduCopter/crash_check.cpp.22.o', 'ArduCopter/ekf_check.cpp.22.o', 'ArduCopter/esc_calibration.cpp.22.o', 'ArduCopter/events.cpp.22.o', 'ArduCopter/failsafe.cpp.22.o', 'ArduCopter/fence.cpp.22.o', 'ArduCopter/heli.cpp.22.o', 'ArduCopter/inertia.cpp.22.o', 'ArduCopter/land_detector.cpp.22.o', 'ArduCopter/landing_gear.cpp.22.o', 'ArduCopter/leds.cpp.22.o', 'ArduCopter/mode.cpp.22.o', 'ArduCopter/mode_acro.cpp.22.o', 'ArduCopter/mode_acro_heli.cpp.22.o', 'ArduCopter/mode_althold.cpp.22.o', 'ArduCopter/mode_auto.cpp.22.o', 'ArduCopter/mode_autotune.cpp.22.o', 'ArduCopter/mode_avoid_adsb.cpp.22.o', 'ArduCopter/mode_brake.cpp.22.o', 'ArduCopter/mode_circle.cpp.22.o', 'ArduCopter/mode_drift.cpp.22.o', 'ArduCopter/mode_flip.cpp.22.o', 'ArduCopter/mode_flowhold.cpp.22.o', 'ArduCopter/mode_follow.cpp.22.o', 'ArduCopter/mode_guided.cpp.22.o', 'ArduCopter/mode_guided_nogps.cpp.22.o', 'ArduCopter/mode_land.cpp.22.o', 'ArduCopter/mode_loiter.cpp.22.o', 'ArduCopter/mode_poshold.cpp.22.o', 'ArduCopter/mode_rtl.cpp.22.o', 'ArduCopter/mode_smart_rtl.cpp.22.o', 'ArduCopter/mode_sport.cpp.22.o', 'ArduCopter/mode_stabilize.cpp.22.o', 'ArduCopter/mode_stabilize_heli.cpp.22.o', 'ArduCopter/mode_throw.cpp.22.o', 'ArduCopter/motor_test.cpp.22.o', 'ArduCopter/motors.cpp.22.o', 'ArduCopter/navigation.cpp.22.o', 'ArduCopter/position_vector.cpp.22.o', 'ArduCopter/precision_landing.cpp.22.o', 'ArduCopter/radio.cpp.22.o', 'ArduCopter/sensors.cpp.22.o', 'ArduCopter/setup.cpp.22.o', 'ArduCopter/switches.cpp.22.o', 'ArduCopter/system.cpp.22.o', 'ArduCopter/takeoff.cpp.22.o', 'ArduCopter/terrain.cpp.22.o', 'ArduCopter/toy_mode.cpp.22.o', 'ArduCopter/tuning.cpp.22.o', 'ArduCopter/version.cpp.22.o', '-obin/arducopter', '-Wl,-Bstatic', '-Llib', '-lArduCopter_libs', '-Wl,-Bdynamic', '-lm', '-ldl']

add new cxx flags in _cache.py in c4che!

... 
12:12:14 runner ['clang++', '-std=gnu++11', '-fcsi', '-emit-llvm', '-fdata-sections', '-ffunction-sections', '-fno-exceptions', '-fsigned-char', '-Wall', '-Wextra', '-Wformat', '-Wshadow', '-Wpointer-arith', '-Wcast-align', '-Wundef', '-Wno-unused-parameter', '-Wno-missing-field-initializers', '-Wno-reorder', '-Wno-redundant-decls', '-Wno-unknown-pragmas', '-Werror=format-security', '-Werror=array-bounds', '-Werror=uninitialized', '-Werror=init-self', '-Werror=switch', '-Werror=sign-compare', '-Wfatal-errors', '-Wno-trigraphs', '-fcolor-diagnostics', '-Wno-gnu-designator', '-Wno-inconsistent-missing-override', '-Wno-mismatched-tags', '-Wno-gnu-variable-sized-type-not-at-end', '-Wno-c++11-narrowing', '-O3', '--sysroot=/media/rpi', '--gcc-toolchain=/media/rpi/usr', '-I/media/rpi/usr/include/arm-linux-gnueabihf', '-I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6', '-MMD', '--target=arm-linux-gnueabihf', '--gcc-toolchain=/usr', '--sysroot=/', '-B/usr/bin', '-include', 'ap_config.h', '-Ilibraries', '-Ilibraries/GCS_MAVLink', '-I.', '-I../../libraries', '-I../../libraries/AP_Common/missing', '-DSKETCHBOOK="/home/osboxes/Desktop/ardupilot"', '-DCONFIG_HAL_BOARD=HAL_BOARD_LINUX', '-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2', '-DFRAME_CONFIG=MULTICOPTER_FRAME', '-DAPM_BUILD_DIRECTORY=APM_BUILD_ArduCopter', '-DSKETCH="ArduCopter"', '-DSKETCHNAME="ArduCopter"', '../../ArduCopter/version.cpp', '-c', '-oArduCopter/version.cpp.22.o']

12:12:14 runner ['/usr/bin/arm-linux-gnueabihf-ar', 'rcs', 'lib/libArduCopter_libs.a', 'libraries/AP_AccelCal/AccelCalibrator.cpp.0.o', 'libraries/AP_AccelCal/AP_AccelCal.cpp.4.o', 'libraries/AP_ADC/AP_ADC_ADS1115.cpp.0.o', 'libraries/AP_AHRS/AP_AHRS_DCM.cpp.0.o', 'libraries/AP_AHRS/AP_AHRS_NavEKF.cpp.0.o', 'libraries/AP_AHRS/AP_AHRS_View.cpp.0.o' ...

new linker command:
$(LLVM_BUILDDIR)/bin/clang++ -g -O0 -fuse-ld=gold -flto main.o ../toolkit/code-coverage.o $(CSI_RTLIBDIR)/libclang_rt.csi-armhf.a -o $@
$(CXX) $(CXXFLAGS) $(LDFLAGS) main.o $(TOOL_OBJ) $(CSI_RTLIBA) -o $@


The one to change:
[530/530] Linking build/navio2/bin/arducopter
17:03:37 runner ['clang++', '-Wl,--gc-sections', '-pthread', '--target=arm-linux-gnueabihf', '--gcc-toolchain=/usr', '--sysroot=/', '-B/usr/bin', 'ArduCopter/AP_Arming.cpp.22.o', 'ArduCopter/AP_Rally.cpp.22.o', 'ArduCopter/AP_State.cpp.22.o', 'ArduCopter/ArduCopter.cpp.22.o', 'ArduCopter/Attitude.cpp.22.o', 'ArduCopter/Copter.cpp.22.o', 'ArduCopter/GCS_Mavlink.cpp.22.o', 'ArduCopter/Log.cpp.22.o', 'ArduCopter/Parameters.cpp.22.o', 'ArduCopter/UserCode.cpp.22.o', 'ArduCopter/afs_copter.cpp.22.o', 'ArduCopter/autoyaw.cpp.22.o', 'ArduCopter/avoidance_adsb.cpp.22.o', 'ArduCopter/baro_ground_effect.cpp.22.o', 'ArduCopter/capabilities.cpp.22.o', 'ArduCopter/commands.cpp.22.o', 'ArduCopter/compassmot.cpp.22.o', 'ArduCopter/crash_check.cpp.22.o', 'ArduCopter/ekf_check.cpp.22.o', 'ArduCopter/esc_calibration.cpp.22.o', 'ArduCopter/events.cpp.22.o', 'ArduCopter/failsafe.cpp.22.o', 'ArduCopter/fence.cpp.22.o', 'ArduCopter/heli.cpp.22.o', 'ArduCopter/inertia.cpp.22.o', 'ArduCopter/land_detector.cpp.22.o', 'ArduCopter/landing_gear.cpp.22.o', 'ArduCopter/leds.cpp.22.o', 'ArduCopter/mode.cpp.22.o', 'ArduCopter/mode_acro.cpp.22.o', 'ArduCopter/mode_acro_heli.cpp.22.o', 'ArduCopter/mode_althold.cpp.22.o', 'ArduCopter/mode_auto.cpp.22.o', 'ArduCopter/mode_autotune.cpp.22.o', 'ArduCopter/mode_avoid_adsb.cpp.22.o', 'ArduCopter/mode_brake.cpp.22.o', 'ArduCopter/mode_circle.cpp.22.o', 'ArduCopter/mode_drift.cpp.22.o', 'ArduCopter/mode_flip.cpp.22.o', 'ArduCopter/mode_flowhold.cpp.22.o', 'ArduCopter/mode_follow.cpp.22.o', 'ArduCopter/mode_guided.cpp.22.o', 'ArduCopter/mode_guided_nogps.cpp.22.o', 'ArduCopter/mode_land.cpp.22.o', 'ArduCopter/mode_loiter.cpp.22.o', 'ArduCopter/mode_poshold.cpp.22.o', 'ArduCopter/mode_rtl.cpp.22.o', 'ArduCopter/mode_smart_rtl.cpp.22.o', 'ArduCopter/mode_sport.cpp.22.o', 'ArduCopter/mode_stabilize.cpp.22.o', 'ArduCopter/mode_stabilize_heli.cpp.22.o', 'ArduCopter/mode_throw.cpp.22.o', 'ArduCopter/motor_test.cpp.22.o', 'ArduCopter/motors.cpp.22.o', 'ArduCopter/navigation.cpp.22.o', 'ArduCopter/position_vector.cpp.22.o', 'ArduCopter/precision_landing.cpp.22.o', 'ArduCopter/radio.cpp.22.o', 'ArduCopter/sensors.cpp.22.o', 'ArduCopter/setup.cpp.22.o', 'ArduCopter/switches.cpp.22.o', 'ArduCopter/system.cpp.22.o', 'ArduCopter/takeoff.cpp.22.o', 'ArduCopter/terrain.cpp.22.o', 'ArduCopter/toy_mode.cpp.22.o', 'ArduCopter/tuning.cpp.22.o', 'ArduCopter/version.cpp.22.o', '-obin/arducopter', '-Wl,-Bstatic', '-Llib', '-lArduCopter_libs', '-Wl,-Bdynamic', '-lm', '-ldl']
ArduCopter/AP_Arming.cpp.22.o: file not recognized: File format not recognized
clang-3.9: error: linker command failed with exit code 1 (use -v to see invocation)

Waf: Leaving directory `/home/pi/ardupilot/build/navio2'
Build failed
 -> task in 'bin/arducopter' failed (exit status 1): 
	{task 1983460376: cxxprogram AP_Arming.cpp.22.o,AP_Rally.cpp.22.o,AP_State.cpp.22.o,ArduCopter.cpp.22.o,Attitude.cpp.22.o,Copter.cpp.22.o,GCS_Mavlink.cpp.22.o,Log.cpp.22.o,Parameters.cpp.22.o,UserCode.cpp.22.o,afs_copter.cpp.22.o,autoyaw.cpp.22.o,avoidance_adsb.cpp.22.o,baro_ground_effect.cpp.22.o,capabilities.cpp.22.o,commands.cpp.22.o,compassmot.cpp.22.o,crash_check.cpp.22.o,ekf_check.cpp.22.o,esc_calibration.cpp.22.o,events.cpp.22.o,failsafe.cpp.22.o,fence.cpp.22.o,heli.cpp.22.o,inertia.cpp.22.o,land_detector.cpp.22.o,landing_gear.cpp.22.o,leds.cpp.22.o,mode.cpp.22.o,mode_acro.cpp.22.o,mode_acro_heli.cpp.22.o,mode_althold.cpp.22.o,mode_auto.cpp.22.o,mode_autotune.cpp.22.o,mode_avoid_adsb.cpp.22.o,mode_brake.cpp.22.o,mode_circle.cpp.22.o,mode_drift.cpp.22.o,mode_flip.cpp.22.o,mode_flowhold.cpp.22.o,mode_follow.cpp.22.o,mode_guided.cpp.22.o,mode_guided_nogps.cpp.22.o,mode_land.cpp.22.o,mode_loiter.cpp.22.o,mode_poshold.cpp.22.o,mode_rtl.cpp.22.o,mode_smart_rtl.cpp.22.o,mode_sport.cpp.22.o,mode_stabilize.cpp.22.o,mode_stabilize_heli.cpp.22.o,mode_throw.cpp.22.o,motor_test.cpp.22.o,motors.cpp.22.o,navigation.cpp.22.o,position_vector.cpp.22.o,precision_landing.cpp.22.o,radio.cpp.22.o,sensors.cpp.22.o,setup.cpp.22.o,switches.cpp.22.o,system.cpp.22.o,takeoff.cpp.22.o,terrain.cpp.22.o,toy_mode.cpp.22.o,tuning.cpp.22.o,version.cpp.22.o -> arducopter}
clang++ -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --gcc-toolchain=/usr --sysroot=/ -B/usr/bin ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o -obin/arducopter -Wl,-Bstatic -Llib -lArduCopter_libs -Wl,-Bdynamic -lm -ldl


only fail at linker, add our instrumentation objects with it!
clang++ -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/ --gcc-toolchain=/usr -B/usr/bin /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o -obin/arducopter -Wl,-Bstatic -Llib -lArduCopter_libs -Wl,-Bdynamic -lm -ldl

above not working


1852
clang++ -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/ --gcc-toolchain=/usr -B/usr/bin /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o libraries/AP_AccelCal/AccelCalibrator.cpp.0.o libraries/AP_AccelCal/AP_AccelCal.cpp.4.o libraries/AP_ADC/AP_ADC_ADS1115.cpp.0.o libraries/AP_AHRS/AP_AHRS_DCM.cpp.0.o libraries/AP_AHRS/AP_AHRS_NavEKF.cpp.0.o libraries/AP_AHRS/AP_AHRS_View.cpp.0.o libraries/AP_AHRS/AP_AHRS.cpp.4.o libraries/AP_Airspeed/AP_Airspeed.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_Backend.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_MS4525.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_MS5525.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_SDP3X.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_analog.cpp.0.o libraries/AP_Airspeed/Airspeed_Calibration.cpp.0.o libraries/AP_Baro/AP_Baro_BMP085.cpp.0.o libraries/AP_Baro/AP_Baro_BMP280.cpp.0.o libraries/AP_Baro/AP_Baro_Backend.cpp.0.o libraries/AP_Baro/AP_Baro_DPS280.cpp.0.o libraries/AP_Baro/AP_Baro_FBM320.cpp.0.o libraries/AP_Baro/AP_Baro_HIL.cpp.0.o libraries/AP_Baro/AP_Baro_ICM20789.cpp.0.o libraries/AP_Baro/AP_Baro_KellerLD.cpp.0.o libraries/AP_Baro/AP_Baro_LPS2XH.cpp.0.o libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o libraries/AP_Baro/AP_Baro_UAVCAN.cpp.0.o libraries/AP_Baro/AP_Baro.cpp.4.o libraries/AP_Baro/AP_Baro_SITL.cpp.4.o libraries/AP_BattMonitor/AP_BattMonitor_Analog.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_BLHeliESC.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_Backend.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_Bebop.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus_Maxell.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus_Solo.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_UAVCAN.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor.cpp.4.o libraries/AP_BattMonitor/AP_BattMonitor_Params.cpp.4.o libraries/AP_BoardConfig/AP_BoardConfig.cpp.0.o libraries/AP_BoardConfig/AP_BoardConfig_CAN.cpp.0.o libraries/AP_BoardConfig/board_drivers.cpp.0.o libraries/AP_BoardConfig/canbus.cpp.0.o libraries/AP_BoardConfig/canbus_driver.cpp.0.o libraries/AP_BoardConfig/px4_drivers.cpp.0.o libraries/AP_Common/AP_Common.cpp.0.o libraries/AP_Common/AP_FWVersion.cpp.0.o libraries/AP_Common/Location.cpp.0.o libraries/AP_Common/c++.cpp.0.o libraries/AP_Compass/AP_Compass_AK09916.cpp.0.o libraries/AP_Compass/AP_Compass_AK8963.cpp.0.o libraries/AP_Compass/AP_Compass_BMM150.cpp.0.o libraries/AP_Compass/AP_Compass_Backend.cpp.0.o libraries/AP_Compass/AP_Compass_Calibration.cpp.0.o libraries/AP_Compass/AP_Compass_HIL.cpp.0.o libraries/AP_Compass/AP_Compass_HMC5843.cpp.0.o libraries/AP_Compass/AP_Compass_IST8310.cpp.0.o libraries/AP_Compass/AP_Compass_LIS3MDL.cpp.0.o libraries/AP_Compass/AP_Compass_LSM303D.cpp.0.o libraries/AP_Compass/AP_Compass_LSM9DS1.cpp.0.o libraries/AP_Compass/AP_Compass_MAG3110.cpp.0.o libraries/AP_Compass/AP_Compass_MMC3416.cpp.0.o libraries/AP_Compass/AP_Compass_QMC5883L.cpp.0.o libraries/AP_Compass/AP_Compass_SITL.cpp.0.o libraries/AP_Compass/AP_Compass_UAVCAN.cpp.0.o libraries/AP_Compass/CompassCalibrator.cpp.0.o libraries/AP_Compass/Compass_PerMotor.cpp.0.o libraries/AP_Compass/Compass_learn.cpp.0.o libraries/AP_Compass/AP_Compass.cpp.4.o libraries/AP_Declination/AP_Declination.cpp.0.o libraries/AP_Declination/tables.cpp.0.o libraries/AP_GPS/AP_GPS.cpp.0.o libraries/AP_GPS/AP_GPS_ERB.cpp.0.o libraries/AP_GPS/AP_GPS_GSOF.cpp.0.o libraries/AP_GPS/AP_GPS_MAV.cpp.0.o libraries/AP_GPS/AP_GPS_MTK.cpp.0.o libraries/AP_GPS/AP_GPS_MTK19.cpp.0.o libraries/AP_GPS/AP_GPS_NMEA.cpp.0.o libraries/AP_GPS/AP_GPS_NOVA.cpp.0.o libraries/AP_GPS/AP_GPS_SBF.cpp.0.o libraries/AP_GPS/AP_GPS_SBP.cpp.0.o libraries/AP_GPS/AP_GPS_SBP2.cpp.0.o libraries/AP_GPS/AP_GPS_SIRF.cpp.0.o libraries/AP_GPS/AP_GPS_UAVCAN.cpp.0.o libraries/AP_GPS/AP_GPS_UBLOX.cpp.0.o libraries/AP_GPS/GPS_Backend.cpp.0.o libraries/AP_HAL/Device.cpp.0.o libraries/AP_HAL/HAL.cpp.0.o libraries/AP_HAL/Scheduler.cpp.0.o libraries/AP_HAL/Util.cpp.0.o libraries/AP_HAL/utility/BetterStream.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap_Linux.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap_Nuttx.cpp.0.o libraries/AP_HAL/utility/RingBuffer.cpp.0.o libraries/AP_HAL/utility/Socket.cpp.0.o libraries/AP_HAL/utility/dsm.cpp.0.o libraries/AP_HAL/utility/ftoa_engine.cpp.0.o libraries/AP_HAL/utility/getopt_cpp.cpp.0.o libraries/AP_HAL/utility/print_vprintf.cpp.0.o libraries/AP_HAL/utility/srxl.cpp.0.o libraries/AP_HAL/utility/st24.cpp.0.o libraries/AP_HAL/utility/sumd.cpp.0.o libraries/AP_HAL/utility/utoa_invert.cpp.0.o libraries/AP_HAL_Empty/AnalogIn.cpp.0.o libraries/AP_HAL_Empty/GPIO.cpp.0.o libraries/AP_HAL_Empty/HAL_Empty_Class.cpp.0.o libraries/AP_HAL_Empty/PrivateMember.cpp.0.o libraries/AP_HAL_Empty/RCInput.cpp.0.o libraries/AP_HAL_Empty/RCOutput.cpp.0.o libraries/AP_HAL_Empty/Scheduler.cpp.0.o libraries/AP_HAL_Empty/Semaphores.cpp.0.o libraries/AP_HAL_Empty/Storage.cpp.0.o libraries/AP_HAL_Empty/UARTDriver.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_BMI055.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_BMI160.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Backend.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_HIL.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Invensense.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_L3G4200D.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_LSM9DS0.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_LSM9DS1.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_PX4.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_RST.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Revo.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_SITL.cpp.0.o libraries/AP_InertialSensor/AuxiliaryBus.cpp.0.o libraries/AP_InertialSensor/BatchSampler.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor.cpp.4.o libraries/AP_Math/AP_GeodesicGrid.cpp.0.o libraries/AP_Math/AP_Math.cpp.0.o libraries/AP_Math/crc.cpp.0.o libraries/AP_Math/edc.cpp.0.o libraries/AP_Math/location.cpp.0.o libraries/AP_Math/location_double.cpp.0.o libraries/AP_Math/matrix3.cpp.0.o libraries/AP_Math/matrixN.cpp.0.o libraries/AP_Math/matrix_alg.cpp.0.o libraries/AP_Math/polygon.cpp.0.o libraries/AP_Math/quaternion.cpp.0.o libraries/AP_Math/spline5.cpp.0.o libraries/AP_Math/vector2.cpp.0.o libraries/AP_Math/vector3.cpp.0.o libraries/AP_Mission/AP_Mission.cpp.4.o libraries/AP_NavEKF2/AP_NavEKF2_AirDataFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Control.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_MagFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Measurements.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_OptFlowFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Outputs.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_PosVelFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_RngBcnFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_VehicleStatus.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_core.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF_GyroBias.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2.cpp.4.o libraries/AP_NavEKF3/AP_NavEKF3_AirDataFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Control.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_GyroBias.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_MagFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Measurements.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_OptFlowFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Outputs.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_PosVelFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_RngBcnFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_VehicleStatus.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_core.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3.cpp.4.o libraries/AP_Notify/AP_BoardLED.cpp.0.o libraries/AP_Notify/AP_BoardLED2.cpp.0.o libraries/AP_Notify/AP_Notify.cpp.0.o libraries/AP_Notify/Buzzer.cpp.0.o libraries/AP_Notify/DiscoLED.cpp.0.o libraries/AP_Notify/DiscreteRGBLed.cpp.0.o libraries/AP_Notify/Display.cpp.0.o libraries/AP_Notify/Display_SH1106_I2C.cpp.0.o libraries/AP_Notify/Display_SSD1306_I2C.cpp.0.o libraries/AP_Notify/ExternalLED.cpp.0.o libraries/AP_Notify/Led_Sysfs.cpp.0.o libraries/AP_Notify/MMLPlayer.cpp.0.o libraries/AP_Notify/NCP5623.cpp.0.o libraries/AP_Notify/OreoLED_PX4.cpp.0.o libraries/AP_Notify/PCA9685LED_I2C.cpp.0.o libraries/AP_Notify/PixRacerLED.cpp.0.o libraries/AP_Notify/RCOutputRGBLed.cpp.0.o libraries/AP_Notify/RGBLed.cpp.0.o libraries/AP_Notify/ToneAlarm.cpp.0.o libraries/AP_Notify/ToshibaLED_I2C.cpp.0.o libraries/AP_Notify/UAVCAN_RGB_LED.cpp.0.o libraries/AP_Notify/VRBoard_LED.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_CXOF.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_Onboard.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_PX4Flow.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_Pixart.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_SITL.cpp.0.o libraries/AP_OpticalFlow/OpticalFlow.cpp.0.o libraries/AP_OpticalFlow/OpticalFlow_backend.cpp.0.o libraries/AP_Param/AP_Param.cpp.0.o libraries/AP_Rally/AP_Rally.cpp.4.o libraries/AP_RangeFinder/AP_RangeFinder_BBB_PRU.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Bebop.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Benewake.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LeddarOne.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LightWareI2C.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LightWareSerial.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MAVLink.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MaxsonarI2CXL.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MaxsonarSerialLV.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_NMEA.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_PX4_PWM.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_PulsedLightLRF.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_TeraRangerI2C.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_VL53L0X.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Wasp.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_analog.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_uLanding.cpp.0.o libraries/AP_RangeFinder/RangeFinder.cpp.0.o libraries/AP_RangeFinder/RangeFinder_Backend.cpp.0.o libraries/AP_Scheduler/PerfInfo.cpp.0.o libraries/AP_Scheduler/AP_Scheduler.cpp.4.o libraries/AP_SerialManager/AP_SerialManager.cpp.0.o libraries/AP_Terrain/AP_Terrain.cpp.0.o libraries/AP_Terrain/TerrainGCS.cpp.0.o libraries/AP_Terrain/TerrainIO.cpp.0.o libraries/AP_Terrain/TerrainMission.cpp.0.o libraries/AP_Terrain/TerrainUtil.cpp.0.o libraries/DataFlash/DFMessageWriter.cpp.0.o libraries/DataFlash/DataFlash.cpp.0.o libraries/DataFlash/DataFlash_Backend.cpp.0.o libraries/DataFlash/DataFlash_File_sd.cpp.0.o libraries/DataFlash/DataFlash_MAVLink.cpp.0.o libraries/DataFlash/DataFlash_MAVLinkLogTransfer.cpp.0.o libraries/DataFlash/DataFlash_Revo.cpp.0.o libraries/DataFlash/LogFile.cpp.0.o libraries/DataFlash/DataFlash_File.cpp.4.o libraries/Filter/DerivativeFilter.cpp.0.o libraries/Filter/LowPassFilter.cpp.0.o libraries/Filter/LowPassFilter2p.cpp.0.o libraries/Filter/NotchFilter.cpp.0.o libraries/GCS_MAVLink/GCS.cpp.0.o libraries/GCS_MAVLink/GCS_Common.cpp.0.o libraries/GCS_MAVLink/GCS_DeviceOp.cpp.0.o libraries/GCS_MAVLink/GCS_MAVLink.cpp.0.o libraries/GCS_MAVLink/GCS_Param.cpp.0.o libraries/GCS_MAVLink/GCS_Rally.cpp.0.o libraries/GCS_MAVLink/GCS_ServoRelay.cpp.0.o libraries/GCS_MAVLink/GCS_Signing.cpp.0.o libraries/GCS_MAVLink/GCS_serial_control.cpp.0.o libraries/GCS_MAVLink/MAVLink_routing.cpp.0.o libraries/RC_Channel/RC_Channel.cpp.0.o libraries/RC_Channel/RC_Channels.cpp.0.o libraries/SRV_Channel/SRV_Channel.cpp.0.o libraries/SRV_Channel/SRV_Channel_aux.cpp.0.o libraries/SRV_Channel/SRV_Channels.cpp.0.o libraries/StorageManager/StorageManager.cpp.0.o libraries/AP_Tuning/AP_Tuning.cpp.0.o libraries/AP_RPM/AP_RPM.cpp.0.o libraries/AP_RPM/RPM_Backend.cpp.0.o libraries/AP_RPM/RPM_PX4_PWM.cpp.0.o libraries/AP_RPM/RPM_Pin.cpp.0.o libraries/AP_RPM/RPM_SITL.cpp.0.o libraries/AP_RSSI/AP_RSSI.cpp.0.o libraries/AP_Mount/AP_Mount.cpp.0.o libraries/AP_Mount/AP_Mount_Alexmos.cpp.0.o libraries/AP_Mount/AP_Mount_Backend.cpp.0.o libraries/AP_Mount/AP_Mount_SToRM32.cpp.0.o libraries/AP_Mount/AP_Mount_SToRM32_serial.cpp.0.o libraries/AP_Mount/AP_Mount_Servo.cpp.0.o libraries/AP_Mount/AP_Mount_SoloGimbal.cpp.0.o libraries/AP_Mount/SoloGimbal.cpp.0.o libraries/AP_Mount/SoloGimbalEKF.cpp.0.o libraries/AP_Mount/SoloGimbal_Parameters.cpp.0.o libraries/AP_Module/AP_Module.cpp.0.o libraries/AP_Button/AP_Button.cpp.0.o libraries/AP_ICEngine/AP_ICEngine.cpp.0.o libraries/AP_Frsky_Telem/AP_Frsky_Telem.cpp.0.o libraries/AP_FlashStorage/AP_FlashStorage.cpp.0.o libraries/AP_Relay/AP_Relay.cpp.0.o libraries/AP_ServoRelayEvents/AP_ServoRelayEvents.cpp.0.o libraries/AP_Volz_Protocol/AP_Volz_Protocol.cpp.0.o libraries/AP_SBusOut/AP_SBusOut.cpp.0.o libraries/AP_IOMCU/AP_IOMCU.cpp.0.o libraries/AP_IOMCU/fw_uploader.cpp.0.o libraries/AP_RAMTRON/AP_RAMTRON.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_Backend.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_DSM.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_PPMSum.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SBUS.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SRXL.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_ST24.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SUMD.cpp.0.o libraries/AP_RCProtocol/SoftSerial.cpp.0.o libraries/AP_Radio/AP_Radio.cpp.0.o libraries/AP_Radio/AP_Radio_backend.cpp.0.o libraries/AP_Radio/AP_Radio_cc2500.cpp.0.o libraries/AP_Radio/AP_Radio_cypress.cpp.0.o libraries/AP_Radio/driver_cc2500.cpp.0.o libraries/AP_TempCalibration/AP_TempCalibration.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom_Backend.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom_MAV.cpp.0.o libraries/AP_BLHeli/AP_BLHeli.cpp.4.o libraries/AP_ROMFS/AP_ROMFS.cpp.0.o libraries/AP_ROMFS/tinfgzip.cpp.0.o libraries/AP_ROMFS/tinflate.cpp.0.o libraries/AP_Proximity/AP_Proximity.cpp.0.o libraries/AP_Proximity/AP_Proximity_Backend.cpp.0.o libraries/AP_Proximity/AP_Proximity_LightWareSF40C.cpp.0.o libraries/AP_Proximity/AP_Proximity_MAV.cpp.0.o libraries/AP_Proximity/AP_Proximity_RPLidarA2.cpp.0.o libraries/AP_Proximity/AP_Proximity_RangeFinder.cpp.0.o libraries/AP_Proximity/AP_Proximity_SITL.cpp.0.o libraries/AP_Proximity/AP_Proximity_TeraRangerTower.cpp.0.o libraries/AP_Proximity/AP_Proximity_TeraRangerTowerEvo.cpp.0.o libraries/AP_Gripper/AP_Gripper.cpp.0.o libraries/AP_Gripper/AP_Gripper_Backend.cpp.0.o libraries/AP_Gripper/AP_Gripper_EPM.cpp.0.o libraries/AP_Gripper/AP_Gripper_Servo.cpp.0.o libraries/AP_RTC/AP_RTC.cpp.0.o libraries/AP_ADSB/AP_ADSB.cpp.4.o libraries/AC_AttitudeControl/AC_AttitudeControl_Heli.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl_Multi.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl_Sub.cpp.0.o libraries/AC_AttitudeControl/AC_PosControl_Sub.cpp.0.o libraries/AC_AttitudeControl/ControlMonitor.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl.cpp.4.o libraries/AC_AttitudeControl/AC_PosControl.cpp.4.o libraries/AC_InputManager/AC_InputManager.cpp.0.o libraries/AC_InputManager/AC_InputManager_Heli.cpp.0.o libraries/AC_Fence/AC_Fence.cpp.0.o libraries/AC_Fence/AC_PolyFence_loader.cpp.0.o libraries/AC_Avoidance/AC_Avoid.cpp.4.o libraries/AC_PID/AC_HELI_PID.cpp.0.o libraries/AC_PID/AC_P.cpp.0.o libraries/AC_PID/AC_PID.cpp.0.o libraries/AC_PID/AC_PID_2D.cpp.0.o libraries/AC_PID/AC_PI_2D.cpp.0.o libraries/AC_PrecLand/AC_PrecLand.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_Companion.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_IRLock.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_SITL.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_SITL_Gazebo.cpp.0.o libraries/AC_PrecLand/PosVelEKF.cpp.0.o libraries/AC_Sprayer/AC_Sprayer.cpp.0.o libraries/AC_WPNav/AC_Circle.cpp.0.o libraries/AC_WPNav/AC_Loiter.cpp.0.o libraries/AC_WPNav/AC_WPNav.cpp.0.o libraries/AP_Camera/AP_Camera.cpp.0.o libraries/AP_IRLock/AP_IRLock_I2C.cpp.0.o libraries/AP_IRLock/AP_IRLock_SITL.cpp.0.o libraries/AP_IRLock/IRLock.cpp.0.o libraries/AP_InertialNav/AP_InertialNav_NavEKF.cpp.0.o libraries/AP_LandingGear/AP_LandingGear.cpp.0.o libraries/AP_Menu/AP_Menu.cpp.0.o libraries/AP_Motors/AP_Motors6DOF.cpp.0.o libraries/AP_Motors/AP_MotorsCoax.cpp.0.o libraries/AP_Motors/AP_MotorsHeli.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Dual.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Quad.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_RSC.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Single.cpp.0.o libraries/AP_Motors/AP_MotorsMatrix.cpp.0.o libraries/AP_Motors/AP_MotorsMulticopter.cpp.0.o libraries/AP_Motors/AP_MotorsSingle.cpp.0.o libraries/AP_Motors/AP_MotorsTri.cpp.0.o libraries/AP_Motors/AP_Motors_Class.cpp.0.o libraries/AP_Motors/AP_MotorsTailsitter.cpp.4.o libraries/AP_Parachute/AP_Parachute.cpp.0.o libraries/AP_RCMapper/AP_RCMapper.cpp.0.o libraries/AP_Avoidance/AP_Avoidance.cpp.4.o libraries/AP_AdvancedFailsafe/AP_AdvancedFailsafe.cpp.0.o libraries/AP_SmartRTL/AP_SmartRTL.cpp.0.o libraries/AP_Stats/AP_Stats.cpp.0.o libraries/AP_Beacon/AP_Beacon.cpp.0.o libraries/AP_Beacon/AP_Beacon_Backend.cpp.0.o libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o libraries/AP_Beacon/AP_Beacon_Pozyx.cpp.0.o libraries/AP_Beacon/AP_Beacon_SITL.cpp.0.o libraries/AP_Arming/AP_Arming.cpp.4.o libraries/AP_WheelEncoder/AP_WheelEncoder.cpp.0.o libraries/AP_WheelEncoder/WheelEncoder_Backend.cpp.0.o libraries/AP_WheelEncoder/WheelEncoder_Quadrature.cpp.0.o libraries/AP_Winch/AP_Winch.cpp.0.o libraries/AP_Winch/AP_Winch_Servo.cpp.0.o libraries/AP_Follow/AP_Follow.cpp.0.o libraries/AP_Devo_Telem/AP_Devo_Telem.cpp.0.o libraries/AP_OSD/AP_OSD.cpp.0.o libraries/AP_OSD/AP_OSD_Backend.cpp.0.o libraries/AP_OSD/AP_OSD_MAX7456.cpp.0.o libraries/AP_OSD/AP_OSD_SITL.cpp.0.o libraries/AP_OSD/AP_OSD_Screen.cpp.0.o libraries/AP_OSD/AP_OSD_Setting.cpp.0.o libraries/AP_HAL_Linux/AnalogIn_ADS1115.cpp.0.o libraries/AP_HAL_Linux/AnalogIn_IIO.cpp.0.o libraries/AP_HAL_Linux/AnalogIn_Navio2.cpp.0.o libraries/AP_HAL_Linux/CAN.cpp.0.o libraries/AP_HAL_Linux/CameraSensor.cpp.0.o libraries/AP_HAL_Linux/CameraSensor_Mt9v117.cpp.0.o libraries/AP_HAL_Linux/CameraSensor_Mt9v117_Patches.cpp.0.o libraries/AP_HAL_Linux/ConsoleDevice.cpp.0.o libraries/AP_HAL_Linux/Flow_PX4.cpp.0.o libraries/AP_HAL_Linux/GPIO.cpp.0.o libraries/AP_HAL_Linux/GPIO_Aero.cpp.0.o libraries/AP_HAL_Linux/GPIO_BBB.cpp.0.o libraries/AP_HAL_Linux/GPIO_Bebop.cpp.0.o libraries/AP_HAL_Linux/GPIO_Disco.cpp.0.o libraries/AP_HAL_Linux/GPIO_Edge.cpp.0.o libraries/AP_HAL_Linux/GPIO_Navio.cpp.0.o libraries/AP_HAL_Linux/GPIO_Navio2.cpp.0.o libraries/AP_HAL_Linux/GPIO_RPI.cpp.0.o libraries/AP_HAL_Linux/GPIO_Sysfs.cpp.0.o libraries/AP_HAL_Linux/HAL_Linux_Class.cpp.0.o libraries/AP_HAL_Linux/Heat_Pwm.cpp.0.o libraries/AP_HAL_Linux/I2CDevice.cpp.0.o libraries/AP_HAL_Linux/Led_Sysfs.cpp.0.o libraries/AP_HAL_Linux/OpticalFlow_Onboard.cpp.0.o libraries/AP_HAL_Linux/PWM_Sysfs.cpp.0.o libraries/AP_HAL_Linux/Perf.cpp.0.o libraries/AP_HAL_Linux/Perf_Lttng.cpp.0.o libraries/AP_HAL_Linux/Poller.cpp.0.o libraries/AP_HAL_Linux/PollerThread.cpp.0.o libraries/AP_HAL_Linux/RCInput.cpp.0.o libraries/AP_HAL_Linux/RCInput_115200.cpp.0.o libraries/AP_HAL_Linux/RCInput_AioPRU.cpp.0.o libraries/AP_HAL_Linux/RCInput_Multi.cpp.0.o libraries/AP_HAL_Linux/RCInput_Navio2.cpp.0.o libraries/AP_HAL_Linux/RCInput_PRU.cpp.0.o libraries/AP_HAL_Linux/RCInput_RPI.cpp.0.o libraries/AP_HAL_Linux/RCInput_SBUS.cpp.0.o libraries/AP_HAL_Linux/RCInput_SoloLink.cpp.0.o libraries/AP_HAL_Linux/RCInput_UART.cpp.0.o libraries/AP_HAL_Linux/RCInput_UDP.cpp.0.o libraries/AP_HAL_Linux/RCInput_ZYNQ.cpp.0.o libraries/AP_HAL_Linux/RCOutput_AeroIO.cpp.0.o libraries/AP_HAL_Linux/RCOutput_AioPRU.cpp.0.o libraries/AP_HAL_Linux/RCOutput_Bebop.cpp.0.o libraries/AP_HAL_Linux/RCOutput_Disco.cpp.0.o libraries/AP_HAL_Linux/RCOutput_PCA9685.cpp.0.o libraries/AP_HAL_Linux/RCOutput_PRU.cpp.0.o libraries/AP_HAL_Linux/RCOutput_Sysfs.cpp.0.o libraries/AP_HAL_Linux/RCOutput_ZYNQ.cpp.0.o libraries/AP_HAL_Linux/SPIDevice.cpp.0.o libraries/AP_HAL_Linux/SPIUARTDriver.cpp.0.o libraries/AP_HAL_Linux/Semaphores.cpp.0.o libraries/AP_HAL_Linux/TCPServerDevice.cpp.0.o libraries/AP_HAL_Linux/Thread.cpp.0.o libraries/AP_HAL_Linux/ToneAlarm.cpp.0.o libraries/AP_HAL_Linux/ToneAlarm_Disco.cpp.0.o libraries/AP_HAL_Linux/UARTDevice.cpp.0.o libraries/AP_HAL_Linux/UARTDriver.cpp.0.o libraries/AP_HAL_Linux/UDPDevice.cpp.0.o libraries/AP_HAL_Linux/Util.cpp.0.o libraries/AP_HAL_Linux/Util_RPI.cpp.0.o libraries/AP_HAL_Linux/VideoIn.cpp.0.o libraries/AP_HAL_Linux/sbus.cpp.0.o libraries/AP_HAL_Linux/system.cpp.0.o libraries/AP_HAL_Linux/Scheduler.cpp.4.o libraries/AP_HAL_Linux/Storage.cpp.4.o -obin/arducopter -Wl,-Bstatic -Wl,-Bdynamic -lm -ldl

This works! But it takes way tooo long, let's change it to static lib to save time. this cannot be changed to a static lib, bc all object inside is actually llvm bytecode waiting for lto link time optimization.


Let us change instrumentation printf and see if it show somethings.

Cross compile Process:
1. go to /home/pi/llvm/csi/toolkit at pi and change code-coverage.cpp and make to generate code-coverage.o
（vim llvm/csi/toolkit/code-coverage.cpp then cd llvm/csi/toolkit && make）
2. scp pi@192.168.0.158:/home/pi/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop to get the object file prepared for cross-compile (assume libclang-rt.armhf is already ready)
3. run above linker command at /home/osboxes/Desktop/ardupilot/build/navio2
4. scp /home/osboxes/Desktop/ardupilot/build/navio2/bin/arducopter pi@192.168.0.158:~ to put binary back to pi
5. sudo ./arducopter at pi ~/ to run

if add printf to __csi_init will lead to segmentation fault though

(gdb) info stack
#0  _dl_runtime_resolve_xsavec () at ../sysdeps/x86_64/dl-trampoline.h:130
#1  0x0000000000400cd5 in __csi_init ()
#2  0x00000000004013a3 in __csirt_unit_init (name=0x4015ee "main.cpp", unit_fed_tables=0x403090 <__csi_unit_fed_tables>, callsite_to_func_init=0x400cb0 <__csi_init_callsite_to_function>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:161
#3  0x0000000000400ca5 in csirt.unit_ctor ()
#4  0x000000000040151d in __libc_csu_init ()
#5  0x00007ffff718c7bf in __libc_start_main (main=0x400b00 <main>, argc=1, argv=0x7fffffffde58, init=0x4014d0 <__libc_csu_init>, fini=<optimized out>, rtld_fini=<optimized out>, stack_end=0x7fffffffde48)
    at ../csu/libc-start.c:247
#6  0x0000000000400a29 in _start ()
(gdb) finish
Run till exit from #0  _dl_runtime_resolve_xsavec () at ../sysdeps/x86_64/dl-trampoline.h:130

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7b635d9 in std::ostream::sentry::sentry(std::ostream&) () from /usr/lib/x86_64-linux-gnu/libstdc++.so.6

Summary on changes to waf:
1. add -fcsi -emit-llvm -flto to CXXFLAGS in c4che for compiling llvm bitcode objects
2. use llvm-ar to create .a static lib
3. use  -fuse-ld=gold -flto /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a to link with instrumentation
(*), code-coverage.o(this can be cross compiled also i guess) and libclang_rt.csi-armhf.a(theoretically can be cross compiled but I am good with now) built by rpi toolchain. others can be cross compiled.


5.3.1.   Test secure payload behavior
The TSPD hands control of a Secure-EL1 interrupt to the TSP at the tsp_sel1_intr_entry(). The TSP handles the interrupt while ensuring that the handover agreement described in Section Test secure payload dispatcher behavior is maintained. It updates some statistics by calling tsp_update_sync_sel1_intr_stats(). It then calls tsp_common_int_handler() which.

Checks whether the interrupt is the secure physical timer interrupt. It uses the platform API plat_ic_get_pending_interrupt_id() to get the interrupt number. If it is not the secure physical timer interrupt, then that means that a higher priority interrupt has preempted it. Invoke tsp_handle_preemption() to handover control back to EL3 by issuing an SMC with TSP_PREEMPTED as the function identifier.
Handles the secure timer interrupt interrupt by acknowledging it using the plat_ic_acknowledge_interrupt() platform API, calling tsp_generic_timer_handler() to reprogram the secure physical generic timer and calling the plat_ic_end_of_interrupt() platform API to signal end of interrupt processing.
The TSP passes control back to the TSPD by issuing an SMC64 with TSP_HANDLED_S_EL1_INTR as the function identifier.

The TSP handles interrupts under the asynchronous model as follows.

Secure-EL1 interrupts are handled by calling the tsp_common_int_handler() function. The function has been described above.
Non-secure interrupts are handled by calling the tsp_common_int_handler() function which ends up invoking tsp_handle_preemption() and issuing an SMC64 with TSP_PREEMPTED as the function identifier. Execution resumes at the instruction that follows this SMC instruction when the TSPD hands control to the TSP in response to an SMC with TSP_FID_RESUME as the function identifier from the non-secure state (see section Test secure payload dispatcher non-secure interrupt handling).

https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/interrupt-framework-design.rst#concepts

change Makefile under raspbian-tee to 
	SPD=tspd
#	SPD=opteed

make[1]: Entering directory '/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware'
Including services/spd/tspd/tspd.mk
bl32/tsp/tsp.mk:33: *** TSP is not supported on platform rpi3.  Stop.
make[1]: Leaving directory '/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware'

juno board supports tspd, but not rpi3 board.

Raspbian have 32-bit version only.
ATF(Trust Firmware-A) now only have 64-bit support for Raspberry Pi 3. (ATF RPI3 support).
I don't want to change this default when considering big workload. So, this project will build ATF as 64-bit, and all others as 32-bit.

ATF 64bit
uboot 32bit
kernel 32bit with tee driver
tee-supplicant 32bit
optee os 32bit

2 routes:
1. 32bit optee + my version of setup secure timer interrupt. (rpi3 has not GIC(general interrupt controller), so has to implement its version instead of using GIC)
2. 64bit optee + already supported macro for read/write secure timer controller and value.

probably 1 is better.

/home/osboxes/Desktop/raspbian-tee/optee_os/core/arch/arm/plat-rpi3/main.c

in this source, need to confirm rpi3 interrupt controller behavior. (not GIC. so needs time)
and then I can write interrupt handler for secure timer.


osboxes@osboxes:/my-rpi3-boot-backup-working-ver-with-emild-img$ ls -l
total 9456
-rwxr-xr-x 1 root root  829070 Mar 16 12:14 armstub8.bin
-rwxr-xr-x 1 root root   24367 Mar 16 12:14 bcm2710-rpi-3-b.dtb
-rwxr-xr-x 1 root root   52296 Mar 16 12:14 bootcode.bin
-rwxr-xr-x 1 root root    1853 Mar 16 12:14 config.txt
-rwxr-xr-x 1 root root    6702 Mar 16 12:14 fixup.dat
-rwxr-xr-x 1 root root      86 Mar 16 12:14 issue.txt
-rwxr-xr-x 1 root root  419024 Mar 16 12:14 optee.bin
drwxr-xr-x 2 root root    4096 Mar 16 12:14 overlays
-rwxr-xr-x 1 root root 2873124 Mar 16 12:14 start.elf
-rwxr-xr-x 1 root root  446144 Mar 16 12:14 u-boot.bin
-rwxr-xr-x 1 root root   16384 Mar 16 12:14 uboot.env
-rwxr-xr-x 1 root root 4992748 Mar 16 12:14 uImage


-rwxr-xr-x 1 root root  829070 Mar 16 12:14 armstub8.bin <-- stored in /out
-rwxr-xr-x 1 root root  446144 Mar 16 12:14 u-boot.bin  <-- stored in /u-boot

so actually, optee is in armstub8.bin and loaded by u-boot?
need confirmation... i guess u-boot.bin serve as BL33, and armstub8.bin contains BL1,BL2,BL31,BL32. so when start.elf load image, it loads armstub8.bin and transfer control to it, armsub8.bin set up BL2,BL31,BL32 step by step and then load BL33(uboot.bin) and transmit control to BL33. BL33(u-boot.bin) can choose to load optee-os(BL32) again or not.


3. Copy ``armstub8.bin`` here. When ``kernel8.img`` is available, The VideoCore
   bootloader will look for a file called ``armstub8.bin`` and load it at
   address **0x0** instead of a predefined one.

so i guess, u-boot.bin serve as kernel8.img here.



/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/docs/plat/rpi3.rst seems to have the answer.

Design
------

The SoC used by the Raspberry Pi 3 is the Broadcom BCM2837. It is a SoC with a
VideoCore IV that acts as primary processor (and loads everything from the SD
card) and is located between all Arm cores and the DRAM. Check the `Raspberry Pi
3 documentation`_ for more information.

This explains why it is possible to change the execution state (AArch64/AArch32)
depending on a few files on the SD card. We only care about the cases in which
the cores boot in AArch64 mode.

The rules are simple:

- If a file called ``kernel8.img`` is located on the ``boot`` partition of the
  SD card, it will load it and execute in EL2 in AArch64. Basically, it executes
  a `default AArch64 stub`_ at address **0x0** that jumps to the kernel.

- If there is also a file called ``armstub8.bin``, it will load it at address
  **0x0** (instead of the default stub) and execute it in EL3 in AArch64. All
  the cores are powered on at the same time and start at address **0x0**.

This means that we can use the default AArch32 kernel provided in the official
`Raspbian`_ distribution by renaming it to ``kernel8.img``, while TF-A and
anything else we need is in ``armstub8.bin``. This way we can forget about the
default bootstrap code. When using a AArch64 kernel, it is only needed to make
sure that the name on the SD card is ``kernel8.img``.

Ideally, we want to load the kernel and have all cores available, which means
that we need to make the secondary cores work in the way the kernel expects, as
explained in `Secondary cores`_. In practice, a small bootstrap is needed
between TF-A and the kernel.


Placement of images
~~~~~~~~~~~~~~~~~~~

The file ``armstub8.bin`` contains BL1 and the FIP. 

A Trusted Board Boot implementation, conforming to all mandatory TBBR requirements. This includes image authentication, Firmware Update (or recovery mode), and packaging of the various firmware images into a Firmware Image Package (FIP).


- ``BL32``: This port can load and run OP-TEE. The OP-TEE image is optional.
  Please use the code from `here <https://github.com/OP-TEE/optee_os>`__.
  Build the Trusted Firmware with option ``BL32=tee-header_v2.bin
  BL32_EXTRA1=tee-pager_v2.bin  BL32_EXTRA2=tee-pageable_v2.bin``
  to put the binaries into the FIP.



In the end, the images look like the following diagram when placed in memory.
All addresses are Physical Addresses from the point of view of the Arm cores.
Again, note that this is all just part of the same DRAM that goes from
**0x00000000** to **0x3F000000**, it just has different names to simulate a real
secure platform!



::

    0x00000000 +-----------------+
               |       ROM       | BL1
    0x00020000 +-----------------+
               |       FIP       |
    0x00200000 +-----------------+
               |                 |
               |       ...       |
               |                 |
    0x01000000 +-----------------+
               |       DTB       | (Loaded by the VideoCore)
               +-----------------+
               |                 |
               |       ...       |
               |                 |
    0x02000000 +-----------------+
               |     Kernel      | (Loaded by the VideoCore)
               +-----------------+
               |                 |
               |       ...       |
               |                 |
    0x10000000 +-----------------+
               |   Secure SRAM   | BL2, BL31
    0x10100000 +-----------------+
               |   Secure DRAM   | BL32 (Secure payload)
    0x11000000 +-----------------+
               | Non-secure DRAM | BL33
               +-----------------+
               |                 |
               |       ...       |
               |                 |
    0x3F000000 +-----------------+
               |       I/O       |
    0x40000000 +-----------------+

The area between **0x10000000** and **0x11000000** has to be manually protected
so that the kernel doesn't use it. That is done by adding ``memmap=16M$256M`` to
the command line passed to the kernel. See the `Setup SD card`_ instructions to
see how to do it.

The last 16 MiB of DRAM can only be accessed by the VideoCore, that has
different mappings than the Arm cores in which the I/O addresses don't overlap
the DRAM. The memory reserved to be used by the VideoCore is always placed at
the end of the DRAM, so this space isn't wasted.

Considering the 128 MiB allocated to the GPU and the 16 MiB allocated for
TF-A, there are 880 MiB available for Linux.

  Note: If OP-TEE is used it may be needed to add the following options to the
  Linux command line so that the USB driver doesn't use FIQs:
  ``dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 dwc_otg.nak_holdoff=0``.
  This will unfortunately reduce the performance of the USB driver. It is needed
  when using Raspbian, for example.


/home/osboxes/devel/optee/optee_os/core/arch/arm/plat-rpi3/platform_config.h
gives memory map

/* 16550 UART */
#define CONSOLE_UART_BASE	0x3f215040 /* UART0 */
#define CONSOLE_BAUDRATE	115200
#define CONSOLE_UART_CLK_IN_HZ	19200000

/home/osboxes/Desktop/raspbian-tee/optee_os/core/arch/arm/kernel/timer_a32.c
says about starting timer
Q: why can't find write_cntps_ctl(). arm compiler knows it or what?

/home/osboxes/Desktop/raspbian-tee/optee_os/core/arch/arm/plat-synquacer/main.c
as a template for my secure timer for changing the following
/home/osboxes/Desktop/raspbian-tee/optee_os/core/arch/arm/plat-rpi3/main.c

interrupt control related phy addr already in /home/osboxes/devel/optee/optee_os/core/arch/arm/plat-rpi3/platform_config.h

driver_init() will register the driver in BL32 optee, BL31 will load these drivers before transfering control to BL32.

NOTICE:  Booting Trusted Firmware
NOTICE:  BL1: v2.0(debug):5ca7b92-dirty
NOTICE:  BL1: Built : 23:26:12, Mar 15 2019
INFO:    BL1: RAM 0x100ee000 - 0x100f7000
INFO:    BL1: cortex_a53: CPU workaround for 843419 was applied
INFO:    BL1: cortex_a53: CPU workaround for 855873 was applied
NOTICE:  rpi3: Detected: Raspberry Pi 3 Model B (1GB, Embest, China) [0x00a22082]
INFO:    BL1: Loading BL2
INFO:    Loading image id=1 at address 0x100b4000
INFO:    Image id=1 loaded: 0x100b4000 - 0x100b9419
NOTICE:  BL1: Booting BL2
INFO:    Entry point address = 0x100b4000
INFO:    SPSR = 0x3c5
NOTICE:  BL2: v2.0(debug):5ca7b92-dirty
NOTICE:  BL2: Built : 23:26:13, Mar 15 2019
INFO:    BL2: Doing platform setup
INFO:    BL2: Loading image id 3
INFO:    Loading image id=3 at address 0x100e0000
INFO:    Image id=3 loaded: 0x100e0000 - 0x100e9081
INFO:    BL2: Loading image id 4
INFO:    Loading image id=4 at address 0x10100000
INFO:    Image id=4 loaded: 0x10100000 - 0x1010001c
INFO:    OPTEE ep=0x10100000
INFO:    OPTEE header info:
INFO:          magic=0x4554504f
INFO:          version=0x2
INFO:          arch=0x0
INFO:          flags=0x0
INFO:          nb_images=0x1
INFO:    BL2: Loading image id 21
INFO:    Loading image id=21 at address 0x10100000
INFO:    Image id=21 loaded: 0x10100000 - 0x1012f1f0
INFO:    BL2: Skip loading image id 22
INFO:    BL2: Loading image id 5
INFO:    Loading image id=5 at address 0x11000000
INFO:    Image id=5 loaded: 0x11000000 - 0x1106cec0
INFO:    BL33 will boot in Non-secure AArch32 Hypervisor mode
NOTICE:  BL1: Booting BL31
INFO:    Entry point address = 0x100e0000
INFO:    SPSR = 0x3cd
NOTICE:  BL31: v2.0(debug):5ca7b92-dirty
NOTICE:  BL31: Built : 23:26:13, Mar 15 2019
INFO:    BL31: Initializing runtime services
INFO:    BL31: cortex_a53: CPU workaround for 843419 was applied
INFO:    BL31: cortex_a53: CPU workaround for 855873 was applied
INFO:    BL31: Initializing BL32
D/TC:0 0 add_phys_mem:536 TEE_SHMEM_START type NSEC_SHM 0x08000000 size 0x00400000
D/TC:0 0 add_phys_mem:536 TA_RAM_START type TA_RAM 0x10800000 size 0x00800000
D/TC:0 0 add_phys_mem:536 VCORE_UNPG_RW_PA type TEE_RAM_RW 0x1012f000 size 0x006d1000
D/TC:0 0 add_phys_mem:536 VCORE_UNPG_RX_PA type TEE_RAM_RX 0x10100000 size 0x0002f000
D/TC:0 0 add_phys_mem:536 CONSOLE_UART_BASE type IO_NSEC 0x3f200000 size 0x00100000
D/TC:0 0 verify_special_mem_areas:474 No NSEC DDR memory area defined
D/TC:0 0 add_va_space:575 type RES_VASPACE size 0x00a00000
D/TC:0 0 add_va_space:575 type SHM_VASPACE size 0x02000000
D/TC:0 0 dump_mmap_table:708 type TEE_RAM_RX   va 0x10100000..0x1012efff pa 0x10100000..0x1012efff size 0x0002f000 (smallpg)
D/TC:0 0 dump_mmap_table:708 type TEE_RAM_RW   va 0x1012f000..0x107fffff pa 0x1012f000..0x107fffff size 0x006d1000 (smallpg)
D/TC:0 0 dump_mmap_table:708 type NSEC_SHM     va 0x10800000..0x10bfffff pa 0x08000000..0x083fffff size 0x00400000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type RES_VASPACE  va 0x10c00000..0x115fffff pa 0x00000000..0x009fffff size 0x00a00000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type SHM_VASPACE  va 0x11600000..0x135fffff pa 0x00000000..0x01ffffff size 0x02000000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type TA_RAM       va 0x13600000..0x13dfffff pa 0x10800000..0x10ffffff size 0x00800000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type IO_NSEC      va 0x13e00000..0x13efffff pa 0x3f200000..0x3f2fffff size 0x00100000 (pgdir)
D/TC:0 0 core_mmu_alloc_l2:238 L2 table used: 1/4
I/TC: 
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[0] with top at 0x10161a38
D/TC:0 0 init_canaries:166 watch *0x10161a3c
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[1] with top at 0x10162078
D/TC:0 0 init_canaries:166 watch *0x1016207c
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[2] with top at 0x101626b8
D/TC:0 0 init_canaries:166 watch *0x101626bc
D/TC:0 0 init_canaries:166 #Stack canaries for stack_tmp[3] with top at 0x10162cf8
D/TC:0 0 init_canaries:166 watch *0x10162cfc
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[0] with top at 0x10157a38
D/TC:0 0 init_canaries:167 watch *0x10157a3c
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[1] with top at 0x10158278
D/TC:0 0 init_canaries:167 watch *0x1015827c
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[2] with top at 0x10158ab8
D/TC:0 0 init_canaries:167 watch *0x10158abc
D/TC:0 0 init_canaries:167 #Stack canaries for stack_abt[3] with top at 0x101592f8
D/TC:0 0 init_canaries:167 watch *0x101592fc
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[0] with top at 0x1015b338
D/TC:0 0 init_canaries:169 watch *0x1015b33c
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[1] with top at 0x1015d378
D/TC:0 0 init_canaries:169 watch *0x1015d37c
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[2] with top at 0x1015f3b8
D/TC:0 0 init_canaries:169 watch *0x1015f3bc
D/TC:0 0 init_canaries:169 #Stack canaries for stack_thread[3] with top at 0x101613f8
D/TC:0 0 init_canaries:169 watch *0x101613fc
I/TC: OP-TEE version: 5730e6f #9 Thu Apr  4 21:54:50 UTC 2019 arm
D/TC:0 0 check_ta_store:533 TA store: "Secure Storage TA"
D/TC:0 0 check_ta_store:533 TA store: "REE"
D/TC:0 0 mobj_mapped_shm_init:709 Shared memory address range: 11600000, 13600000
I/TC: now init_timer_itr!
I/TC: Initialized
D/TC:0 0 init_primary_helper:1033 Primary CPU switching to normal world boot
INFO:    BL31: Preparing for EL3 exit to normal world
INFO:    Entry point address = 0x11000000
INFO:    SPSR = 0x1da


U-Boot 2018.11 (Apr 04 2019 - 17:54:51 -0400)

/*
 * RPi memory map
 *
 * No secure memory on RPi...
 *
 *
 *    Available to Linux <above>
 *  0x0a00_0000
 *    TA RAM: 16 MiB                          |
 *  0x0842_0000                               | TZDRAM
 *    TEE RAM: 4 MiB (TEE_RAM_VA_SIZE)	      |
 *  0x0840_0000 [ARM Trusted Firmware       ] -
 *  0x0840_0000 [TZDRAM_BASE, BL32_LOAD_ADDR] -
 *    Shared memory: 4 MiB                    |
 *  0x0800_0000                               | DRAM0
 *    Available to Linux                      |
 *  0x0000_0000 [DRAM0_BASE]                  -
 *
 */

current plan:
1. at driver_init() enable the timer, enable the interrupt line, set timer value, start the timer.
2. register handler for timer.


rpiOS:
#define PBASE 0x3F000000

arm bcm2835/2837 perihperal:
peripherals at phy addr 0x3f000000 - 0x3fffffff
peripherals at phy addr 0x3f000000 == bus address 0x7e000000

base addr for arm timer reg -> 0x7e00b000
base addr for mini uart -> 0x7e215040

arm timer doc:
0x3e000000 - 0x3fffffff -> GpU peripheral access
0x40000000 - 0x4001ffff -> ARM timer, IRQs, mailboxes

#define core0_timer_irqcntl 0x40000040

optee source code:
UART_base -> 0x3f215040


Raspberry Pi has both a system timer and an ARM Timer that is based on an ARM AP804. The system timer is part of the GPU and the ARM Timer is part of the ARM CPU. Interestingly, the ARM timer is derived from the system clock. Since the system clock can have a variable clock rate (low power mode, for instance), the ARM timer can be unreliable. We would have to force the system clock to be a constant 250 MHz to get accurate readings from the ARM timer. In an embedded environment, this isn’t necessarily an issue since the system clock should be running at 250 MHz by default. However, for absolute certainty, we will want to use the GPU system timer to ensure accurate timing.

arm ap804
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0271d/DDI0271.pdf

http://docs-api-peg.northeurope.cloudapp.azure.com/assets/ddi0500/g/DDI0500G_cortex_a53_trm.pdf

so actually the system arch be:

GPU peripheral - arm control logic - arm core

so for me, i need to:
1. set secure el1 timer with (arm core a53 ref)
2. set IRQ routing on bcm2837 to enable routing of arm core timer (QA7 ref)
-3. arm control logic deal with gpu irqs, so not really important, system timer is peripheral 
4. implement fiq timer handler

 ARM AP804 is a provides to timer, system timer and arm timer. arm timer is supplied to arm a53 core probably?

14 Timer (ARM side)
14.1 Introduction
The ARM Timer is based on a ARM SP804, but it has a number of differences with the standard SP804:
• There is only one timer.
• It only runs in continuous mode.
• It has a extra clock pre-divider register.
• It has a extra stop-in-debug-mode control bit.
• It also has a 32-bit free running counter.
The clock from the ARM timer is derived from the system clock. This clock can change dynamically e.g. if the system goes into reduced power or in low power mode. Thus the clock speed adapts to the overal system performance capabilities. For accurate timing it is recommended to use the system timers.

question: can ns world change clock source to change core timer freq ?

#include <stdint.h>
/*--------------------------------------------------------------------------}
{    LOCAL TIMER INTERRUPT ROUTING REGISTER - QA7_rev3.4.pdf page 18		}
{--------------------------------------------------------------------------*/
typedef union
{
	struct
	{
		enum {
			LOCALTIMER_TO_CORE0_IRQ = 0,
			LOCALTIMER_TO_CORE1_IRQ = 1,
			LOCALTIMER_TO_CORE2_IRQ = 2,
			LOCALTIMER_TO_CORE3_IRQ = 3,
			LOCALTIMER_TO_CORE0_FIQ = 4,
			LOCALTIMER_TO_CORE1_FIQ = 5,
			LOCALTIMER_TO_CORE2_FIQ = 6,
			LOCALTIMER_TO_CORE3_FIQ = 7,
		} Routing: 3;												// @0-2	  Local Timer routing 
		unsigned unused : 29;										// @3-31
	};
	uint32_t Raw32;													// Union to access all 32 bits as a uint32_t
} local_timer_int_route_reg_t;

/*--------------------------------------------------------------------------}
{    LOCAL TIMER CONTROL AND STATUS REGISTER - QA7_rev3.4.pdf page 17		}
{--------------------------------------------------------------------------*/
typedef union
{
	struct
	{
		unsigned ReloadValue : 28;									// @0-27  Reload value 
		unsigned TimerEnable : 1;									// @28	  Timer enable (1 = enabled) 
		unsigned IntEnable : 1;										// @29	  Interrupt enable (1= enabled)
		unsigned unused : 1;										// @30	  Unused
		unsigned IntPending : 1;									// @31	  Timer Interrupt flag (Read-Only) 
	};
	uint32_t Raw32;													// Union to access all 32 bits as a uint32_t
} local_timer_ctrl_status_reg_t;

/*--------------------------------------------------------------------------}
{     LOCAL TIMER CLEAR AND RELOAD REGISTER - QA7_rev3.4.pdf page 18		}
{--------------------------------------------------------------------------*/
typedef union
{
	struct
	{
		unsigned unused : 30;										// @0-29  unused 
		unsigned Reload : 1;										// @30	  Local timer-reloaded when written as 1 
		unsigned IntClear : 1;										// @31	  Interrupt flag clear when written as 1  
	};
	uint32_t Raw32;													// Union to access all 32 bits as a uint32_t
} local_timer_clr_reload_reg_t;

/*--------------------------------------------------------------------------}
{    GENERIC TIMER INTERRUPT CONTROL REGISTER - QA7_rev3.4.pdf page 13		}
{--------------------------------------------------------------------------*/
typedef union
{
	struct
	{
		unsigned nCNTPSIRQ_IRQ : 1;									// @0	Secure physical timer event IRQ enabled, This bit is only valid if bit 4 is clear otherwise it is ignored. 
		unsigned nCNTPNSIRQ_IRQ : 1;								// @1	Non-secure physical timer event IRQ enabled, This bit is only valid if bit 5 is clear otherwise it is ignored
		unsigned nCNTHPIRQ_IRQ : 1;									// @2	Hypervisor physical timer event IRQ enabled, This bit is only valid if bit 6 is clear otherwise it is ignored
		unsigned nCNTVIRQ_IRQ : 1;									// @3	Virtual physical timer event IRQ enabled, This bit is only valid if bit 7 is clear otherwise it is ignored
		unsigned nCNTPSIRQ_FIQ : 1;									// @4	Secure physical timer event FIQ enabled, If set, this bit overrides the IRQ bit (0) 
		unsigned nCNTPNSIRQ_FIQ : 1;								// @5	Non-secure physical timer event FIQ enabled, If set, this bit overrides the IRQ bit (1)
		unsigned nCNTHPIRQ_FIQ : 1;									// @6	Hypervisor physical timer event FIQ enabled, If set, this bit overrides the IRQ bit (2)
		unsigned nCNTVIRQ_FIQ : 1;									// @7	Virtual physical timer event FIQ enabled, If set, this bit overrides the IRQ bit (3)
		unsigned reserved : 24;										// @8-31 reserved
	};
	uint32_t Raw32;													// Union to access all 32 bits as a uint32_t
} generic_timer_int_ctrl_reg_t;

struct __attribute__((__packed__, aligned(4))) QA7Registers {
	local_timer_int_route_reg_t TimerRouting;						// 0x24
	uint32_t GPIORouting;											// 0x28
	uint32_t AXIOutstandingCounters;								// 0x2C
	uint32_t AXIOutstandingIrq;										// 0x30
	local_timer_ctrl_status_reg_t TimerControlStatus;				// 0x34
	local_timer_clr_reload_reg_t TimerClearReload;					// 0x38
	uint32_t unused;												// 0x3C
	generic_timer_int_ctrl_reg_t Core0TimerIntControl;				// 0x40
	generic_timer_int_ctrl_reg_t Core1TimerIntControl;				// 0x44
	generic_timer_int_ctrl_reg_t Core2TimerIntControl;				// 0x48
	generic_timer_int_ctrl_reg_t Core3TimerIntControl;				// 0x4C
};

#define QA7 ((volatile __attribute__((aligned(4))) struct QA7Registers*)(uintptr_t)(0x40000024))


/* Here is your interrupt function */
void __attribute__((interrupt("IRQ")))  irq_handler_stub(void) {

       /* You code goes here */

	local_timer_clr_reload_reg_t temp = { .IntClear = 1, .Reload = 1 };
	QA7->TimerClearReload  = temp;									// Clear interrupt & reload
}

/* here is your main */
int main(void) {

	QA7->TimerRouting.Routing = LOCALTIMER_TO_CORE0_IRQ;			// Route local timer IRQ to Core0

	QA7->TimerControlStatus.ReloadValue = 100;						// Timer period set
	QA7->TimerControlStatus.TimerEnable = 1;						// Timer enabled
	QA7->TimerControlStatus.IntEnable = 1;							// Timer IRQ enabled

	QA7->TimerClearReload.IntClear = 1;								// Clear interrupt
	QA7->TimerClearReload.Reload = 1;								// Reload now

	QA7->Core0TimerIntControl.nCNTPNSIRQ_IRQ = 1;					// We are in NS EL1 so enable IRQ to core0 that level
	QA7->Core0TimerIntControl.nCNTPNSIRQ_FIQ = 0;					// Make sure FIQ is zero

	EnableInterrupts();												// Start interrupts rolling

	while (1) {
	}

	return(0);
}


http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.prd29-genc-009492c/ch06s03s02.html mentions about needing a secure Real clock timer in secure world.

ARM TZPC: The best solution is to use ARM TZPC (TrustZone Protection Controller). With the TZPC, 24 separate memory regions can be secured – configured to be accessible only by the SW. Unfortunately the RPi3 lack this peripheral component. Confirmation of this can can be found in LAS16-111: Easing Access to ARM TrustZone – OP-TEE and Raspberry Pi 3 (page 7).

https://blog.crysys.hu/2018/06/linux-integrity-monitoring-on-the-raspberry-pi/

The Generic Timer can schedule events and trigger interrupts based on an incrementing counter value.
The CPUs have one generic timer block per CPU. However, the clock part of the timer is external 
to the CPU with the reference time being passed to the CPU via the 64-bit CNTVALUEB[63:0] input. 
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka16107.html
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0464d/BABIDBIJ.html

The system counter which generates CNTCALUEB time signal should be in an always-on clock domain, 
so that the clock is always running. It is expected to increment at a rate of between 1MHz and 
50MHz to implement a real time clock. The counter may support low power modes (switch to lower 
frequency operation – in which case the increments of the count are larger).

so if not an always-on clock domain, then will get trouble. also, this counter may vary at speed.

Register banking
Register banking refers to providing multiple copies of a register at the same address. The properties of a register
access determine which copy of the register is addressed. The GIC banks registers in the following cases:
• If the GIC implements the Security Extensions, some registers are banked to provide separate Secure and
Non-secure copies of the registers. The Secure and Non-secure register bit assignments can differ. A Secure
access to the register address accesses the Secure copy of the register, and a Non-secure access accesses the
Non-secure copy

https://www.raspberrypi.org/forums/viewtopic.php?t=178382

I was surprised by your remark above because I have never seen memory mapped registers in any ARM processor.


https://www.raspberrypi.org/forums/viewtopic.php?t=78970
The R-Pi Model B uses two quartz crystals, mounted on the back side of the board, labelled X1 (25 MHz) and X2 (19.2 MHz) which you can see in this photo: http://elinux.org/File:RPi-back-JPB.jpg One of them is used for the SoC and the other for the Ethernet/USB chip. I do not know the interior volume of those packages, it is a good question.

https://www.google.com/search?source=hp&ei=JgWpXI_vK6bI_QaW2b7AAg&q=cortex+a53+clock+rate&btnK=Google+Search&oq=cortex+a53+clock+rate&gs_l=psy-ab.3...195.6991..7092...5.0..0.192.2235.26j1......0....1..gws-wiz.....0..35i39j0i67j0j0i20i263j0i131j0i22i30j33i22i29i30j33i160.4MM0XyGwfoQ
In computing, the clock multiplier (or CPU multiplier or bus/core ratio) sets the ratio of an internal CPU clock rate to the externally supplied clock. A CPU with a 10x multiplier will thus see 10 internal cycles (produced by PLL-based frequency multiplier circuitry) for every external clock cycle. For example, a system with an external clock of 100 MHz and a 36x clock multiplier will have an internal CPU clock of 3.6 GHz. The external address and data buses of the CPU (often collectively termed front side bus (FSB) in PC contexts) also use the external clock as a fundamental timing base; however, they could also employ a (small) multiple of this base frequency (typically two or four) to transfer data faster.


 ARM Trusted Base System Architecture
● ARM Document RM DEN0007 ○ Available under NDA from ARM
● Describes the requirements for a Trusted ARM SoC:
○ To meet OMTP and Global Platform “Boundary 1” specifications
○ Covers: CPU, Caches, Interrupt Control, Debug, On-chip Boot ROM, Trusted RAM, Interconnect, Non- volatile memory, Watchdog timers, Clock source, Random number generator entropy source, User input, Power management, Boot Process

https://www.slideshare.net/linaroorg/bkk16110-a-gentle-introduction-to-trusted-execution-and-optee
CPUs must be at least Level 1 Standard Configuration, including TrustZone extensions...
Cache accesses from one world must not be able to read, write or modify a line from a different world...
The interrupt controller must support at least eight non-secure Software Generated Interrupts and eight secure SGIs...
Trusted Base System must always boot from On- chip Boot ROM...
Trusted RAM area for use by the Trusted OS and Applications, minimum size...

https://www.raspberrypi.org/forums/viewtopic.php?t=159858
I've dived more deeply into the BCM2836 document today https://www.raspberrypi.org/documentati ... rev3.4.pdf. There is a crystal oscillator running at 19.2 MHz on the board. It can be the source of the ARM clocks. Another clock, the peripheral bus clock (APB), which is running at half of the CPU frequency, can also be the source of the timers. The latter is not recommended because the CPU frequency is variable, but I have not tested if GPU would adjust the divider when it changes the CPU's frequency to keep the clock rate constant. Despite that, the source of the clock can be configured by setting bit 8 of the register mapped to physical address 0x40000000.

Regardless of what the firmware and boot stubs do, bcm2709_timer_init in the Linux board support code sets the prescaler to one, so 19.2MHz is the correct timer frequency. Since the source of the scaled clock is the external 19.2MHz crystal, the architected timers are free running and stable.

P.S. Multiplying by the reciprocal of a number is the same as dividing.



Conclusion:
1. rpi3 is using a 19.2MHz crystal as clock source. And NS world can configure it (since bcm2709_timer_init can tweak it). VideoCore can also tweak it. This clock source is supplied to a53 cores. (a53 use multiplier to make it 1.5ghz).
2. NS world can make the secure world not knowing real time (that is why i.mx use secure Real Time Clock(RTC)).
3. Secure world can use a53 core generic timer, and use its physical secure timer. (only EL3 can tweak it).
4. rpi3 is not secure if Video Core is untrusted and controls clock and others.
5. NS world can actually tweak arm core clock source and other peripheral clock source by tweaking divider pre-scale. 
6. can we map this to secure memory and set up the clock source and dividers in secure EL3 boot?

https://cs.stackexchange.com/questions/32149/what-are-system-clock-and-cpu-clock-and-what-are-their-functions
The system clock is needed to synchronize all components on the motherboard, which means they all do their work only if the clock is high; never when it's low. And because the clock speed is set above the longest time any signal needs to propagate through any circuit on the board, this system is preventing signals from arriving before other signals are ready and thus keeps everything safe and synchronized. The CPU clock has the same purpose, but is only used on the chip itself. Because the CPU needs to perform more operations per time than the motherboard, the CPU clock is much higher. And because we don't want to have another oscillator (e.g. because they also would need to be synchronized), the CPU just takes the system clock and multiplies it by a number, which is either fixed or unlocked (black edition models).

https://www.tablix.org/~avian/blog/archives/2018/02/notes_on_the_general_purpose_clock_on_bcm2835/
The BCM2835 contains 5 independent PLLs - PLLA, PLLB, PLLC, PLLD and PLLH. The system uses most of these for their own purposes, such as clocking the ARM CPU, the VideoCore GPU, HDMI interface, etc. 

https://events.linuxfoundation.org/wp-content/uploads/2017/12/Christopher-Dall_Arm-Timers-and-Fire.pdf
architected timer aka generic timer

https://babaawesam.com/2014/01/24/power-saving-tips-for-raspberry-pi/
Tip 4 Down-clock the Core (Based on comment by User Headpi)

if you downclock your core, i think you consume less power too.
Adding this lines to your config.txt <-- processed by VideoCore
arm_freq_min=250
core_freq_min=100
sdram_freq_min=150
over_voltage_min=0 or 4 if you have overclocked your rasppi

i have it overclocked to 1100 mhz, it works at 250 mhz when i do nothing.
In 1100mhz mode it operates at 64ºC with fan,
and 30ºC at 250mhz mode.

https://www.slideshare.net/linaroorg/las16111-easing-access-to-arm-trustzone-optee-and-raspberry-pi-3
Raspberry Pi 3 implements Cortex-A/V8a exceptions
But
— It does not implement the crypto acceleration instructions
— Linux Device Tree Source (DTS) showed no indication of any security hardware IP
— No TZPC, TZASC, GIC or other proprietary bus/fabric security control interfaces
— No securable memory
— IE., A53 core security state signals not propagated throughout the fabric.
 Conclusion
— not-securable TrustZone implementation but GREAT for education, learning, Trusted Application development and debug


https://www.raspberrypi.org/forums/viewtopic.php?t=215868#p1332540
It has nothing to do with the VC in this case.

Arm cores have the concept of "secure" and "non-secure" memory. This is essentially just one extra bit of physical address that the peripherals can detect. For example, you can have a secure timer and a non-secure timer. Usually, Arm platforms have some static RAM (SRAM) that can only be accessed with secure accesses (secure SRAM). This RAM is internal to the SoC, to make it harder to attack. This can also be expanded to secure DRAM in some ways (TrustZone Controller TZC-400, for example).

Arm cores have secure and non-secure execution modes. There are 4 levels of privilege: EL0 (user), EL1 (OS), EL2 (hypervisor), EL3 (firmware). Non-secure mode has EL0, EL1 and EL2. Secure mode, S-EL0, S-EL1 and EL3. Non-secure execution levels can only access non-secure memory, secure levels can access both secure and non-secure.

The only privilege level that can change the security mode is EL3. This means that if the OS in EL1 wants to request a secure service from a secure OS in S-EL1 (OP-TEE), it has to send the request to EL3, and it will change the security mode to send the request to S-EL1, and then send the reply back to EL1.

This is secure because the non trusted software is limited and can only check non-secure memory (DRAM, mostly). That software physically can't even see whatever is in secure memory. That's why it is secure. Normally, at EL3 you have the Trusted Firmware (or equivalent), which starts from ROM. This is secure because there is no way to modify it outside of the factory. Through cryptographic signatures the firmware loads the software that runs at S-EL1 into secure SRAM. This can't be accessed by software means or hardware means (you need to decap the chip and probe the conectors inside, which is crazy hard, but it can be done!). Once all secure software is loaded in secure memory and it is initialized, EL3 loads U-Boot or UEFI into non-secure memory and that continues the regular execution that you see (Linux, etc).

The Raspberry Pi 3 could be secure because after the software in the SD card is loaded you could technically block the non-secure world from accessing the SD card, and you would always boot the same software that you trust. However, this is pointless for the following reason.

The Raspberry Pi 3 is not secure because it doesn't have secure memory. There is no way to hide any memory from the normal world. Software at EL3 can see all the memory of the device, but so can EL2, and this is the level at which U-Boot/UEFI runs (Linux can also start running at EL2, it leaves a service handler to deal with hardware virtualization and jumps to EL1). In short, you could load secure software from EL3, but your non-secure software can see it. There is no way to hide it.

The only real option to hide secure software from non-secure software is to use EL2 to hide the memory from EL1. EL2 has hardware support to fake a memory map for EL1. You can map all memory of the Raspberry Pi except for the space used by secure software. You can boot Linux at EL1 so it can't have more privileges, and you can use EL2 to virtualize Linux and hide the "secure memory". This is a real option, but you lose virtualization support. However, I'd be surprised if someone was sad about losing support for virtualization in this device... Also, it's only secure from software, the accesses to DRAM could be intercepted by an external digital analyzer.

PS: The VC can also access all the memory of the device, but I don't think that it can be leaked in any way using the VC. I may be wrong, though.

EDIT: By the way, there is a port of the Trusted Firmware to the RPi3, you can see that in the repository. There's also some effort ongoing to have OP-TEE and U-Boot working at the same time. But again, this is not secure. However, that doesn't mean it's worthless. I think it can be quite useful to see how things work.

https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/plat/rpi3.rst
IMPORTANT NOTE: This port isn't secure. All of the memory used is DRAM, which is available from both the Non-secure and Secure worlds. This port shouldn't be considered more than a prototype to play with and implement elements like PSCI to support the Linux kernel.



In summary for making rpi3 secure:
1. After loading from sd card, block it
2. Rpi3 only has DRAM no SDRAM, so EL2 can access all memory. Thus u-boot in EL2 needs to be in part of Trusted firmware, and linux run on EL1
3. No external digital analyzer


Sumup for scheme 2.
1. uboot at EL2 setup page table in kernel space and only allocate Virtal memory mapped to NS physical memory to EL1
2. normally when user space EL0 is loaded, linux kernel EL1 will allocate free NS physical memory to it. each process can only access NS physical memory allocated to it using its virtual memory and page table. whenever it needs more NS physical memory, fire a page fault and EL1 kernel handles it.
3. Process isolation: On a context switch between different processes, the kernel modifies the MMU configuration so that it contains the desired translation for the new process. similar to reg.s bookkeeping and restore. kernel log mmu config and restore.
https://developer.arm.com/docs/100942/latest/hypervisor-software


BCM2837-arm-peripheral.pdf
7 Interrupts 7.1 Introduction
The ARM has two types of interrupt sources:
1. Interrupts coming from the GPU peripherals.
2. Interrupts coming from local ARM control peripherals.
The ARM processor gets three types of interrupts:
1. Interrupts from ARM specific peripherals.
2. Interrupts from GPU peripherals.
3. Special events interrupts.
The ARM specific interrupts are:
• One timer.
• One Mailbox.
• Two Doorbells.
• Two GPU halted interrupts.
• Two Address/access error interrupt
The Mailbox and Doorbell registers are not for general usage.


The System Timer
The System Timer peripheral provides four 32-bit timer channels and a single 64-bit free running counter. Each channel has an output compare register, which is compared against the 32 least significant bits of the free running counter values. When the two values match, the system timer peripheral generates a signal to indicate a match for the appropriate channel. The match signal is then fed into the interrupt controller. The interrupt service routine then reads the output compare register and adds the appropriate offset for the next timer tick. The free running counter is driven by the timer clock and stopped whenever the processor is stopped in debug mode.

The Physical (hardware) base address for the system timers is 0x7E003000.

The ARM Timer
The ARM Timer is based on a ARM SP804, but it has a number of differences with the standard SP804:
• There is only one timer.
• It only runs in continuous mode.
• It has a extra clock pre-divider register.
• It has a extra stop-in-debug-mode control bit.
• It also has a 32-bit free running counter.
The clock from the ARM timer is derived from the system clock. This clock can change dynamically e.g. if the system goes into reduced power or in low power mode. Thus the clock speed adapts to the overal system performance capabilities. For accurate timing it is recommended to use the system timers.

The base address for the ARM timer register is 0x7E00B000.
0x400 Load 
0x404 Value (Read Only) 
0x408 Control 
0x40C IRQ Clear/Ack (Write only) 
0x410 RAW IRQ (Read Only) 
0x414 Masked IRQ (Read Only) 
0x418 Reload 
0x41C Pre-divider (Not in real 804!) 
0x420  Free running counter (Not in real 804!)


QA7_rev3.4.pdf
The ARM control logic is a module which performs the following functions:
Provide a 64-bit Timer
Route the various interrupts to the cores 
Route the GPU interrupts to the core Provide mailboxes between the processors 
Provide extra interrupt timer

so.. ARM control contains system timer and rpi3 version of GIC?

4.6 Core timers interrupts
There are four core timer control and four core timer status registers. The registers allow you to enable or disable an IRQ or FIQ interrupt. They cannot clear an pending interrupts. For that and other details of the timers, read the Cortex-A7-coprocessor description.



a53.pdf
The Generic Timer can schedule events and trigger interrupts based on an incrementing counter value. It provides:
• Generation of timer events as interrupt outputs.
• Generation of event streams.

armv8.pdf pg 5593
This chapter describes an instance of the Generic Timer component that Figure G6-1 shows as Timer_0 or Timer_1 within the Multiprocessor A or Multiprocessor B block. This component can be accessed from AArch64 state or AArch32 state, and this chapter describes access from AArch32 state.

Timers
In an implementation that includes EL3, in any implementation of the Generic Timer, the following timers are accessible from AArch32 state, provided the appropriate Exception level can use AArch32:
• A Non-secure EL1 physical timer. A Non-secure EL1 control determines whether this register is accessible from Non-secure EL0.
• A Secure PL1 physical timer. This timer:
— Is accessible from Secure EL1 using AArch32 when EL3 is using AArch64.
— Is accessible from Secure EL3 when EL3 is using AArch32.
A Secure PL1 control determines whether this register is accessible from Secure EL0.
• A Non-secure EL2 physical timer.
• A virtual timer.
The output of each implemented timer:
• Provides an output signal to the system.
• If the PE interfaces to a Generic Interrupt Controller (GIC), signals a Private Peripheral Interrupt (PPI) to that GIC. In a multiprocessor implementation, each PE must use the same interrupt number for each timer.

Each timer:
Is based around a 64-bit CompareValue that provides a 64-bit unsigned upcounter.
Provides an alternative view of the CompareValue, called the TimerValue, that appears to operate as a 32-bit downcounter.
Has, in addition, a 32-bit Control register.

In all implementations, the AArch32 System registers for the EL1 (or PL1) physical timer are banked, to provide the Secure and Non-secure implementations of the timer. Table G6-1 shows the Timer registers.
In AArch32 state, these registers are banked to provide the Non-secure EL1 physical timer and the Secure PL1 physical timer.

Secure PL1 and Non-secure EL1 physical timer:
The Secure PL1 physical timer is accessible from Secure PL1 modes. ...
In all implementations:
• Except for accesses from Monitor mode, accesses are to the registers for the current Security state.
• For accesses from Monitor mode, the value of SCR.NS determines whether accesses are to the Secure or the Non-secure registers.
Note
Monitor mode is present only when EL3 is using AArch32.


Armv8 aarch32 application instruction set & system reg. access:
armv8.pdf pg 6357


K13-7398
General name Short description AArch64 register AArch32 register
CNTFRQ Counter-timer Frequency register CNTFRQ_EL0 CNTFRQ
CNTHCTL Counter-timer Hypervisor Control register CNTHCTL_EL2 CNTHCTL
CNTHP_CTL Counter-timer Hypervisor Physical Timer Control register CNTHP_CTL_EL2 CNTHP_CTL
CNTHP_CVAL Counter-timer Hypervisor Physical Timer CompareValue
register
CNTHP_CVAL_EL2 CNTHP_CVAL
CNTHP_TVAL Counter-timer Hypervisor Physical Timer TimerValue register CNTHP_TVAL_EL2 CNTHP_TVAL
CNTKCTL Counter-timer Kernel Control register CNTKCTL_EL1 CNTKCTL
CNTP_CTL Counter-timer Physical Timer Control register CNTP_CTL_EL0 CNTP_CTL
CNTP_CVAL Counter-timer Physical Timer CompareValue register CNTP_CVAL_EL0 CNTP_CVAL
CNTP_TVAL Counter-timer Physical Timer TimerValue register CNTP_TVAL_EL0 CNTP_TVAL
CNTPCT Counter-timer Physical Count register CNTPCT_EL0 CNTPCT
CNTPS_CTL Counter-timer Physical Secure Timer Control register CNTPS_CTL_EL1 -
CNTPS_CVAL Counter-timer Physical Secure Timer CompareValue register CNTPS_CVAL_EL1 -
CNTPS_TVAL Counter-timer Physical Secure Timer TimerValue register CNTPS_TVAL_EL1 -

banked?

for AARCH32
G6 pg 5593
The Secure PL1 physical timer uses the Secure banked instances of the CNTP_CTL,
CNTP_CVAL, and CNTP_TVAL registers, and the Non-secure EL1 physical timer uses the
Non-secure instances of the same registers.

so 2 routes:
1. use AArch64 EL3 arm trusted firemware to set secure timer
2. use AArch64 optee os instead of AArch32

use AArch64 optee os is actually very simple, continuing on this route.

now EL3 runtime exception handler captures the fiq and have no idea what to do.

ERROR:   rpi3: Interrupt routed to EL3.

this can be found in /home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/bl31/aarch64/runtime_exceptions.S
/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/plat/rpi3/rpi3_common.c

added following to trigger secure timer every 10 secs.

uint32_t plat_ic_get_pending_interrupt_type(void)
{
	ERROR("rpi3: Interrupt routed to EL3.\n");
	assert((read_cntps_ctl_el1() >> 2));

	ERROR("rd: Disabling secure physical timer!\n");
	/* Disable the timer */
	write_cntps_ctl_el1(0);

	ERROR("rd: Reconfigure timer to fire time_ms from now!\n");

	uint32_t time_ms;
	time_ms = 10000; // 1000 is 1 second
	uint32_t timer_ticks;
	/* Reconfigure timer to fire time_ms from now */
	timer_ticks = (read_cntfrq_el0() * time_ms) / 1000;
	write_cntps_tval_el1(timer_ticks);

	/* Enable the secure physical timer */
	write_cntps_ctl_el1(1);
	return INTR_TYPE_INVAL;
}

use following in /home/osboxes/Desktop/raspbian-tee/optee_os/core/arch/arm/plat-rpi3/main.c to route interrupts (on rpi3 peripheral ic (interrupt controller))

static TEE_Result init_timer_itr(void)
{
//	int curVal = get32();
	IMSG("optee_os/core/arch/arm/plat-rpi3/main.c: now init_timer_itr!\n");
	IMSG("I am at 64bit now!\n");

	//itr_add(&timer_itr); // add interrupt handler
	//itr_enable(IT_SEC_TIMER); //# enble timer interrupt

	IMSG("setting IRQ_routing:\n");
	IMSG("setting core0 FIQ source to timer0 physical secure interrupt on IRQ_routing!\n");

	vaddr_t core0_fiq_source;

	core0_fiq_source = (vaddr_t)phys_to_virt(CORE0_FIQ_SOURCE,
					  MEM_AREA_IO_SEC);

	write32(INT_SRC_TIMER0, core0_fiq_source);

	// where to route timer interrupt to, IRQ or FIQ
	IMSG("routing core0 secure timer interrupt to fiq interrupt on IRQ_routing!\n");

	vaddr_t core0_timer_irqcntl;

	core0_timer_irqcntl = (vaddr_t)phys_to_virt(CORE0_TIMER_IRQCNTL,
					  MEM_AREA_IO_SEC);	

	write32(TIMER0_FIQ, core0_timer_irqcntl);

	IMSG("setting core0 secure timer:\n");
	IMSG("starting time interrupt counter!\n");
	uint32_t timer_ticks;
	uint32_t time_ms;

	time_ms = 10000; // 1000 is 1 second

	timer_ticks = (read_cntfrq() * time_ms) / 1000;
	IMSG("read_cntfrq shows: %d!\n", read_cntfrq());

	write_cntps_tval(timer_ticks);

	IMSG("enabling the secure physical timer on core!\n");

	/* Enable the secure physical timer */
	write_cntps_ctl(1);

	/* Disable the secure physical timer */
	//write_cntps_ctl(0);

	
	// Enable timer FIQ to fetch entropy required during boot
	//	generic_timer_start(TIMER_PERIOD_MS); # start time interrupt counter

	return TEE_SUCCESS;
}
driver_init(init_timer_itr);


in waf c4che add '-g'(need this for line number meta data) '-O0'(no opt.) '-emit-llvm'(llvm bytecode object code) '-fcsi'(add instrumentation)

clang++ -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/usr -B/usr/bin /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a 

ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o libraries/AP_AccelCal/AccelCalibrator.cpp.0.o libraries/AP_AccelCal/AP_AccelCal.cpp.4.o libraries/AP_ADC/AP_ADC_ADS1115.cpp.0.o libraries/AP_AHRS/AP_AHRS_DCM.cpp.0.o libraries/AP_AHRS/AP_AHRS_NavEKF.cpp.0.o libraries/AP_AHRS/AP_AHRS_View.cpp.0.o libraries/AP_AHRS/AP_AHRS.cpp.4.o libraries/AP_Airspeed/AP_Airspeed.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_Backend.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_MS4525.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_MS5525.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_SDP3X.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_analog.cpp.0.o libraries/AP_Airspeed/Airspeed_Calibration.cpp.0.o libraries/AP_Baro/AP_Baro_BMP085.cpp.0.o libraries/AP_Baro/AP_Baro_BMP280.cpp.0.o libraries/AP_Baro/AP_Baro_Backend.cpp.0.o libraries/AP_Baro/AP_Baro_DPS280.cpp.0.o libraries/AP_Baro/AP_Baro_FBM320.cpp.0.o libraries/AP_Baro/AP_Baro_HIL.cpp.0.o libraries/AP_Baro/AP_Baro_ICM20789.cpp.0.o libraries/AP_Baro/AP_Baro_KellerLD.cpp.0.o libraries/AP_Baro/AP_Baro_LPS2XH.cpp.0.o libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o libraries/AP_Baro/AP_Baro_UAVCAN.cpp.0.o libraries/AP_Baro/AP_Baro.cpp.4.o libraries/AP_Baro/AP_Baro_SITL.cpp.4.o libraries/AP_BattMonitor/AP_BattMonitor_Analog.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_BLHeliESC.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_Backend.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_Bebop.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus_Maxell.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus_Solo.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_UAVCAN.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor.cpp.4.o libraries/AP_BattMonitor/AP_BattMonitor_Params.cpp.4.o libraries/AP_BoardConfig/AP_BoardConfig.cpp.0.o libraries/AP_BoardConfig/AP_BoardConfig_CAN.cpp.0.o libraries/AP_BoardConfig/board_drivers.cpp.0.o libraries/AP_BoardConfig/canbus.cpp.0.o libraries/AP_BoardConfig/canbus_driver.cpp.0.o libraries/AP_BoardConfig/px4_drivers.cpp.0.o libraries/AP_Common/AP_Common.cpp.0.o libraries/AP_Common/AP_FWVersion.cpp.0.o libraries/AP_Common/Location.cpp.0.o libraries/AP_Common/c++.cpp.0.o libraries/AP_Compass/AP_Compass_AK09916.cpp.0.o libraries/AP_Compass/AP_Compass_AK8963.cpp.0.o libraries/AP_Compass/AP_Compass_BMM150.cpp.0.o libraries/AP_Compass/AP_Compass_Backend.cpp.0.o libraries/AP_Compass/AP_Compass_Calibration.cpp.0.o libraries/AP_Compass/AP_Compass_HIL.cpp.0.o libraries/AP_Compass/AP_Compass_HMC5843.cpp.0.o libraries/AP_Compass/AP_Compass_IST8310.cpp.0.o libraries/AP_Compass/AP_Compass_LIS3MDL.cpp.0.o libraries/AP_Compass/AP_Compass_LSM303D.cpp.0.o libraries/AP_Compass/AP_Compass_LSM9DS1.cpp.0.o libraries/AP_Compass/AP_Compass_MAG3110.cpp.0.o libraries/AP_Compass/AP_Compass_MMC3416.cpp.0.o libraries/AP_Compass/AP_Compass_QMC5883L.cpp.0.o libraries/AP_Compass/AP_Compass_SITL.cpp.0.o libraries/AP_Compass/AP_Compass_UAVCAN.cpp.0.o libraries/AP_Compass/CompassCalibrator.cpp.0.o libraries/AP_Compass/Compass_PerMotor.cpp.0.o libraries/AP_Compass/Compass_learn.cpp.0.o libraries/AP_Compass/AP_Compass.cpp.4.o libraries/AP_Declination/AP_Declination.cpp.0.o libraries/AP_Declination/tables.cpp.0.o libraries/AP_GPS/AP_GPS.cpp.0.o libraries/AP_GPS/AP_GPS_ERB.cpp.0.o libraries/AP_GPS/AP_GPS_GSOF.cpp.0.o libraries/AP_GPS/AP_GPS_MAV.cpp.0.o libraries/AP_GPS/AP_GPS_MTK.cpp.0.o libraries/AP_GPS/AP_GPS_MTK19.cpp.0.o libraries/AP_GPS/AP_GPS_NMEA.cpp.0.o libraries/AP_GPS/AP_GPS_NOVA.cpp.0.o libraries/AP_GPS/AP_GPS_SBF.cpp.0.o libraries/AP_GPS/AP_GPS_SBP.cpp.0.o libraries/AP_GPS/AP_GPS_SBP2.cpp.0.o libraries/AP_GPS/AP_GPS_SIRF.cpp.0.o libraries/AP_GPS/AP_GPS_UAVCAN.cpp.0.o libraries/AP_GPS/AP_GPS_UBLOX.cpp.0.o libraries/AP_GPS/GPS_Backend.cpp.0.o libraries/AP_HAL/Device.cpp.0.o libraries/AP_HAL/HAL.cpp.0.o libraries/AP_HAL/Scheduler.cpp.0.o libraries/AP_HAL/Util.cpp.0.o libraries/AP_HAL/utility/BetterStream.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap_Linux.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap_Nuttx.cpp.0.o libraries/AP_HAL/utility/RingBuffer.cpp.0.o libraries/AP_HAL/utility/Socket.cpp.0.o libraries/AP_HAL/utility/dsm.cpp.0.o libraries/AP_HAL/utility/ftoa_engine.cpp.0.o libraries/AP_HAL/utility/getopt_cpp.cpp.0.o libraries/AP_HAL/utility/print_vprintf.cpp.0.o libraries/AP_HAL/utility/srxl.cpp.0.o libraries/AP_HAL/utility/st24.cpp.0.o libraries/AP_HAL/utility/sumd.cpp.0.o libraries/AP_HAL/utility/utoa_invert.cpp.0.o libraries/AP_HAL_Empty/AnalogIn.cpp.0.o libraries/AP_HAL_Empty/GPIO.cpp.0.o libraries/AP_HAL_Empty/HAL_Empty_Class.cpp.0.o libraries/AP_HAL_Empty/PrivateMember.cpp.0.o libraries/AP_HAL_Empty/RCInput.cpp.0.o libraries/AP_HAL_Empty/RCOutput.cpp.0.o libraries/AP_HAL_Empty/Scheduler.cpp.0.o libraries/AP_HAL_Empty/Semaphores.cpp.0.o libraries/AP_HAL_Empty/Storage.cpp.0.o libraries/AP_HAL_Empty/UARTDriver.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_BMI055.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_BMI160.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Backend.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_HIL.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Invensense.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_L3G4200D.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_LSM9DS0.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_LSM9DS1.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_PX4.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_RST.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Revo.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_SITL.cpp.0.o libraries/AP_InertialSensor/AuxiliaryBus.cpp.0.o libraries/AP_InertialSensor/BatchSampler.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor.cpp.4.o libraries/AP_Math/AP_GeodesicGrid.cpp.0.o libraries/AP_Math/AP_Math.cpp.0.o libraries/AP_Math/crc.cpp.0.o libraries/AP_Math/edc.cpp.0.o libraries/AP_Math/location.cpp.0.o libraries/AP_Math/location_double.cpp.0.o libraries/AP_Math/matrix3.cpp.0.o libraries/AP_Math/matrixN.cpp.0.o libraries/AP_Math/matrix_alg.cpp.0.o libraries/AP_Math/polygon.cpp.0.o libraries/AP_Math/quaternion.cpp.0.o libraries/AP_Math/spline5.cpp.0.o libraries/AP_Math/vector2.cpp.0.o libraries/AP_Math/vector3.cpp.0.o libraries/AP_Mission/AP_Mission.cpp.4.o libraries/AP_NavEKF2/AP_NavEKF2_AirDataFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Control.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_MagFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Measurements.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_OptFlowFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Outputs.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_PosVelFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_RngBcnFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_VehicleStatus.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_core.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF_GyroBias.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2.cpp.4.o libraries/AP_NavEKF3/AP_NavEKF3_AirDataFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Control.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_GyroBias.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_MagFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Measurements.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_OptFlowFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Outputs.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_PosVelFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_RngBcnFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_VehicleStatus.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_core.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3.cpp.4.o libraries/AP_Notify/AP_BoardLED.cpp.0.o libraries/AP_Notify/AP_BoardLED2.cpp.0.o libraries/AP_Notify/AP_Notify.cpp.0.o libraries/AP_Notify/Buzzer.cpp.0.o libraries/AP_Notify/DiscoLED.cpp.0.o libraries/AP_Notify/DiscreteRGBLed.cpp.0.o libraries/AP_Notify/Display.cpp.0.o libraries/AP_Notify/Display_SH1106_I2C.cpp.0.o libraries/AP_Notify/Display_SSD1306_I2C.cpp.0.o libraries/AP_Notify/ExternalLED.cpp.0.o libraries/AP_Notify/Led_Sysfs.cpp.0.o libraries/AP_Notify/MMLPlayer.cpp.0.o libraries/AP_Notify/NCP5623.cpp.0.o libraries/AP_Notify/OreoLED_PX4.cpp.0.o libraries/AP_Notify/PCA9685LED_I2C.cpp.0.o libraries/AP_Notify/PixRacerLED.cpp.0.o libraries/AP_Notify/RCOutputRGBLed.cpp.0.o libraries/AP_Notify/RGBLed.cpp.0.o libraries/AP_Notify/ToneAlarm.cpp.0.o libraries/AP_Notify/ToshibaLED_I2C.cpp.0.o libraries/AP_Notify/UAVCAN_RGB_LED.cpp.0.o libraries/AP_Notify/VRBoard_LED.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_CXOF.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_Onboard.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_PX4Flow.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_Pixart.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_SITL.cpp.0.o libraries/AP_OpticalFlow/OpticalFlow.cpp.0.o libraries/AP_OpticalFlow/OpticalFlow_backend.cpp.0.o libraries/AP_Param/AP_Param.cpp.0.o libraries/AP_Rally/AP_Rally.cpp.4.o libraries/AP_RangeFinder/AP_RangeFinder_BBB_PRU.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Bebop.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Benewake.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LeddarOne.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LightWareI2C.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LightWareSerial.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MAVLink.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MaxsonarI2CXL.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MaxsonarSerialLV.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_NMEA.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_PX4_PWM.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_PulsedLightLRF.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_TeraRangerI2C.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_VL53L0X.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Wasp.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_analog.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_uLanding.cpp.0.o libraries/AP_RangeFinder/RangeFinder.cpp.0.o libraries/AP_RangeFinder/RangeFinder_Backend.cpp.0.o libraries/AP_Scheduler/PerfInfo.cpp.0.o libraries/AP_Scheduler/AP_Scheduler.cpp.4.o libraries/AP_SerialManager/AP_SerialManager.cpp.0.o libraries/AP_Terrain/AP_Terrain.cpp.0.o libraries/AP_Terrain/TerrainGCS.cpp.0.o libraries/AP_Terrain/TerrainIO.cpp.0.o libraries/AP_Terrain/TerrainMission.cpp.0.o libraries/AP_Terrain/TerrainUtil.cpp.0.o libraries/DataFlash/DFMessageWriter.cpp.0.o libraries/DataFlash/DataFlash.cpp.0.o libraries/DataFlash/DataFlash_Backend.cpp.0.o libraries/DataFlash/DataFlash_File_sd.cpp.0.o libraries/DataFlash/DataFlash_MAVLink.cpp.0.o libraries/DataFlash/DataFlash_MAVLinkLogTransfer.cpp.0.o libraries/DataFlash/DataFlash_Revo.cpp.0.o libraries/DataFlash/LogFile.cpp.0.o libraries/DataFlash/DataFlash_File.cpp.4.o libraries/Filter/DerivativeFilter.cpp.0.o libraries/Filter/LowPassFilter.cpp.0.o libraries/Filter/LowPassFilter2p.cpp.0.o libraries/Filter/NotchFilter.cpp.0.o libraries/GCS_MAVLink/GCS.cpp.0.o libraries/GCS_MAVLink/GCS_Common.cpp.0.o libraries/GCS_MAVLink/GCS_DeviceOp.cpp.0.o libraries/GCS_MAVLink/GCS_MAVLink.cpp.0.o libraries/GCS_MAVLink/GCS_Param.cpp.0.o libraries/GCS_MAVLink/GCS_Rally.cpp.0.o libraries/GCS_MAVLink/GCS_ServoRelay.cpp.0.o libraries/GCS_MAVLink/GCS_Signing.cpp.0.o libraries/GCS_MAVLink/GCS_serial_control.cpp.0.o libraries/GCS_MAVLink/MAVLink_routing.cpp.0.o libraries/RC_Channel/RC_Channel.cpp.0.o libraries/RC_Channel/RC_Channels.cpp.0.o libraries/SRV_Channel/SRV_Channel.cpp.0.o libraries/SRV_Channel/SRV_Channel_aux.cpp.0.o libraries/SRV_Channel/SRV_Channels.cpp.0.o libraries/StorageManager/StorageManager.cpp.0.o libraries/AP_Tuning/AP_Tuning.cpp.0.o libraries/AP_RPM/AP_RPM.cpp.0.o libraries/AP_RPM/RPM_Backend.cpp.0.o libraries/AP_RPM/RPM_PX4_PWM.cpp.0.o libraries/AP_RPM/RPM_Pin.cpp.0.o libraries/AP_RPM/RPM_SITL.cpp.0.o libraries/AP_RSSI/AP_RSSI.cpp.0.o libraries/AP_Mount/AP_Mount.cpp.0.o libraries/AP_Mount/AP_Mount_Alexmos.cpp.0.o libraries/AP_Mount/AP_Mount_Backend.cpp.0.o libraries/AP_Mount/AP_Mount_SToRM32.cpp.0.o libraries/AP_Mount/AP_Mount_SToRM32_serial.cpp.0.o libraries/AP_Mount/AP_Mount_Servo.cpp.0.o libraries/AP_Mount/AP_Mount_SoloGimbal.cpp.0.o libraries/AP_Mount/SoloGimbal.cpp.0.o libraries/AP_Mount/SoloGimbalEKF.cpp.0.o libraries/AP_Mount/SoloGimbal_Parameters.cpp.0.o libraries/AP_Module/AP_Module.cpp.0.o libraries/AP_Button/AP_Button.cpp.0.o libraries/AP_ICEngine/AP_ICEngine.cpp.0.o libraries/AP_Frsky_Telem/AP_Frsky_Telem.cpp.0.o libraries/AP_FlashStorage/AP_FlashStorage.cpp.0.o libraries/AP_Relay/AP_Relay.cpp.0.o libraries/AP_ServoRelayEvents/AP_ServoRelayEvents.cpp.0.o libraries/AP_Volz_Protocol/AP_Volz_Protocol.cpp.0.o libraries/AP_SBusOut/AP_SBusOut.cpp.0.o libraries/AP_IOMCU/AP_IOMCU.cpp.0.o libraries/AP_IOMCU/fw_uploader.cpp.0.o libraries/AP_RAMTRON/AP_RAMTRON.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_Backend.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_DSM.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_PPMSum.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SBUS.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SRXL.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_ST24.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SUMD.cpp.0.o libraries/AP_RCProtocol/SoftSerial.cpp.0.o libraries/AP_Radio/AP_Radio.cpp.0.o libraries/AP_Radio/AP_Radio_backend.cpp.0.o libraries/AP_Radio/AP_Radio_cc2500.cpp.0.o libraries/AP_Radio/AP_Radio_cypress.cpp.0.o libraries/AP_Radio/driver_cc2500.cpp.0.o libraries/AP_TempCalibration/AP_TempCalibration.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom_Backend.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom_MAV.cpp.0.o libraries/AP_BLHeli/AP_BLHeli.cpp.4.o libraries/AP_ROMFS/AP_ROMFS.cpp.0.o libraries/AP_ROMFS/tinfgzip.cpp.0.o libraries/AP_ROMFS/tinflate.cpp.0.o libraries/AP_Proximity/AP_Proximity.cpp.0.o libraries/AP_Proximity/AP_Proximity_Backend.cpp.0.o libraries/AP_Proximity/AP_Proximity_LightWareSF40C.cpp.0.o libraries/AP_Proximity/AP_Proximity_MAV.cpp.0.o libraries/AP_Proximity/AP_Proximity_RPLidarA2.cpp.0.o libraries/AP_Proximity/AP_Proximity_RangeFinder.cpp.0.o libraries/AP_Proximity/AP_Proximity_SITL.cpp.0.o libraries/AP_Proximity/AP_Proximity_TeraRangerTower.cpp.0.o libraries/AP_Proximity/AP_Proximity_TeraRangerTowerEvo.cpp.0.o libraries/AP_Gripper/AP_Gripper.cpp.0.o libraries/AP_Gripper/AP_Gripper_Backend.cpp.0.o libraries/AP_Gripper/AP_Gripper_EPM.cpp.0.o libraries/AP_Gripper/AP_Gripper_Servo.cpp.0.o libraries/AP_RTC/AP_RTC.cpp.0.o libraries/AP_ADSB/AP_ADSB.cpp.4.o libraries/AC_AttitudeControl/AC_AttitudeControl_Heli.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl_Multi.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl_Sub.cpp.0.o libraries/AC_AttitudeControl/AC_PosControl_Sub.cpp.0.o libraries/AC_AttitudeControl/ControlMonitor.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl.cpp.4.o libraries/AC_AttitudeControl/AC_PosControl.cpp.4.o libraries/AC_InputManager/AC_InputManager.cpp.0.o libraries/AC_InputManager/AC_InputManager_Heli.cpp.0.o libraries/AC_Fence/AC_Fence.cpp.0.o libraries/AC_Fence/AC_PolyFence_loader.cpp.0.o libraries/AC_Avoidance/AC_Avoid.cpp.4.o libraries/AC_PID/AC_HELI_PID.cpp.0.o libraries/AC_PID/AC_P.cpp.0.o libraries/AC_PID/AC_PID.cpp.0.o libraries/AC_PID/AC_PID_2D.cpp.0.o libraries/AC_PID/AC_PI_2D.cpp.0.o libraries/AC_PrecLand/AC_PrecLand.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_Companion.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_IRLock.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_SITL.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_SITL_Gazebo.cpp.0.o libraries/AC_PrecLand/PosVelEKF.cpp.0.o libraries/AC_Sprayer/AC_Sprayer.cpp.0.o libraries/AC_WPNav/AC_Circle.cpp.0.o libraries/AC_WPNav/AC_Loiter.cpp.0.o libraries/AC_WPNav/AC_WPNav.cpp.0.o libraries/AP_Camera/AP_Camera.cpp.0.o libraries/AP_IRLock/AP_IRLock_I2C.cpp.0.o libraries/AP_IRLock/AP_IRLock_SITL.cpp.0.o libraries/AP_IRLock/IRLock.cpp.0.o libraries/AP_InertialNav/AP_InertialNav_NavEKF.cpp.0.o libraries/AP_LandingGear/AP_LandingGear.cpp.0.o libraries/AP_Menu/AP_Menu.cpp.0.o libraries/AP_Motors/AP_Motors6DOF.cpp.0.o libraries/AP_Motors/AP_MotorsCoax.cpp.0.o libraries/AP_Motors/AP_MotorsHeli.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Dual.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Quad.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_RSC.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Single.cpp.0.o libraries/AP_Motors/AP_MotorsMatrix.cpp.0.o libraries/AP_Motors/AP_MotorsMulticopter.cpp.0.o libraries/AP_Motors/AP_MotorsSingle.cpp.0.o libraries/AP_Motors/AP_MotorsTri.cpp.0.o libraries/AP_Motors/AP_Motors_Class.cpp.0.o libraries/AP_Motors/AP_MotorsTailsitter.cpp.4.o libraries/AP_Parachute/AP_Parachute.cpp.0.o libraries/AP_RCMapper/AP_RCMapper.cpp.0.o libraries/AP_Avoidance/AP_Avoidance.cpp.4.o libraries/AP_AdvancedFailsafe/AP_AdvancedFailsafe.cpp.0.o libraries/AP_SmartRTL/AP_SmartRTL.cpp.0.o libraries/AP_Stats/AP_Stats.cpp.0.o libraries/AP_Beacon/AP_Beacon.cpp.0.o libraries/AP_Beacon/AP_Beacon_Backend.cpp.0.o libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o libraries/AP_Beacon/AP_Beacon_Pozyx.cpp.0.o libraries/AP_Beacon/AP_Beacon_SITL.cpp.0.o libraries/AP_Arming/AP_Arming.cpp.4.o libraries/AP_WheelEncoder/AP_WheelEncoder.cpp.0.o libraries/AP_WheelEncoder/WheelEncoder_Backend.cpp.0.o libraries/AP_WheelEncoder/WheelEncoder_Quadrature.cpp.0.o libraries/AP_Winch/AP_Winch.cpp.0.o libraries/AP_Winch/AP_Winch_Servo.cpp.0.o libraries/AP_Follow/AP_Follow.cpp.0.o libraries/AP_Devo_Telem/AP_Devo_Telem.cpp.0.o libraries/AP_OSD/AP_OSD.cpp.0.o libraries/AP_OSD/AP_OSD_Backend.cpp.0.o libraries/AP_OSD/AP_OSD_MAX7456.cpp.0.o libraries/AP_OSD/AP_OSD_SITL.cpp.0.o libraries/AP_OSD/AP_OSD_Screen.cpp.0.o libraries/AP_OSD/AP_OSD_Setting.cpp.0.o libraries/AP_HAL_Linux/AnalogIn_ADS1115.cpp.0.o libraries/AP_HAL_Linux/AnalogIn_IIO.cpp.0.o libraries/AP_HAL_Linux/AnalogIn_Navio2.cpp.0.o libraries/AP_HAL_Linux/CAN.cpp.0.o libraries/AP_HAL_Linux/CameraSensor.cpp.0.o libraries/AP_HAL_Linux/CameraSensor_Mt9v117.cpp.0.o libraries/AP_HAL_Linux/CameraSensor_Mt9v117_Patches.cpp.0.o libraries/AP_HAL_Linux/ConsoleDevice.cpp.0.o libraries/AP_HAL_Linux/Flow_PX4.cpp.0.o libraries/AP_HAL_Linux/GPIO.cpp.0.o libraries/AP_HAL_Linux/GPIO_Aero.cpp.0.o libraries/AP_HAL_Linux/GPIO_BBB.cpp.0.o libraries/AP_HAL_Linux/GPIO_Bebop.cpp.0.o libraries/AP_HAL_Linux/GPIO_Disco.cpp.0.o libraries/AP_HAL_Linux/GPIO_Edge.cpp.0.o libraries/AP_HAL_Linux/GPIO_Navio.cpp.0.o libraries/AP_HAL_Linux/GPIO_Navio2.cpp.0.o libraries/AP_HAL_Linux/GPIO_RPI.cpp.0.o libraries/AP_HAL_Linux/GPIO_Sysfs.cpp.0.o libraries/AP_HAL_Linux/HAL_Linux_Class.cpp.0.o libraries/AP_HAL_Linux/Heat_Pwm.cpp.0.o libraries/AP_HAL_Linux/I2CDevice.cpp.0.o libraries/AP_HAL_Linux/Led_Sysfs.cpp.0.o libraries/AP_HAL_Linux/OpticalFlow_Onboard.cpp.0.o libraries/AP_HAL_Linux/PWM_Sysfs.cpp.0.o libraries/AP_HAL_Linux/Perf.cpp.0.o libraries/AP_HAL_Linux/Perf_Lttng.cpp.0.o libraries/AP_HAL_Linux/Poller.cpp.0.o libraries/AP_HAL_Linux/PollerThread.cpp.0.o libraries/AP_HAL_Linux/RCInput.cpp.0.o libraries/AP_HAL_Linux/RCInput_115200.cpp.0.o libraries/AP_HAL_Linux/RCInput_AioPRU.cpp.0.o libraries/AP_HAL_Linux/RCInput_Multi.cpp.0.o libraries/AP_HAL_Linux/RCInput_Navio2.cpp.0.o libraries/AP_HAL_Linux/RCInput_PRU.cpp.0.o libraries/AP_HAL_Linux/RCInput_RPI.cpp.0.o libraries/AP_HAL_Linux/RCInput_SBUS.cpp.0.o libraries/AP_HAL_Linux/RCInput_SoloLink.cpp.0.o libraries/AP_HAL_Linux/RCInput_UART.cpp.0.o libraries/AP_HAL_Linux/RCInput_UDP.cpp.0.o libraries/AP_HAL_Linux/RCInput_ZYNQ.cpp.0.o libraries/AP_HAL_Linux/RCOutput_AeroIO.cpp.0.o libraries/AP_HAL_Linux/RCOutput_AioPRU.cpp.0.o libraries/AP_HAL_Linux/RCOutput_Bebop.cpp.0.o libraries/AP_HAL_Linux/RCOutput_Disco.cpp.0.o libraries/AP_HAL_Linux/RCOutput_PCA9685.cpp.0.o libraries/AP_HAL_Linux/RCOutput_PRU.cpp.0.o libraries/AP_HAL_Linux/RCOutput_Sysfs.cpp.0.o libraries/AP_HAL_Linux/RCOutput_ZYNQ.cpp.0.o libraries/AP_HAL_Linux/SPIDevice.cpp.0.o libraries/AP_HAL_Linux/SPIUARTDriver.cpp.0.o libraries/AP_HAL_Linux/Semaphores.cpp.0.o libraries/AP_HAL_Linux/TCPServerDevice.cpp.0.o libraries/AP_HAL_Linux/Thread.cpp.0.o libraries/AP_HAL_Linux/ToneAlarm.cpp.0.o libraries/AP_HAL_Linux/ToneAlarm_Disco.cpp.0.o libraries/AP_HAL_Linux/UARTDevice.cpp.0.o libraries/AP_HAL_Linux/UARTDriver.cpp.0.o libraries/AP_HAL_Linux/UDPDevice.cpp.0.o libraries/AP_HAL_Linux/Util.cpp.0.o libraries/AP_HAL_Linux/Util_RPI.cpp.0.o libraries/AP_HAL_Linux/VideoIn.cpp.0.o libraries/AP_HAL_Linux/sbus.cpp.0.o libraries/AP_HAL_Linux/system.cpp.0.o libraries/AP_HAL_Linux/Scheduler.cpp.4.o libraries/AP_HAL_Linux/Storage.cpp.4.o

 -obin/arducopter -Wl,-Bdynamic -lm -ldl

alias waf="$PWD/modules/waf/waf-light"
waf --targets bin/arducopter -v

Angelina Instrumentation
example/Makefile for main.cpp:
-g will add line number main.cpp:xxx information.
-O3 without -g will lead to less BB number

try no -flto? no optimization? can't. need to for linking.

link:
pi:
clang++ -fuse-ld=gold -flto -Wl,--gc-sections -pthread --sysroot=/ --gcc-toolchain=/usr -B/usr/bin /home/pi/llvm/csi/toolkit/code-coverage.o /home/pi/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a ...... -obin/arducopter -Wl,-Bdynamic -lm -ldl

cross:
clang++ -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/ --gcc-toolchain=/usr -B/usr/bin /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a .... -obin/arducopter -Wl,-Bdynamic -lm -ldl


clang++ -fuse-ld=gold -flto -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/usr -B/usr/bin /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a ....  -obin/arducopter -Wl,-Bdynamic -lm -ldl

test easy cross compile with main instrumentation now

clang++ -std=gnu++11 -g -O0 -fcsi -emit-llvm -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6 -MMD --target=arm-linux-gnueabihf --gcc-toolchain=/usr --sysroot=/ -B/usr/bin -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing ../../ArduCopter/version.cpp -c -oArduCopter/version.cpp.22.o

compile object code:
clang++ -std=gnu++11 -g -O0 -fcsi -emit-llvm -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall --sysroot=/media/rpi -MMD --target=arm-linux-gnueabihf ./main.cpp -c -o main.o

g++:
-fdata-sections: generation of one ELF section for each variable in the source file
-ffunction-sections: generates a separate ELF section for each function in the source file. The unused section elimination feature of the linker can then remove unused functions at link time.
-fno-exceptions: disables the generation of code needed to support C++ exceptions. Use of try, catch, or throw results in an error message.
-fsigned-char: Instructs the compiler to compile type char as signed

clang:
-B<dir>, --prefix <arg>, --prefix=<arg>
Add <dir> to search path for binaries and object files used implicitly

options for preprocessor
-M
Instead of outputting the result of preprocessing, output a rule suitable for make describing the dependencies of the main source file. The preprocessor outputs one make rule containing the object file name for that source file, a colon, and the names of all the included files, including those coming from -include or -imacros command-line options.
Unless specified explicitly (with -MT or -MQ), the object file name consists of the name of the source file with any suffix replaced with object file suffix and with any leading directory parts removed. If there are many included files then the rule is split into several lines using ‘\’-newline. The rule has no commands.
This option does not suppress the preprocessor’s debug output, such as -dM. To avoid mixing such debug output with the dependency rules you should explicitly specify the dependency output file with -MF, or use an environment variable like DEPENDENCIES_OUTPUT (see Environment Variables). Debug output is still sent to the regular output stream as normal.
Passing -M to the driver implies -E, and suppresses warnings with an implicit -w.
-MF file
When used with -M or -MM, specifies a file to write the dependencies to. If no -MF switch is given the preprocessor sends the rules to the same place it would send preprocessed output.
When used with the driver options -MD or -MMD, -MF overrides the default dependency output file.
If file is -, then the dependencies are written to stdout.
-MD
-MD is equivalent to -M -MF file, except that -E is not implied. The driver determines file based on whether an -o option is given. If it is, the driver uses its argument but with a suffix of .d, otherwise it takes the name of the input file, removes any directory components and suffix, and applies a .d suffix.
-MMD
Like -MD except mention only user header files, not system header files.
-E
If you use the -E option, nothing is done except preprocessing. 

link objects:
clang++ -fuse-ld=gold -flto -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/usr /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a main.o -o main -Wl,-Bdynamic -lm -ldl

linker needs --gcc-toolchain=/usr while compiler dont. why?

--gcc-toolchain=<arg>, -gcc-toolchain <arg>
Use the gcc toolchain at the given directory

so use gcc toolchain ld.gold?

configure:
alias waf="$PWD/modules/waf/waf-light"
CC=clang CXX=clang++ CXXFLAGS="--sysroot=/media/rpi --gcc-toolchain=/usr" waf configure --board=navio2 -v
waf --targets bin/arducopter -v

generate script to compile all .cpp to .o now

-include include header files to define #define symbols

clang++ -std=gnu++11 -g -O0 -fcsi -emit-llvm -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 --sysroot=/media/rpi -MMD --target=arm-linux-gnueabihf --gcc-toolchain=/usr -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing ../../ArduCopter/version.cpp -c -oArduCopter/version.cpp.22.o

following will find isinf isnan lib while above won't.
CC=clang CXX=clang++ CXXFLAGS="--sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6" waf configure --board=navio2 

so i guess --gcc-toolchain=/media/rpi/usr is correct for compiler? bc lib it needs are on rpi3? and --gcc-toolchain=/usr for linker? if use --gcc-toolchain=/media/rpi/usr for linker, (.text+0xc): undefined reference to `__dlopen'. if use --gcc-toolchain=/usr for compiler, then isnan undefined.

working version:
11:38:02 runner ['clang++', '-std=gnu++11', '-fdata-sections', '-ffunction-sections', '-fno-exceptions', '-fsigned-char', '-O0', '--sysroot=/media/rpi', '--gcc-toolchain=/media/rpi/usr', '-I/media/rpi/usr/include/arm-linux-gnueabihf', '-I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6', '-MMD', '--target=arm-linux-gnueabihf', '-B/usr/bin', '-include', 'ap_config.h', '-Ilibraries', '-Ilibraries/GCS_MAVLink', '-I.', '-I../../libraries', '-I../../libraries/AP_Common/missing', '-DSKETCHBOOK="/home/osboxes/Desktop/ardupilot"', '-DCONFIG_HAL_BOARD=HAL_BOARD_LINUX', '-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2', '-DFRAME_CONFIG=MULTICOPTER_FRAME', '-DAPM_BUILD_DIRECTORY=APM_BUILD_ArduCopter', '-DSKETCH="ArduCopter"', '-DSKETCHNAME="ArduCopter"', '../../ArduCopter/terrain.cpp', '-c', '-oArduCopter/terrain.cpp.22.o']

real location of libdl.so of rpi
readelf -s /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so 
/media/rpi/lib/arm-linux-gnueabihf/libm-2.24.so

adding this two to replace ldl lm -> -Wl,-Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so /media/rpi/lib/arm-linux-gnueabihf/libm-2.24.so
works, so now can use --gcc-toolchain=/media/rpi/usr for linker!

so now lets link the llvm fcsi again!

COMPILE:
12:15:26 runner ['clang++', '-std=gnu++11', '-fdata-sections', '-ffunction-sections', '-fno-exceptions', '-fsigned-char', '-O0', '--sysroot=/media/rpi', '--gcc-toolchain=/media/rpi/usr', '-I/media/rpi/usr/include/arm-linux-gnueabihf', '-I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6', '-MMD', '--target=arm-linux-gnueabihf', '-include', 'ap_config.h', '-Ilibraries', '-Ilibraries/GCS_MAVLink', '-I.', '-I../../libraries', '-I../../libraries/AP_Common/missing', '-DSKETCHBOOK="/home/osboxes/Desktop/ardupilot"', '-DCONFIG_HAL_BOARD=HAL_BOARD_LINUX', '-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2', '../../libraries/AP_Gripper/AP_Gripper_Servo.cpp', '-c', '-olibraries/AP_Gripper/AP_Gripper_Servo.cpp.0.o']

--> added  '-fcsi', '-emit-llvm' to cxxflags, forget '-g', add '-g' later for line number and src code information

12:17:06 runner ['clang++', '-std=gnu++11', '-fcsi', '-emit-llvm', '-fdata-sections', '-ffunction-sections', '-fno-exceptions', '-fsigned-char', '-O0', '--sysroot=/media/rpi', '--gcc-toolchain=/media/rpi/usr', '-I/media/rpi/usr/include/arm-linux-gnueabihf', '-I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6', '-MMD', '--target=arm-linux-gnueabihf', '-include', 'ap_config.h', '-Ilibraries', '-Ilibraries/GCS_MAVLink', '-I.', '-I../../libraries', '-I../../libraries/AP_Common/missing', '-DSKETCHBOOK="/home/osboxes/Desktop/ardupilot"', '-DCONFIG_HAL_BOARD=HAL_BOARD_LINUX', '-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2', '../../libraries/AP_Compass/AP_Compass_QMC5883L.cpp', '-c', '-olibraries/AP_Compass/AP_Compass_QMC5883L.cpp.0.o']

LINK:
clang++ -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a 
...
 -obin/arducopter -Wl,-Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so /media/rpi/lib/arm-linux-gnueabihf/libm-2.24.so

error:
/home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a(csirt.c.o)(.ARM.exidx+0x0): error: undefined reference to '__aeabi_unwind_cpp_pr0'
/tmp/lto-llvm-e2baeb.o(.ARM.exidx+0x0): error: undefined reference to '__aeabi_unwind_cpp_pr0'
/tmp/lto-llvm-e2baeb.o(.ARM.exidx+0x8): error: undefined reference to '__aeabi_unwind_cpp_pr1'
/tmp/lto-llvm-e2baeb.o(.ARM.exidx+0x10): error: undefined reference to '__aeabi_unwind_cpp_pr1'
/tmp/lto-llvm-e2baeb.o(.ARM.exidx+0x20): error: undefined reference to '__aeabi_unwind_cpp_pr0'
/tmp/lto-llvm-e2baeb.o(.ARM.exidx+0x30): error: undefined reference to '__aeabi_unwind_cpp_pr0'
clang-3.9: error: linker command failed with exit code 1 (use -v to see invocation)

i guess dynamic lib have not been found correctly. symbols inside /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a 
readelf -s gives me undef symbols:
    44: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND realloc
    45: 00000000     0 NOTYPE  WEAK   DEFAULT  UND __csi_unit_init
    46: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND malloc
    47: 00000000     0 NOTYPE  WEAK   DEFAULT  UND __csi_init
    48: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND __aeabi_unwind_cpp_pr0

__aeabi_unwind_cpp_pr0 belongs to c++ exception handling libs. so need to link c++ runtime lib. add -std=gnu++11 to linker flags to add runtime lib maybe?

lets try:
clang++ -std=gnu++11 -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a 
...
 -obin/arducopter -Wl,-Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so /media/rpi/lib/arm-linux-gnueabihf/libm-2.24.so

btw: i link all those 500+ llvm objects to one libarducopter.o using llvm-link

errors:
/usr/bin/arm-linux-gnueabihf-ld.gold: error: cannot open /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/libm.so: No such file or directory
/usr/bin/arm-linux-gnueabihf-ld.gold: error: cannot open /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/libgcc_s.so.1: No such file or directory
/usr/bin/arm-linux-gnueabihf-ld.gold: error: cannot open /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/libgcc_s.so.1: No such file or directory
/usr/bin/arm-linux-gnueabihf-ld.gold: warning: LLVM gold plugin: Linking two modules of different target triples: libarducopter.o' is 'armv6kz--linux-gnueabihf' whereas 'ld-temp.o' is 'armv7-unknown-linux-gnueabihf'

with / w/o -std=gnu++11. guess llvm-link not working as expected?

so the issue actually is "What is the most practical way to compile against a mounted foreign filesystem full of absolute symlinks"

osboxes@osboxes:/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0$ readelf -s /media/rpi/lib/arm-linux-gnueabihf/libgcc_s.so.1 | grep __aeabi_unwind_cpp_pr0
    81: 0001a69c     8 FUNC    GLOBAL DEFAULT   12 __aeabi_unwind_cpp_pr0@@GCC_3.5

now trying:
clang++ -std=gnu++11 -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.o  -obin/arducopter -Wl,-Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so /media/rpi/lib/arm-linux-gnueabihf/libm-2.24.so /media/rpi/lib/arm-linux-gnueabihf/libgcc_s.so.1

after changing abs path to relative path and add -v:
 "/usr/bin/arm-linux-gnueabihf-ld.gold" --sysroot=/media/rpi -z relro -X --hash-style=gnu --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/media/rpi/lib/arm-linux-gnueabihf -L/media/rpi/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf -L/media/rpi/usr/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf/../../lib -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/media/rpi/lib -L/media/rpi/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=arm1176jzf-s --gc-sections /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.o -Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

This method still segfault:
(gdb) run
Starting program: /home/pi/arducopter 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/arm-linux-gnueabihf/libthread_db.so.1".

Program received signal SIGSEGV, Segmentation fault.
0x0005445c in Bitset::set (this=0x0) at ./bitset.h:52
52	        _data[elt] |= 1 << off;


change '-emit-llvm' to -flto but keeping fcsi
according to https://llvm.org/docs/GoldPlugin.html
ar q libarducopter.a ... -> create .a
clang++ -std=gnu++11 -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.a  -obin/arducopter2 -Wl,-Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so

/usr/bin/arm-linux-gnueabihf-ld.gold: error: libarducopter.a: no archive symbol table (run ranlib)
/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o(.text+0x34): error: undefined reference to 'main'
clang-3.9: error: linker command failed with exit code 1 (use -v to see invocation)

guess need to use llvm-ar and change target
llvm-ar --target=arm-linux-gnueabihf libarducopter.a ...
cannot recognize target, guess no need to tweak? lets try
llvm-ar q libarducopter.a ...
finished w/o warning and can work with following. Good!
clang++ -std=gnu++11 -fuse-ld=gold -flto -Wl,--gc-sections -pthread --target=arm-linux-gnueabihf --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.a  -obin/arducopter2 -Wl,-Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so

this also segfault..

maybe its issue with bitset.h?? lets try printf without logging any information.

-v 
 "/usr/bin/arm-linux-gnueabihf-ld.gold" --sysroot=/media/rpi -z relro -X --hash-style=gnu --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter2 /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/media/rpi/lib/arm-linux-gnueabihf -L/media/rpi/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf -L/media/rpi/usr/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf/../../lib -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/media/rpi/lib -L/media/rpi/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=arm1176jzf-s --gc-sections /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.a -Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

--gc-sections
--no-gc-sections
Enable garbage collection of unused input sections. It is ignored on targets that do not support this option. The default behaviour (of not performing this garbage collection) can be restored by specifying `--no-gc-sections' on the command line. Note that garbage collection for COFF and PE format targets is supported, but the implementation is currently considered to be experimental.
`--gc-sections' decides which input sections are used by examining symbols and relocations. The section containing the entry symbol and all sections containing symbols undefined on the command-line will be kept, as will sections containing symbols referenced by dynamic objects. Note that when building shared libraries, the linker must assume that any visible symbol is referenced. Once this initial set of sections has been determined, the linker recursively marks as used any section referenced by their relocations. See `--entry' and `--undefined'.
This option can be set when doing a partial link (enabled with option `-r'). In this case the root of symbols kept must be explicitly specified either by an `--entry' or `--undefined' option or by a ENTRY command in the linker script.

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0301h/I1022730.html
ARM1176JZF-S instruction set summary
The ARM1176JZF-S processor implements the ARM architecture v6 with ARM Jazelle technology.

/tmp/lto-llvm-001f8b.o:ld-temp.o:function csirt.unit_ctor: error: undefined reference to '__csirt_unit_init'
/tmp/lto-llvm-001f8b.o:ld-temp.o:function csirt.unit_ctor.17: error: undefined reference to '__csirt_unit_init'
/tmp/lto-llvm-001f8b.o:ld-temp.o:function csirt.unit_ctor.45: error: undefined reference to '__csirt_unit_init'
/tmp/lto-llvm-001f8b.o:ld-temp.o:function csirt.unit_ctor.90: error: undefined reference to '__csirt_unit_init'

why? after change code-coverage.o. weild!

linker on pi:
 "/usr/bin/ld.gold" -X --hash-style=both --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o main /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/home/pi/llvm/build/bin/../lib -L/lib/arm-linux-gnueabihf -L/lib/../lib -L/usr/lib/arm-linux-gnueabihf -L/usr/lib/../lib -L/usr/lib/arm-linux-gnueabihf/../../lib -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/home/pi/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/pi/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=cortex-a8 -plugin-opt=O0 main.o ../toolkit/code-coverage.o ../../build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a -lstdc++ -lm -lgcc_s -lgcc -lc -lgcc_s -lgcc /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

tweak?
 /usr/bin/arm-linux-gnueabihf-ld.gold --sysroot=/media/rpi -z relro -X --hash-style=both --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter2 /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/media/rpi/lib/arm-linux-gnueabihf -L/media/rpi/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf -L/media/rpi/usr/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf/../../lib -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/media/rpi/lib -L/media/rpi/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=cortex-a8 -plugin-opt=O0 /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.a -Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

-z keyword
`relro'
Create an ELF PT_GNU_RELRO segment header in the object. 

/tmp/lto-llvm-008f39.o:ld-temp.o:function csirt.unit_ctor: error: undefined reference to '__csirt_unit_init'
/tmp/lto-llvm-008f39.o:ld-temp.o:function csirt.unit_ctor.17: error: undefined reference to '__csirt_unit_init'
/tmp/lto-llvm-008f39.o:ld-temp.o:function csirt.unit_ctor.45: error: undefined reference to '__csirt_unit_init'
/tmp/lto-llvm-008f39.o:ld-temp.o:function csirt.unit_ctor.90: error: undefined reference to '__csirt_unit_init'

but fast now! so -O0 stops lto i guess.

scp pi@192.168.0.158:/home/pi/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/code-coverage.o

after changing back to original code-coverage than my printf, it works. wield.

same error.

Starting program: /home/pi/arducopter2 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/arm-linux-gnueabihf/libthread_db.so.1".

Program received signal SIGSEGV, Segmentation fault.
0x01b36bc8 in Bitset::set (this=0x0, bit=0) at ./bitset.h:52
52	        _data[elt] |= 1 << off;

merge printf and original, lets see if it can find symbols now.
still cant find. so weild.

get rid of pthread?

lets try with rpi3 link.
 "/usr/bin/ld.gold" -X --hash-style=both --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter3 /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/home/pi/llvm/build/bin/../lib -L/lib/arm-linux-gnueabihf -L/lib/../lib -L/usr/lib/arm-linux-gnueabihf -L/usr/lib/../lib -L/usr/lib/arm-linux-gnueabihf/../../lib -L/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/home/pi/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/pi/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=cortex-a8 -plugin-opt=O0 /home/pi/llvm/csi/toolkit/code-coverage.o /home/pi/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a libarducopter.a -lstdc++ -lm -lgcc_s -lgcc -lc -lgcc_s -lgcc -lpthread /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

prerequisite:
export PATH=/home/pi/llvm/build/bin:$PATH
waf --targets bin/arducopter -v
llvm-ar q libarducopter.a

tweal position of .o and .a works!:
 /usr/bin/arm-linux-gnueabihf-ld.gold --sysroot=/media/rpi -z relro -X --hash-style=both --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter2 /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/media/rpi/lib/arm-linux-gnueabihf -L/media/rpi/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf -L/media/rpi/usr/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf/../../lib -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/media/rpi/lib -L/media/rpi/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=cortex-a8 -plugin-opt=O0 libarducopter.a /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a -Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

https://cgold.readthedocs.io/en/latest/tutorials/libraries/symbols/link-order.html
All files passed to linker processed from left to right
Linker collects undefined symbols from files to the pool of undefined symbols
If object from archive doesn’t resolve any symbols from pool of undefined symbols, then it dropped!

printf works now!

lets find out how to start arducopter:
/etc/systemd/system/arducopter.service

[Unit]
Description=ArduPilot for Linux
After=systemd-modules-load.service
Documentation=https://docs.emlid.com/navio2/navio-ardupilot/installation-and-running/#autostarting-ardupilot-on-boot
Conflicts=ardupilot.service arduplane.service ardurover.service ardusub.service

[Service]
EnvironmentFile=/etc/default/arducopter

###############################################################################
####### DO NOT EDIT ABOVE THIS LINE UNLESS YOU KNOW WHAT YOU"RE DOING #########
###############################################################################

ExecStart=/bin/sh -c "/usr/bin/arducopter ${ARDUPILOT_OPTS}"

##### CAUTION ######
# There should be only one uncommented ExecStart in this file
# Comment out unused ExecStart. 

###############################################################################
######## DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU"RE DOING ########
###############################################################################

Restart=on-failure

[Install]
WantedBy=multi-user.target

sudo nano /etc/default/arducopter 
tweaks ARDUPILOT_OPTS

pi@navio:~ $ cat /etc/default/arducopter 
# Default settings for ArduPilot for Linux.
# The file is sourced by systemd from arducopter.service

TELEM1="-A udp:127.0.0.1:14550"
#TELEM2="-C /dev/ttyAMA0"

# Options to pass to ArduPilot
ARDUPILOT_OPTS="$TELEM1 $TELEM2"

                          #    # ###### #      #####  
                          #    # #      #      #    # 
                          ###### #####  #      #    # 
                          #    # #      #      #####  
                          #    # #      #      #      
                          #    # ###### ###### #      
                                                      
# -A is a console switch (usually this is a Wi-Fi link)

# -C is a telemetry switch
# Usually this is either /dev/ttyAMA0 - UART connector on your Navio 
# or /dev/ttyUSB0 if you're using a serial to USB convertor 

# -B or -E is used to specify non default GPS

# Type "emlidtool ardupilot" for further help

pi@navio:~ $ TELEM1="-A udp:192.168.0.174:14550"
pi@navio:~ $ sudo arducopter $TELEM1
Raspberry Pi 3 Model B Rev 1.2. (intern: 2)
MS5611 found on bus 1 address 0x77
MPU: temp reset IMU[0] 8971 6372

starts it!

https://docs.emlid.com/navio2/common/ardupilot/installation-and-running/
Mapping between switches and serial ports (TCP or UDP can be used instead of serial ports):

-A - serial 0 (always console; default baud rate 115200)
-C - serial 1 (normally telemetry 1; default baud rate 57600)
3DR Radios are configured for 57600 by default, so the simplest way to connect over them is to run with -C option.
-D - serial 2 (normally telemetry 2; default baud rate 57600)
-B - serial 3 (normally 1st GPS; default baud rate 38400)
-E - serial 4 (normally 2st GPS; default baud rate 38400)
http://ardupilot.org/copter/docs/parameters.html?highlight=serial#serial-parameters

3 options for GCS(ground control station):
QGroundControl¶
A crossplatform ground station for Mavlink-based flight stacks (like Ardupilot). It can be downloaded from the qgroundcontrol.com

APM Planner¶
APM Planner is a ground station software for ArduPilot. It can be downloaded from the ardupilot.com
APM Planner listens on UDP port 14550, so it should catch telemetry from the drone automatically. Also, if you are using linux, you have to add your user to dialout group '''sudo adduser $USER dialout'''

MAVProxy¶
MAVProxy is a console-oriented ground station software written in Python. It’s well suited for advanced users and developers.
To install MAVProxy use Download and Installation instructions.
To run it specify the --master port, which can be serial, TCP or UDP. It also can perform data passthrough using --out option.
pi@navio: ~ $ mavproxy.py --master 192.168.1.2:14550 --console
Where 192.168.1.2 is the IP address of the GCS, not RPi.


MAVProxy is used in SITL sim
mavproxy.py --master 192.168.0.174:14550 --console
on host can see the same platform.

remember to use ethernet cable on mac so it can find rpi3 in same subdomain.

script to switch btw sim and real and have fun:
real:
use ./ardupilot/build/c4che/navio2_cache.py
alias waf="$PWD/modules/waf/waf-light"
waf --targets bin/arducopter -v
llvm-ar q libarducopter.a ...
 /usr/bin/arm-linux-gnueabihf-ld.gold --sysroot=/media/rpi -z relro -X --hash-style=both --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter2 /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/media/rpi/lib/arm-linux-gnueabihf -L/media/rpi/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf -L/media/rpi/usr/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf/../../lib -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/media/rpi/lib -L/media/rpi/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=cortex-a8 -plugin-opt=O0 libarducopter.a /home/osboxes/Desktop/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a -Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

sim:
location of file ./Tools/autotest/sim_vehicle.py
sim_vehicle.py --map --console

lets find out how to instrument sim_vehicle.py compiler arducopter

guess i need to change sitl_cache.py
1. add fcsi flto to cxxflags
2. change compiler to clang
3. change ar to llvm-ar
4. change linker 
5. change linker flags

CC=clang CXX=clang++ sim_vehicle.py --map --console

change sim_vehicle.py to get rid of configure phase so i can change build cache directly.
line 328-
#run_cmd_blocking("Configure waf", cmd_configure, check=True)
#if opts.clean:
#    run_cmd_blocking("Building clean", [waf_light, "clean"])

success! but building ardupilot, change path to build ardupilot_sim

line 333 add -v
cmd_build = [waf_light, "build", "--target", frame_options["waf_target"], "-v"]
CXXFLAGS & LINKFLAGS need -v

linker:

/home/osboxes/Desktop/ardupilot_sim/build/c4che/sitl_cache.py
/home/osboxes/Desktop/ardupilot_sim/Tools/autotest/sim_vehicle.py

manual link gold, and disable opt. 

so run the following not in python script but in cmdline will show ld.gold command:
clang++ -v -std=gnu++11 -fuse-ld=gold -flto -Wl--gc-sections -pthread ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o -obin/arducopter -Wl-Bstatic -Llib -lArduCopter_libs -Wl-Bdynamic -lm

linker cmd add  -plugin-opt=O0 add code-coverage.o add libcsirt...a:
 "/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/arducopter /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0 ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o -lArduCopter_libs /home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o

above works!

turns out the ./arducopter error is 
Starting program: /home/osboxes/Desktop/ardupilot_sim/build/sitl/bin/arducopter2 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Program received signal SIGSEGV, Segmentation fault.
0x00000000017bfdbb in Bitset::set (this=0x0, bit=0) at ./bitset.h:53
53	        _data[elt] |= 1 << off;

so also same as prev. simply change instrumentation solves it.

comment out 337 - 355 in /home/osboxes/Desktop/ardupilot_sim/Tools/autotest/sim_vehicle.py will lead to no compile and run sim:
#    os.chdir(old_dir)
    for piece in pieces:
        cmd_build.extend(piece)
...


procedule:
1. cp sitl_cache.py to build/
2. CC=clang CXX=clang++ ../Tools/autotest/sim_vehicle.py --map --console to compile llvm bitcode
3. link with above at /build/sitl
4. comment out 340-358 in sim_vehicle.py, uncomment 338
5. run /bin/arducopter
*. remember to modify toolkit.o in sitl_cache.py and in link command if change instrumentation tools.

instrumentation in sim mode done!

sim vehicle (instrumented output in a new window):
"/home/osboxes/Desktop/ardupilot_instru_sim/Tools/autotest/run_in_terminal_window.sh" "ArduCopter" "/home/osboxes/Desktop/ardupilot_instru_sim/build/sitl/bin/arducopter" "-S" "-I0" "--home" "-35.363261,149.165230,584,353" "--model" "+" "--speedup" "1" "--defaults" "/home/osboxes/Desktop/ardupilot_instru_sim/Tools/autotest/default_params/copter.parm"

command to start mavproxy:
"mavproxy.py" "--master" "tcp:127.0.0.1:5760" "--sitl" "127.0.0.1:5501" "--out" "127.0.0.1:14550" "--out" "127.0.0.1:14551" "--map" "--console"

command to start arducopter(this is not needed):
/home/osboxes/Desktop/ardupilot_instru_sim/build/sitl/bin/arducopter -S -I0 --home -35.363261,149.165230,584,353 --model + --speedup 1 --defaults /home/osboxes/Desktop/ardupilot_instru_sim/Tools/autotest/default_params/copter.parm

wireless:
1. wifi (short range)
2. lte (not yet)
3. https://www.ebay.com/itm/3DR-Radio-Wireless-Telemetry-433Mhz-Module-USB-Kit-For-APM2-6-APM2-8-Pixhawk-PX4-/222445648501?oid=121399735673 (long range ready, uart ttl)
https://www.youtube.com/watch?v=0lINt4hv5tg
https://www.youtube.com/watch?v=QSjUdOOlCxk
300m “out of the box” (the range can be extended to several kilometres with the use of a patch antenna on the ground)
http://ardupilot.org/copter/docs/common-sik-telemetry-radio.html

hijack a drone mid-air:
Mavlink hack:
https://diydrones.com/profiles/blogs/hijacking-quadcopters-with-a-mavlink-exploit
https://madhacker.org/how-to-hijack-a-drone-by-telemetry-and-prevent-it/

MAVPACKED(
typedef struct __mavlink_message {
	uint16_t checksum;      ///< sent at end of packet
	uint8_t magic;          ///< protocol magic marker
	uint8_t len;            ///< Length of payload
	uint8_t incompat_flags; ///< flags that must be understood
	uint8_t compat_flags;   ///< flags that can be ignored if not understood
	uint8_t seq;            ///< Sequence of packet
	uint8_t sysid;          ///< ID of message sender system/aircraft
	uint8_t compid;         ///< ID of the message sender component
	uint32_t msgid:24;      ///< ID of message in payload
	uint64_t payload64[(MAVLINK_MAX_PAYLOAD_LEN+MAVLINK_NUM_CHECKSUM_BYTES+7)/8];
	uint8_t ck[2];          ///< incoming checksum bytes
	uint8_t signature[MAVLINK_SIGNATURE_BLOCK_LEN];
}) mavlink_message_t;

https://mavlink.io/en/about/overview.html

uint8_t magic;              ///< protocol magic marker
uint8_t len;                ///< Length of payload
uint8_t incompat_flags;     ///< flags that must be understood
uint8_t compat_flags;       ///< flags that can be ignored if not understood
uint8_t seq;                ///< Sequence of packet
uint8_t sysid;              ///< ID of message sender system/aircraft
uint8_t compid;             ///< ID of the message sender component
uint8_t msgid 0:7;          ///< first 8 bits of the ID of the message
uint8_t msgid 8:15;         ///< middle 8 bits of the ID of the message
uint8_t msgid 16:23;        ///< last 8 bits of the ID of the message
uint8_t payload[max 255];   ///< A maximum of 255 payload bytes
uint16_t checksum;          ///< X.25 CRC
uint8_t signature[13];      ///< Signature which allows ensuring that the link is tamper-proof (optional)

https://mavlink.io/en/messages/ardupilotmega.html
This topic is a human-readable form of the XML definition file: ardupilotmega.xml.
https://mavlink.io/en/guide/serialization.html

each msg has a msg type and this decides what this payload is for, see ardupilotmega.xml

https://mavlink.io/en/file_formats/ for mission plans ...
https://mavlink.io/en/services/ for micro services on top of MavLink

http://ardupilot.org/dev/docs/code-overview-adding-a-new-mavlink-message.html

http://ardupilot.org/dev/docs/learning-ardupilot-threading.html
The timer callbacks
Every platform provides a 1kHz timer in the AP_HAL. Any code in ArduPilot can register a timer function which is then called at 1kHz. All registered timer functions are called sequentially. 

/home/osboxes/Desktop/ardupilot/ArduCopter/ArduCopter.cpp
                task         freq(hz)    max. time expected to finish(micro seconds)
SCHED_TASK(gcs_check_input,      400,    180),

void AP_Scheduler::run(uint32_t time_available) in /home/osboxes/Desktop/ardupilot/libraries/AP_Scheduler/AP_Scheduler.cpp
shows how the timer trigger tasks by internal ticks. it use system time (AP_HAL::micros();) as reference for time


to debug:
gdb /home/osboxes/Desktop/ardupilot_sim/build/sitl/bin/arducopter 
break xxx
run -S -I0 --home -35.363261,149.165230,584,353 --model + --speedup 1 --defaults /home/osboxes/Desktop/ardupilot_sim/Tools/autotest/default_params/copter.parm

HAL:
User level app talks to HAL. HAL talks to device driver directly through ioctl() to path/to/device/file.

#0  0x0000000000a0328f in AP_Scheduler::loop (this=0x1fd10b8 <copter+1712>) at ../../libraries/AP_Scheduler/AP_Scheduler.cpp:263
#1  0x000000000045a893 in Copter::loop (this=0x1fd0a08 <copter>) at ../../ArduCopter/ArduCopter.cpp:213
#2  0x0000000000f3ff1e in HAL_SITL::run (this=0x1fdae20 <AP_HAL::get_HAL()::hal>, argc=11, argv=0x7fffffffdca8, callbacks=0x1fd0a08 <copter>) at ../../libraries/AP_HAL_SITL/HAL_SITL_Class.cpp:93
#3  0x000000000045e2a4 in main (argc=11, argv=0x7fffffffdca8) at ../../ArduCopter/ArduCopter.cpp:576

Timer callback:
Every platform provides a 1kHz timer in the AP_HAL. Any code in ArduPilot can register a timer function which is then called at 1kHz. All registered timer functions are called sequentially.

./libraries/AP_HAL/Scheduler.h:47:    virtual void     register_timer_process(AP_HAL::MemberProc) = 0;
./libraries/AP_HAL_Linux/Scheduler.h:31:    void     register_timer_process(AP_HAL::MemberProc);
./libraries/AP_HAL_Linux/Scheduler.cpp:165:void Scheduler::register_timer_process(AP_HAL::MemberProc proc)
./libraries/AP_HAL_Linux/Perf.cpp:107:    hal.scheduler->register_timer_process(FUNCTOR_BIND_MEMBER(&Perf::_debug_counters, void));
./libraries/AP_Notify/ToneAlarm.cpp:111:    hal.scheduler->register_timer_process(FUNCTOR_BIND(this, &AP_ToneAlarm::_timer_task, void));
./libraries/AP_Camera/AP_Camera.cpp:387:    hal.scheduler->register_timer_process(FUNCTOR_BIND_MEMBER(&AP_Camera::feedback_pin_timer, void));
./libraries/AP_Button/AP_Button.cpp:96:        hal.scheduler->register_timer_process(FUNCTOR_BIND_MEMBER(&AP_Button::timer_update, void));        

AP_Scheduler system:
The next aspect of ArduPilot threading and tasks to understand is the AP_Scheduler system. The AP_Scheduler library is used to divide up time within the main vehicle thread, while providing some simple mechanisms to control how much time is used for each operation (called a ‘task’ in AP_Scheduler).

The way it works is that the loop() function for each vehicle implementation contains some code that does this:
wait for a new IMU sample to arrive
call a set of tasks between each IMU sample

It is a table driven scheduler, and each vehicle type has a AP_Scheduler::Task table.

// Main loop - 400hz, 0.0025s
void Copter::fast_loop()
    SCHED_TASK(rc_loop,              100,    130),
// loop at 100Hz, 
    SCHED_TASK(throttle_loop,         50,     75),
// loop at 50Hz

call frequency aka how often they should be called (in hz)(max 400Hz) / max time expected to take (in micro seconds)
(this is different from http://ardupilot.org/dev/docs/learning-ardupilot-threading.html)

Note that tasks in AP_Scheduler tables must have the following attributes:
1. they should never block (except for the ins.update() call)
2. they should never call sleep functions when flying (an autopilot, like a real pilot, should never sleep while flying)
3. they should have predictable worst case timing

HAL specific threads:
on Pixhawk the following HAL specific threads are created:
1. The UART thread, for reading and writing UARTs (and USB)
2. The timer thread, which supports the 1kHz timer functionality described above
3. The IO thread, which supports writing to the microSD card, EEPROM and FRAM
It is important that slow IO tasks like this not be called on the timer thread as they would cause delays in the more important processing of high speed sensor data.

Driver specific threads:
It is also possible to create driver specific threads, to support asynchronous processing in a manner specific to one driver. currently platform dependent
1. you can use the register_io_process() and register_timer_process() scheduler calls to use the existing timer or IO threads
2. you can add a new HAL interface that provides a generic way to create threads on multiple AP_HAL targets (please contribute patches back)
An example of a driver specific thread is the ToneAlarm thread in the Linux port. See AP_HAL_Linux/ToneAlarmDriver.cpp

i changed /home/osboxes/Desktop/ardupilot_native/ArduCopter/GCS_Mavlink.cpp
i added 
    std::chrono::milliseconds timespan(1605); // 1000 ms = 1s, 400hz is 
    std::this_thread::sleep_for(timespan);
to
void Copter::gcs_check_input(void)
{
    gcs().update();
}

only pthread_t in all source:
./libraries/AP_HAL_Linux/Scheduler.h:    pthread_t _main_ctx;
./libraries/AP_HAL_Linux/Thread.h:    pthread_t _ctx = 0;
./libraries/AP_HAL_Linux/OpticalFlow_Onboard.h:    pthread_t _thread;
./libraries/AP_HAL_Linux/RCOutput_Bebop.h:    pthread_t _thread;

not sure about background thread
http://ardupilot.org/dev/docs/code-overview-sensor-drivers.html

for _pthread

./libraries/AP_HAL_Linux/Scheduler.h:    bool     in_main_thread() const override;
./libraries/AP_HAL_Linux/Scheduler.h:    void _wait_all_threads();
./libraries/AP_HAL_Linux/Scheduler.h:    SchedulerThread _timer_thread{FUNCTOR_BIND_MEMBER(&Scheduler::_timer_task, void), *this};
./libraries/AP_HAL_Linux/Scheduler.h:    SchedulerThread _io_thread{FUNCTOR_BIND_MEMBER(&Scheduler::_io_task, void), *this};
./libraries/AP_HAL_Linux/Scheduler.h:    SchedulerThread _rcin_thread{FUNCTOR_BIND_MEMBER(&Scheduler::_rcin_task, void), *this};
./libraries/AP_HAL_Linux/Scheduler.h:    SchedulerThread _uart_thread{FUNCTOR_BIND_MEMBER(&Scheduler::_uart_task, void), *this};
./libraries/AP_HAL_Linux/RCOutput_Bebop.cpp:    ret = pthread_create(&_thread, &attr, _control_thread, this);
./libraries/AP_HAL_Linux/RCOutput_Bebop.cpp:void* RCOutput_Bebop::_control_thread(void *arg) {
./libraries/AP_HAL_Linux/Thread.h:    bool is_current_thread();
./libraries/AP_HAL_Linux/OpticalFlow_Onboard.h:    static void *_read_thread(void *arg);
./libraries/AP_HAL_Linux/OpticalFlow_Onboard.h:    pthread_t _thread;
./libraries/AP_HAL_Linux/Scheduler.cpp:        .thread = &_##name_##_thread,                           \
./libraries/AP_HAL_Linux/Scheduler.cpp:    unsigned n_threads = ARRAY_SIZE(sched_table) + 1;
./libraries/AP_HAL_Linux/Scheduler.cpp:    ret = pthread_barrier_init(&_initialized_barrier, nullptr, n_threads);
./libraries/AP_HAL_Linux/Scheduler.cpp:                _timer_thread.get_stack_usage(),
./libraries/AP_HAL_Linux/Scheduler.cpp:                _io_thread.get_stack_usage(),
./libraries/AP_HAL_Linux/Scheduler.cpp:                _rcin_thread.get_stack_usage(),
./libraries/AP_HAL_Linux/Scheduler.cpp:                _uart_thread.get_stack_usage());
./libraries/AP_HAL_Linux/Scheduler.cpp:        if (in_main_thread() && _min_delay_cb_ms <= ms) {
./libraries/AP_HAL_Linux/Scheduler.cpp:bool Scheduler::in_main_thread() const
./libraries/AP_HAL_Linux/Scheduler.cpp:void Scheduler::_wait_all_threads()
./libraries/AP_HAL_Linux/Scheduler.cpp:    _wait_all_threads();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _sched._wait_all_threads();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _timer_thread.stop();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _io_thread.stop();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _rcin_thread.stop();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _uart_thread.stop();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _timer_thread.join();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _io_thread.join();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _rcin_thread.join();
./libraries/AP_HAL_Linux/Scheduler.cpp:    _uart_thread.join();
./libraries/AP_HAL_Linux/Thread.cpp:bool Thread::is_current_thread()
./libraries/AP_HAL_Linux/OpticalFlow_Onboard.cpp:    ret = pthread_create(&_thread, &attr, _read_thread, this);
./libraries/AP_HAL_Linux/OpticalFlow_Onboard.cpp:void *OpticalFlow_Onboard::_read_thread(void *arg)
./libraries/AP_HAL_Linux/RCOutput_Bebop.h:    pthread_t _thread;
./libraries/AP_HAL_Linux/RCOutput_Bebop.h:    static void *_control_thread(void *arg);
./libraries/AP_HAL_Linux/tests/test_thread.cpp:TEST(LinuxThread, poller_thread)
./libraries/AP_HAL_Linux/tests/test_thread.cpp:TEST(LinuxThread, periodic_thread)

./libraries/AP_HAL_Linux/Scheduler.cpp:
void Scheduler::init()
{
    int ret;
    const struct sched_table {
        const char *name;
        SchedulerThread *thread;
        int policy;
        int prio;
        uint32_t rate;
    } sched_table[] = {
        SCHED_THREAD(timer, TIMER),
        SCHED_THREAD(uart, UART),
        SCHED_THREAD(rcin, RCIN),
        SCHED_THREAD(io, IO),
    };

    _main_ctx = pthread_self();


void Scheduler::register_timer_failsafe(AP_HAL::Proc failsafe, uint32_t period_us)
{
    _failsafe = failsafe;
}

void Scheduler::_timer_task()
{
    int i;

    if (_in_timer_proc) {
        return;
    }
    _in_timer_proc = true;

    // now call the timer based drivers
    for (i = 0; i < _num_timer_procs; i++) {
        if (_timer_proc[i]) {
            _timer_proc[i]();
        }
    }

    // and the failsafe, if one is setup
    if (_failsafe != nullptr) {
        _failsafe();
    }

void Scheduler::{register_timer_process,register_io_process, _rcin_task,_uart_task,_io_task,in_main_thread...}

/home/osboxes/Desktop/ardupilot_native/ArduCopter/failsafe.cpp
//  our failsafe strategy is to detect main loop lockup and disarm the motors
//  failsafe_check - this function is called from the core timer interrupt at 1kHz.

// Disarming the motors will cause the motors to stop spinning

so failsafe is acutally running in parallel with main loop.

so i guess for navio2 on rpi3, 4 threads:

vehicle code only ever calls into the Library’s (aka sensor driver’s) front-end. 
On start-up the front-end creates one or more back-ends based either on automatic detection of the sensor (i.e. probing for a response on a known I2C address) or by using the user defined _TYPE params (i.e. RNGFND_TYPE, RNGFND_TYPE2). The front-end maintains pointers to each back-end which are normally held within an array named _drivers[].

User settable parameters are always held within the front-end.

The vehicle code’s main thread runs regularly (i.e. 400hz for copter) and accesses the latest data available through methods in the driver’s front-end.

evidence for using device file to talk to hardware

/home/osboxes/Desktop/ardupilot_native/libraries/AP_RangeFinder/AP_RangeFinder_LightWareSerial.cpp
void AP_RangeFinder_LightWareSerial::update(void)
{
    if (get_reading(state.distance_cm)) {
        // update range_valid state based on distance measured
        last_reading_ms = AP_HAL::millis();
        update_status();
    } else if (AP_HAL::millis() - last_reading_ms > 200) {
        set_status(RangeFinder::RangeFinder_NoData);
    }
}

bool AP_RangeFinder_LightWareSerial::get_reading(uint16_t &reading_cm)
{
    if (uart == nullptr) {
        return false;
    }

    // read any available lines from the lidar
    float sum = 0;
    uint16_t count = 0;
    int16_t nbytes = uart->available();
    while (nbytes-- > 0) {
        char c = uart->read();
        if (c == '\r') {


/home/osboxes/Desktop/ardupilot_native/libraries/AP_RangeFinder/AP_RangeFinder_LightWareSerial.h
    AP_HAL::UARTDriver *uart = nullptr;

/home/osboxes/Desktop/ardupilot_native/libraries/AP_HAL_Linux/UARTDriver.cpp
#include <sys/ioctl.h>

UARTDriver::UARTDriver(bool default_console) :
    device_path(nullptr),
    _packetise(false),
    _device{new ConsoleDevice()}
{
    if (default_console) {
        _console = true;
    }
}


so current understanding, when ardupilot starts, it creates 4 threads, and background sensor driver is not device driver, but driver sits in background threads talking to device driver

debug: 
../Tools/autotest/sim_vehicle.py -v ArduCopter -f quad --console --map -D -G
gdb /home/osboxes/Desktop/ardupilot_sim/build/sitl/bin/arducopter 
break xxx
run -S -I0 --home -35.363261,149.165230,584,353 --model + --speedup 1 --defaults /home/osboxes/Desktop/ardupilot_sim/Tools/autotest/default_params/copter.parm

by check SITL gdb symbols, i guess it does not include timer registration & stuff. need to check rpi3 then.

set up rpi3 debug. and retry threading issue.
alias waf="$PWD/modules/waf/waf-light"
CC=clang CXX=clang++ CXXFLAGS="--sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6" waf configure --board=navio2 
waf -j4 --targets bin/arducopter 

after testing, failsafe will be registered in rpi3, and it will be triggered when main loop does not tick.

current understanding:
1. arducopter starts the main thread
2. main thread registers timer thread, io thread, uart thread, rcin thread (priority timer>uart>rcin>main>io)
3. timer thread includes tasks in scheduler and a failsafe task, doubled checked finish about failsafe is nothing more than another task.
4. some sensor driver are divided into frontend and backend(I2C, SPI), while others aren't(UART), bc UART has buffer itself, no need a thread to take care of its buffering.
5. sensor backend are in another thread than timer thread, they are slower and share memory to enable configure and read sensor data from timer thread. while uart are directly take cared of by timer thread.
6. threads are isolated processes sharing some predefined memory for cooperation.

https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6969407
no, i was wrong about theads not sharing memory, they do run in the same address space. Also written in PL book.

       CLONE_VM (since Linux 2.0)
              If  CLONE_VM  is  set, the calling process and the child process
              run in the same memory space.  In particular, memory writes per‐
              formed  by  the calling process or by the child process are also
              visible in the other process.  Moreover, any memory  mapping  or
              unmapping  performed  with  mmap(2) or munmap(2) by the child or
              calling process also affects the other process.

              If CLONE_VM is not set, the child process  runs  in  a  separate
              copy  of  the memory space of the calling process at the time of
              clone().  Memory writes or file mappings/unmappings performed by
              one of the processes do not affect the other, as with fork(2).



PX4
http://dev.px4.io/en/concept/architecture.html
The inter-module communication (using uORB) is based on shared memory. The whole PX4 middleware runs in a single address space, i.e. memory is shared between all modules.
A task is scheduled by specifying a fixed time in the future. The advantage is that it uses less RAM, but the task is not allowed to sleep or poll on a message.

The shell starts each module as a new (client) process. Each client process needs to communicate with the main instance of px4 (the server), where the actual modules are running as threads. This is done through a UNIX socket. The server listens on a socket, to which clients can connect and send a command. The server then sends the output and return code back to the client.

http://dev.px4.io/en/middleware/uorb.html

understanding:
1. uorb serve as publish-subscribe shared memory zone
2. every module is a process, and subscribe to uorb and can publish any message. no authentication here (every modules shares the address space of uorb)
3. navigator module use received information to publish message to commander module
4. commander module execute commands received
5. thus if compromise Mavlink sw stack, can publish any message
6. realtime effect? analogus to navio2, but instead of background threads and timer thread to control navigation and flight and share memory through thread clone_vm sharing memory address, it use multi processes and uorb to share memory object and commands modules and navigator modules to control.

Navigator::run()

Mavlink_main.cpp
MavlinkOrbSubscription *cmd_sub = add_orb_subscription(ORB_ID(vehicle_command), 0, true); vehicle_command
MavlinkOrbSubscription *ack_sub = add_orb_subscription(ORB_ID(vehicle_command_ack), 0, true);
orb_publish(ORB_ID(vehicle_command_ack), command_ack_pub, &command_ack);
command_ack_pub = orb_advertise_queue(ORB_ID(vehicle_command_ack), &command_ack,vehicle_command_ack_s::ORB_QUEUE_LENGTH);

navigator_main.cpp
orb_publish(ORB_ID(vehicle_command), _vehicle_cmd_pub, vcmd);
_vehicle_cmd_pub = orb_advertise_queue(ORB_ID(vehicle_command), vcmd, vehicle_command_s::ORB_QUEUE_LENGTH);

Commander.cpp
orb_publish(ORB_ID(power_button_state), power_button_state_pub, &button_state);
orb_publish(ORB_ID(vehicle_control_mode), control_mode_pub, &control_mode);
orb_publish(ORB_ID(actuator_armed), armed_pub, &armed);
orb_publish(ORB_ID(commander_state), commander_state_pub, &internal_state);

uORB::DeviceNode::DeviceNode(const struct orb_metadata *meta, const uint8_t instance, const char *path,
			     uint8_t priority, uint8_t queue_size) :
	CDev(path),
	_meta(meta),
	_instance(instance),
	_priority(priority),
	_queue_size(queue_size)
{
}

all modules orb.publish calls the following:

ssize_t
uORB::DeviceNode::publish(const orb_metadata *meta, orb_advert_t handle, const void *data)
{
	uORB::DeviceNode *devnode = (uORB::DeviceNode *)handle;
	int ret;

	/* check if the device handle is initialized and data is valid */
	if ((devnode == nullptr) || (meta == nullptr) || (data == nullptr)) {
		errno = EFAULT;
		return PX4_ERROR;
	}

	/* check if the orb meta data matches the publication */
	if (devnode->_meta != meta) {
		errno = EINVAL;
		return PX4_ERROR;
	}

	/* call the devnode write method with no file pointer */
	ret = devnode->write(nullptr, (const char *)data, meta->o_size);

	if (ret < 0) {
		errno = -ret;
		return PX4_ERROR;
	}

	if (ret != (int)meta->o_size) {
		errno = EIO;
		return PX4_ERROR;
	}

#ifdef ORB_COMMUNICATOR
	/*
	 * if the write is successful, send the data over the Multi-ORB link
	 */
	uORBCommunicator::IChannel *ch = uORB::Manager::get_instance()->get_uorb_communicator();

	if (ch != nullptr) {
		if (ch->send_message(meta->o_name, meta->o_size, (uint8_t *)data) != 0) {
			PX4_ERR("Error Sending [%s] topic data over comm_channel", meta->o_name);
			return PX4_ERROR;
		}
	}

#endif /* ORB_COMMUNICATOR */

	return PX4_OK;
}

uORBManager.cpp is using px4_ioctl(), so it strengthen my belief.

file:///Users/rd/Downloads/PX4_A_Node-Based_Multithreaded_Open_Sour.pdf
so i guess uorb is using a char device driver to serve as inter process communication interface.

https://dev.px4.io/en/middleware/uorb_graph.html#instructions


http://nuttx.org/doku.php?id=wiki:nxinternal:tasks-vs-processes
NuttX Build Types
NuttX can be built in several different ways:

Kernel Build. The kernal build, selected with CONFIG_BUILD_KERNEL, uses the MCU's Memory Management Unit (MMU) to implement processes very similar to Linux processes. There is no interesting discussion here; NuttX behaves very much like Linux.
Flat Build. Most resource-limited MCUs have no MMU and the code is built as a blob that runs in an unprotected, flat address space out of on-chip FLASH memory. This build mode is selected with CONFIG_BUILD_FLAT and is, by far, the most common way that people build NuttX. This is the interesting case to which this Wiki page is directed.
Protected Build. Another build option is the protected build. This is essentially the same as the flat build, but uses the MCU's Memory Protection Unit (MPU) to separate unproctect user address ranges from protected system address ranges. The comments of this Wiki page also apply in this case.



NuttX
https://dev.px4.io/en/concept/architecture.html
NuttX is the primary RTOS for running PX4 on a flight-control board. It is open source (BSD license), light-weight, efficient and very stable.

Modules are executed as tasks: they have their own file descriptor lists, but they share a single address space. A task can still start one or more threads that share the file descriptor list.

Each task/thread has a fixed-size stack, and there is a periodic task which checks that all stacks have enough free space left (based on stack coloring).

Linux/macOS
On Linux or macOS, PX4 runs in a single process, and the modules run in their own threads (there is no distinction between tasks and threads as on NuttX).


Parr uav
MCU. a lot like arduino

int main(void)
{
  main_init();
  while (1) {
    if (sys_time_check_and_ack_timer(0)) {
      main_periodic_task();
    }
    main_event_task();
  }
  return 0;
}

static inline void main_init(void)
{
  mcu_init();
  sys_time_register_timer((1. / PERIODIC_FREQUENCY), NULL);
  uart0_init_tx();
  mcu_int_enable();
}

static inline void main_periodic_task(void)
{
  //  LED_TOGGLE(1);
  uint16_t time_sec = sys_time.nb_sec;
  DOWNLINK_SEND_TAKEOFF(&time_sec);
}


csi usage. csi.h

WEAK void __csi_init();

WEAK void __csi_unit_init(const char * const file_name,
                          const instrumentation_counts_t counts);

WEAK void __csi_func_entry(const csi_id_t func_id, const func_prop_t prop);

WEAK void __csi_func_exit(const csi_id_t func_exit_id,
                          const csi_id_t func_id, const func_exit_prop_t prop);

WEAK void __csi_bb_entry(const csi_id_t bb_id, const bb_prop_t prop);

WEAK void __csi_bb_exit(const csi_id_t bb_id, const bb_prop_t prop);

WEAK void __csi_before_call(const csi_id_t call_id, const csi_id_t func_id,
                            const call_prop_t prop);

WEAK void __csi_after_call(const csi_id_t call_id, const csi_id_t func_id,
                           const call_prop_t prop);

WEAK void __csi_before_load(const csi_id_t load_id,
                            const void *addr,
                            const int32_t num_bytes,
                            const load_prop_t prop);

WEAK void __csi_after_load(const csi_id_t load_id,
                           const void *addr,
                           const int32_t num_bytes,
                           const load_prop_t prop);

WEAK void __csi_before_store(const csi_id_t store_id,
                             const void *addr,
                             const int32_t num_bytes,
                             const store_prop_t prop);

WEAK void __csi_after_store(const csi_id_t store_id,
                            const void *addr,
                            const int32_t num_bytes,
                            const store_prop_t prop);

// Front-end data (FED) table accessors.

source_loc_t const * __csi_get_func_source_loc(const csi_id_t func_id);
source_loc_t const * __csi_get_func_exit_source_loc(const csi_id_t func_exit_id);
source_loc_t const * __csi_get_bb_source_loc(const csi_id_t bb_id);
source_loc_t const * __csi_get_callsite_source_loc(const csi_id_t call_id);
source_loc_t const * __csi_get_load_source_loc(const csi_id_t load_id);
source_loc_t const * __csi_get_store_source_loc(const csi_id_t store_id);


void __csi_func_entry(const csi_id_t func_id, const csi_prop_t prop) {
    printf("Enter function %ld [%s:%d]\n", func_id,
           __csi_get_func_source_loc(func_id)->filename,
           __csi_get_func_source_loc(func_id)->line_number);
}

see line 5175 for instrumenting ardupilot in sim mode.

current issue:
(gdb) b initialize_fed_tables
Breakpoint 1 at 0x401ae0: file /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c, line 62.
(gdb) b __csi_get_func_source_loc
Breakpoint 2 at 0x401b70: file /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c, line 182.

__csi_get_func_source_loc called before initialize_fed_tables

initialize_fed_tables is in __csirt_unit_init. __csi_get_func_source_loc called before __csirt_unit_init

csirt.unit_ctor call __csirt_unit_init. __csi_get_func_source_loc called before csirt.unit_ctor

// A call to this is inserted by the CSI compiler pass, and occurs
// before main().
CSIRT_API void __csirt_unit_init


#0  0x0000000000666a24 in __csi_func_entry (func_id=0, prop=...) at prof-lite.cpp:30
#1  0x0000000000403224 in __cxx_global_var_init () at ../../libraries/AP_Math/definitions.h:40
#2  0x00000000004031f9 in _GLOBAL__sub_I_AP_Arming.cpp ()
#3  0x000000000193d9bd in __libc_csu_init ()
#4  0x00007ffff6f6f7bf in __libc_start_main (main=0x45def0 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d970 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#5  0x000000000043e009 in _start () at ../../libraries/AP_Math/definitions.h:71


(gdb) info files
Symbols from "/home/osboxes/Desktop/ardupilot_instru_sim/build/sitl/bin/arducopter".
Local exec file:
	`/home/osboxes/Desktop/ardupilot_instru_sim/build/sitl/bin/arducopter', 
        file type elf64-x86-64.
	Entry point: 0x43dfe0
	0x0000000000400238 - 0x0000000000400254 is .interp
	0x0000000000400254 - 0x0000000000400274 is .note.ABI-tag
	0x0000000000400278 - 0x0000000000401190 is .dynsym
	0x0000000000401190 - 0x00000000004017d8 is .dynstr
	0x00000000004017d8 - 0x0000000000401828 is .gnu.hash
	0x0000000000401828 - 0x000000000040196a is .gnu.version
	0x000000000040196c - 0x0000000000401a2c is .gnu.version_r
	0x0000000000401a30 - 0x0000000000401ac0 is .rela.dyn
	0x0000000000401ac0 - 0x0000000000402888 is .rela.plt
	0x0000000000402888 - 0x00000000004028a2 is .init
	0x00000000004028b0 - 0x00000000004031f0 is .plt
	0x00000000004031f0 - 0x000000000193da30 is .text
	0x000000000193da30 - 0x000000000193da39 is .fini
	0x000000000193da40 - 0x0000000001985a30 is .rodata
	0x0000000001985a30 - 0x00000000019c68dc is .eh_frame
	0x00000000019c68dc - 0x00000000019d71d0 is .eh_frame_hdr
	0x00000000019d8640 - 0x00000000019d8648 is .jcr
	0x00000000019d8648 - 0x00000000019d8650 is .fini_array
	0x00000000019d8650 - 0x00000000019d9cc8 is .init_array
	0x00000000019d9cc8 - 0x00000000019d9ed8 is .dynamic
	0x00000000019d9ed8 - 0x00000000019d9fe0 is .data.rel.ro
	0x00000000019d9fe0 - 0x00000000019d9fe8 is .got
	0x00000000019d9fe8 - 0x00000000019da498 is .got.plt
	0x00000000019da4a0 - 0x0000000001fd08a0 is .data
	0x0000000001fd08a0 - 0x0000000001fd08a0 is .tm_clone_table
	0x0000000001fd08a0 - 0x0000000001fe0fd0 is .bss

(gdb) b *0x43dfe0
Breakpoint 1 at 0x43dfe0: file ../../libraries/AP_Math/definitions.h, line 71.
(gdb) r
Starting program: /home/osboxes/Desktop/ardupilot_instru_sim/build/sitl/bin/arducopter 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, 0x000000000043dfe0 in _start () at ../../libraries/AP_Math/definitions.h:71
71	static const double WGS84_E = (sqrt(2 * WGS84_F - WGS84_F * WGS84_F));
(gdb) bt
#0  0x000000000043dfe0 in _start () at ../../libraries/AP_Math/definitions.h:71


B+>│0x43dfe0 <_start>                       xor    %ebp,%ebp                                        │
   │0x43dfe2 <_start+2>                     mov    %rdx,%r9                                         │
   │0x43dfe5 <_start+5>                     pop    %rsi                                             │
   │0x43dfe6 <_start+6>                     mov    %rsp,%rdx                                        │
   │0x43dfe9 <_start+9>                     and    $0xfffffffffffffff0,%rsp                         │
   │0x43dfed <_start+13>                    push   %rax                                             │
   │0x43dfee <_start+14>                    push   %rsp                                             │
   │0x43dfef <_start+15>                    mov    $0x193d9e0,%r8                                   │
   │0x43dff6 <_start+22>                    mov    $0x193d970,%rcx                                  │
   │0x43dffd <_start+29>                    mov    $0x45def0,%rdi                                   │
   │0x43e004 <_start+36>                    callq  0x4028c0 <__libc_start_main@plt> 


   │0x4031f0 <_GLOBAL__sub_I_AP_Arming.cpp>         push   %rbp                                     │
   │0x4031f1 <_GLOBAL__sub_I_AP_Arming.cpp+1>       mov    %rsp,%rbp                                │
B+>│0x4031f4 <_GLOBAL__sub_I_AP_Arming.cpp+4>       callq  0x403200 <__cxx_global_var_init()>       │
   │0x4031f9 <_GLOBAL__sub_I_AP_Arming.cpp+9>       callq  0x403340 <__cxx_global_var_init.1(void)> │
   

  >│0x403200 <__cxx_global_var_init()>              push   %rbp                                                            │
   │0x403201 <__cxx_global_var_init()+1>            mov    %rsp,%rbp                                                       │
   │0x403204 <__cxx_global_var_init()+4>            sub    $0x50,%rsp                                                      │
   │0x403208 <__cxx_global_var_init()+8>            xor    %eax,%eax                                                       │
   │0x40320a <__cxx_global_var_init()+10>           mov    %eax,%esi                                                       │
   │0x40320c <__cxx_global_var_init()+12>           mov    0x1fd08c0,%rcx                                                  │
   │0x403214 <__cxx_global_var_init()+20>           add    $0x0,%rcx                                                       │
   │0x403218 <__cxx_global_var_init()+24>           mov    %rcx,%rdi                                                       │
   │0x40321b <__cxx_global_var_init()+27>           mov    %rcx,-0x8(%rbp)                                                 │
   │0x40321f <__cxx_global_var_init()+31>           callq  0x666a20 <__csi_func_entry(csi_id_t, func_prop_t)>              │

in intrumented ardupcopter only printf:

Breakpoint 2, __csi_func_entry (func_id=0, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
(gdb) bt
#0  __csi_func_entry (func_id=0, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
#1  0x0000000000403224 in __cxx_global_var_init () at ../../libraries/AP_Math/definitions.h:40
#2  0x00000000004031f9 in _GLOBAL__sub_I_AP_Arming.cpp ()
#3  0x000000000193d8ad in __libc_csu_init ()
#4  0x00007ffff6f6f7bf in __libc_start_main (main=0x45df50 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d860 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#5  0x000000000043e069 in _start () at ../../libraries/AP_Math/definitions.h:71

Breakpoint 2, __csi_func_entry (func_id=1, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
(gdb) bt
#0  __csi_func_entry (func_id=1, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
#1  0x0000000000403364 in __cxx_global_var_init.1(void) ()
    at ../../libraries/AP_Math/definitions.h:71
#2  0x00000000004031fe in _GLOBAL__sub_I_AP_Arming.cpp ()
#3  0x000000000193d8ad in __libc_csu_init ()
#4  0x00007ffff6f6f7bf in __libc_start_main (main=0x45df50 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d860 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#5  0x000000000043e069 in _start ()
    at /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0/iostream:74


Breakpoint 3, __csirt_unit_init (name=0x196d710 "../../ArduCopter/AP_Arming.cpp",
    unit_fed_tables=0x19da7b0 <__csi_unit_fed_tables>,
    callsite_to_func_init=0x453e20 <__csi_init_callsite_to_function>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:155
(gdb) bt
#0  __csirt_unit_init (name=0x196d710 "../../ArduCopter/AP_Arming.cpp",
    unit_fed_tables=0x19da7b0 <__csi_unit_fed_tables>,
    callsite_to_func_init=0x453e20 <__csi_init_callsite_to_function>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:155
#1  0x0000000000453e14 in csirt.unit_ctor ()
    at /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0/iostream:74
#2  0x000000000193d8ad in __libc_csu_init ()
#3  0x00007ffff6f6f7bf in __libc_start_main (main=0x45df50 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d860 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#4  0x000000000043e069 in _start ()
    at /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0/iostream:74

Breakpoint 2, __csi_func_entry (func_id=0, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
(gdb) bt
#0  __csi_func_entry (func_id=0, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
#1  0x00000000004034a4 in __cxx_global_var_init () at ../../libraries/AP_Math/definitions.h:40
#2  0x0000000000403479 in _GLOBAL__sub_I_AP_Rally.cpp ()
#3  0x000000000193d8ad in __libc_csu_init ()
#4  0x00007ffff6f6f7bf in __libc_start_main (main=0x45df50 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d860 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#5  0x000000000043e069 in _start () at ../../libraries/AP_Math/definitions.h:71

Breakpoint 2, __csi_func_entry (func_id=1, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
(gdb) bt
#0  __csi_func_entry (func_id=1, prop=...)
    at ../../projects/compiler-rt/test/csi/tools/null-tool.c:34
#1  0x00000000004035e4 in __cxx_global_var_init.1(void) ()
    at ../../libraries/AP_Math/definitions.h:71
#2  0x000000000040347e in _GLOBAL__sub_I_AP_Rally.cpp ()
#3  0x000000000193d8ad in __libc_csu_init ()
#4  0x00007ffff6f6f7bf in __libc_start_main (main=0x45df50 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d860 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#5  0x000000000043e069 in _start () at ../../libraries/AP_Math/definitions.h:71


Breakpoint 3, __csirt_unit_init (name=0x196da40 "../../ArduCopter/AP_Rally.cpp",
    unit_fed_tables=0x19e1ba0 <__csi_unit_fed_tables.11>,
    callsite_to_func_init=0x4545b0 <__csi_init_callsite_to_function.12>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:155
(gdb) bt
#0  __csirt_unit_init (name=0x196da40 "../../ArduCopter/AP_Rally.cpp",
    unit_fed_tables=0x19e1ba0 <__csi_unit_fed_tables.11>,
    callsite_to_func_init=0x4545b0 <__csi_init_callsite_to_function.12>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:155
#1  0x00000000004545a4 in csirt.unit_ctor ()
    at /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0/iostream:74
#2  0x000000000193d8ad in __libc_csu_init ()
#3  0x00007ffff6f6f7bf in __libc_start_main (main=0x45df50 <main(int, char* const*)>, argc=1,
    argv=0x7fffffffdd78, init=0x193d860 <__libc_csu_init>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffdd68) at ../csu/libc-start.c:247
#4  0x000000000043e069 in _start () at ../../libraries/AP_Math/definitions.h:71

comparing to main in example of csi:

Breakpoint 1, __csirt_unit_init (name=0x401d6a "main.cpp", unit_fed_tables=0x4040a0 <__csi_unit_fed_tables>, 
    callsite_to_func_init=0x401650 <__csi_init_callsite_to_function>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:155
155	                       __csi_init_callsite_to_functions callsite_to_func_init) {
(gdb) bt
#0  __csirt_unit_init (name=0x401d6a "main.cpp", unit_fed_tables=0x4040a0 <__csi_unit_fed_tables>, 
    callsite_to_func_init=0x401650 <__csi_init_callsite_to_function>)
    at /home/osboxes/Desktop/llvm/projects/compiler-rt/lib/csi/csirt.c:155
#1  0x0000000000401644 in csirt.unit_ctor ()
#2  0x0000000000401cdd in __libc_csu_init ()
#3  0x00007ffff718c7bf in __libc_start_main (main=0x4008b0 <main()>, argc=1, argv=0x7fffffffddb8, 
    init=0x401c90 <__libc_csu_init>, fini=<optimized out>, rtld_fini=<optimized out>, stack_end=0x7fffffffdda8)
    at ../csu/libc-start.c:247
#4  0x00000000004007d9 in _start ()

(gdb) c
Continuing.

Breakpoint 2, __csi_func_entry (func_id=0, prop=...) at prof-lite.cpp:31
31	    printf("Enter function %ld [%s:%d], name: %s\n", func_id,
(gdb) bt
#0  __csi_func_entry (func_id=0, prop=...) at prof-lite.cpp:31
#1  0x00000000004008d7 in main ()

gdb arducopter
run -S -I0 --home -35.363261,149.165230,584,353 --model + --speedup 1 --defaults /home/osboxes/Desktop/ardupilot_instru_sim/Tools/autotest/default_params/copter.parm

command to start mavproxy:
"mavproxy.py" "--master" "tcp:127.0.0.1:5760" "--sitl" "127.0.0.1:5501" "--out" "127.0.0.1:14550" "--out" "127.0.0.1:14551" "--map" "--console"

Enter function 69 [../../libraries/AP_Math/definitions.h:74], name: set_failsafe_gcs
Enter function 69 [../../libraries/AP_Math/definitions.h:74], name: set_failsafe_gcs
Enter function 15 [../../libraries/AP_Math/definitions.h:119], name: ins_checks
Enter function 14 [../../libraries/AP_Math/definitions.h:86], name: compass_checks
Enter function 16 [../../libraries/AP_Math/definitions.h:430], name: pre_arm_ekf_attitude_check

turns out name is correct but path is wrong


/home/osboxes/Desktop/ardupilot_instru_sim/libraries/AP_HAL/AP_HAL_Namespace.h
namespace AP_HAL {

    /* Toplevel pure virtual class Hal.*/
    class HAL;


/home/osboxes/Desktop/ardupilot_instru_sim/libraries/AP_HAL/HAL.h
class AP_HAL::HAL {
public:
    HAL(AP_HAL::UARTDriver* _uartA, // console
        AP_HAL::UARTDriver* _uartB, // 1st GPS
        AP_HAL::UARTDriver* _uartC, // telem1
        AP_HAL::UARTDriver* _uartD, // telem2
        AP_HAL::UARTDriver* _uartE, // 2nd GPS
        AP_HAL::UARTDriver* _uartF, // extra1
        AP_HAL::UARTDriver* _uartG, // extra2
        AP_HAL::I2CDeviceManager* _i2c_mgr,
        AP_HAL::SPIDeviceManager* _spi,
        AP_HAL::AnalogIn*   _analogin,
        AP_HAL::Storage*    _storage,
        AP_HAL::UARTDriver* _console,
        AP_HAL::GPIO*       _gpio,
        AP_HAL::RCInput*    _rcin,
        AP_HAL::RCOutput*   _rcout,
        AP_HAL::Scheduler*  _scheduler,
        AP_HAL::Util*       _util,
        AP_HAL::OpticalFlow *_opticalflow,
        :
        uartA(_uartA),
        uartB(_uartB),
        uartC(_uartC),
        uartD(_uartD),
        uartE(_uartE),
        uartF(_uartF),
        uartG(_uartG),
        i2c_mgr(_i2c_mgr),
        spi(_spi),
        analogin(_analogin),
        storage(_storage),
        console(_console),
        gpio(_gpio),
        rcin(_rcin),
        rcout(_rcout),
        scheduler(_scheduler),
        util(_util),
        opticalflow(_opticalflow)
    {
    
            AP_HAL::init();
    }

    struct Callbacks {
        virtual void setup() = 0;
        virtual void loop() = 0;
    };

    struct FunCallbacks : public Callbacks {
        FunCallbacks(void (*setup_fun)(void), void (*loop_fun)(void));

        void setup() override { _setup(); }
        void loop() override { _loop(); }

    private:
        void (*_setup)(void);
        void (*_loop)(void);
    };

    virtual void run(int argc, char * const argv[], Callbacks* callbacks) const = 0;

    AP_HAL::UARTDriver* uartA;
    AP_HAL::UARTDriver* uartB;
    AP_HAL::UARTDriver* uartC;
    AP_HAL::UARTDriver* uartD;
    AP_HAL::UARTDriver* uartE;
    AP_HAL::UARTDriver* uartF;
    AP_HAL::UARTDriver* uartG;
    AP_HAL::I2CDeviceManager* i2c_mgr;
    AP_HAL::SPIDeviceManager* spi;
    AP_HAL::AnalogIn*   analogin;
    AP_HAL::Storage*    storage;
    AP_HAL::UARTDriver* console;
    AP_HAL::GPIO*       gpio;
    AP_HAL::RCInput*    rcin;
    AP_HAL::RCOutput*   rcout;
    AP_HAL::Scheduler*  scheduler;
    AP_HAL::Util        *util;
    AP_HAL::OpticalFlow *opticalflow;
};

Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop

Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Exit function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Exit function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Enter function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop
Count 100: Exit function 128 [../../libraries/AP_Math/definitions.h:268], name: rd_rc_loop


steps for function trace execution timing:
1. csi toolset, func enry log according to func name
2. change arducopter source code to get rd_xxxx func name
3. compile & link
4. run:
gdb arducopter
run -S -I0 --home -35.363261,149.165230,584,353 --model + --speedup 1 --defaults /home/osboxes/Desktop/ardupilot_instru_sim/Tools/autotest/default_params/copter.parm
command to start mavproxy:
"mavproxy.py" "--master" "tcp:127.0.0.1:5760" "--sitl" "127.0.0.1:5501" "--out" "127.0.0.1:14550" "--out" "127.0.0.1:14551" "--map" "--console"


/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/plat/arm/common/arm_bl2_el3_setup.c
void arm_bl2_el3_plat_arch_setup(void)
{
	const mmap_region_t bl_regions[] = {
		MAP_BL2_EL3_TOTAL,
		ARM_MAP_BL_RO,
		{0}
	};
	arm_setup_page_tables(bl_regions, plat_arm_get_mmap());
	enable_mmu_el3(0);
}

MAP_BL2_EL3_TOTAL:
ARM_BL_RAM_BASE 0x04001000
ARM_BL_RAM_SIZE 0x00041000

using following but not arm common:
/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/plat/rpi3/rpi3_bl31_setup.c
void bl31_plat_arch_setup(void)
{
	rpi3_setup_page_tables(BL31_BASE, BL31_END - BL31_BASE,
			       BL_CODE_BASE, BL_CODE_END,
			       BL_RO_DATA_BASE, BL_RO_DATA_END
			      );

	enable_mmu_el3(0);
}

#define BL31_BASE			(BL31_LIMIT - PLAT_MAX_BL31_SIZE)
#define BL31_LIMIT			(BL_RAM_BASE + BL_RAM_SIZE)
#define BL_RAM_BASE			(SHARED_RAM_BASE + SHARED_RAM_SIZE)
#define SHARED_RAM_BASE			SEC_SRAM_BASE
#define SHARED_RAM_SIZE			ULL(0x00001000)
#define SEC_SRAM_BASE			ULL(0x10000000)
BL_RAM_BASE = 0x100001000
#define BL_RAM_SIZE			(SEC_SRAM_SIZE - SHARED_RAM_SIZE)
#define SEC_SRAM_SIZE			ULL(0x00100000)
BL_RAM_SIZE = 0x00100000 - 0x00001000 = 0xFF000
BL31_LIMIT = 0x100001000 + 0xFF000 = 0x100100000

INFO:    BL31: Initializing BL32
D/TC:0 0 add_phys_mem:536 TEE_SHMEM_START type NSEC_SHM 0x08000000 size 0x00400000
D/TC:0 0 add_phys_mem:536 TA_RAM_START type TA_RAM 0x10800000 size 0x00800000
D/TC:0 0 add_phys_mem:536 VCORE_UNPG_RW_PA type TEE_RAM_RW 0x10147000 size 0x006b9000
D/TC:0 0 add_phys_mem:536 VCORE_UNPG_RX_PA type TEE_RAM_RX 0x10100000 size 0x00047000
D/TC:0 0 add_phys_mem:536 BCM2836_BASE type IO_SEC 0x40000000 size 0x00200000
D/TC:0 0 add_phys_mem:536 CONSOLE_UART_BASE type IO_NSEC 0x3f200000 size 0x00200000
D/TC:0 0 verify_special_mem_areas:474 No NSEC DDR memory area defined
D/TC:0 0 add_va_space:575 type RES_VASPACE size 0x00a00000
D/TC:0 0 add_va_space:575 type SHM_VASPACE size 0x02000000
D/TC:0 0 dump_mmap_table:708 type TEE_RAM_RX   va 0x10100000..0x10146fff pa 0x10100000..0x10146fff size 0x00047000 (smallpg)
D/TC:0 0 dump_mmap_table:708 type TEE_RAM_RW   va 0x10147000..0x107fffff pa 0x10147000..0x107fffff size 0x006b9000 (smallpg)
D/TC:0 0 dump_mmap_table:708 type SHM_VASPACE  va 0x10800000..0x127fffff pa 0x00000000..0x01ffffff size 0x02000000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type IO_SEC       va 0x12800000..0x129fffff pa 0x40000000..0x401fffff size 0x00200000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type RES_VASPACE  va 0x12a00000..0x133fffff pa 0x00000000..0x009fffff size 0x00a00000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type TA_RAM       va 0x13400000..0x13bfffff pa 0x10800000..0x10ffffff size 0x00800000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type NSEC_SHM     va 0x13c00000..0x13ffffff pa 0x08000000..0x083fffff size 0x00400000 (pgdir)
D/TC:0 0 dump_mmap_table:708 type IO_NSEC      va 0x14000000..0x141fffff pa 0x3f200000..0x3f3fffff size 0x00200000 (pgdir)

INFO:     BL31_BASE is 100e0000, BL_CODE_BASE is 100e0000 !
make -j4 V=50
wield, verbose no effect

add in /home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/plat/rpi3/rpi3_common.c:rpi3_setup_page_tables 

	uintptr_t rd_start = UL(0x02000000);
	uintptr_t rd_limit = UL(0x02001000);

	INFO("rd added region: %p - %p\n",
		(void *) rd_start, (void *) rd_limit);
	mmap_add_region(rd_start, rd_limit,
			rd_limit - rd_start,
			MT_MEMORY | MT_RW | MT_NS);


/home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/plat/rpi3/include/platform_def.h
#define MAX_XLAT_TABLES		4 -> 5
#define MAX_MMAP_REGIONS	8 -> 9


sha256 added from https://github.com/amosnier/sha-2 

	uintptr_t* p = (void*)(UL(0x02000010));


U-Boot 2018.11 (Apr 29 2019 - 19:06:25 -0400)

DRAM:  948 MiB
RPI 3 Model B (0xa22082)
ERROR:   rpi3: Interrupt routed to EL3.
ERROR:   rd: Disabling secure physical timer!
ERROR:   rd: Accessing normal world kernel memory!
INFO:    rd: now accessing mapped kernel memory!
Unhandled Exception in EL3.
x30 =		0x00000000100e4220
x0 =		0x0000000002000010
x1 =		0x000000003f215040
x2 =		0x0000000000000060
x3 =		0x0000000000000000
x4 =		0x00000000e67de3d0
x5 =		0x0000000000000000
x6 =		0x00000000ae6c0fa0
x7 =		0x000000003c6c0a3c
x8 =		0x000000003f00b800
x9 =		0x000000003af5ded8
x10 =		0x000000001100085c
x11 =		0x0000000000000017
x12 =		0x0000000000000000
x13 =		0x0000000000000000
x14 =		0x00000000431bde82
x15 =		0x000000003af5dd24
x16 =		0x0000000000000000
x17 =		0x0000000000000000
x18 =		0x0000000000000000
x19 =		0x0000000000000000
x20 =		0x00000000100ed1d0
x21 =		0x0000000000000000
x22 =		0x0000000000000000
x23 =		0x0000000000000000
x24 =		0x0000000000000000
x25 =		0x0000000000000000
x26 =		0x0000000000000000
x27 =		0x0000000000000000
x28 =		0x0000000000000000
x29 =		0x00000000100ea090
scr_el3 =		0x0000000000000335
sctlr_el3 =		0x0000000030cd183f
cptr_el3 =		0x0000000000000000
tcr_el3 =		0x0000000080803520
daif =		0x00000000000003c0
mair_el3 =		0x00000000004404ff
spsr_el3 =		0x00000000200002cc
elr_el3 =		0x00000000100e4228
ttbr0_el3 =		0x00000000100edac0
esr_el3 =		0x0000000096000007
far_el3 =		0x0000000002000010
spsr_el1 =		0x0000000000000000
elr_el1 =		0x0000000000000000
spsr_abt =		0x0000000000000000
spsr_und =		0x0000000000000000
spsr_irq =		0x0000000000000000
spsr_fiq =		0x0000000000000000
sctlr_el1 =		0x0000000000c50838
actlr_el1 =		0x0000000000000000
cpacr_el1 =		0x0000000000000000
csselr_el1 =		0x0000000000000000
sp_el1 =		0x0000000000000000
esr_el1 =		0x0000000000000000
ttbr0_el1 =		0x0000000000000000
ttbr1_el1 =		0x0000000000000000
mair_el1 =		0x0000000000000000
amair_el1 =		0x0000000000000000
tcr_el1 =		0x0000000000000000
tpidr_el1 =		0x0000000000000000
tpidr_el0 =		0x0000000000000000
tpidrro_el0 =		0x0000000000000000
dacr32_el2 =		0x00000000ffffffff
ifsr32_el2 =		0x0000000000000000
par_el1 =		0x0000000000000000
mpidr_el1 =		0x0000000080000000
afsr0_el1 =		0x0000000000000000
afsr1_el1 =		0x0000000000000000
contextidr_el1 =		0x0000000000000000
vbar_el1 =		0x000000003b362000
cntp_ctl_el0 =		0x0000000000000000
cntp_cval_el0 =		0x1bf5fb7e879b4eed
cntv_ctl_el0 =		0x0000000000000002
cntv_cval_el0 =		0xbcce77bbb06ff8fe
cntkctl_el1 =		0x0000000000000000
sp_el0 =		0x00000000100ea090
isr_el1 =		0x0000000000000000
cpuectlr_el1 =		0x0000000000000040
cpumerrsr_el1 =		0x0000000000000000
l2merrsr_el1 =		0x0000000000000000
cpuactlr_el1 =		0x00001000090ca000

figure out tomorrow.

INFO:    /home/osboxes/Desktop/raspbian-tee/arm-trusted-firmware/plat/rpi3/rpi3_bl31_setup.c:bl31_plat_arch_setup!
INFO:     BL31_BASE is 100e0000, BL_CODE_BASE is 100e0000 !
INFO:    Trusted SRAM seen by this BL image: 0x100e0000 - 0x100f5000
INFO:    Code region: 0x100e0000 - 0x100e7000
INFO:    Read-only data region: 0x100e7000 - 0x100e9000
INFO:    Coherent region: 0x100f4000 - 0x100f5000
INFO:    rd added region: 0x2000000 - 0x2001000

turns out //void mmap_add_region(unsigned long long base_pa, uintptr_t base_va,size_t size, unsigned int attr)
the second arg is base_va, i thought it was limit, mb. stupid mistake..

now working like a charm.

INFO:    rpi3: Interrupt routed to EL3.
INFO:    rd: Disabling secure physical timer!
INFO:    rd: Accessing normal world kernel memory!
INFO:    rd: now accessing mapped kernel memory!
INFO:    rd: accessed mapped kernel memory is e1a00000e1a00000!
INFO:    calculating calc_sha_256 now!
INFO:    calc_sha_256 give hash: h2W ��|��UK1=p�Z̻}ĵ�����s!
INFO:    rd: Reconfigure timer to fire time_ms from now!


https://llvm.org/doxygen/BasicBlock_8h_source.html

 /// LLVM Basic Block Representation
 ///
 /// This represents a single basic block in LLVM. A basic block is simply a
 /// container of instructions that execute sequentially. Basic blocks are Values
 /// because they are referenced by instructions such as branches and switch
 /// tables. The type of a BasicBlock is "Type::LabelTy" because the basic block
 /// represents a label to which a branch can jump.
 ///
 /// A well formed basic block is formed of a list of non-terminating
 /// instructions followed by a single terminator instruction. Terminator
 /// instructions may not occur in the middle of basic blocks, and must terminate
 /// the blocks. The BasicBlock class allows malformed basic blocks to occur
 /// because it may be useful in the intermediate stage of constructing or
 /// modifying a program. However, the verifier will ensure that basic blocks are
 /// "well formed".


https://llvm.org/doxygen/classllvm_1_1TerminatorInst.html#details
llvm::TerminatorInst Class Reference
Detailed Description
Subclasses of this class are all able to terminate a basic block.
Thus, these are all the flow control type of operations.

https://releases.llvm.org/1.1/docs/Stacker.html#terminate
All BasicBlocks in your compiler must be terminated with a terminating instruction (branch, return, etc.).
Terminating instructions are a semantic requirement of the LLVM IR. There is no facility for implicitly chaining together blocks placed into a function in the order they occur. Indeed, in the general case, blocks will not be added to the function in the order of execution because of the recursive way compilers are written.

http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.232.3942&rep=rep1&type=pdf
Branches and return instructions are only allowed as the last instruction of a basic block and
each basic block is terminated by one of these instructions.

http://www.cs.cmu.edu/~15745/llvm-doxygen/de/dd7/a09235.html#details
Detailed Description
A basic block represents a single entry single exit section of code.
Basic blocks contain a list of instructions which form the body of the block.
Basic blocks belong to functions. They have the type of label.
Basic blocks are themselves values. However, the C API models them as LLVMBasicBlockRef.

B – Branch
PC := <address>
BL – Branch with Link
R14 := address of next instruction, PC := <address>

We use the bl instruction as the dispatch instruction. The value of lr after the
dispatch is used to identify the call site of the trampoline.

so basically logging pc location before each bl instruction.

we dont need pc location, but only bb id?

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ihi0014q/I88594.html 

For direct branches (B, BL, or BLX <immediate> instructions) the assembler code provides an offset to be added to the current PC. All direct branches are branches whose target can be determined solely from the executed instruction. Therefore, to calculate the destination of the branch, it is necessary only to know the address of the instruction, along with the fact that it executed.

Direct branch instructions
Direct branches in ARM, Thumb, and ThumbEE instruction sets are defined to be the following:
B: Branch.
BL: Branch with link.
BLX immed:  Branch with link and exchange instruction sets, immediate.
CBZ: Compare and branch on zero, Thumb and ThumbEE instruction sets only.
CBNZ: Compare and branch on nonzero, Thumb and ThumbEE instruction sets only.
ENTERX: Enter ThumbEE state, from Thumb state only.
LEAVEX: Leave ThumbEE state, from ThumbEE state only.

The branch address must be output only when the program flow changes for a reason other than a direct branch. These are collectively known as indirect branches. Examples of indirect branches are:
1. a load instruction (LDR or LDM) with the PC as one of the destination registers
2. a data operation (MOV or ADD, for example) with the PC as the destination register
3. a BX instruction, that moves a register into the PC
4. a SVC instruction or an Undefined Instruction exception
5. all other exceptions, such as interrupt, abort, and processor reset.

An indirect branch (also known as a computed jump, indirect jump and register-indirect jump) is a type of program control instruction present in some machine language instruction sets. Rather than specifying the address of the next instruction to execute, as in a direct branch, the argument specifies where the address is located. An example is 'jump indirect on the r1 register', which means that the next instruction to be executed is at the address in register r1. The address to be jumped to is not known until the instruction is executed. Indirect branches can also depend on the value of a memory location.


checking indirect in assemble from -S:

clang++ -S -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 --sysroot=/media/rpi --gcc-toolchain=/media/rpi/usr -I/media/rpi/usr/include/arm-linux-gnueabihf -I/media/rpi/usr/include/arm-linux-gnueabihf/c++/6 -MMD --target=arm-linux-gnueabihf --gcc-toolchain=/usr --sysroot=/ -B/usr/bin -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_native_rpi3" -DCONFIG_HAL_BOARD=HAL_BOARD_LINUX -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_NAVIO2 ../../libraries/AP_Baro/AP_Baro_BMP085.cpp

add '-S' to navio2.cache all the .o files becomes assembly!

osboxes@osboxes:~/Desktop/ardupilot_native_rpi3/build/navio2$ grep -r './' -e 'ldr' | grep pc
./libraries/AP_AccelCal/AccelCalibrator.cpp.0.o:	ldr	pc, [r0, r1]
./libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o:	ldr	pc, [r0, r1]
./libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o:	ldr	pc, [r0, r1]
./libraries/AP_Airspeed/AP_Airspeed.cpp.0.o:	ldr	pc, [r0, r1]
./libraries/AP_AdvancedFailsafe/AP_AdvancedFailsafe.cpp.0.o:	ldr	pc, [r2, r3]
./libraries/AP_Common/Location.cpp.0.o:	ldr	pc, [r0, r1]
./libraries/AP_Common/Location.cpp.0.o:	ldr	pc, [r0, r1]
./libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o:	ldr	pc, [r2, r3]
./libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o:	ldr	pc, [r1, r2]
./libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o:	ldr	pc, [r2, r3]


osboxes@osboxes:~/Desktop/ardupilot_native_rpi3/build/navio2$ grep -rnw './' -e 'pc' | grep -v 'pop'
./libraries/AP_AccelCal/AccelCalibrator.cpp.0.o:292:	ldr	pc, [r0, r1]
./libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o:166:	ldr	pc, [r0, r1]
./libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o:969:	ldr	pc, [r0, r1]
./libraries/AP_Airspeed/AP_Airspeed.cpp.0.o:122:	ldr	pc, [r0, r1]
./libraries/AP_AdvancedFailsafe/AP_AdvancedFailsafe.cpp.0.o:165:	ldr	pc, [r2, r3]
./libraries/AP_Common/Location.cpp.0.o:577:	ldr	pc, [r0, r1]
./libraries/AP_Common/Location.cpp.0.o:669:	ldr	pc, [r0, r1]
./libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o:918:	ldr	pc, [r2, r3]
./libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o:956:	ldr	pc, [r1, r2]
./libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o:1022:	ldr	pc, [r2, r3]


actually, pop {xxx, ..., pc} pop the stack value to pc register. and change control flow.

start from:
(before are all about implementing property)
/home/osboxes/Desktop/llvm/lib/Transforms/Instrumentation/ComprehensiveStaticInstrumentation.cpp: line 435
/// The Comprehensive Static Instrumentation pass.
/// Inserts calls to user-defined hooks at predefined points in the IR.
struct ComprehensiveStaticInstrumentation : public ModulePass {

  for (BasicBlock &BB : F) {
    SmallVector<Instruction *, 8> BBLoadsAndStores;
    for (Instruction &I : BB) {
      if (isAtomic(&I))
        AtomicAccesses.push_back(&I);
      else if (isa<LoadInst>(I) || isa<StoreInst>(I)) {
        BBLoadsAndStores.push_back(&I);
      } else if (isa<ReturnInst>(I)) {
        ReturnInstructions.push_back(&I);
      } else if (isa<CallInst>(I) || isa<InvokeInst>(I)) {
        if (isa<MemIntrinsic>(I)) {
          MemIntrinsics.push_back(&I);
        } else {
          Callsites.push_back(&I);
        }
        computeLoadAndStoreProperties(LoadAndStoreProperties, BBLoadsAndStores,
                                      DL);
      }
    }
    computeLoadAndStoreProperties(LoadAndStoreProperties, BBLoadsAndStores, DL);
    BasicBlocks.push_back(&BB);
  }

call: CallInst, InvokeInst
Return: ReturnInst, (resume)
Branch: (br) (indirectbr) (switch)
Unreachable: (unreachable)

to enforce inter-procedule:
1.
cficall
call
cfiReturned
2.
cfiexit
exit/unreachabke
3.
cfienter
entry

to enforce intra-procedule:
1.
cfibeforejump
branch
2.
cfiafterjump
bb-start

https://www.aosabook.org/en/llvm.html
Each LLVM pass is written as a C++ class that derives (indirectly) from the Pass class. Most passes are written in a single .cpp file, and their subclass of the Pass class is defined in an anonymous namespace (which makes it completely private to the defining file). In order for the pass to be useful, code outside the file has to be able to get it, so a single function (to create the pass) is exported from the file. Here is a slightly simplified example of a pass to make things concrete.6



/home/osboxes/Desktop/llvm/include/llvm/IR/IRBuilder.h
/// \brief This provides a uniform API for creating instructions and inserting
/// them into a basic block: either at the end of a BasicBlock, or at a specific
/// iterator location in a block.
///
/// Note that the builder does not expose the full generality of LLVM
/// instructions.  For access to extra instruction properties, use the mutators
/// (e.g. setVolatile) on the instructions after they have been
/// created. Convenience state exists to specify fast-math flags and fp-math
/// tags.
///
/// The first template argument specifies a class to use for creating constants.
/// This defaults to creating minimally folded constants.  The second template
/// argument allows clients to specify custom insertion hooks that are called on
/// every newly created insertion.
template <typename T = ConstantFolder,
          typename Inserter = IRBuilderDefaultInserter>
class IRBuilder : public IRBuilderBase, public Inserter {
  T Folder;

  CallInst *CreateCall(llvm::FunctionType *FTy, Value *Callee,
                       ArrayRef<Value *> Args, const Twine &Name = "",
                       MDNode *FPMathTag = nullptr) {
    CallInst *CI = CallInst::Create(FTy, Callee, Args, DefaultOperandBundles);
    if (isa<FPMathOperator>(CI))
      CI = cast<CallInst>(AddFPMathAttributes(CI, FPMathTag, FMF));
    return Insert(CI, Name);
  }

CallInst::Create is the one to create inserted functions. (both in picon and csi)

summary:
1. picon and csi both use llvm pass, picon make llvm pass source external, csi embed it in llvm build process
2. csi use weak symbol to instrument, but it actually make no much diff from picon, both use c code to serve as inserted function. though picon need to recompile llvm pass then compile target, while csi need to recompile inserted function then compile target linking the updated inserted function.
3. picon care about control flow related ones. csi care about subset of control flow related ones and load/store llvm IR instruction.



first create code segments in target memory by inserting function prototypes
void injectorCFI::injectPrototype(void) {
  Function *func___CFI_INTERNAL_BB_AFTER_BR = Function::Create(
      /*Type=*/FuncTy_1,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_BB_AFTER_BR", &_M); // (external, no body)

  Function *func___CFI_INTERNAL_BB_BEFORE_BR = Function::Create(
      /*Type=*/FuncTy_1,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_BB_BEFORE_BR", &_M); // (external, no body)
  Function* func___CFI_INTERNAL_ENTER = Function::Create(
      /*Type=*/FuncTy_2,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_ENTER", &_M); // (external, no body)

  Function* func___CFI_INTERNAL_EXIT = Function::Create(
      /*Type=*/FuncTy_2,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_EXIT", &_M); // (external, no body)

  Function *func___CFI_INTERNAL_CALL = Function::Create(
      /*Type=*/FuncTy_3,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_CALL", &_M); // (external, no body)

  Function *func___CFI_INTERNAL_RETURNED = Function::Create(
      /*Type=*/FuncTy_3,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_RETURNED", &_M); // (external, no body)

  Function *func___CFI_INTERNAL_FORK_SON= Function::Create(
      /*Type=*/FuncTy_3,
      /*Linkage=*/GlobalValue::ExternalLinkage,
      /*Name=*/"__CFI_INTERNAL_FORK_SON", &_M); // (external, no body)
}

then insert llvm IR call inst to call above func.s.
void injectorCFI::injectMentry(Function& F, int FctID) {
Function *funcEnter = _M.getFunction("__CFI_INTERNAL_ENTER");
Instruction *EntryPos = dyn_cast<Instruction>(F.getEntryBlock().getFirstInsertionPt());
std::vector<Value*> Args;
Value *ID = llvm::ConstantInt::get(_M.getContext(), llvm::APInt(32, FctID, true));
Args.push_back(ID);
Args.push_back(retAddrCall);
CallInst* callfctEnter = CallInst::Create(funcEnter, Args, "", EntryPos);
}

EntryPos is entry position, i.e. entry code memory location for first instruction.
funcEnter is the inserted function
Args is func_id and return addr back to caller

void injectorCFI::injectMexit(Function &F, int FctID) {
BasicBlock *Last;
for (auto &BB : F) {
  Last = &BB;
} // rd: this iterate all BBs in this function
ExitPos = Last->getTerminator();
CallInst* callfctEnter = CallInst::Create(funcEnter, Args, "", ExitPos);
}

void injectorCFI::injectMcall(ControlFlowIntegrity *cfi, Function &F) {
for (auto &BB : F) { // iterate BB in function
for (auto &I : BB) { // iterate Instruction in BB
}



/home/osboxes/Desktop/llvm/include/llvm/IR/Instructions.h
  /// getCalledFunction - Return the function called, or null if this is an
  /// indirect function invocation.
  ///
  Function *getCalledFunction() const {
    return dyn_cast<Function>(Op<-1>());
  }

  /// getCalledValue - Get a pointer to the function that is invoked by this
  /// instruction.
  const Value *getCalledValue() const { return Op<-1>(); }
        Value *getCalledValue()       { return Op<-1>(); }


Following need to get idBB from where bl is going to(but not from where it is supposed to go to), or else it cannot protect cfi.
void injectorCFI::injectBBLeave(ControlFlowIntegrity *cfi, Function &F) {
  Function *funcBBLeave = _M.getFunction("__CFI_INTERNAL_BB_BEFORE_BR");
  unsigned int idBB = 0;

  if (funcBBLeave == NULL)
    assert(0 && "__CFI_INTERNAL_BB_BEFORE_BR must be defined");
  // inject before each terminator instructions
  // (ret, br, switch, indirectbr, invoke, resume, unreachable) function
  // with no parameters, to notify the monitor of the new state.
  // (a.k.a: waiting for a BBEnter)

  // do not inject if the BB is the last BB of the function

  for (auto &BB : F) {
    if (&BB == &F.back()) {
      break ;
    }
    std::vector<Value*> Args;
    Value *ID = llvm::ConstantInt::get(_M.getContext(), llvm::APInt(32, cfi->getIdentifier(&F), true));
    Args.push_back(ID);
    ID = llvm::ConstantInt::get(_M.getContext(), llvm::APInt(32, idBB, true));
    Args.push_back(ID);
    CallInst *callfctBBLeave = CallInst::Create(funcBBLeave, Args, "", BB.getTerminator());
    ++idBB;
  }
}


  /// Twine - A lightweight data structure for efficiently representing the
  /// concatenation of temporary values as strings.

static CallInst *Create(Value *Func, ArrayRef<Value *> Args,
                          const Twine &NameStr, BasicBlock *InsertAtEnd) {
    return new (unsigned(Args.size() + 1))
        CallInst(Func, Args, None, NameStr, InsertAtEnd);
}

/home/osboxes/Desktop/llvm/include/llvm/IR/Instructions.h
CallInst::CallInst(Value *Func, ArrayRef<Value *> Args,
                   ArrayRef<OperandBundleDef> Bundles, const Twine &NameStr,
                   BasicBlock *InsertAtEnd)
    : Instruction(
          cast<FunctionType>(cast<PointerType>(Func->getType())
                                 ->getElementType())->getReturnType(),
          Instruction::Call, OperandTraits<CallInst>::op_end(this) -
                                 (Args.size() + CountBundleInputs(Bundles) + 1),
          unsigned(Args.size() + CountBundleInputs(Bundles) + 1), InsertAtEnd) {
  init(Func, Args, Bundles, NameStr);
}


Args contains func_id and bb_id.


void HIDDEN __CFI_INTERNAL_BB_BEFORE_BR(uint32_t f_id, uint32_t idBB) {
  _cs.event = CFI_BEFORE_JUMP;
  _cs.function = f_id;
  _cs.block = idBB;

  send_monitor(_cs);
}

DSO is a "dynamic shared object", often just ".so".

link ardupoilot and csi and optee:

script to switch btw sim and real and have fun:
real:
use ./ardupilot/build/c4che/navio2_cache.py
alias waf="$PWD/modules/waf/waf-light"
waf --targets bin/arducopter -v
llvm-ar q libarducopter.a ...
/home/osboxes/Desktop/prof-lite.o compiled in rpi3
 /usr/bin/arm-linux-gnueabihf-ld.gold --sysroot=/media/rpi -z relro -X --hash-style=both --eh-frame-hdr -m armelf_linux_eabi -dynamic-linker /lib/ld-linux-armhf.so.3 -o bin/arducopter2 -lteec -L/home/osboxes/Desktop/raspbian-tee/optee_client/out/export/lib /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crt1.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crti.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtbegin.o -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../../lib -L/media/rpi/lib/arm-linux-gnueabihf -L/media/rpi/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf -L/media/rpi/usr/lib/../lib -L/media/rpi/usr/lib/arm-linux-gnueabihf/../../lib -L/media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../.. -L/media/rpi/lib -L/media/rpi/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=cortex-a8 -plugin-opt=O0 libarducopter.a /home/osboxes/Desktop/prof-lite.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-armhf.a -Bdynamic /media/rpi/lib/arm-linux-gnueabihf/libdl-2.24.so -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/crtend.o /media/rpi/usr/lib/gcc/arm-linux-gnueabihf/6.3.0/../../../arm-linux-gnueabihf/crtn.o

-lteec -L/home/osboxes/Desktop/raspbian-tee/optee_client/out/export/lib

compile process:
tweak /home/pi/llvm/csi/toolkit/prof-lite.cpp
make in /home/pi/llvm/csi/toolkit/
move-o-here.sh in /home/osboxes/Desktop
link using above at /home/osboxes/Desktop/ardupilot_instru_rpi3/build/navio2
move to rpi3 through /home/osboxes/Desktop/ardupilot_instru_rpi3/build/navio2/bin/move_bin.sh

current status: optee works
current issue: remember some func_id does not init csi before call in __csi_func_before?
workaround, put these func_id in the func_id == xxxx

pi@navio:~ $ sudo ./arducopter2
__csi_bb_entry number 0! bb_id is 0!
Invoking PTA to increment op.params[0].value.a: 0
Segmentation fault

BB before Init.

now all works!


void ComprehensiveStaticInstrumentation::initializeLoadStoreHooks(Module &M) {
  LLVMContext &C = M.getContext();
  IRBuilder<> IRB(C);
  Type *LoadPropertyTy = CsiLoadStoreProperty::getType(C);
  Type *StorePropertyTy = CsiLoadStoreProperty::getType(C);
  Type *RetType = IRB.getVoidTy();
  Type *AddrType = IRB.getInt8PtrTy();
  Type *NumBytesType = IRB.getInt32Ty();

  CsiBeforeRead = checkCsiInterfaceFunction(
      M.getOrInsertFunction("__csi_before_load", RetType, IRB.getInt64Ty(),
                            AddrType, NumBytesType, LoadPropertyTy, nullptr));
  CsiAfterRead = checkCsiInterfaceFunction(
      M.getOrInsertFunction("__csi_after_load", RetType, IRB.getInt64Ty(),
                            AddrType, NumBytesType, LoadPropertyTy, nullptr));

  CsiBeforeWrite = checkCsiInterfaceFunction(
      M.getOrInsertFunction("__csi_before_store", RetType, IRB.getInt64Ty(),
                            AddrType, NumBytesType, StorePropertyTy, nullptr));
  CsiAfterWrite = checkCsiInterfaceFunction(
      M.getOrInsertFunction("__csi_after_store", RetType, IRB.getInt64Ty(),
                            AddrType, NumBytesType, StorePropertyTy, nullptr));

  MemmoveFn = checkCsiInterfaceFunction(
      M.getOrInsertFunction("memmove", IRB.getInt8PtrTy(), IRB.getInt8PtrTy(),
                            IRB.getInt8PtrTy(), IntptrTy, nullptr));
  MemcpyFn = checkCsiInterfaceFunction(
      M.getOrInsertFunction("memcpy", IRB.getInt8PtrTy(), IRB.getInt8PtrTy(),
                            IRB.getInt8PtrTy(), IntptrTy, nullptr));
  MemsetFn = checkCsiInterfaceFunction(
      M.getOrInsertFunction("memset", IRB.getInt8PtrTy(), IRB.getInt8PtrTy(),
                            IRB.getInt32Ty(), IntptrTy, nullptr));
}

void ComprehensiveStaticInstrumentation::addLoadStoreInstrumentation(
    Instruction *I, Function *BeforeFn, Function *AfterFn, Value *CsiId,
    Type *AddrType, Value *Addr, int NumBytes, CsiLoadStoreProperty &Prop) {
  IRBuilder<> IRB(I);
  Value *PropVal = Prop.getValue(IRB);
  insertConditionalHookCall(I, BeforeFn,
                            {CsiId, IRB.CreatePointerCast(Addr, AddrType),
                                IRB.getInt32(NumBytes), PropVal});

  BasicBlock::iterator Iter(I);
  Iter++;
  IRB.SetInsertPoint(&*Iter);
  insertConditionalHookCall(&*Iter, AfterFn,
                            {CsiId, IRB.CreatePointerCast(Addr, AddrType),
                                IRB.getInt32(NumBytes), PropVal});
}

void ComprehensiveStaticInstrumentation::instrumentLoadOrStore(
    Instruction *I, CsiLoadStoreProperty &Prop, const DataLayout &DL) {
  IRBuilder<> IRB(I);
  bool IsWrite = isa<StoreInst>(I);
  Value *Addr = IsWrite ? cast<StoreInst>(I)->getPointerOperand()
                        : cast<LoadInst>(I)->getPointerOperand();
  int NumBytes = getNumBytesAccessed(Addr, DL);
  Type *AddrType = IRB.getInt8PtrTy();

  if (NumBytes == -1)
    return; // size that we don't recognize

  if (IsWrite) {
    uint64_t LocalId = StoreFED.add(*I);
    Value *CsiId = StoreFED.localToGlobalId(LocalId, IRB);
    addLoadStoreInstrumentation(I, CsiBeforeWrite, CsiAfterWrite, CsiId,
                                AddrType, Addr, NumBytes, Prop);
  } else { // is read
    uint64_t LocalId = LoadFED.add(*I);
    Value *CsiId = LoadFED.localToGlobalId(LocalId, IRB);
    addLoadStoreInstrumentation(I, CsiBeforeRead, CsiAfterRead, CsiId, AddrType,
                                Addr, NumBytes, Prop);
  }
}

my understanding:
Instruction *I // is the llvm ir instruction
IRBuilder<> IRB(I); // covert it to a IRB type
Value *Addr = IsWrite ? cast<StoreInst>(I)->getPointerOperand()
                        : cast<LoadInst>(I)->getPointerOperand(); // get the read from or write to target address from Operand
int NumBytes = getNumBytesAccessed(Addr, DL); // get number of bytes read from or write to

for arducopter:

"/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/arducopter /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0 ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o -lArduCopter_libs /home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o


for ardurover:
 "/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/ardurover /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0 APMrover2/APMrover2.cpp.19.o APMrover2/AP_Arming.cpp.19.o APMrover2/AP_MotorsUGV.cpp.19.o APMrover2/GCS_Mavlink.cpp.19.o APMrover2/Log.cpp.19.o APMrover2/Parameters.cpp.19.o APMrover2/Rover.cpp.19.o APMrover2/Steering.cpp.19.o APMrover2/afs_rover.cpp.19.o APMrover2/balance_bot.cpp.19.o APMrover2/capabilities.cpp.19.o APMrover2/commands.cpp.19.o APMrover2/commands_logic.cpp.19.o APMrover2/compat.cpp.19.o APMrover2/control_modes.cpp.19.o APMrover2/crash_check.cpp.19.o APMrover2/cruise_learn.cpp.19.o APMrover2/failsafe.cpp.19.o APMrover2/fence.cpp.19.o APMrover2/mode.cpp.19.o APMrover2/mode_acro.cpp.19.o APMrover2/mode_auto.cpp.19.o APMrover2/mode_guided.cpp.19.o APMrover2/mode_hold.cpp.19.o APMrover2/mode_loiter.cpp.19.o APMrover2/mode_manual.cpp.19.o APMrover2/mode_rtl.cpp.19.o APMrover2/mode_smart_rtl.cpp.19.o APMrover2/mode_steering.cpp.19.o APMrover2/motor_test.cpp.19.o APMrover2/radio.cpp.19.o APMrover2/sensors.cpp.19.o APMrover2/system.cpp.19.o APMrover2/version.cpp.19.o -lAPMrover2_libs /home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o

for arduplane:
"/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/arduplane /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0 ArduPlane/AP_Arming.cpp.22.o ArduPlane/ArduPlane.cpp.22.o ArduPlane/Attitude.cpp.22.o ArduPlane/GCS_Mavlink.cpp.22.o ArduPlane/GCS_Plane.cpp.22.o ArduPlane/Log.cpp.22.o ArduPlane/Parameters.cpp.22.o ArduPlane/Plane.cpp.22.o ArduPlane/afs_plane.cpp.22.o ArduPlane/altitude.cpp.22.o ArduPlane/avoidance_adsb.cpp.22.o ArduPlane/capabilities.cpp.22.o ArduPlane/commands.cpp.22.o ArduPlane/commands_logic.cpp.22.o ArduPlane/control_modes.cpp.22.o ArduPlane/events.cpp.22.o ArduPlane/failsafe.cpp.22.o ArduPlane/geofence.cpp.22.o ArduPlane/is_flying.cpp.22.o ArduPlane/motor_test.cpp.22.o ArduPlane/navigation.cpp.22.o ArduPlane/parachute.cpp.22.o ArduPlane/px4_mixer.cpp.22.o ArduPlane/quadplane.cpp.22.o ArduPlane/radio.cpp.22.o ArduPlane/sensors.cpp.22.o ArduPlane/servos.cpp.22.o ArduPlane/soaring.cpp.22.o ArduPlane/system.cpp.22.o ArduPlane/tailsitter.cpp.22.o ArduPlane/takeoff.cpp.22.o ArduPlane/tiltrotor.cpp.22.o ArduPlane/tuning.cpp.22.o ArduPlane/version.cpp.22.o -lArduPlane_libs /home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o

ardusub:
"/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/ardusub /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0 ArduSub/AP_Arming_Sub.cpp.20.o ArduSub/AP_State.cpp.20.o ArduSub/ArduSub.cpp.20.o ArduSub/Attitude.cpp.20.o ArduSub/GCS_Mavlink.cpp.20.o ArduSub/Log.cpp.20.o ArduSub/Parameters.cpp.20.o ArduSub/Sub.cpp.20.o ArduSub/UserCode.cpp.20.o ArduSub/capabilities.cpp.20.o ArduSub/commands.cpp.20.o ArduSub/commands_logic.cpp.20.o ArduSub/control_acro.cpp.20.o ArduSub/control_althold.cpp.20.o ArduSub/control_auto.cpp.20.o ArduSub/control_circle.cpp.20.o ArduSub/control_guided.cpp.20.o ArduSub/control_manual.cpp.20.o ArduSub/control_poshold.cpp.20.o ArduSub/control_stabilize.cpp.20.o ArduSub/control_surface.cpp.20.o ArduSub/failsafe.cpp.20.o ArduSub/fence.cpp.20.o ArduSub/flight_mode.cpp.20.o ArduSub/inertia.cpp.20.o ArduSub/joystick.cpp.20.o ArduSub/motors.cpp.20.o ArduSub/position_vector.cpp.20.o ArduSub/radio.cpp.20.o ArduSub/sensors.cpp.20.o ArduSub/surface_bottom_detector.cpp.20.o ArduSub/system.cpp.20.o ArduSub/terrain.cpp.20.o ArduSub/turn_counter.cpp.20.o ArduSub/version.cpp.20.o -lArduSub_libs /home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o


template
"/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/(1. ardurover)
/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0

2 .... (get from last link command)
3. -lAPMrover2_libs

/home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o


(1)instrumentation in sim procedule:
-1. cp -r ardupilot_native_sim_rover ardupilot_instru_sim_rover
0. alias waf="$PWD/modules/waf/waf-light"
1. rm -rf build/
2. CC=clang CXX=clang++ waf configure
3. add "'-g', '-O0', '-fcsi', '-flto'" to sitl_cache.py
4. cd APMrover2/
5. CC=clang CXX=clang++ ../Tools/autotest/sim_vehicle.py --map --console to compile llvm bitcode
6. link with above at /build/sitl
7. comment out 340-358 in sim_vehicle.py, uncomment 338
8. cd APMrover2/
9. ../Tools/autotest/sim_vehicle.py --map --console
*. remember to modify toolkit.o in sitl_cache.py and in link command if change instrumentation tools.

instrumentation in rover sim mode done!


(0)native in sim procedule:
-1. cp -r ardupilot_native_sim ardupilot_native_sim_rover
0. alias waf="$PWD/modules/waf/waf-light"
1. rm -rf build/
2. CC=clang CXX=clang++ waf configure
3. cd APMRover
4. ../Tools/autotest/sim_vehicle.py --map --console



list: copter rover plane submarine

SITL can simulate:

multi-rotor aircraft
fixed wing aircraft
ground vehicles
underwater vehicles
camera gimbals
antenna trackers
a wide variety of optional sensors, such as Lidars and optical flow sensors

finished: copter rover plane submarine

commands for mavproxy:
wp load ../Tools/autotest/CMAC-circuit.txt
mode auto
arm throttle

I/TC: rd_count_bb is right now 300003!
I/TC: rd_count_bb is right now 400004!
I/TC: secure payload EL-1 received FIQ! now panicing!
E/TC:0 0 Panic at core/arch/arm/plat-rpi3/main.c:68 <main_fiq>
E/TC:0 0 Call stack:
E/TC:0 0  0x000000001010ad48

INFO:    calculating calc_sha_256 now!
INFO:    calc_sha_256 give hash: h2W ��|��UK1=p�Z̻}ĵ�����s!
INFO:    rd: Reconfigure timer to fire time_ms from now!
I/TC: secure payload EL-1 received FIQ! now panicing!
E/TC:0 0 Panic at core/arch/arm/plat-rpi3/main.c:68 <main_fiq>
E/TC:0 0 Call stack:
E/TC:0 0  0x000000001010ad48


commented out /arm-trusted-firmware/plat/rpi3/rpi3_common.c INFO and *p access ns kernel memory test to see panic() in main_fiq at /home/osboxes/Desktop/raspbian-tee/optee_os/core/arch/arm/plat-rpi3/main.c

https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/interrupt-framework-design.rst#interrupt-types
This framework is responsible for managing interrupts routed to EL3. It also allows EL3 software to configure the interrupt routing behavior.
1.1.   Interrupt types
Secure EL1 interrupt. This type of interrupt can be routed to EL3 or Secure-EL1 depending upon the security state of the current execution context. It is always handled in Secure-EL1.
Non-secure interrupt. This type of interrupt can be routed to EL3, Secure-EL1, Non-secure EL1 or EL2 depending upon the security state of the current execution context. It is always handled in either Non-secure EL1 or EL2.
EL3 interrupt. This type of interrupt can be routed to EL3 or Secure-EL1 depending upon the security state of the current execution context. It is always handled in EL3.
The following constants define the various interrupt types in the framework implementation.

#define INTR_TYPE_S_EL1      0
#define INTR_TYPE_EL3        1
#define INTR_TYPE_NS         2

1.3.   Valid routing models

CSS. Current Security State. 0 when secure and 1 when non-secure
TEL3. Target Exception Level 3. 0 when targeted to the FEL. 1 when targeted to EL3.

1.3.3.   EL3 interrupts
CSS=0, TEL3=0. Interrupt is routed to the FEL when execution is in Secure-EL1/Secure-EL0. This is a valid routing model as secure software in Secure-EL1/Secure-EL0 is in control of how its execution is preempted by EL3 interrupt and can handover the interrupt to EL3 for handling.

CSS=0, TEL3=1. Interrupt is routed to EL3 when execution is in Secure-EL1/Secure-EL0. This is a valid routing model as secure software in EL3 can handle the interrupt.



/home/osboxes/Desktop/raspbian-tee/Makefile
add 	EL3_EXCEPTION_HANDLING=1
can't compile, this makes all exception handled in el3, i guess opteed needs to handle in el1 too.


my current guess: 
timer interrupt from S world is diff from from NS world. So current NS world works but not S world. I need to do same thing in S world(or pass it to el3 may be better).

https://buildmedia.readthedocs.org/media/pdf/optee/latest/optee.pdf
Deliver secure interrupts to Secure World
This section uses the Arm GICv1/v2 conventions: FIQ signals secure interrupts while IRQ signals non-secure interrupts. On a GICv3 configuration, one should exchange IRQ and FIQ in this section. A FIQ can be received during
two different states, either in normal world (SCR_NS is set) or in secure world (SCR_NS is cleared). When the secure
monitor is active (Armv8-A EL3 or Armv7-A Monitor mode) FIQ is masked. FIQ reception in the two different states
is described below.
Deliver FIQ to secure world when SCR_NS is cleared
Since SCR_FIQ is cleared when SCR_NS is cleared a FIQ will be delivered using the state vector (VBAR) in secure
world. The FIQ is received as any other exception by Trusted OS, the monitor is not involved at all.
Fig. 4: FIQ received while processing an IRQ forwarded from secure world


so my current impl is in el3 secure monitor, and only ns world fiq can be handled. now i need to add code in el1 main.c to make it forward this timer interrupt to el3 secure monitor.


http://www.valvers.com/programming/c/gcc-weak-function-attributes/
Weak attribute:
Here we see an excerpt of psuedo code where the library is running a thread which continually scans the keyboard. After each key press onKeypress is called with the character that was pressed. If this library is linked with an application that does not have a strong onKeypress function, the blank weak function is used from the library. Generally the optimiser will eliminate this call anyway (though in embedded versions of GCC it will make that blank call, as I’ve seen!)

see optee book chapter 12.8.

fiq in EL3 vs in S-EL1. all use main_fiq in S-EL1 to solve. but i need to change here. since S-EL1 cannot use el3 instruction to configure secure timer.


still did not clear fiq, need to clear it. 

turns out el1 can disable timer and enable timer (secure). thus copy el3 handler to main_fiq works.

now finding intrumentation take too much time. now use linker option -O3, this suppose to clear any WEAK symbols. 

compile time is: started from 2:58PM, finished at 3:11PM.

after optimization, all other instumentations become bl lr.

  >│0x480d8 <__csi_after_store>     bx     lr                                                                                                                                                              │
   │0x480dc <__csi_func_entry>      bx     lr                                                                                                                                                              │
   │0x480e0 <__csi_func_exit>       bx     lr                                                                                                                                                              │
   │0x480e4 <__csi_bb_exit>         bx     lr                                                                                                                                                              │
   │0x480e8 <__csi_before_call>     bx     lr                                                                                                                                                              │
   │0x480ec <__csi_after_call>      bx     lr 

but still, call into optee pta session is too much for it.

Current task:
get the right command to use and then log time.


TELEM1="-A udp:127.0.0.1:14550"  <-- Wifi
TELEM2="-C /dev/ttyAMA0"  <-- USB serial telemetry

ARDUPILOT_OPTS="$TELEM1 $TELEM2"

/usr/bin/arducopter ${ARDUPILOT_OPTS}

On PI:
sudo arducopter -A tcp:192.168.0.158:14550

On MavProxy:
mavproxy.py --master=tcp:192.168.0.158:14550


Comparison for every 10,000 basic blocks.

USE optee:
pi@navio:~ $ sudo ./arducopter2
Open session from user space! 
measure time microseconds is 614211, for loop is 10000!
Raspberry Pi 3 Model B Rev 1.2. (intern: 2)
measure time microseconds is 1314145, for loop is 10000!
measure time microseconds is 1794763, for loop is 10000!
measure time microseconds is 2319155, for loop is 10000!
measure time microseconds is 2785782, for loop is 10000!
measure time microseconds is 3214510, for loop is 10000!
measure time microseconds is 3694878, for loop is 10000!
measure time microseconds is 4225576, for loop is 10000!
measure time microseconds is 4718918, for loop is 10000!
measure time microseconds is 5258837, for loop is 10000!
Close session from user space! 
Finalize context from user space! 

NO optee:
pi@navio:~ $ sudo ./arducopter2
Open session from user space! 
measure time microseconds is 13757, for loop is 10000!
Raspberry Pi 3 Model B Rev 1.2. (intern: 2)
measure time microseconds is 166179, for loop is 10000!
measure time microseconds is 169749, for loop is 10000!
measure time microseconds is 173185, for loop is 10000!
measure time microseconds is 176661, for loop is 10000!
measure time microseconds is 180097, for loop is 10000!
measure time microseconds is 183541, for loop is 10000!
measure time microseconds is 187009, for loop is 10000!
measure time microseconds is 190443, for loop is 10000!
measure time microseconds is 193892, for loop is 10000!
Close session from user space! 
Finalize context from user space! 

So, for 10,000 bb: 500ms vs 3ms

I/TC: pta: current max_idx is now 51050:

uint32_t shared_mem[1000000] = {0}; 
in pta will used too much space.

uint32_t shared_mem[100000] = {0};
this is okay.

I/TC: pta: list shared_mem now:
I/TC: index 0 saved count is 293
I/TC: index 1 saved count is 328
I/TC: index 2 saved count is 52
I/TC: index 3 saved count is 73
I/TC: index 4 saved count is 144
I/TC: index 5 saved count is 25
I/TC: index 6 saved count is 51
I/TC: index 7 saved count is 16
I/TC: index 8 saved count is 30
I/TC: index 9 saved count is 69



partial fcsi:

"/home/osboxes/Desktop/ardupilot_instru_sim_copter/modules/waf/waf-light" "build" "--target" "bin/arducopter" "-v"


12:07:12 runner ['clang++', '-g', '-O0', '-flto', '-std=gnu++11', '-fdata-sections', '-ffunction-sections', '-fno-exceptions', '-fsigned-char', '-Wall', '-Wextra', '-Wformat', '-Wshadow', '-Wpointer-arith', '-Wcast-align', '-Wundef', '-Wno-unused-parameter', '-Wno-missing-field-initializers', '-Wno-reorder', '-Wno-redundant-decls', '-Wno-unknown-pragmas', '-Werror=format-security', '-Werror=array-bounds', '-Werror=uninitialized', '-Werror=init-self', '-Werror=switch', '-Werror=sign-compare', '-Wfatal-errors', '-Wno-trigraphs', '-fcolor-diagnostics', '-Wno-gnu-designator', '-Wno-inconsistent-missing-override', '-Wno-mismatched-tags', '-Wno-gnu-variable-sized-type-not-at-end', '-Wno-c++11-narrowing', '-O3', '-fno-slp-vectorize', '-MMD', '-include', 'ap_config.h', '-Ilibraries', '-Ilibraries/GCS_MAVLink', '-I.', '-I../../libraries', '-I../../libraries/AP_Common/missing', '-DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter"', '-DCONFIG_HAL_BOARD=HAL_BOARD_SITL', '-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE', '../../libraries/AP_HAL_SITL/Util.cpp', '-c', '-olibraries/AP_HAL_SITL/Util.cpp.0.o']

12:07:13 runner ['clang++', '-g', '-O0', '-flto', '-std=gnu++11', '-fdata-sections', '-ffunction-sections', '-fno-exceptions', '-fsigned-char', '-Wall', '-Wextra', '-Wformat', '-Wshadow', '-Wpointer-arith', '-Wcast-align', '-Wundef', '-Wno-unused-parameter', '-Wno-missing-field-initializers', '-Wno-reorder', '-Wno-redundant-decls', '-Wno-unknown-pragmas', '-Werror=format-security', '-Werror=array-bounds', '-Werror=uninitialized', '-Werror=init-self', '-Werror=switch', '-Werror=sign-compare', '-Wfatal-errors', '-Wno-trigraphs', '-fcolor-diagnostics', '-Wno-gnu-designator', '-Wno-inconsistent-missing-override', '-Wno-mismatched-tags', '-Wno-gnu-variable-sized-type-not-at-end', '-Wno-c++11-narrowing', '-O3', '-fno-slp-vectorize', '-MMD', '-include', 'ap_config.h', '-Ilibraries', '-Ilibraries/GCS_MAVLink', '-I.', '-I../../libraries', '-I../../libraries/AP_Common/missing', '-DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter"', '-DCONFIG_HAL_BOARD=HAL_BOARD_SITL', '-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE', '../../libraries/XXXX/XXXX.cpp', '-c', '-olibraries/XXXX/XXXX.cpp.0.o']

try add -fcsi:

clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../libraries/XXXX/XXXX.cpp -c -olibraries/XXXX/XXXX.cpp.0.o

mode_auto.cpp:
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../ArduCopter/mode_auto.cpp -c -oArduCopter/mode_auto.cpp.0.o

AP_Arming.cpp:
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../ArduCopter/AP_Arming.cpp -c -oArduCopter/AP_Arming.cpp.0.o

ArduCopter.cpp:
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../ArduCopter/ArduCopter.cpp -c -oArduCopter/ArduCopter.cpp.0.o

stil_gps.cpp:
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../libraries/AP_HAL_SITL/sitl_gps.cpp -c -olibraries/AP_HAL_SITL/sitl_gps.cpp.0.o



now link:

"/usr/local/bin/ld.gold" -z relro --hash-style=gnu --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o bin/arducopter /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crt1.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtbegin.o -Llib -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0 -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu -L/lib/x86_64-linux-gnu -L/lib/../lib64 -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../.. -L/home/osboxes/Desktop/llvm/build/bin/../lib -L/lib -L/usr/lib -plugin /home/osboxes/Desktop/llvm/build/bin/../lib/LLVMgold.so -plugin-opt=mcpu=x86-64 -plugin-opt=O0 ArduCopter/AP_Arming.cpp.22.o ArduCopter/AP_Rally.cpp.22.o ArduCopter/AP_State.cpp.22.o ArduCopter/ArduCopter.cpp.22.o ArduCopter/Attitude.cpp.22.o ArduCopter/Copter.cpp.22.o ArduCopter/GCS_Mavlink.cpp.22.o ArduCopter/Log.cpp.22.o ArduCopter/Parameters.cpp.22.o ArduCopter/UserCode.cpp.22.o ArduCopter/afs_copter.cpp.22.o ArduCopter/autoyaw.cpp.22.o ArduCopter/avoidance_adsb.cpp.22.o ArduCopter/baro_ground_effect.cpp.22.o ArduCopter/capabilities.cpp.22.o ArduCopter/commands.cpp.22.o ArduCopter/compassmot.cpp.22.o ArduCopter/crash_check.cpp.22.o ArduCopter/ekf_check.cpp.22.o ArduCopter/esc_calibration.cpp.22.o ArduCopter/events.cpp.22.o ArduCopter/failsafe.cpp.22.o ArduCopter/fence.cpp.22.o ArduCopter/heli.cpp.22.o ArduCopter/inertia.cpp.22.o ArduCopter/land_detector.cpp.22.o ArduCopter/landing_gear.cpp.22.o ArduCopter/leds.cpp.22.o ArduCopter/mode.cpp.22.o ArduCopter/mode_acro.cpp.22.o ArduCopter/mode_acro_heli.cpp.22.o ArduCopter/mode_althold.cpp.22.o ArduCopter/mode_auto.cpp.22.o ArduCopter/mode_autotune.cpp.22.o ArduCopter/mode_avoid_adsb.cpp.22.o ArduCopter/mode_brake.cpp.22.o ArduCopter/mode_circle.cpp.22.o ArduCopter/mode_drift.cpp.22.o ArduCopter/mode_flip.cpp.22.o ArduCopter/mode_flowhold.cpp.22.o ArduCopter/mode_follow.cpp.22.o ArduCopter/mode_guided.cpp.22.o ArduCopter/mode_guided_nogps.cpp.22.o ArduCopter/mode_land.cpp.22.o ArduCopter/mode_loiter.cpp.22.o ArduCopter/mode_poshold.cpp.22.o ArduCopter/mode_rtl.cpp.22.o ArduCopter/mode_smart_rtl.cpp.22.o ArduCopter/mode_sport.cpp.22.o ArduCopter/mode_stabilize.cpp.22.o ArduCopter/mode_stabilize_heli.cpp.22.o ArduCopter/mode_throw.cpp.22.o ArduCopter/motor_test.cpp.22.o ArduCopter/motors.cpp.22.o ArduCopter/navigation.cpp.22.o ArduCopter/position_vector.cpp.22.o ArduCopter/precision_landing.cpp.22.o ArduCopter/radio.cpp.22.o ArduCopter/sensors.cpp.22.o ArduCopter/setup.cpp.22.o ArduCopter/switches.cpp.22.o ArduCopter/system.cpp.22.o ArduCopter/takeoff.cpp.22.o ArduCopter/terrain.cpp.22.o ArduCopter/toy_mode.cpp.22.o ArduCopter/tuning.cpp.22.o ArduCopter/version.cpp.22.o -lArduCopter_libs /home/osboxes/Desktop/llvm/csi/toolkit/code-coverage.o /home/osboxes/Desktop/llvm/build/lib/clang/3.9.0/lib/linux/libclang_rt.csi-x86_64.a -lm -lstdc++ -lm -lgcc_s -lgcc -lpthread -lc -lgcc_s -lgcc /usr/lib/gcc/x86_64-linux-gnu/5.4.0/crtend.o /usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../x86_64-linux-gnu/crtn.o

not working? why? 
1. not called?
2. not intrumented inside?

debug: 
gdb /home/osboxes/Desktop/ardupilot_sim/build/sitl/bin/arducopter 
break xxx
run -S -I0 --home -35.363261,149.165230,584,353 --model + --speedup 1 --defaults /home/osboxes/Desktop/ardupilot_sim/Tools/autotest/default_params/copter.parm

"mavproxy.py" "--master" "tcp:127.0.0.1:5760" "--sitl" "127.0.0.1:5501" "--out" "127.0.0.1:14550" "--out" "127.0.0.1:14551" "--map" "--console"

./libraries/AP_HAL_SITL/SITL_cmdline.cpp:    fprintf(stdout, "Starting sketch '%s'\n", SKETCH);

Scheduler.cpp:
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../libraries/AP_HAL_SITL/Scheduler.cpp -c -olibraries/AP_HAL_SITL/Scheduler.cpp.0.o


./libraries/AP_HAL_SITL/SITL_State.cpp:    fprintf(stdout, "Starting SITL input\n");
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../libraries/AP_HAL_SITL/SITL_State.cpp -c -olibraries/AP_HAL_SITL/SITL_State.cpp.0.o


libArduCopter_libs.a did not change? Yep, so use mode_auto.cpp to test first.

 ../Tools/autotest/sim_vehicle.py --map --console

mode_guided.cpp:
clang++ -g -O0 -fcsi -flto -std=gnu++11 -fdata-sections -ffunction-sections -fno-exceptions -fsigned-char -Wall -Wextra -Wformat -Wshadow -Wpointer-arith -Wcast-align -Wundef -Wno-unused-parameter -Wno-missing-field-initializers -Wno-reorder -Wno-redundant-decls -Wno-unknown-pragmas -Werror=format-security -Werror=array-bounds -Werror=uninitialized -Werror=init-self -Werror=switch -Werror=sign-compare -Wfatal-errors -Wno-trigraphs -fcolor-diagnostics -Wno-gnu-designator -Wno-inconsistent-missing-override -Wno-mismatched-tags -Wno-gnu-variable-sized-type-not-at-end -Wno-c++11-narrowing -O3 -fno-slp-vectorize -MMD -include ap_config.h -Ilibraries -Ilibraries/GCS_MAVLink -I. -I../../libraries -I../../libraries/AP_Common/missing -DSKETCHBOOK="/home/osboxes/Desktop/ardupilot_instru_sim_copter" -DCONFIG_HAL_BOARD=HAL_BOARD_SITL -DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_NONE ../../ArduCopter/mode_guided.cpp -c -oArduCopter/mode_guided.cpp.0.o

/home/osboxes/Desktop/llvm/build/bin/llvm-ar rcs lib/libArduCopter_libs.a libraries/AP_AccelCal/AccelCalibrator.cpp.0.o libraries/AP_AccelCal/AP_AccelCal.cpp.4.o libraries/AP_ADC/AP_ADC_ADS1115.cpp.0.o libraries/AP_AHRS/AP_AHRS_DCM.cpp.0.o libraries/AP_AHRS/AP_AHRS_NavEKF.cpp.0.o libraries/AP_AHRS/AP_AHRS_View.cpp.0.o libraries/AP_AHRS/AP_AHRS.cpp.4.o libraries/AP_Airspeed/AP_Airspeed.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_Backend.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_MS4525.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_MS5525.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_SDP3X.cpp.0.o libraries/AP_Airspeed/AP_Airspeed_analog.cpp.0.o libraries/AP_Airspeed/Airspeed_Calibration.cpp.0.o libraries/AP_Baro/AP_Baro_BMP085.cpp.0.o libraries/AP_Baro/AP_Baro_BMP280.cpp.0.o libraries/AP_Baro/AP_Baro_Backend.cpp.0.o libraries/AP_Baro/AP_Baro_DPS280.cpp.0.o libraries/AP_Baro/AP_Baro_FBM320.cpp.0.o libraries/AP_Baro/AP_Baro_HIL.cpp.0.o libraries/AP_Baro/AP_Baro_ICM20789.cpp.0.o libraries/AP_Baro/AP_Baro_KellerLD.cpp.0.o libraries/AP_Baro/AP_Baro_LPS2XH.cpp.0.o libraries/AP_Baro/AP_Baro_MS5611.cpp.0.o libraries/AP_Baro/AP_Baro_UAVCAN.cpp.0.o libraries/AP_Baro/AP_Baro.cpp.4.o libraries/AP_Baro/AP_Baro_SITL.cpp.4.o libraries/AP_BattMonitor/AP_BattMonitor_Analog.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_BLHeliESC.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_Backend.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_Bebop.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus_Maxell.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_SMBus_Solo.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor_UAVCAN.cpp.0.o libraries/AP_BattMonitor/AP_BattMonitor.cpp.4.o libraries/AP_BattMonitor/AP_BattMonitor_Params.cpp.4.o libraries/AP_BoardConfig/AP_BoardConfig.cpp.0.o libraries/AP_BoardConfig/AP_BoardConfig_CAN.cpp.0.o libraries/AP_BoardConfig/board_drivers.cpp.0.o libraries/AP_BoardConfig/canbus.cpp.0.o libraries/AP_BoardConfig/canbus_driver.cpp.0.o libraries/AP_BoardConfig/px4_drivers.cpp.0.o libraries/AP_Common/AP_Common.cpp.0.o libraries/AP_Common/AP_FWVersion.cpp.0.o libraries/AP_Common/Location.cpp.0.o libraries/AP_Common/c++.cpp.0.o libraries/AP_Compass/AP_Compass_AK09916.cpp.0.o libraries/AP_Compass/AP_Compass_AK8963.cpp.0.o libraries/AP_Compass/AP_Compass_BMM150.cpp.0.o libraries/AP_Compass/AP_Compass_Backend.cpp.0.o libraries/AP_Compass/AP_Compass_Calibration.cpp.0.o libraries/AP_Compass/AP_Compass_HIL.cpp.0.o libraries/AP_Compass/AP_Compass_HMC5843.cpp.0.o libraries/AP_Compass/AP_Compass_IST8310.cpp.0.o libraries/AP_Compass/AP_Compass_LIS3MDL.cpp.0.o libraries/AP_Compass/AP_Compass_LSM303D.cpp.0.o libraries/AP_Compass/AP_Compass_LSM9DS1.cpp.0.o libraries/AP_Compass/AP_Compass_MAG3110.cpp.0.o libraries/AP_Compass/AP_Compass_MMC3416.cpp.0.o libraries/AP_Compass/AP_Compass_QMC5883L.cpp.0.o libraries/AP_Compass/AP_Compass_SITL.cpp.0.o libraries/AP_Compass/AP_Compass_UAVCAN.cpp.0.o libraries/AP_Compass/CompassCalibrator.cpp.0.o libraries/AP_Compass/Compass_PerMotor.cpp.0.o libraries/AP_Compass/Compass_learn.cpp.0.o libraries/AP_Compass/AP_Compass.cpp.4.o libraries/AP_Declination/AP_Declination.cpp.0.o libraries/AP_Declination/tables.cpp.0.o libraries/AP_GPS/AP_GPS.cpp.0.o libraries/AP_GPS/AP_GPS_ERB.cpp.0.o libraries/AP_GPS/AP_GPS_GSOF.cpp.0.o libraries/AP_GPS/AP_GPS_MAV.cpp.0.o libraries/AP_GPS/AP_GPS_MTK.cpp.0.o libraries/AP_GPS/AP_GPS_MTK19.cpp.0.o libraries/AP_GPS/AP_GPS_NMEA.cpp.0.o libraries/AP_GPS/AP_GPS_NOVA.cpp.0.o libraries/AP_GPS/AP_GPS_SBF.cpp.0.o libraries/AP_GPS/AP_GPS_SBP.cpp.0.o libraries/AP_GPS/AP_GPS_SBP2.cpp.0.o libraries/AP_GPS/AP_GPS_SIRF.cpp.0.o libraries/AP_GPS/AP_GPS_UAVCAN.cpp.0.o libraries/AP_GPS/AP_GPS_UBLOX.cpp.0.o libraries/AP_GPS/GPS_Backend.cpp.0.o libraries/AP_HAL/Device.cpp.0.o libraries/AP_HAL/HAL.cpp.0.o libraries/AP_HAL/Scheduler.cpp.0.o libraries/AP_HAL/Util.cpp.0.o libraries/AP_HAL/utility/BetterStream.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap_Linux.cpp.0.o libraries/AP_HAL/utility/RCOutput_Tap_Nuttx.cpp.0.o libraries/AP_HAL/utility/RingBuffer.cpp.0.o libraries/AP_HAL/utility/Socket.cpp.0.o libraries/AP_HAL/utility/dsm.cpp.0.o libraries/AP_HAL/utility/ftoa_engine.cpp.0.o libraries/AP_HAL/utility/getopt_cpp.cpp.0.o libraries/AP_HAL/utility/print_vprintf.cpp.0.o libraries/AP_HAL/utility/srxl.cpp.0.o libraries/AP_HAL/utility/st24.cpp.0.o libraries/AP_HAL/utility/sumd.cpp.0.o libraries/AP_HAL/utility/utoa_invert.cpp.0.o libraries/AP_HAL_Empty/AnalogIn.cpp.0.o libraries/AP_HAL_Empty/GPIO.cpp.0.o libraries/AP_HAL_Empty/HAL_Empty_Class.cpp.0.o libraries/AP_HAL_Empty/PrivateMember.cpp.0.o libraries/AP_HAL_Empty/RCInput.cpp.0.o libraries/AP_HAL_Empty/RCOutput.cpp.0.o libraries/AP_HAL_Empty/Scheduler.cpp.0.o libraries/AP_HAL_Empty/Semaphores.cpp.0.o libraries/AP_HAL_Empty/Storage.cpp.0.o libraries/AP_HAL_Empty/UARTDriver.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_BMI055.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_BMI160.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Backend.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_HIL.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Invensense.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_L3G4200D.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_LSM9DS0.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_LSM9DS1.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_PX4.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_RST.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_Revo.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor_SITL.cpp.0.o libraries/AP_InertialSensor/AuxiliaryBus.cpp.0.o libraries/AP_InertialSensor/BatchSampler.cpp.0.o libraries/AP_InertialSensor/AP_InertialSensor.cpp.4.o libraries/AP_Math/AP_GeodesicGrid.cpp.0.o libraries/AP_Math/AP_Math.cpp.0.o libraries/AP_Math/crc.cpp.0.o libraries/AP_Math/edc.cpp.0.o libraries/AP_Math/location.cpp.0.o libraries/AP_Math/location_double.cpp.0.o libraries/AP_Math/matrix3.cpp.0.o libraries/AP_Math/matrixN.cpp.0.o libraries/AP_Math/matrix_alg.cpp.0.o libraries/AP_Math/polygon.cpp.0.o libraries/AP_Math/quaternion.cpp.0.o libraries/AP_Math/spline5.cpp.0.o libraries/AP_Math/vector2.cpp.0.o libraries/AP_Math/vector3.cpp.0.o libraries/AP_Mission/AP_Mission.cpp.4.o libraries/AP_NavEKF2/AP_NavEKF2_AirDataFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Control.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_MagFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Measurements.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_OptFlowFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_Outputs.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_PosVelFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_RngBcnFusion.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_VehicleStatus.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2_core.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF_GyroBias.cpp.0.o libraries/AP_NavEKF2/AP_NavEKF2.cpp.4.o libraries/AP_NavEKF3/AP_NavEKF3_AirDataFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Control.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_GyroBias.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_MagFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Measurements.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_OptFlowFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_Outputs.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_PosVelFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_RngBcnFusion.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_VehicleStatus.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3_core.cpp.0.o libraries/AP_NavEKF3/AP_NavEKF3.cpp.4.o libraries/AP_Notify/AP_BoardLED.cpp.0.o libraries/AP_Notify/AP_BoardLED2.cpp.0.o libraries/AP_Notify/AP_Notify.cpp.0.o libraries/AP_Notify/Buzzer.cpp.0.o libraries/AP_Notify/DiscoLED.cpp.0.o libraries/AP_Notify/DiscreteRGBLed.cpp.0.o libraries/AP_Notify/Display.cpp.0.o libraries/AP_Notify/Display_SH1106_I2C.cpp.0.o libraries/AP_Notify/Display_SSD1306_I2C.cpp.0.o libraries/AP_Notify/ExternalLED.cpp.0.o libraries/AP_Notify/Led_Sysfs.cpp.0.o libraries/AP_Notify/MMLPlayer.cpp.0.o libraries/AP_Notify/NCP5623.cpp.0.o libraries/AP_Notify/OreoLED_PX4.cpp.0.o libraries/AP_Notify/PCA9685LED_I2C.cpp.0.o libraries/AP_Notify/PixRacerLED.cpp.0.o libraries/AP_Notify/RCOutputRGBLed.cpp.0.o libraries/AP_Notify/RGBLed.cpp.0.o libraries/AP_Notify/ToneAlarm.cpp.0.o libraries/AP_Notify/ToshibaLED_I2C.cpp.0.o libraries/AP_Notify/UAVCAN_RGB_LED.cpp.0.o libraries/AP_Notify/VRBoard_LED.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_CXOF.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_Onboard.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_PX4Flow.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_Pixart.cpp.0.o libraries/AP_OpticalFlow/AP_OpticalFlow_SITL.cpp.0.o libraries/AP_OpticalFlow/OpticalFlow.cpp.0.o libraries/AP_OpticalFlow/OpticalFlow_backend.cpp.0.o libraries/AP_Param/AP_Param.cpp.0.o libraries/AP_Rally/AP_Rally.cpp.4.o libraries/AP_RangeFinder/AP_RangeFinder_BBB_PRU.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Bebop.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Benewake.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LeddarOne.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LightWareI2C.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_LightWareSerial.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MAVLink.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MaxsonarI2CXL.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_MaxsonarSerialLV.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_NMEA.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_PX4_PWM.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_PulsedLightLRF.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_TeraRangerI2C.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_VL53L0X.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_Wasp.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_analog.cpp.0.o libraries/AP_RangeFinder/AP_RangeFinder_uLanding.cpp.0.o libraries/AP_RangeFinder/RangeFinder.cpp.0.o libraries/AP_RangeFinder/RangeFinder_Backend.cpp.0.o libraries/AP_Scheduler/PerfInfo.cpp.0.o libraries/AP_Scheduler/AP_Scheduler.cpp.4.o libraries/AP_SerialManager/AP_SerialManager.cpp.0.o libraries/AP_Terrain/AP_Terrain.cpp.0.o libraries/AP_Terrain/TerrainGCS.cpp.0.o libraries/AP_Terrain/TerrainIO.cpp.0.o libraries/AP_Terrain/TerrainMission.cpp.0.o libraries/AP_Terrain/TerrainUtil.cpp.0.o libraries/DataFlash/DFMessageWriter.cpp.0.o libraries/DataFlash/DataFlash.cpp.0.o libraries/DataFlash/DataFlash_Backend.cpp.0.o libraries/DataFlash/DataFlash_File_sd.cpp.0.o libraries/DataFlash/DataFlash_MAVLink.cpp.0.o libraries/DataFlash/DataFlash_MAVLinkLogTransfer.cpp.0.o libraries/DataFlash/DataFlash_Revo.cpp.0.o libraries/DataFlash/LogFile.cpp.0.o libraries/DataFlash/DataFlash_File.cpp.4.o libraries/Filter/DerivativeFilter.cpp.0.o libraries/Filter/LowPassFilter.cpp.0.o libraries/Filter/LowPassFilter2p.cpp.0.o libraries/Filter/NotchFilter.cpp.0.o libraries/GCS_MAVLink/GCS.cpp.0.o libraries/GCS_MAVLink/GCS_Common.cpp.0.o libraries/GCS_MAVLink/GCS_DeviceOp.cpp.0.o libraries/GCS_MAVLink/GCS_MAVLink.cpp.0.o libraries/GCS_MAVLink/GCS_Param.cpp.0.o libraries/GCS_MAVLink/GCS_Rally.cpp.0.o libraries/GCS_MAVLink/GCS_ServoRelay.cpp.0.o libraries/GCS_MAVLink/GCS_Signing.cpp.0.o libraries/GCS_MAVLink/GCS_serial_control.cpp.0.o libraries/GCS_MAVLink/MAVLink_routing.cpp.0.o libraries/RC_Channel/RC_Channel.cpp.0.o libraries/RC_Channel/RC_Channels.cpp.0.o libraries/SRV_Channel/SRV_Channel.cpp.0.o libraries/SRV_Channel/SRV_Channel_aux.cpp.0.o libraries/SRV_Channel/SRV_Channels.cpp.0.o libraries/StorageManager/StorageManager.cpp.0.o libraries/AP_Tuning/AP_Tuning.cpp.0.o libraries/AP_RPM/AP_RPM.cpp.0.o libraries/AP_RPM/RPM_Backend.cpp.0.o libraries/AP_RPM/RPM_PX4_PWM.cpp.0.o libraries/AP_RPM/RPM_Pin.cpp.0.o libraries/AP_RPM/RPM_SITL.cpp.0.o libraries/AP_RSSI/AP_RSSI.cpp.0.o libraries/AP_Mount/AP_Mount.cpp.0.o libraries/AP_Mount/AP_Mount_Alexmos.cpp.0.o libraries/AP_Mount/AP_Mount_Backend.cpp.0.o libraries/AP_Mount/AP_Mount_SToRM32.cpp.0.o libraries/AP_Mount/AP_Mount_SToRM32_serial.cpp.0.o libraries/AP_Mount/AP_Mount_Servo.cpp.0.o libraries/AP_Mount/AP_Mount_SoloGimbal.cpp.0.o libraries/AP_Mount/SoloGimbal.cpp.0.o libraries/AP_Mount/SoloGimbalEKF.cpp.0.o libraries/AP_Mount/SoloGimbal_Parameters.cpp.0.o libraries/AP_Module/AP_Module.cpp.0.o libraries/AP_Button/AP_Button.cpp.0.o libraries/AP_ICEngine/AP_ICEngine.cpp.0.o libraries/AP_Frsky_Telem/AP_Frsky_Telem.cpp.0.o libraries/AP_FlashStorage/AP_FlashStorage.cpp.0.o libraries/AP_Relay/AP_Relay.cpp.0.o libraries/AP_ServoRelayEvents/AP_ServoRelayEvents.cpp.0.o libraries/AP_Volz_Protocol/AP_Volz_Protocol.cpp.0.o libraries/AP_SBusOut/AP_SBusOut.cpp.0.o libraries/AP_IOMCU/AP_IOMCU.cpp.0.o libraries/AP_IOMCU/fw_uploader.cpp.0.o libraries/AP_RAMTRON/AP_RAMTRON.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_Backend.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_DSM.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_PPMSum.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SBUS.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SRXL.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_ST24.cpp.0.o libraries/AP_RCProtocol/AP_RCProtocol_SUMD.cpp.0.o libraries/AP_RCProtocol/SoftSerial.cpp.0.o libraries/AP_Radio/AP_Radio.cpp.0.o libraries/AP_Radio/AP_Radio_backend.cpp.0.o libraries/AP_Radio/AP_Radio_cc2500.cpp.0.o libraries/AP_Radio/AP_Radio_cypress.cpp.0.o libraries/AP_Radio/driver_cc2500.cpp.0.o libraries/AP_TempCalibration/AP_TempCalibration.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom_Backend.cpp.0.o libraries/AP_VisualOdom/AP_VisualOdom_MAV.cpp.0.o libraries/AP_BLHeli/AP_BLHeli.cpp.4.o libraries/AP_ROMFS/AP_ROMFS.cpp.0.o libraries/AP_ROMFS/tinfgzip.cpp.0.o libraries/AP_ROMFS/tinflate.cpp.0.o libraries/AP_Proximity/AP_Proximity.cpp.0.o libraries/AP_Proximity/AP_Proximity_Backend.cpp.0.o libraries/AP_Proximity/AP_Proximity_LightWareSF40C.cpp.0.o libraries/AP_Proximity/AP_Proximity_MAV.cpp.0.o libraries/AP_Proximity/AP_Proximity_RPLidarA2.cpp.0.o libraries/AP_Proximity/AP_Proximity_RangeFinder.cpp.0.o libraries/AP_Proximity/AP_Proximity_SITL.cpp.0.o libraries/AP_Proximity/AP_Proximity_TeraRangerTower.cpp.0.o libraries/AP_Proximity/AP_Proximity_TeraRangerTowerEvo.cpp.0.o libraries/AP_Gripper/AP_Gripper.cpp.0.o libraries/AP_Gripper/AP_Gripper_Backend.cpp.0.o libraries/AP_Gripper/AP_Gripper_EPM.cpp.0.o libraries/AP_Gripper/AP_Gripper_Servo.cpp.0.o libraries/AP_RTC/AP_RTC.cpp.0.o libraries/AP_ADSB/AP_ADSB.cpp.4.o libraries/AC_AttitudeControl/AC_AttitudeControl_Heli.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl_Multi.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl_Sub.cpp.0.o libraries/AC_AttitudeControl/AC_PosControl_Sub.cpp.0.o libraries/AC_AttitudeControl/ControlMonitor.cpp.0.o libraries/AC_AttitudeControl/AC_AttitudeControl.cpp.4.o libraries/AC_AttitudeControl/AC_PosControl.cpp.4.o libraries/AC_InputManager/AC_InputManager.cpp.0.o libraries/AC_InputManager/AC_InputManager_Heli.cpp.0.o libraries/AC_Fence/AC_Fence.cpp.0.o libraries/AC_Fence/AC_PolyFence_loader.cpp.0.o libraries/AC_Avoidance/AC_Avoid.cpp.4.o libraries/AC_PID/AC_HELI_PID.cpp.0.o libraries/AC_PID/AC_P.cpp.0.o libraries/AC_PID/AC_PID.cpp.0.o libraries/AC_PID/AC_PID_2D.cpp.0.o libraries/AC_PID/AC_PI_2D.cpp.0.o libraries/AC_PrecLand/AC_PrecLand.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_Companion.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_IRLock.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_SITL.cpp.0.o libraries/AC_PrecLand/AC_PrecLand_SITL_Gazebo.cpp.0.o libraries/AC_PrecLand/PosVelEKF.cpp.0.o libraries/AC_Sprayer/AC_Sprayer.cpp.0.o libraries/AC_WPNav/AC_Circle.cpp.0.o libraries/AC_WPNav/AC_Loiter.cpp.0.o libraries/AC_WPNav/AC_WPNav.cpp.0.o libraries/AP_Camera/AP_Camera.cpp.0.o libraries/AP_IRLock/AP_IRLock_I2C.cpp.0.o libraries/AP_IRLock/AP_IRLock_SITL.cpp.0.o libraries/AP_IRLock/IRLock.cpp.0.o libraries/AP_InertialNav/AP_InertialNav_NavEKF.cpp.0.o libraries/AP_LandingGear/AP_LandingGear.cpp.0.o libraries/AP_Menu/AP_Menu.cpp.0.o libraries/AP_Motors/AP_Motors6DOF.cpp.0.o libraries/AP_Motors/AP_MotorsCoax.cpp.0.o libraries/AP_Motors/AP_MotorsHeli.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Dual.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Quad.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_RSC.cpp.0.o libraries/AP_Motors/AP_MotorsHeli_Single.cpp.0.o libraries/AP_Motors/AP_MotorsMatrix.cpp.0.o libraries/AP_Motors/AP_MotorsMulticopter.cpp.0.o libraries/AP_Motors/AP_MotorsSingle.cpp.0.o libraries/AP_Motors/AP_MotorsTri.cpp.0.o libraries/AP_Motors/AP_Motors_Class.cpp.0.o libraries/AP_Motors/AP_MotorsTailsitter.cpp.4.o libraries/AP_Parachute/AP_Parachute.cpp.0.o libraries/AP_RCMapper/AP_RCMapper.cpp.0.o libraries/AP_Avoidance/AP_Avoidance.cpp.4.o libraries/AP_AdvancedFailsafe/AP_AdvancedFailsafe.cpp.0.o libraries/AP_SmartRTL/AP_SmartRTL.cpp.0.o libraries/AP_Stats/AP_Stats.cpp.0.o libraries/AP_Beacon/AP_Beacon.cpp.0.o libraries/AP_Beacon/AP_Beacon_Backend.cpp.0.o libraries/AP_Beacon/AP_Beacon_Marvelmind.cpp.0.o libraries/AP_Beacon/AP_Beacon_Pozyx.cpp.0.o libraries/AP_Beacon/AP_Beacon_SITL.cpp.0.o libraries/AP_Arming/AP_Arming.cpp.4.o libraries/AP_WheelEncoder/AP_WheelEncoder.cpp.0.o libraries/AP_WheelEncoder/WheelEncoder_Backend.cpp.0.o libraries/AP_WheelEncoder/WheelEncoder_Quadrature.cpp.0.o libraries/AP_Winch/AP_Winch.cpp.0.o libraries/AP_Winch/AP_Winch_Servo.cpp.0.o libraries/AP_Follow/AP_Follow.cpp.0.o libraries/AP_Devo_Telem/AP_Devo_Telem.cpp.0.o libraries/AP_OSD/AP_OSD.cpp.0.o libraries/AP_OSD/AP_OSD_Backend.cpp.0.o libraries/AP_OSD/AP_OSD_MAX7456.cpp.0.o libraries/AP_OSD/AP_OSD_SITL.cpp.0.o libraries/AP_OSD/AP_OSD_Screen.cpp.0.o libraries/AP_OSD/AP_OSD_Setting.cpp.0.o libraries/AP_HAL_SITL/AnalogIn.cpp.0.o libraries/AP_HAL_SITL/GPIO.cpp.0.o libraries/AP_HAL_SITL/HAL_SITL_Class.cpp.0.o libraries/AP_HAL_SITL/RCInput.cpp.0.o libraries/AP_HAL_SITL/RCOutput.cpp.0.o libraries/AP_HAL_SITL/SITL_State.cpp.0.o libraries/AP_HAL_SITL/Scheduler.cpp.0.o libraries/AP_HAL_SITL/Semaphores.cpp.0.o libraries/AP_HAL_SITL/Storage.cpp.0.o libraries/AP_HAL_SITL/UARTDriver.cpp.0.o libraries/AP_HAL_SITL/UART_utils.cpp.0.o libraries/AP_HAL_SITL/Util.cpp.0.o libraries/AP_HAL_SITL/sitl_airspeed.cpp.0.o libraries/AP_HAL_SITL/sitl_gps.cpp.0.o libraries/AP_HAL_SITL/sitl_rangefinder.cpp.0.o libraries/AP_HAL_SITL/system.cpp.0.o libraries/AP_HAL_SITL/SITL_cmdline.cpp.4.o libraries/SITL/SIM_ADSB.cpp.0.o libraries/SITL/SIM_Aircraft.cpp.0.o libraries/SITL/SIM_BalanceBot.cpp.0.o libraries/SITL/SIM_Balloon.cpp.0.o libraries/SITL/SIM_CRRCSim.cpp.0.o libraries/SITL/SIM_Calibration.cpp.0.o libraries/SITL/SIM_FlightAxis.cpp.0.o libraries/SITL/SIM_Frame.cpp.0.o libraries/SITL/SIM_Gazebo.cpp.0.o libraries/SITL/SIM_Gimbal.cpp.0.o libraries/SITL/SIM_Gripper_EPM.cpp.0.o libraries/SITL/SIM_Gripper_Servo.cpp.0.o libraries/SITL/SIM_Helicopter.cpp.0.o libraries/SITL/SIM_ICEngine.cpp.0.o libraries/SITL/SIM_JSBSim.cpp.0.o libraries/SITL/SIM_Motor.cpp.0.o libraries/SITL/SIM_Multicopter.cpp.0.o libraries/SITL/SIM_Plane.cpp.0.o libraries/SITL/SIM_QuadPlane.cpp.0.o libraries/SITL/SIM_Rover.cpp.0.o libraries/SITL/SIM_SingleCopter.cpp.0.o libraries/SITL/SIM_Sprayer.cpp.0.o libraries/SITL/SIM_Submarine.cpp.0.o libraries/SITL/SIM_Tracker.cpp.0.o libraries/SITL/SIM_Vicon.cpp.0.o libraries/SITL/SIM_XPlane.cpp.0.o libraries/SITL/SIM_last_letter.cpp.0.o libraries/SITL/SITL.cpp.0.o


ok partial instrumentation works!

below is sched_task and fast_loop combined(these two covers all regular tasks)

400hz: gcs_check_input, AP_InertialSensor, fast_loop(ins.update(), attitude_control->rate_controller_run(), motors_output, read_AHRS, read_inertia, update_flight_mode)
opt: AP_Beacon, update_visual_odom, update_precland, fourhundred_hz_logging, DataFlash_Class
200hz:
opt: update_optical_flow
100hz: rc_loop, update_throttle_hover, compass_accumulate, compass_cal_update
opt: AP_Proximity
50hz: throttle_loop, update_GPS, run_nav_updates, AP_Baro, AP_Notify, gcs_send_deferred, gcs_data_stream_send
opt: check_dynamic_flight, AP_Mount(camera), AP_Camera,
20hz:
opt: read_rangefinder
10hz: update_batt_compass, read_aux_switches, arm_motors_check, auto_disarm_check, auto_trim, update_altitude, ekf_check, gpsglitch_check, landinggear_update, lost_vehicle_check, accel_cal_update, AP_TempCalibration
opt: ToyMode, rpm_update, avoidance_adsb_update, afs_fs_check(failsafe), terrain_update, AP_Gripper, winch_update
5hz: AP_Button
3.3hz: failsafe_gcs_check, failsafe_terrain_check, fence_check
3hz:
opt: Copter::ModeSmartRTL
1hz: gcs_send_heartbeat, arming.update, ahrs.set_orientation
opt: AP_Stats
0.1hz: AP_Scheduler

opt: ten_hz_logging_loop, twentyfive_hz_logging

rc_loops - reads user input from transmitter/receiver

/home/osboxes/Desktop/ardupilot_instru_sim_copter/ArduCopter/Copter.h shows source file mapping to func.s.
e.g.
    ...
    // GCS_Mavlink.cpp
    void gcs_send_heartbeat(void);
    void gcs_send_deferred(void);
    void send_fence_status(mavlink_channel_t chan);
    void send_extended_status1(mavlink_channel_t chan);
    void send_nav_controller_output(mavlink_channel_t chan);
    void send_rpm(mavlink_channel_t chan);
    void send_pid_tuning(mavlink_channel_t chan);
    void gcs_data_stream_send(void);
    void gcs_check_input(void);

    // heli.cpp
    void heli_init();
    void check_dynamic_flight(void);
    void update_heli_control_dynamics(void);
    void heli_update_landing_swash();
    void heli_update_rotor_speed_targets();

    // inertia.cpp
    void read_inertia();
    ...

investigate gcs().update() at /home/osboxes/Desktop/ardupilot_instru_sim_copter/ArduCopter/GCS_Mavlink.cpp
/*
 *  look for incoming commands on the GCS links
 */
void Copter::gcs_check_input(void)
{
    gcs().update();
}
/home/osboxes/Desktop/ardupilot_instru_sim_copter/ArduCopter/Copter.h
    // GCS selection
    GCS_Copter _gcs; // avoid using this; use gcs()
    GCS_Copter &gcs() { return _gcs; }
/home/osboxes/Desktop/ardupilot_instru_sim_copter/ArduCopter/GCS_Copter.h
class GCS_Copter : public GCS
{
    friend class Copter; // for access to _chan in parameter declarations
                        // friend class make Copter able to access private members in GCS_Copter
/home/osboxes/Desktop/ardupilot_instru_sim_copter/libraries/GCS_MAVLink/GCS.h
/// @class GCS
/// @brief global GCS object
class GCS
{
public:
    void update();
/home/osboxes/Desktop/ardupilot_instru_sim_copter/libraries/GCS_MAVLink/GCS_Common.cpp
void GCS::update(void)
{
    for (uint8_t i=0; i<num_gcs(); i++) {
        if (chan(i).initialised) {
            chan(i).update();
        }
    }
}
/home/osboxes/Desktop/ardupilot_instru_sim_copter/libraries/GCS_MAVLink/GCS.h
    virtual GCS_MAVLINK &chan(const uint8_t ofs) = 0;
    virtual const GCS_MAVLINK &chan(const uint8_t ofs) const = 0;
    virtual uint8_t num_gcs() const = 0;
/home/osboxes/Desktop/ardupilot_instru_sim_copter/libraries/GCS_MAVLink/GCS_Common.cpp
GCS_MAVLINK::update(uint32_t max_time_us)
{
    // receive new packets
    mavlink_message_t msg;
    mavlink_status_t status;
    uint32_t tstart_us = AP_HAL::micros();
    uint32_t now_ms = AP_HAL::millis();


tasks:
% ruide, I think we need the following data 
%  what is the cost of recording in kernel 
%  what is the cost of recording in trustzone - we already have this
%  what is the cost of recoridng in user space applicaton - you are working on this one
%  what is the cost of just applying CFI

% ruide - please fill in the detail here
% 
% things that will work
%  instrument memory write instruction such that nobody can write to the sequence recording
% hash each branch using hardware registers
% alternatively, xor can also be used, however, if we do need to use xor, we want to make sure we have a solid analysis  
%-----we can also have a function level CFI, where the tz asssit in setting the range per function on a read-only memory


% 
% 1. we probably want to do this on multiple platforms(px4 and paparazzi), not to set up trustzone, but to show that if trustzone is there, it is possible to have a efficient CFI like guarantee with non reduced security
% 2. how to solve CFI overhead by leveraging CPS - i.e. is the pattern consistent across different platforms, we believe it does 
% 3. priority inversion problem, using the timing time, can we fix / detect this problem, even though it is easily fixable
% 4***. we need to read in the latest development of CFI and Data only attack etc, to see what type of new defense or methods can we develop or adopt for CPS system 
%  look up drone attacks and see how we can prevent them, maybe even demo

