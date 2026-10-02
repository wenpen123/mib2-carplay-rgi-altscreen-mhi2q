#!/bin/sh
# BEGIN ALT111 BASEVIDEO3 AUTOSTART
if [ -f /mnt/app/root/carplay-altscreen/state/basevideo3.enabled ]; then
    rm -f /tmp/mmi-mirror-basevideo.ready >/dev/null 2>&1 || true
    touch /tmp/mmi-mirror-active >/dev/null 2>&1 || true
    /mnt/app/root/carplay-altscreen/bin/mirror/start_vehicle.sh >>/tmp/MMI-Cockpit-Carplay.mirror.autostart.log 2>&1 &
fi
# END ALT111 BASEVIDEO3 AUTOSTART
# BEGIN ALTSCREEN DIAGNOSTICS
(
    PATH=${PATH:-/bin:/usr/bin}:/proc/boot:/armle/bin:/armle/scripts:/bin:/usr/bin:/usr/sbin:/sbin:/mnt/app/armle/bin:/mnt/app/armle/sbin:/mnt/app/armle/usr/bin:/mnt/app/armle/usr/sbin:/eso/bin:/eso/bin/apps
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-}:/proc/boot:/usr/lib:/armle/lib:/armle/lib/dll:/lib:/mnt/app/root/carplay-altscreen/lib:/eso/lib:/mnt/app/usr/lib:/mnt/app/armle/lib:/mnt/app/armle/lib/dll:/mnt/app/armle/usr/lib:/lib/dll
    export PATH LD_LIBRARY_PATH
    ALTS_RUNTIME=/mnt/app/root/carplay-altscreen/bin
    ALTS_BOOT_ENTRY=/tmp/MMI-Cockpit-Carplay.boot_entry.log
    if ( : >> "$ALTS_BOOT_ENTRY" ) 2>/dev/null; then
        exec >> "$ALTS_BOOT_ENTRY" 2>&1
    fi
    echo "BOOT_ENTRY pid=$$ universal_persistent_diag=1 runtime=$ALTS_RUNTIME"
    alts_boot_wait=0
    while { [ ! -f "$ALTS_RUNTIME/altscreen_boot_diag.sh" ] || [ ! -f "$ALTS_RUNTIME/altscreen_adaptive_diag.sh" ]; } && [ "$alts_boot_wait" -lt 60 ]; do
        sleep 2
        alts_boot_wait=$((alts_boot_wait + 1))
    done
    if [ -f "$ALTS_RUNTIME/altscreen_adaptive_diag.sh" ]; then
        /bin/sh "$ALTS_RUNTIME/altscreen_adaptive_diag.sh" &
        echo "ADAPTIVE_FAILSAFE_STARTED pid=$! wait_steps=$alts_boot_wait store_required=NO"
    else
        echo "ADAPTIVE_FAILSAFE_MISSING after_seconds=120"
    fi
    if [ -f "$ALTS_RUNTIME/altscreen_boot_diag.sh" ]; then
        echo "BOOT_HELPER_FOUND wait_steps=$alts_boot_wait"
        /bin/sh "$ALTS_RUNTIME/altscreen_boot_diag.sh"
        echo "BOOT_HELPER_EXIT rc=$?"
    else
        echo "BOOT_HELPER_MISSING after_seconds=120"
    fi
) > /dev/null 2>&1 < /dev/null &
# END ALTSCREEN DIAGNOSTICS
## $Id: //mib2_tools/rel/CLU8P_CNQC/qc_system-components/ERL/legacy/startup.sh#1 $
##
## Changes:
##                           rev /dev/main
##                           |      merged to branch-rev
##                           |      |
## 25.11.2015 eso/klwa+rosc  rev56          merged QC changes ES9.0
## 25.11.2015 eso/klwa       rev57          added Analyzer
## 26.11.2015 eso/seki       rev58          use hardcoded name usblauncher_otg.lua
## 26.11.2015 eso/geel       rev59          set executable bit in perforce
## 27.11.2015 eso/klwa       rev60          retrieve QC bootloader version decoupled
## 27.11.2015 eso/klwa       rev61          removed double print of eMMC FW info
## 01.12.2015 eso/klwa       rev62          moved launch of pps from start_qcore.sh to startup.sh
## 01.12.2015 eso/klwa       rev63          watchdog args changed according to QC
## 03.12.2015 eso/klwa       rev64          WLAN start fixed
## 03.12.2015 eso/klwa       rev65          slf reenabled
## 07.12.2015 eso/geel       rev67          merged QC changes ES9.1
## 07.12.2015 eso/klwa       rev68          changes accroding mail QC 03.12.2015:
##                                          - ssr_policy_mgr moved to start_late_drivers()
##                                          - useless cds removed
##                                          - printing of version info in background
##                                          - read PROJ_ID saves a cat
## 08.12.2015 eso/geel       rev69          Fixed wrong preprocessing
## 08.12.2015 eso/klwa       rev70          - systracker output reduced
##                                          - simulation for cinemo keys
## 08.12.2015 eso/geel       rev71          Fixed wrong comment
## 09.12.2015 eso/klwa       rev72          io-audio args changed according Mail QC 09.12.2015
## 09.12.2015 eso/beol       rev73          Fixed WLAN tethering startup
## 16.12.2015 eso/klwa       rev74          stale waitfor /ramdisk/pps removed
## 13.01.2016 eso/klwa       rev75          move the "start_analyzer" after  "start_system_services &" in startup.sh
## 15.01.2016 eso/klwa       rev76          update arguments of sdiorm (mail QC 19.12.2015)
## 15.01.2016 eso/klwa       rev77          set maxclk for SD2 on B sample
## 22.01.2016 eso/rosc       rev78          ES 9.4 System components
## 25.01.2016 QC+klwa        rev79          remove io_service from ulp_startup()
## 28.01.2016 eso/amag       rev80          Added mediaconnector verbosity option in GEM.
## 29.01.2016 eso/klwa       rev81          reviewed
## 01.02.2016 eso/rosc       rev82          ES 9.5 SystemComponents
## 08.02.2016 eso/geel       rev83          Exporting variabled $BRANCH and $MEDIA_STACK
## 03.02.2016 eso/klwa       rev84          print APQ serial num and clock driver info
## 12.02.2016 eso/klwa       rev85          start sdiorm in bg
## 12.02.2016 eso/java4571   rev86          Disabling io-audio driver in SWDL temporarily in order to get a flashable software
## 15.02.2016 eso/keta       rev87          block execution if script is not pp'ed
## 15.02.2016 eso/klwa       rev88          check for old cdt partition and replace with new (temperaturabhaengiger double-refresh Micron)
## 18.02.2016 eso/java4571   rev89          Enabling test_cbc in normal and swdl startup
## 22.02.2016 eso/klwa       rev90          - shebang fixed
##                                          - dplmp removed from start_late_drivers
## 23.02.2016 eso/java4571   rev91          Setting poll and timeout arguments of test_cbc to 5000ms respectively to 10000ms to avoid false alarms
## 24.02.2016 eso/java4571   rev92          Setting poll and timeout arguments of test_cbc to 7000ms respectively to 15000ms to avoid false alarms
## 24.02.2016 eso/klwa       rev93          add call of addmem to release splashscreen memory
## 29.02.2016 eso/klwa       rev94          print sbl1+sbl2+lk ES version
## 01.03.2016 eso/klwa       rev95          pooled identical BL version checksums
## 01.03.2016 eso/rosc       rev96          integrated change from ES9.8
## 08.03.2016 eso/rosc       rev97          integrated additions from ES9.9
## 09.03.2016 eso/geel       rev98          Exporting variabled $CHIP_VENDOR
## 11.03.2016 eso/beol       rev99          Removed "export AUTOCONNECT=1" because it's not used and seems to produce problems.
## 14.03.2016 eso/beol       rev100         Also Removed "export AUTOCONNECT=1" in ULP mode.
## 21.03.2016 eso/klwa       rev101         start mnand refresh (matching systemservices)
## 24.03.2016 eso/dabr       rev102         Added tinit / removed qconn
## 30.03.2016 eso/keta       rev103         correct start mnand refresh parameters
## 04.04.2016 eso/andz       rev104         integrated change from ES10.2 change in start_ioaudio
## 04.04.2016 eso/beol       rev105         Add support for 2nd io-pkt used by CarPlay.
## 07.04.2016 eso/klwa       rev106         start (MNAND-) refresh_tool not in bg anymore
## 07.04.2016 eso/ropa7095   rev107         Remove test_cbc
## 08.04.2016 eso/beol       rev109         Fixed support for 2nd io-pkt used by CarPlay.
## 08.04.2016 eso/beol       rev110         Temporary deactivated because of problems with CarPlay.
## 12.04.2016 eso/keta       rev111         prepare ramdisk for /mnt/app shared libraries that will be used during SWDL
## 12.04.2016 eso/klwa       rev112         moved version printing
## 13.04.2016 eso/keta       rev113         adapted ramdisk directory structure for /mnt/app shared libraries,
## 13.04.2016 eso/klwa       rev114         cosmetic changes
## 13.04.2016 eso/klwa       rev115         typo fixed
## 13.04.2016 eso/klwa       rev116         systracker called without pipe to grep (should be unnecessary since ptm works)
## 13.04.2016 eso/beol       rev117         Reenabled CarPlay and fixed pf rules. Removed invalid io-pkt option 'guardpage'.
## 14.04.2016 eso/klwa       rev118         start MNAND refresh_tool in background
## 12.04.2016 eso/keta       rev119         correct folder structure and unmount ramdisk
## 18.04.2016 eso/andz       rev120         ES 10.5 SystemComponents pmicregio was removed
## 19.04.2016 eso/keta       rev121         start_late_drivers for swdl mode
## 19.04.2016 eso/keta       rev122         ramdisk setup and files copy in swdl mode should be completed before swdl starts
## 21.04.2016 eso/klwa       rev123         create_sysramdisk fixed for ULP mode
## 19.04.2016 eso/keta       rev124         floater reserved memory reduced from 190MB to 140MB
## 25.04.2016 eso/klwa       rev125         refresh_tool args match latest version
## 26.04.2016 eso/keta       rev126         prepare required shared library during swdl, when /mnt/app is unmounted
## 29.04.2016 eso/klwa       rev127         update bootloader image checksums
## 04.05.2016 eso/klwa       rev128 C7-1    print error message if waitfor_quick fails
## 11.05.2016 eso/klwa       rev131 C7-2    NV_ENV_AUDIO_CONFIG defined along with NV_ENV_AUDIO_DTCP_CONFIG_FILE for
##                                          ULP and not ULP.
##                                          Note: depending on QC delivery one of them is used, the other is unused.
##                                          Should solve artf339548 : [KPM] [DTCP] DVD Audio not protected [6724342]
##                                                       artf338674 : [KPM] [DTCP] DVD Audio not protected [6724342]
## 12.05.2016 eso/klwa       rev132 C7-3    added checksums for sbl1 + sbl3 from ES10.8
## 13.05.2016 eso/klwa       rev133 C7-4    fixed typo (space)
## 13.05.2016 eso/klwa       rev134 C7-5    fixed typo (space) in ulp
## 19.05.2016 eso/beol       rev135         Removed support for 2nd io-pkt used by CarPlay.
## 20.05.2016 eso/beol       rev136         Merged code for networking/WLAN.
## 25.05.2016 eso/keta       rev137         fix error message when creating ramdisk
## 30.05.2016 eso/klwa       rev138         move corefiles from /tmp to ota (limiting maximum count)
## 31.05.2016 eso/klwa       rev139         merged changes from ES10.11A
## 31.05.2016 eso/klwa       rev140 CL7-13  floater only in DEV mode
## 02.06.2016 eso/klwa       rev141         remove needless background &
## 02.06.2016 eso/klwa       rev142 CL7-15  fixed Errorhandling after waitfor
## 06.06.2016 eso/klwa       rev143 CL7-16  updated checksums for sbl1 and sbl3 from ES10.12
## 06.06.2016 eso/klwa       rev144         get the overcurrent pps update after system startup
## 06.06.2016 eso/klwa       rev145 CL7-17  decrease floater to 100MB
## 10.06.2016 eso/keta       rev146         launch mqueue for AISIN specific SW
## 14.06.2016 eso/klwa       rev147         enable verbosity for DVD ROM driver (remove quiet)
## 21.06.2016 eso/klwa       rev148 CL7-18  added checksums for ES10.14 sbl images
## 24.06.2016 eso/klwa       rev149 CL7-19  added cache=1 to io-usb
## 29.06.2016 eso/keta       rev150         function run_mergelog: trace the current system memory consumption state
## 29.06.2016 eso/keta       rev151         function run_mergelog: number of files to keep
## 30.06.2016 eso/klwa       rev152         review
## 11.07.2016 eso/keta       rev153         floater reserved memory reduced from 100MB to 50MB
## 13.07.2016 eso/keta       rev154         ramdisk size for tinymnt extended so that all shared libraries can be copied during swdl
## 15.07.2016 eso/keta       rev155         launching mqueue moved to boot.sh due to timing problem with NaviApp
## 15.07.2016 eso/keta       rev156         Due to timing, earlier mqueue launching required before navi app starts
## 19.07.2016 eso/keta       rev157         correct syntax for pre-processor
## 29.07.2016 eso/keta       rev158         launch system tools earlier to get system information as early as possible
## 25.08.2016 eso/keta       rev159         driver for the USB-to-Serial adapters devc-serusb is needed during swdl, when modem is restarted by swdl app
## 02.09.2016 eso/klwa       rev162         fix path for refresh_tool
## 08.09.2016 eso/muwa       rev163 CLU8-4  Making test_cbc active by default
## 11.10.2016 eso/keta       rev164 CLU8-5  required tool for modem restart when swdl is active
## 20.10.2016 eso/klwa       rev165 CLU8-6  reduce SDCard cache from 10MB to 2MB each
## 24.10.2016 eso/klwa       rev168 CLU8-10 fix wlan/Marvell manufacturing mode for WiFi certification
## 25.10.2016 eso/keta       rev170 CLU8-11 start mqueue in swdl mode
## 27.10.2016 eso/klwa       rev171 CLU8-11 free IFS memory / QC buffer removal (artf373079 System Reset et al.)
## 27.10.2016 eso/klwa       rev172 CLU8-12 start videoCore+vpeCore earlier (artf383343 : [QC][R][Perf] LM Jukebox Is Worse Than On nVidia [6947260])
## 07.11.2016 eso/muwa       rev173 CLU8-13 changes made in test_cbc arguments. It will also write io-usb coredump when CBC issue appears.
## 17.11.2016 eso/klwa       rev176 CLU8-14 added checksums for C8REL01.02A sbl images
## 27.01.2017 eso/klwa                      only CLU8-15+CLU8_ASIA-2: temp logging of refresh_tool rolled back to /mnt/persist/var
## 17.03.2017 eso/klwa       rev177 CLU8P-2 ICU mountpoint changed to ...58 according to lib version change


## global settings (not exported)
SKUDIR=/dev/nvsku


## log text with severity 5, major code 10000, minor code 0

SLOG_PREFIX="\015\0\0\0\020\047\0\0\0\0\0\0"

##               1
##                severity                   maj%256/1   maj%65536/256  maj/65536    min/16
##                                                                      + min%16<<4
##SLOG_PREFIX="\015    \0      \0     \0     \020        \047           \0           \0     \0     \0     \0     \0"
##             001101  000000  000000 000000 001110      100011         000000       000000 000000 000000 000000 000000

## major = 10125 minor = 3
##               1
##                severity                   maj%256/1   maj%65536/256  maj/65536    min/16
##SLOG_PREFIX="\015    \0      \0     \0     \0215       \047           \0           \0     \0     \0     \0     \0"
##             001101  000000  000000 000000 001110      100011         000000       000000 000000 000000 000000 000000

Error()
{
    echo -e `date +%T`" Error : $*"
}


info()
{
    print "${SLOG_PREFIX}${1}: launching\0" > /dev/slog
}

to_bmetrics()
{
    print ${1+"${@}"} > /dev/bmetrics
}

log_launch()
{
    to_bmetrics bootmarker ${1}: launching
}

log_ready()
{
    to_bmetrics bootmarker ${1} ready
}

## TODO: move next 3 functions to a globally available location

#############################################################################
##
##  print next unused systemwide unique number to stdout
##
#############################################################################
next_unused_uniq()
{
    read a < /mnt/ota/system/logs/unique.txt 2>/dev/null || a=0
    echo $(( 1 + a ))> /mnt/ota/system/logs/unique.txt
    echo -n $a
}

#############################################################################
##
## lists alle files to be deleted because of a to low sequence number
##
## usage:
##   print_files_matching_regex_except_latest_n <wd> <ere> <keep>
## with:
##   <wd>      working directory
##   <ere>     a (extended) regular expression matching all file names
##             There needs to be one parenthesized subexpression marking
##             the number part - see man 7 regex
##             The re must not contain any slashes since it is used in
##             a sed -e s/.../.../ command!
##   <keep>    a positive number telling how many files not to list
##
## Note: this works actually only for file names NOT containing spaces
##
## Example:
## Assuming you have the following files in /tmp:
##   aaa.1.txt aaa.2.txt aaa.3.txt aaa.5.txt aaa.10.txt
## An extended RE matching these files and having the number part
## parenthesized might look like:
##   '.*[.]([0-9]+)[.]txt'
## Then this call:
##   print_files_matching_regex_except_latest_n /tmp '.*[.]([0-9]+)[.]txt' 2
## will print:
##   aaa.1.txt aaa.2.txt aaa.3.txt
## (all files matching, but not the last two)
##
#############################################################################
print_files_matching_regex_except_latest_n()
{
    WD=$1
    EXE=$2
    KEEP=$3

    test -n "$WD" -a -n "$EXE" -a -n "$KEEP" || return 1

    OLD_DIR=`pwd`
    cd "$WD"/

    ##               find files                                             | remove leading ./     | prepend number              | sort by number  | remove prepended number
    set -A FILELIST `/mnt/app/armle/usr/bin/find -maxdepth 1  -regex "$EXE" | sed -r -e 's+^[.]/++' | sed -r -e "s/($EXE)/\2 \1/" | sort -n         | sed -r -e "s/^[0-9]* //"`

    ## FILELIST contains now all files matching EXE sorted by number.

    ## ${#FILELIST[*]}-$KEEP files are candidates to be deleted
    while [ ${#FILELIST[*]} -gt $KEEP ]
    do
        KEEP=$(( $KEEP + 1 ))
        echo "${FILELIST[$(( ${#FILELIST[*]} - $KEEP ))]}"
    done

    cd $OLD_DIR > /dev/null
    return 0
}

#############################################################################
##
## print highest number from a set of numbered files and add an
## offset if given
##
## usage:
##   print_highest_number_from_filenames <wd> <ere> [<offset>]
## with:
##   <wd>      working directory
##   <ere>     a (extended) regular expression matching all file names
##             There needs to be one parenthesized subexpression marking
##             the number part - see man 7 regex
##             The re must not contain any slashes since it is used in
##             a sed -e s/.../.../ command!
##   <offset>  a number added to highest found number (default: 0)
##
## Note: this works actually only for file names NOT containing spaces
##
## Example:
## Assuming you have the following files in /tmp:
##   aaa.1.txt aaa.2.txt aaa.3.txt aaa.5.txt aaa.10.txt
## An extended RE matching these files and having the number part
## parenthesized might look like:
##   '.*[.]([0-9]+)[.]txt'
## Then this call:
##   print_highest_number_from_filenames /tmp '.*[.]([0-9]+)[.]txt' 1
## will print:
##   11
## (highest existing number is 10, offset 1 added)
##
#############################################################################
print_highest_number_from_filenames()
{
    WD=$1
    EXE=$2
    OFFSET=$3
    OFFSET=${OFFSET:-0}

    test -n "$WD" -a -n "$EXE" -a -n "$OFFSET" || return 1

    OLD_DIR=`pwd`
    cd "$WD"/

    ##               find files                                             | remove leading ./     | replace with number      | reverse sort by number
    set -A FILELIST `/mnt/app/armle/usr/bin/find -maxdepth 1  -regex "$EXE" | sed -r -e 's+^[.]/++' | sed -r -e "s/($EXE)/\2/" | sort -n -r     `

    ## FILELIST contains now all files matching EXE sorted by number (reverted).

    ## print first element
    echo "$(( ${FILELIST[0]} + $OFFSET ))"

    cd $OLD_DIR > /dev/null
    return 0
}



#############################################################################
##
## moves core files from tmp to mnand with consecutive numbers and limiting
## number of those copies
##
#############################################################################
move_core_files_from_tmp_to_ota()
{
    DESTINATION_DIR=/mnt/ota/system/core
    SOURCE_DIR=/tmp
    LIMIT_TMP_CORE_FILES=5
    DESTINATION_EREGEX='tmp_([0-9]+)_.+[.]core.gz'

    ## core files in /tmp?
    if ls -1 $SOURCE_DIR/*.core.gz > /dev/null 2>&1
    then
        echo "Info startup.sh: move core files from $SOURCE_DIR to $DESTINATION_DIR..."
        OLD_DIR=`pwd`
        cd $SOURCE_DIR
        ## move to /mnt/ota
        for i in *.core.gz
        do
            mv -vf $i $DESTINATION_DIR/tmp_$( print_highest_number_from_filenames "$DESTINATION_DIR" "$DESTINATION_EREGEX" 1 )_$i
        done
        ## limit number
        for i in $( print_files_matching_regex_except_latest_n "$DESTINATION_DIR" "$DESTINATION_EREGEX" 5 )
        do
            echo "Info startup.sh: remove $DESTINATION_DIR/$i to limit number of tmp_* core files..."
            rm -f $DESTINATION_DIR/$i
        done
        cd $OLD_DIR
    fi
}


#############################################################################
##
##  Waitfor with builtin quickcheck
##
#############################################################################

waitfor_quick()
{
    ## quote the path, but not the timeout as empty string is
    ## interpreted as 0
    if [ ! -e "$1" ]
    then
        waitfor "$1" $2
    else
        return 0
    fi
}

run_mergelog()
{
    ## wait for some time before calling mergelog and copy output to /mnt/ota/system/logs
    sleep 90
    echo "startup.sh: launch RCC::mergelog"
    echo "========== mergelog =========="

    on -f rcc /usr/apps/mergelog -v

    echo "========== mergelog done =========="
    OUTDIR=/mnt/ota/system/logs
    num="0" ; for i in `(cd $OUTDIR; ls Performance*.txt 2>/dev/null) | sed -e 's/^Performance//' | sed -e 's/.txt$//'` ; do if [ $i -ge "$num" ] ; then num=$(( $i + 1 )) ; fi ; done ;
    if [ $num -gt 10000 ]
    then
        num=10000
    fi
    OUTPUT=$OUTDIR/Performance$num.txt
    echo "startup.sh: copy mergelog output to $OUTPUT ..."
    cp /net/rcc/dev/shmem/Performance.txt $OUTPUT

    OUTPUT=$OUTDIR/showmem-E$num.txt
    echo "startup.sh: trace memory usage with showmem-E to file $OUTPUT ..."
    showmem-E > $OUTPUT

    echo "========== copied to $OUTPUT =========="
}

#############################################################################
##
##  Set Environment Variables
##
#############################################################################

set_environment_variables()
{
    export PATH=.:/armle/bin:/armle/scripts:/proc/boot:/bin:/usr/bin:/usr/sbin:/sbin:/mnt/app/media/gracenote/bin:/mnt/app/armle/bin:/mnt/app/armle/sbin:/mnt/app/armle/usr/bin:/mnt/app/armle/usr/sbin:/armle/bin:/root/bin-target

    export LD_LIBRARY_PATH=/proc/boot:/usr/lib:/armle/lib:/armle/lib/dll:/armle/graphics:/lib:/mnt/app/root/lib-target:/eso/lib:/mnt/app/usr/lib:/mnt/app/armle/lib:/mnt/app/armle/lib/dll:/mnt/app/armle/usr/lib:/lib/dll

    ## needed from nvidia components
    export SSP_AUDIO_OUT_BACKEND=nvaudio
    export SSP_AUDIO_IN_BACKEND=nvaudio

    if [ -e /etc/nodtcp ]
    then
        echo XXX dtcp deactivated XXX
        export NV_ENV_AUDIO_DTCP=0
    else
        export NV_ENV_AUDIO_DTCP=2
    fi

    ## if nvaudio PCM dump is enabled (available in the GEM)
    if [ -e /etc/nvaudio_pcm_dump ]
    then
        echo XXX nvaudio PCM dump activated XXX
        export NV_ENV_PCM_DUMP_ENABLED=1
        export NV_ENV_PCM_DUMP_PATH=/tmp/
    else
        export NV_ENV_PCM_DUMP_ENABLED=0
    fi

    export LIBIMG_CFGFILE=/etc/config/img.conf
    export HMI3D=false
    export SOP=SOP1
    export OEM=AU
    export REGION=CN
    export VARIANT=G22
    export FIRST_TIER_SUPPLIER=AISIN
    export BRANCH=CLU8P
    export MEDIA_STACK=EVO
    export NV_ENV_AUDIO_DTCP_CONFIG_FILE=/etc/emi.cfg
    export NV_ENV_AUDIO_CONFIG=/etc/emi.cfg
    export BUILD_MODE=production        # "development" or "production"
    export HMI_TYPE=EVO_G22
    export CHIP_VENDOR=QUALCOMM
    export ICU_DATA=/mnt/app/eso/lib

    ## Needed for usblauncher/medialauncher for ipod.cfg location
    export CUSTOMER_UPDATE_FLAG_AVAILABLE=/var/customerUpdateAvailableFlag
}

set_environment_variables_ulp()
{
    export PATH=.:/proc/boot:/bin:/usr/bin:/usr/sbin:/sbin:/mnt/app/media/gracenote/bin:/mnt/app/armle/bin:/mnt/app/armle/sbin:/mnt/app/armle/usr/bin:/mnt/app/armle/usr/sbin
    export LD_LIBRARY_PATH=/proc/boot:/lib:/mnt/app/root/lib-target:/eso/lib:/mnt/app/usr/lib:/mnt/app/armle/lib:/mnt/app/armle/lib/dll:/mnt/app/armle/usr/lib:/ifs/jre/bin

    ## needed from nvidia components
    export SSP_AUDIO_OUT_BACKEND=nvaudio
    export SSP_AUDIO_IN_BACKEND=nvaudio
    export NV_ENV_AUDIO_DTCP=2
    export LIBIMG_CFGFILE=/etc/config/img.conf
    export HMI3D=false
    export SOP=SOP1
    export OEM=AU
    export REGION=CN
    export NV_ENV_AUDIO_DTCP_CONFIG_FILE=/etc/emi.cfg
    export NV_ENV_AUDIO_CONFIG=/etc/emi.cfg
    export BUILD_MODE=production        # "development" or "production"
    export ICU_DATA=/mnt/app/eso/lib

    ## Needed for usblauncher/medialauncher for ipod.cfg location
    export CUSTOMER_UPDATE_FLAG_AVAILABLE=/var/customerUpdateAvailableFlag
    export LOG_TO_CONSOLE=1
}

set_environment_variables_swdl()
{
    export IPL_CONFIG_FILE_TRACING=/etc/eso/production/tracing.swdl.json
}

#############################################################################
##
##  Start video drivers.
##
#############################################################################
start_video_drivers()
{
    videoCore &
    vpeCore &
}

#############################################################################
##
##  Start late drivers.
##
#############################################################################
start_late_drivers()
{
    ## Launch mis if only RNDIS is enabled.
    if [ -e ${QC_TOUCH_BASEFS}/ENABLE_USB_DEVICE ]
    then
        RNDIS_HOSTIP="192.168.0.10"
        ## QC Diagnostics service. (QPST/QXDM)
        mis --serverip=${RNDIS_HOSTIP}
    fi

    DEVICE_DESCRIPTOR_RNDIS=3
    ## This is the RNDIS index ( start from 1 ) to the descriptor list in the usblauncher_otg.lua
    ## This overrides the device driver loaded by the otg device stack and loads the
    ## RNDIS descriptor raw_desc_usb_rndis.lua
    INTERRUPT_EDGE_TRIGGER=0
    INTERRUPT_LEVEL_TRIGGER=1
    INTERRUPT_POLARITY_LOW=0
    INTERRUPT_POLARITY_HIGH=1
    USBLAUNCHER_STACK_INSTANCE=0
    USBLAUNCHER_OTG_STACK_INSTANCE=1
    USBLAUNCHER_LUA=usblauncher.lua
    USBLAUNCHER_OTG_LUA=usblauncher_otg.lua


    if [ -e  ${QC_TOUCH_BASEFS}/ENABLE_USB_ROLE_REVERSE ]
    then
        echo "${QC_TOUCH_BASEFS}/ENABLE_USB_ROLE_REVERSE present, USB Role Reverse will be started"
        waitfor_quick /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE} || Error "waitfor_quick failed on /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE} in start_late_drivers; continue..."
        ## Launch 2nd instance of USB Launcher only if in Debug Mode and MediaConnectors are not present
        if [ -e ${QC_TOUCH_BASEFS}/ENABLE_USB_DEVICE ]
        then
            if [ ! -e /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE} ]
            then
                if [ -e /tmp/usblauncherFlag_mediaconnector* ]
                then
                    echo "ERROR!!MediaConncetors Detected , but did not launch 2nd instance of usblauncher"
                else
                    echo "MediaConnectors Not Detected , so launching the 2nd instance of usblauncher"
                    LD_LIBRARY_PATH=/eso/bin/apps/customerupdate_media/lib/dll:$LD_LIBRARY_PATH PATH=/eso/bin/apps:$PATH \
                        usblauncher -h -r -v -c /etc/$USBLAUNCHER_OTG_LUA -M /etc/mcd_otg.mnt -t -l -m /ramdisk/pps -p 2 -s \
                        /mnt/app/armle/lib/dll/pubs -n /dev/io-usb/otg -S 1 &
                    waitfor_quick /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE} || Error "waitfor_quick failed on /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE} in start_late_drivers; continue..."
                fi
            fi

            if [ -e /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE} ]
            then
                echo "start_stack::none" >> /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE}
                sleep 1
                ## Check if its the MC 2.5 Media Connector , in which case we need to do the physical port switch
                if [ -e /tmp/usblauncherFlag_mediaconnector_2530_2 ]
                then
                    echo "switch port 1 1 1" >> /dev/media-con-ctrl
                    sleep 1
                    ## Check if its the MC 2.5 Media Connector , in which case we need to do the physical port switch
                    if [ -e /tmp/usblauncherFlag_mediaconnector_2530_2 ]
                    then
                        echo "switch port 1 1 1" >> /dev/media-con-ctrl
                        sleep 1
                    fi
                fi
                echo "start_stack::device,3" >> /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE}
            fi
            echo "start_stack::device,3" >> /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE}
        fi


        usbrolereverse -d ${DEVICE_DESCRIPTOR_RNDIS}                               \
            -t ${INTERRUPT_EDGE_TRIGGER}                                           \
            -l ${INTERRUPT_POLARITY_HIGH}                                          \
            -p /ramdisk/pps/device/usb_ctrl${USBLAUNCHER_OTG_STACK_INSTANCE}
    fi

    inetd > /dev/null 2>&1

    ## starting SSR policy manager
    /mnt/app/armle/bin/ssr_policy_mgr -d "-m 1 -p3"
}

#############################################################################
##
##  Start Early Drivers
##
#############################################################################

start_early_drivers()
{
    log_launch "early drivers"
    if [ -e /var/transportserver_mibhigh_mmx ]
    then
        (   waitfor_quick /dev/pci $TIMEOUT || Error "waitfor_quick failed on /dev/pci $TIMEOUT in start_early_drivers; continue..."
            /var/transportserver_mibhigh_mmx -q -m /dev/transportserver
        ) &
    fi

}

#############################################################################
##
##  Start Drivers
##
#############################################################################

start_usb_driver()
{
    USB1_PORT_ADDR=0x12500000
    USB1_IRQ=132
    USB3_PORT_ADDR=0x12520000
    USB3_IRQ=220


    [ "${QC_TOUCH_BASEFS_REQUIRED_REMOUNT_RW}" -ne 0 ] && mount -uw ${QC_TOUCH_BASEFS_REQUIRED_REMOUNT_PATH}
    touch ${QC_TOUCH_BASEFS}/ENABLE_USB_ROLE_REVERSE
    [ "${QC_TOUCH_BASEFS_REQUIRED_REMOUNT_RW}" -ne 0 ] && mount -ur ${QC_TOUCH_BASEFS_REQUIRED_REMOUNT_PATH}
    echo 'dlexec "devcfg_usb_asic_AF.so" "dll_init" "" GLOBALSYMS ' > /dev/qcore
    if [ -f /mnt/app/iousbVerbosity-vv_enabled ];
    then
        io-usb -vv -c -d compiled-ehci-arc-msm8960 ioport=$USB1_PORT_ADDR,irq=$USB1_IRQ,cache=1,ioport=$USB3_PORT_ADDR,irq=$USB3_IRQ,cache=1
    elif [ -f /mnt/app/iousbVerbosity-vvvvvv_enabled ];
    then
        io-usb -vvvvvv -c -d compiled-ehci-arc-msm8960 ioport=$USB1_PORT_ADDR,irq=$USB1_IRQ,cache=1,ioport=$USB3_PORT_ADDR,irq=$USB3_IRQ,cache=1
    else
        io-usb -c -d compiled-ehci-arc-msm8960 ioport=$USB1_PORT_ADDR,irq=$USB1_IRQ,cache=1,verbose=2,ioport=$USB3_PORT_ADDR,irq=$USB3_IRQ,cache=1,verbose=2
    fi
    waitfor_quick /dev/io-usb/io-usb  $TIMEOUT || Error "waitfor_quick failed on /dev/io-usb/io-usb  $TIMEOUT in start_usb_driver; continue..."
    > /tmp/usb-stack
}

start_ioaudio()
{
    ## production mode needs a special audio driver for audio loopback tests
    if [[ $RUN_MODE = "hb_testmode" ]]; then
        DEVA_ARGS="skip_device_disable=1,bmetrics_level=medium,log_level=medium,default_enable_csd_dev_tx=11,default_enable_csd_dev_rx=14,platform_id=mib2_ftm"
    else
        #DEVA_ARGS="skip_device_disable=0,bmetrics_level=medium,log_level=high,default_enable_csd_dev_tx=11,default_enable_csd_dev_rx=14,platform_id=mib2,mib_cgms=0"
        DEVA_ARGS="skip_device_disable=0,bmetrics_level=medium,log_level=high,default_enable_csd_dev_tx=11,default_enable_csd_dev_rx=14,platform_id=mib2,mib_cgms=0,intr_thread_prio=21"
    fi

    waitfor_quick /dev/audio_service  $TIMEOUT || Error "waitfor_quick failed on /dev/audio_service  $TIMEOUT in start_ioaudio; continue..."

    io-audio -d qc ${DEVA_ARGS}

    ## TODO Remove these links once eSol media/gal/cinemo/EB move to new virtual nodes.
    ## TODO Aneeket and ESO-audio
    waitfor_quick /dev/snd/mpl1_int_ent || Error "waitfor_quick failed on /dev/snd/mpl1_int_ent in start_ioaudio; continue..."
    exec makelinks - <<EOF
                /dev/snd/mpl1_int_ent /dev/snd/ent1p
                /dev/snd/ann1_int_nav /dev/snd/ann1p
                /dev/snd/ann2_int_sds /dev/snd/ann2p
                /dev/snd/tel1         /dev/snd/telp
                /dev/snd/sse_bundle_1 /dev/snd/mic1c
EOF
}

start_drivers()
{
    start_usb_driver &

    # starting with C sample (rev 301+302) the SDCard slots are reverted compared with B sample (rev 100...102)
    if [ $REVISION -gt 300 ]
    then
        devb-sdmmc-rim-msmsdcc blk cache=2M,noatime,ra=128k:128k disk name=sda cam quiet,cache,pnp sdmmc verbose=0,bs=dname=compat sdio idx=1,bs=cd=p26:en=35:wp=p20:maxclk=43300000,timing=hs
        devb-sdmmc-rim-msmsdcc blk cache=2M,noatime,ra=128k:128k disk name=sdb cam quiet,cache,pnp sdmmc verbose=0,bs=dname=compat sdio idx=2,bs=cd=p23:en=37:wp=p19:maxclk=43300000,timing=hs
    else
        devb-sdmmc-rim-msmsdcc blk cache=2M,noatime,ra=128k:128k disk name=sdb cam quiet,cache,pnp sdmmc verbose=0,bs=dname=compat sdio idx=1,bs=cd=p26:en=35:wp=p20:maxclk=43300000
        devb-sdmmc-rim-msmsdcc blk cache=2M,noatime,ra=128k:128k disk name=sda cam quiet,cache,pnp sdmmc verbose=0,bs=dname=compat sdio idx=2,bs=cd=p23:en=37:wp=p19:maxclk=43300000,timing=hs
    fi

    VAR_ACDB_CFG_PATH="/etc/acdb/mmx2_8064/acdb_cfg"
    ACDB_CFG_PATH="${VAR_ACDB_CFG_PATH}" audio_service -f /etc/ &

    if [[ ${RUN_MODE} != "swdl" ]]
    then
        start_ioaudio &
    fi
}

start_usb_driver_ulp()
{
    USB3_PORT_ADDR=0x12520000
    USB3_IRQ=220
    echo 'dlexec "devcfg_usb_asic_AF.so" "dll_init" "" GLOBALSYMS ' > /dev/qcore

    io-usb -c -d compiled-ehci-arc-msm8960 ioport=$USB3_PORT_ADDR,irq=$USB3_IRQ,cache=1,verbose=10
    waitfor_quick /dev/io-usb/io-usb  $TIMEOUT || Error "waitfor_quick failed on /dev/io-usb/io-usb  $TIMEOUT in start_usb_driver_ulp; continue..."
    > /tmp/usb-stack
}

start_drivers_ulp()
{
    ## add code if not handled by another script yet
    start_usb_driver_ulp &
    Info "start basic ulp drivers"
    waitfor /dev/qcore 1
    info "Disable MM clocks"
    # SBL sets these clocks. Workaround till we disable in a cleaner way
    /armle/scripts/disable_mm_clocks.sh
    echo 'dlexec "" "enable_dplmp" "0" GLOBALSYMS ' > /dev/qcore
    sleep 1
    echo ulp:persistent /power/dplmp 4 0 1 > /dev/npa
    Info "DPLMP running!! System with 1 core online at lowest perf level"
}

safe_slay()
{
    echo SEND SIGTERM: "$1"
    slay -f -v "$1"
    COUNTER=1
    while [[ ($COUNTER -lt 10) && ($(pidin -p "$1" -F "%80N" | tail -1 | grep -c "$1") -gt 0) ]]; do
        echo WAIT FOR DEATH: $1
        sleep 1
        COUNTER=$(( $COUNTER + 1 ))
    done
    if [ $(pidin -p "$1" -F "%80N" | tail -1 | grep -c "$1") -gt 0 ]; then
        echo SEND SIGKILL: "$1"
        slay -f -v -s SIGKILL "$1"
        sleep 1
    fi
}

check_persist()
{
    PERSIST_IMG=/mnt/app/img_restore/persist.img
    PERSIST_MP=/mnt/persist
    PERSIST_VER=${PERSIST_MP}/img_ver.txt
    PERSIST_PT=/dev/emmc/persist

    if [ ! -e ${PERSIST_VER} ]
    then
        Error "CHECK PERSIST: ${PERSIST_VER} not found"
        waitfor_quick ${PERSIST_IMG} $TIMEOUT || Error "waitfor_quick failed on ${PERSIST_IMG} $TIMEOUT in check_persist; continue..."
        if [ ! -e ${PERSIST_IMG} ]
        then
            Error "CHECK PERSIST: ${PERSIST_IMG} not found. Giving up."
            return
        fi

        echo "CHECK PERSIST: restoring default persistence"

        dd if=${PERSIST_IMG} of=${PERSIST_PT}
        mount -t qnx6 ${PERSIST_PT} ${PERSIST_MP}
        waitfor_quick ${PERSIST_VER} $TIMEOUT || Error "waitfor_quick failed on ${PERSIST_VER} $TIMEOUT in check_persist; continue..."

        if [ -e ${PERSIST_VER} ]
        then
            echo "CHECK PERSIST: recovering persistence done"
        else
            Error "CHECK PERSIST: recovering persistence failed"
        fi
    fi
}

check_ota_partition()
{
    waitfor_quick /mnt/ota 2

    if [ $? -ne 0 ]
    then
        echo "startup.sh: /mnt/ota not mounted"
        umount -f /mnt/ota

        OTA_DEV_NAME=$(getfsoptions_from_fstab -d /mnt/ota | head -n 1)

        if [ $? -ne 0 ]
        then
            echo "startup.sh: getfsoptions_from_fstab failed to get device name - returned $OTA_DEV_NAME"
            return
        fi

        chkqnx6fs -sv $OTA_DEV_NAME

        if [ $? -ne 0 ]
        then
            echo "startup.sh: /mnt/ota failed QNX6 consistency check -> required formating"

            RAW_FORMATTING_OPTS=$(getfsoptions_from_fstab /mnt/ota)

            if [ $? -ne 0 ]
            then

                echo "startup.sh: getfsoptions_from_fstab failed -> \"$RAW_FORMATTING_OPTS\""
                return

            fi

            FORMATTING_OPTS=$(echo -e "$RAW_FORMATTING_OPTS" | head -n 1)

            echo "startup.sh: /bin/mkqnx6fs $OTA_DEV_NAME $FORMATTING_OPTS"
            mkqnx6fs $OTA_DEV_NAME $FORMATTING_OPTS

            if [ $? -ne 0 ]
            then
                echo "startup.sh: formatting $OTA_DEV_NAME failed"
                return
            fi
            echo "startup.sh: formatting $OTA_DEV_NAME successful"

        fi

        mount /mnt/ota

        if [ $? -ne 0 ]
        then
            echo "startup.sh: mount failed for /mnt/ota"
            return
        fi

        echo "startup.sh: /mnt/ota successfully mounted"

    else
        echo "startup.sh: /mnt/ota already mounted"

    fi
}

check_filesystems()
{
    log_launch "check_filesystems"
    ## Wait for the notification from start_mmc() that all mounts are done
    waitfor_quick /tmp/mnand_all_mounts_complete $TIMEOUT || Error "waitfor_quick failed on /tmp/mnand_all_mounts_complete $TIMEOUT in check_filesystems; continue..."

    check_persist
    check_ota_partition

    create_required_dirs_and_links
    mount -t cd /mnt/app/eso/lib/icu.iso /mnt/app/eso/lib/icudt58l
}

#############################################################################
##
##  Start DVD-ROM Driver
##
#############################################################################

start_dvdrom_driver()
{
    waitfor_quick /dev/pci $TIMEOUT || Error "waitfor_quick failed on /dev/pci $TIMEOUT in start_dvdrom_driver; continue..."
    if [ -e /dev/pci ]
    then
        if [ -f /mnt/app/devb-eideVerbosity-vv_enabled ];
        then
            devb-eide-mmx eide noslave,verbose=2 blk marking=none,cache=2m,ro cam verbose=2,resmgr mem name=/ram/dma cdrom timeout=20:10:7:7,retries=3
            /sbin/ejectd
        elif [ -f /mnt/app/devb-eideVerbosity-vvvvvv_enabled ];
        then
            devb-eide-mmx eide noslave,verbose=5 blk marking=none,cache=2m,ro cam verbose=5,resmgr mem name=/ram/dma cdrom timeout=20:10:7:7,retries=3
            /sbin/ejectd
        else
            devb-eide-mmx eide noslave blk marking=none,cache=2m,ro cam resmgr,quiet mem name=/ram/dma cdrom timeout=20:10:7:7,retries=3
            /sbin/ejectd
        fi
    else
        echo "Warning: /dev/pci does not exist. Skipped start of DVD ROM driver"
    fi
}

#############################################################################
##
## Generic RAM disk creation function (with long file name support)
##
##  $1 = ram disk size in MB
##  $2 = ram disk device name
##  $3 = ram disk mount point
##
## NOTE: $2 (the ram disk device name) __must__ be unique (otherwise the
##       waitfor_quick /dev/${RD_NAME}0t77 will fail as the "0t77" suffix is
##       enumerated to "1t77" for the second ramdisk device with the same
##       name)
##
#############################################################################

create_ramdisk()
{
    ## RAM disk size in MB
    RD_SIZE=$1
    ## RAM disk name (e.g. sysramdisk)
    RD_NAME=$2
    ## RAM disk mount point (e.g. /ramdisk)
    RD_MOUNT_POINT=$3
    ## Ram disk creation attempts
    RD_ATTEMPTS=2
    ## Ram disk creation timeout
    RD_TIMEOUT=5

    waitfor_quick /sbin/devb-ram $TIMEOUT || Error "waitfor_quick failed on /sbin/devb-ram $TIMEOUT in create_ramdisk; continue..."
    info "Creating a $RD_SIZE MB ramdisk ($RD_NAME) mounted at $RD_MOUNT_POINT"

    devb-ram blk cache=512k ram capacity=$((2048 * $RD_SIZE)) disk name=$RD_NAME

    ## The ram disk device sometimes doesn't show up
    ## artf248299: RF:[G21] long startup [6462645]
    echo devb-ram $RD_NAME returned $?
    while ! waitfor_quick /dev/${RD_NAME}0t77 $RD_TIMEOUT && [[ $RD_ATTEMPTS -gt 0 ]]
    do
        info retrying start devb-ram $RD_NAME
        pidin -p devb-ram arg | grep name=$RD_NAME > /tmp/pidin-devb-ram-$RD_NAME
        if [[ $? -eq 0 ]]
        then
            read RD_DEVB_PID RD_DEVB_REST < /tmp/pidin-devb-ram-$RD_NAME
            slay -f -m pid $RD_DEVB_PID || slay -f -m pid -s 9 $RD_DEVB_PID
        fi
        devb-ram blk cache=512k ram capacity=$((2048 * $RD_SIZE)) disk name=$RD_NAME
        echo devb-ram $RD_NAME returned $?
        RD_ATTEMPTS=$((RD_ATTEMPTS - 1))
    done

    waitfor_quick /dev/${RD_NAME}0t77 $RD_TIMEOUT || Error "waitfor_quick failed on device /dev/${RD_NAME}0t77 $RD_TIMEOUT in create_ramdisk; continue..."

    mount -t qnx4 /dev/${RD_NAME}0t77 $RD_MOUNT_POINT
    waitfor_quick $RD_MOUNT_POINT $TIMEOUT || Error "waitfor_quick failed on mount point $RD_MOUNT_POINT $TIMEOUT in start; continue..."
    if [ -e $RD_MOUNT_POINT ]
    then
        if [ ! -e ${RD_MOUNT_POINT}/.longfilenames ]
        then
            touch ${RD_MOUNT_POINT}/.longfilenames
            chmod 0444 ${RD_MOUNT_POINT}/.longfilenames
        fi
        return 0
    else
        Error "failed to create ramdisk for $RD_MOUNT_POINT"
        return 1
    fi
}

#############################################################################
##
##  Create the system ramdisk
##
## $1 = ram disk size in MB
##
#############################################################################

create_sysramdisk()
{
    RD_SIZE=$1
    create_ramdisk $RD_SIZE sysramdisk /ramdisk

    waitfor_quick /ramdisk $TIMEOUT || Error "waitfor_quick failed on /ramdisk $TIMEOUT in create_sysramdisk; continue..."
    mkdir -p /ramdisk/var/run
    mkdir -p /ramdisk/mldb
    mkdir -p -m a+rwx /ramdisk/modem_scripts
}

#############################################################################
##
##  Move etc to ramdisk
##
#############################################################################

move_etc_to_ramdisk()
{
    waitfor_quick /ramdisk $TIMEOUT || Error "waitfor_quick failed on /ramdisk $TIMEOUT in move_etc_to_ramdisk; continue..."
    cp -r /mnt/system/etc /ramdisk/etc
    ln -Ps /ramdisk/etc /etc
}

#############################################################################
##
##  Copy shared libraries from /mnt/app to ramdisk that will be used during swdl
##
#############################################################################
copy_mntapp_libs_ramdisk()
{
    RAM_DISK_DEV_NAME="tinymntapp"
    RAMDISK_MOUNT_POINT="tinymntapp"
    RAM_DISK_SIZE_MB=180

    ## During SWDL the /mnt/app will be unmounted, as a result the libraries will not accessible.
    ## Create a ramdisk to copy the folder structure for the libraries
    ## The ramdisk serves as a temporary path for the libraries while SWDL is running

    create_ramdisk  ${RAM_DISK_SIZE_MB}   ${RAM_DISK_DEV_NAME}   /${RAMDISK_MOUNT_POINT}

    waitfor_quick /${RAMDISK_MOUNT_POINT}  10
    if [ $? -eq 0 ]
    then
        mkdir -p /${RAMDISK_MOUNT_POINT}/eso/lib        > /dev/null 2>&1
        mkdir -p /${RAMDISK_MOUNT_POINT}/eso/bin/apps   > /dev/null 2>&1
        mkdir -p /${RAMDISK_MOUNT_POINT}/armle/lib      > /dev/null 2>&1
        mkdir -p /${RAMDISK_MOUNT_POINT}/armle/usr/lib  > /dev/null 2>&1
        mkdir -p /${RAMDISK_MOUNT_POINT}/armle/sbin     > /dev/null 2>&1
        ## copy shared libs / executables
        cp -R /mnt/app/eso/lib/*              /${RAMDISK_MOUNT_POINT}/eso/lib       > /dev/null
        cp -R /mnt/app/armle/lib/*            /${RAMDISK_MOUNT_POINT}/armle/lib     > /dev/null
        cp -R /mnt/app/armle/usr/lib/*        /${RAMDISK_MOUNT_POINT}/armle/usr/lib > /dev/null
        cp -f /mnt/app/armle/sbin/devc-serusb /${RAMDISK_MOUNT_POINT}/armle/sbin    > /dev/null
        cp -f /mnt/app/eso/bin/apps/NADUtil   /${RAMDISK_MOUNT_POINT}/eso/bin/apps  > /dev/null
        sync
        umount -f /${RAMDISK_MOUNT_POINT}
        echo "startup.sh: copy_mntapp_libs_ramdisk: ${RAMDISK_MOUNT_POINT} created and shared libraries copied"
    else
        Error "Error: copy_mntapp_libs_ramdisk: RAMdisk for /mnt/app shared libraries could not be created"
    fi

    ## copy the required library for the mount action, when /mnt/app/ is unmounted
    waitfor_quick /tmp 10
    if [ $? -eq 0 ]
    then
        cp /mnt/app/armle/lib/dll/fs-qnx4.so /tmp
        ln -Ps /tmp/fs-qnx4.so  /mnt/app/armle/lib/dll/fs-qnx4.so
    else
        Error "copy_mntapp_libs_ramdisk: fs-qnx4.so could not be copied - no /tmp"
    fi
}

#############################################################################
##
##  Start Wlan
##
#############################################################################

start_wlan()
{
    sysctl -w kern.sbmax=600000
    sysctl -w net.inet.ip.forwarding=1
    sysctl -w net.inet.tcp.recvspace=128480
    sysctl -w net.inet.tcp.sendspace=128480
    setconf RESOLVE nameserver_127.0.0.1

    io-sdiorm-mib2-qc -hioport=0x121C0000,irq=0x85 -c43243000 &

    waitfor_quick /dev/sdio0 5 || Error "waitfor_quick failed on /dev/sdio0 5 in start_wlan; continue..."
    on -p 14 mvload -p /mnt/app/var/FwImage -a /eso/bin/PhoneCustomer

    mount -Tio-pkt -o drv_mode=3,max_uap_bss=1,eeprom_nmacs=3,force_shutdown,scan_chan_times=150:50:50 /armle/lib/dll/devnp-mrvl_wlan-sdiorm.so
    >/tmp/mvloaded

    if_up -p -r 100 uap0
    ifconfig uap0 up
    ifconfig uap0 mediaopt hostap
    ifconfig uap0 10.173.189.1 netmask 255.255.255.0
    >/tmp/uap0

    if if_up -p -r 10 mlan0 ; then
        ifconfig mlan0 up
        >/tmp/mlan0
        echo "ctrl_interface=/var/run/wpa_supplicant\nap_scan=2\nupdate_config=1\n\n" >/ramdisk/wpa_supplicant.conf
        /armle/usr/sbin/wpa_supplicant -Bi mlan0 -c /ramdisk/wpa_supplicant.conf
    fi
}

start_wlan_mfg_mode ()
{
   io-sdiorm-mib2-qc -hioport=0x121C0000,irq=0x85 -c43243000 &

   waitfor_quick /dev/sdio0 $TIMEOUT || Error "waitfor_quick failed on /dev/sdio0 $TIMEOUT in start_wlan_mfg_mode; continue..."
   on -p 14 mvload -p /mnt/app/var/FwImage -F w8787_wlan_SDIO_bt_SDIO.bin

   mount -Tio-pkt -o mfg_mode=1 /armle/lib/dll/devnp-mrvl_wlan-sdiorm.so

   if_up -p -r 100 uap0
   ifconfig uap0 up
   ifconfig uap0 mediaopt hostap
   ifconfig uap0 10.173.189.1 netmask 255.255.255.0

   /eso/bin/apps/mfgbridge &
}

#############################################################################
##
##  Start Network
##
#############################################################################

start_network()
{
    log_launch "network"
    touch /tmp/dnsmasq.sdis.conf
    if [ -e /var/mvmfgmode ]
    then
        start_wlan_mfg_mode
    else
        start_wlan
    fi

    /armle/sbin/pfctl -ef /etc/pf.conf
    echo "block quick all" | /armle/sbin/pfctl -a EXLAP -f -
    ifconfig pflog0 up

    echo "3\n" >/tmp/dhcp.opts
    /eso/bin/apps/dnsmasq
}

start_network_ulp()
{
    sysctl -w net.inet.ip.forwarding=1 > /dev/null 2>&1
    sysctl -w net.inet.tcp.recvspace=64240 > /dev/null 2>&1
    setconf RESOLVE nameserver_127.0.0.1

    ##       pfctl -ef /etc/pf.conf
    ##       ifconfig pflog0 up

    /eso/bin/apps/dnsmasq -C /etc/dnsmasq_ulp.conf
}

#############################################################################
##
##  Start Autorunner
##
#############################################################################

start_autorunner()
{
    waitfor_quick /dev/mcd/AUTORUN $TIMEOUT || Error "waitfor_quick failed on /dev/mcd/AUTORUN $TIMEOUT in start_autorunner; continue..."
    autorunner
}

#############################################################################
##
##  Start System Services
##
#############################################################################

start_system_services()
{

    waitfor_quick /tmp/usb-stack $TIMEOUT || Error "waitfor_quick failed on /tmp/usb-stack $TIMEOUT in start_system_services; continue..."
    start_usblauncher

    waitfor_quick /ramdisk/pps $TIMEOUT || Error "waitfor_quick failed on /ramdisk/pps $TIMEOUT in start_system_services; continue..."
    if [ -f /mnt/app/mmcsdpubVerbosity-vv_enabled ];
    then
        mmcsdpub -vv -l -f /dev/sda0 -f /dev/sdb0 -m /ramdisk/pps -s /mnt/app/armle/lib/dll/pubs &
    elif [ -f /mnt/app/mmcsdpubVerbosity-vvvvvv_enabled ];
    then
        mmcsdpub -vvvvvv -l -f /dev/sda0 -f /dev/sdb0 -m /ramdisk/pps -s /mnt/app/armle/lib/dll/pubs &
    else
        mmcsdpub -l -f /dev/sda0 -f /dev/sdb0 -m /ramdisk/pps -s /mnt/app/armle/lib/dll/pubs &
    fi

    check_mcd_config
    if [ -f /mnt/app/mcdVerbosity-vv_enabled ];
    then
        mcd -Vvv /etc/mcd.conf &
    elif [ -f /mnt/app/mcdVerbosity-vvvvvv_enabled ];
    then
        mcd -Vvvvvvv /etc/mcd.conf &
    else
        mcd -Vv /etc/mcd.conf &
    fi

    ## Enable dplmp with mpdecision turned off, right after PPS availibility.
    ## TODO : Remove pps dependency from dplmp so that it can be
    ##        launched earlier to allow for core offlining by thermalmgr during early startup.
    echo 'dlexec "" "enable_dplmp" "0" GLOBALSYMS ' > /dev/qcore
}

start_system_services_ulp()
{
    waitfor_quick /tmp/usb-stack $TIMEOUT || Error "waitfor_quick failed on /tmp/usb-stack $TIMEOUT in start_system_services_ulp; continue..."
    start_usblauncher_ulp
    mcd -Vv /etc/mcd.conf &
}

#############################################################################
##
##  Start System Tools
##
#############################################################################

start_system_tools()
{
    cd /sbin
    if [ -d /mnt/ota/system/jobs ]
    then
        jobctrl -p 22110 &
    fi
    challenge -p 22111 -f &
    ./cpumeter -c 999999000 -n mmx -i 1000 &
    ./IRCOutpost &
    waitfor_quick /ramdisk/IRC_PIPE $TIMEOUT || Error "waitfor_quick failed on /ramdisk/IRC_PIPE $TIMEOUT in start_system_tools; continue..."
    cartimeprovider &
    waitfor_quick /dev/cartime $TIMEOUT || Error "waitfor_quick failed on /dev/cartime $TIMEOUT in start_system_tools; continue..."
    systracker &
    heartbeat -p11 &
    (
        sleep 120 ;
        memmonit -c /etc/memmonit/memmonit.cfg ;
    ) &

    ./slf -f /etc/slf/slf.cfg &

}

start_system_tools_ulp()
{
    cd /sbin
    ./cpumeter -c 999999000 -n mmx -i 1000 & ## start that anyway, we might use that
    ./slf -f /etc/slf/slf.cfg &
}

#############################################################################
##
##  Start Framework (ifs parts)
##
#############################################################################

start_early_framework()
{
    /eso/bin/broker &
}

#############################################################################
##
##  Start Framework (mnand parts)
##
#############################################################################

start_framework()
{
    cd /mnt/app/eso/

    if [[ -e /etc/startup_test_mode && ! ${RUN_MODE} = "swdl" ]]
    then
        run_mergelog &
    fi
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/eso/lib/tracingPlugins /eso/bin/traceserver &

    ## needed by Parrot
    waitfor_quick /dev/ptyp0 $TIMEOUT || Error "waitfor_quick failed on /dev/ptyp0 $TIMEOUT in start_framework; continue..."
    log_launch "framework"
    /eso/bin/servicemgrmibhigh &
}

#############################################################################
##
##  Start HMI
##
#############################################################################

start_hmi()
{
    cd /mnt/app/eso

    log_launch "hmi"
    if [[ $QUIET = 1 ]]
    then
        bin/runHMI.sh > /dev/shmem/hmi.log 2>&1
    else
        bin/runHMI.sh
    fi
}

#############################################################################
##
##  Start usblauncher
##
#############################################################################
start_usblauncher()
{
    ## Start pps framework first since usblauncher has to publish mediadetection information

    log_launch pps

    mkdir -p /ramdisk/pps_dummy_persist
    if [ -f /mnt/app/ppsVerbosity-vv_enabled ]
    then
        pps -m /ramdisk/pps -p /ramdisk/pps_dummy_persist -vv
    elif [ -f /mnt/app/ppsVerbosity-vvvvvv_enabled ]
    then
        pps -m /ramdisk/pps -p /ramdisk/pps_dummy_persist -vvvvvv
    else
        pps -m /ramdisk/pps -p /ramdisk/pps_dummy_persist
    fi

    waitfor_quick /ramdisk/pps $TIMEOUT || Error "waitfor_quick failed on /ramdisk/pps $TIMEOUT in start_usblauncher; continue..."

    ## This is a workaround for a suspected pps synchronization issue (artf163903)
    sleep 1

    ## Don't change the name of the *.lua files in these rules anymore since the files are
    ## provided from team Media

    if [ -f /mnt/app/usblauncherVerbosity-vvvvvv_enabled ]
    then
        USBLAUNCHER_VERBOSITY="-vvvvvv"
    else
        USBLAUNCHER_VERBOSITY="-vv"
    fi

    LD_LIBRARY_PATH=/eso/bin/apps/customerupdate_media/lib/dll:$LD_LIBRARY_PATH PATH=/eso/bin/apps:$PATH usblauncher -e ${USBLAUNCHER_VERBOSITY} -c /etc/usblauncher.lua -M /etc/mcd.mnt -t -l -m /ramdisk/pps -p 2 -s /mnt/app/armle/lib/dll/pubs -n /dev/io-usb/io-usb -S 0 -O &


    ## In normal mode 2nd usblauncher instance is started via usblauncher.lua, depends on MediaConnector type.
    ## In case the run mode of the system is "hb_production" or "hb_testmode" the 2nd usblauncher instance has to be started
    ## incl. the start of io-usb, otherwise the production tests may fail. Please be aware that the usblauncher.lua has been
    ## adapted in order to skip the start of 2nd usblauncher (done as soon as MediaConnector is detected).

    if [ $RUN_MODE = "hb_production" ] || [ $RUN_MODE = "hb_testmode" ]
    then

        LD_LIBRARY_PATH=/eso/bin/apps/customerupdate_media/lib/dll:$LD_LIBRARY_PATH PATH=/eso/bin/apps:$PATH usblauncher -r -e ${USBLAUNCHER_VERBOSITY} -c /etc/usblauncher_otg.lua -M /etc/mcd_otg.mnt -t -l -m /ramdisk/pps -p 2 -s /mnt/app/armle/lib/dll/pubs -n /dev/io-usb/otg -S 1 &

    fi

}

start_usblauncher_ulp()
{
    ## Start pps framework first since usblauncher has to publish mediadetection information
    ## The pps persistence has been activated with "-p" option as a workaround since
    ## otherwise it is not ensured that all updates are written to pps
    mkdir -p /ramdisk/pps_dummy_persist
    pps -m /ramdisk/pps -p /ramdisk/pps_dummy_persist &
    waitfor_quick /ramdisk/pps $TIMEOUT || Error "waitfor_quick failed on /ramdisk/pps $TIMEOUT in start_usblauncher_ulp; continue..."

    ## This is a workaround for a suspected pps synchronization issue (artf163903)
    sleep 1

    LD_LIBRARY_PATH=/eso/bin/apps/customerupdate_media/lib/dll:$LD_LIBRARY_PATH PATH=/eso/bin/apps:$PATH usblauncher -v -c /etc/usblauncher.lua -M /etc/mcd.mnt -t -l -m /ramdisk/pps -p 2 -s /mnt/app/armle/lib/dll/pubs -n /dev/io-usb/io-usb -S 0 &
}

#############################################################################
##
##  Check mcd Configuration
##
##  mount devices r/w if "/etc/mcd.writable" exists
##
#############################################################################

check_mcd_config()
{
    if [ -f /etc/mcd.writable ]
    then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!!!      SOME SCRIPT REQUIRES R/W MOUNTS              !!!"
        if [ ! -e /etc/mcd_orig.mnt ]
        then
            echo "!!! BUT MCD MOUNTS DEVICES READONLY CHECK GEM mmx/mcd !!!"
        fi
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    fi
    if [ -e /etc/mcd_orig.mnt ]
    then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!!!          MCD MOUNTS DEVICES R/W.                  !!!"
        echo "!!! READ PERFORMANCE MIGHT BE BAD. CHECK GEM mmx/mcd  !!!"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    fi
}

create_required_dirs_and_links()
{
    ## Creating /mnt/app/speech/hmi could fail if partition couldn't be mounted
    ## Don't add a 'waitfor' for /mnt/speech
    if [[ ! -e /mnt/speech/hmi ]]; then
        ln -s /mnt/app/speech/hmi /mnt/speech/hmi
    fi

    if [[ ! -d $COREFILES_DIR ]]; then
        mkdir -p $COREFILES_DIR
    fi

    if [[ ! -d $LOGFILES_DIR ]]; then
        mkdir -p $LOGFILES_DIR
    fi

    ## create fifo for green menu if not available
    if [[ ! -p /var/script.fifo ]]; then
        mkfifo /var/script.fifo
    fi
}

#############################################################################
##
##  Start Java
##
#############################################################################

java_startup()
{
    VMOPTIONS="-Xmjit:code=2000,singleCache"
    VMOPTIONS="$VMOPTIONS -Xquickstart"
    VMOPTIONS="$VMOPTIONS -Xrunheaputil:file=/tmp/j9heapdump.txt"
    VMOPTIONS="$VMOPTIONS -Xcompactexplicitgc"
    VMOPTIONS="$VMOPTIONS -Xgcpolicy:gencon -Xgcpolicy:optthruput"
    VMOPTIONS="$VMOPTIONS -Xssi32 -Xss4096K"
    VMOPTIONS="$VMOPTIONS -Djava.library.path=$LD_LIBRARY_PATH"
    VMOPTIONS="$VMOPTIONS -Dcom.ibm.oti.vm.bootstrap.library.path=$LD_LIBRARY_PATH"
    VMOPTIONS="$VMOPTIONS -Xmca16k -Xmco16k -Xmo26m -Xmoi0 -Xmn2m -Xmx28m"

    echo "Starting Java..."
    /ifs/jre/bin/j9 $VMOPTIONS -Dipl.config.myProcName=hmi -Dipl.config.dir=/etc/eso/production -Dipl.config.file.tracing=tracing.ulp.json -Xbootclasspath:/ifs/lsd.jxe -cp /mnt/app/eso/ulp/arc-ulp-launcher.jar arc.ulp.launcher.UlpLauncher
}

#############################################################################
##
##  Overwrite env. variable "SOP" if SOP1PLUS-feature are enabled
##
#############################################################################

check_sop()
{
    waitfor_quick /eso/hmi $TIMEOUT || Error "waitfor_quick failed on /eso/hmi $TIMEOUT in check_sop; continue..."

    ## TODO: remove for SOP2+
    ## probably only here for historical reasons.
    ## make sure no hmi provides the file /eso/hmi/sop1plus
    ## make sure no app either uses the file or the environment variable
    ##
    if [ -f "/eso/hmi/sop1plus" ]
    then
        export SOP=SOP1PLUS
    fi
}

#############################################################################
##
##  Moving old corefiles into subfolder during startup
##
#############################################################################

move_old_corefiles()
{
    waitfor_quick $COREFILES_DIR $TIMEOUT || Error "waitfor_quick failed on $COREFILES_DIR $TIMEOUT in move_old_corefiles; continue..."
    /eso/hmi/engdefs/scripts/move_corefiles.sh
}

#############################################################################
##
##  HB productiontest support Functions
##
#############################################################################

start_production_test_server()
{
    waitfor_quick /mnt/app/armle/lib $TIMEOUT || Error "waitfor_quick failed on /mnt/app/armle/lib $TIMEOUT in start_production_test_server; continue..."
    waitfor_quick /mnt/app/armle/usr/sbin $TIMEOUT || Error "waitfor_quick failed on /mnt/app/armle/usr/sbin $TIMEOUT in start_production_test_server; continue..."
    /mnt/app/armle/usr/sbin/production
}

############################################################################
##
##  start a watchdog; args depend on GEM settings
##
############################################################################

start_watchdog()
{
    if [ -e ${QC_TOUCH_BASEFS}/ENABLE_RAMDUMPS ]
    then
        echo "Info startup.sh: RAM dumps enabled (${QC_TOUCH_BASEFS}/ENABLE_RAMDUMPS)"
        WDOG_ARGS="-r"
    else
        WDOG_ARGS="-k 20 -b 600 -i 610"
    fi
    watchdog $WDOG_ARGS
}

############################################################################
##
##  release IFS memory
##
############################################################################

cleanup_ifs()
{
    if [ -e ${QC_TOUCH_BASEFS}/ENABLE_RAMDUMPS ]
    then
        echo "Info startup.sh: note - do NOT free ifs memory due to ENABLE_RAMDUMPS"
    else
        echo "Info startup.sh: free ifs memory..."
        addmem -i efs
    fi
}


############################################################################
##
##  start a Analyzer; GEM settings responsible for creating/deleting flag
##
############################################################################

start_analyzer()
{
    if [ -e ${QC_TOUCH_BASEFS}/ENABLE_ANALYZER ]
    then
        echo "Info startup.sh: Analyzer enabled (${QC_TOUCH_BASEFS}/ENABLE_ANALYZER)"
        # Start Analyzer
        ${BASEFS}/scripts/analyzer.sh start
    fi
}

############################################################################
##
## 15.02.2016
## there is a new cdt with DDR double refresh as needed for temp above 85C.
##
## If we find an old cdt then this function overwrites it with the
## newer one.
##
############################################################################
install_cdt_with_double_refresh_if_necessary()
{
    CDT_PARTITION=/dev/emmc/cdt
    CDT_TMP_COPY=/tmp/cdt.tmp
    CDT_PARTITION_CHECK_LENGTH=388   # checks this length of CDT partition
    CDT_PARTITION_OLD_SOURCEIMAGE=/mnt/app/eso/lib/mmx2_primary_cdt.bin
    CDT_PARTITION_NEW_SOURCEIMAGE=/mnt/app/eso/lib/cdt.bin
    CDT_PARTITION_OLD_MD5SUM=5DCE702C6D8B7FB2E7F0FC8ABFA43F56
    CDT_PARTITION_NEW_MD5SUM=6DB48F172A69C81076D9AAEC3F54484F
    CDT_PARTITION_OLD_DESCRIPTION="old (primary CDT as used up to Feb 2016)"
    CDT_PARTITION_NEW_DESCRIPTION="new (OEM CDT 2GB, DDR3 double refresh)"
    CDT_PARTITION_UNKNOWN_DESCRIPTION="unknown"
    CDT_SOURCE_IMAGE=${CDT_PARTITION_NEW_SOURCEIMAGE}
    CDT_PARTITION_DESCRIPTION=${CDT_PARTITION_NEW_DESCRIPTION}

    echo "startup.sh: test cdt version..."

    echo "in32 0x00A800A0 + 0x00D800A0: 0x07345007 = up to ES9.5, 0x071a1007 = ES9.6 or newer"
    in32 0x00A800A0
    in32 0x00D800A0


    dd if="${CDT_PARTITION}" of="${CDT_TMP_COPY}" bs=1 count=${CDT_PARTITION_CHECK_LENGTH}
    CDT_MD5SUM=$( fsutil checksum -d MD5 -f "${CDT_TMP_COPY}" )
    rm -f "${CDT_TMP_COPY}"

    echo "startup.sh: md5sum = "${CDT_MD5SUM}

    case "${CDT_MD5SUM}" in
        (${CDT_PARTITION_OLD_MD5SUM})
            echo "startup.sh: CDT is ${CDT_PARTITION_OLD_DESCRIPTION}"
            echo "startup.sh: update..."
            if [ -f "${CDT_SOURCE_IMAGE}" ]
            then
                echo "startup.sh: copy ${CDT_PARTITION_DESCRIPTION}  ..."
                if dd if="${CDT_SOURCE_IMAGE}" of="${CDT_PARTITION}"
                then
                    echo "startup.sh: . . ${CDT_SOURCE_IMAGE} done."
                else
                    echo "startup.sh: error while flashing ${CDT_SOURCE_IMAGE}!"
                fi
            else
                echo "startup.sh: error: file ${CDT_SOURCE_IMAGE} not found!"
            fi

            ;;
        (${CDT_PARTITION_NEW_MD5SUM})
            echo "startup.sh: CDT is "${CDT_PARTITION_NEW_DESCRIPTION}
            ;;
        (*)
            echo "startup.sh: CDT is "${CDT_PARTITION_UNKNOWN_DESCRIPTION}
            ;;
    esac


}

############################################################################
##
##  Normal Startup
##
############################################################################

normal_startup()
{
    set_environment_variables
    start_early_framework
    start_early_drivers
    check_filesystems
    start_drivers &
    ## AISIN specific for Navi app
    /armle/sbin/mqueue &
    log_launch "ramdisk(s)"
    create_sysramdisk 20 &
    create_ramdisk 10 organizer /organizerdisk &
    check_sop

    waitfor_quick /mnt/app/eso $TIMEOUT || Error "waitfor_quick failed on /mnt/app/eso $TIMEOUT in normal_startup; continue..."
    waitfor_quick /organizerdisk || Error "waitfor_quick failed on /organizerdisk in normal_startup; continue..."
    start_network &
    start_system_services &
    start_analyzer
    cleanup_ifs
    start_watchdog
    start_framework
    start_hmi &
    start_system_tools
    waitfor_quick /mnt/app/img_ver.txt $TIMEOUT || Error "waitfor_quick failed on /mnt/app/img_ver.txt $TIMEOUT in normal_startup; continue..."
    { read IMG_VER1; read IMG_VER2; } < /mnt/app/img_ver.txt
    info "MMX BENCH_Startup IMG_VER $IMG_VER1 $IMG_VER2"
    echo "MMX BENCH_Startup IMG_VER $IMG_VER1 $IMG_VER2"
    pidin info

    start_autorunner &

    # New driver from eso replaced i2c-smsc_bridge
    if [ -f /mnt/app/mediaconnectorVerbosity-v3_enabled ]
    then
        /eso/bin/apps/mediaconnector -v3 -map 0x11,0x10 &
    elif [ -f /mnt/app/mediaconnectorVerbosity-v6_enabled ]
    then
        /eso/bin/apps/mediaconnector -v6 -map 0x11,0x10 &
    else
        /eso/bin/apps/mediaconnector -v1 -map 0x11,0x10 &
    fi

    start_dvdrom_driver

    # MOST not for DELPHI
    # DTV
    waitfor_quick /net/rcc/dev/name/local/inic/isoRX1 2
    if [ $? -eq 0 ]
    then
        devp-iso-mmx-mib2 -R -S196 -i0 -B3 -P32 -Q24 -m/dev/mlb -MisoRX1 -v5 -p16 &
    else
        Error "waitfor_quick failed on /net/rcc/dev/name/local/inic/isoRX1 2 in normal_startup; continue..."
    fi
    ## AVDC
    waitfor_quick /net/rcc/dev/name/local/inic/isoRX2 2
    if [ $? -eq 0 ]
    then
        devp-iso-mmx-mib2 -R -S196 -i1 -B3 -P32 -Q24 -m/dev/mlb -MisoRX2 -v5 -p16 &
    else
        Error "waitfor_quick failed on /net/rcc/dev/name/local/inic/isoRX2 2 in normal_startup; continue..."
    fi
    ## Passenger Map
    waitfor_quick /net/rcc/dev/name/local/inic/isoTX1 2
    if [ $? -eq 0 ]
    then
        devp-iso-mmx-mib2 -T -S188 -i2 -B3 -P64 -Q18 -m/dev/mlb -MisoTX1 -v5 -p16 &
    else
        Error "waitfor_quick failed on /net/rcc/dev/name/local/inic/isoTX1 2 in normal_startup; continue..."
    fi
    ## DCIVIDEO: Kombi Map
    waitfor_quick /net/rcc/dev/name/local/inic/isoTX2 2
    if [ $? -eq 0 ]
    then
        devp-iso-mmx-mib2 -T -S188 -i3 -B3 -P64 -Q18 -m/dev/mlb -MisoTX2 -v5 -p16 &
    else
        Error "waitfor_quick failed on /net/rcc/dev/name/local/inic/isoTX2 2 in normal_startup; continue..."
    fi

    ham


    sleep 5
    start_video_drivers

    sleep 10
    start_late_drivers

    echo "startup.sh: check cdt..."
    install_cdt_with_double_refresh_if_necessary

    ## Release static splash memory back to kernel heap.
    addmem -i splash

    ## Write protect the boot1 partition
    wpctl -d /dev/emmc/boot1 -s 0 -n 8192

    echo "startup.sh: startup.sh: launch MNAND refresh_tool..."
    ## only in CLU8+CLU8_ASIA: write refresh_tool logs to MLC (as it was in CLU7)
    ## note: CLU10 is expected to use /mnt/slc0 again
    /net/mmx/mnt/app/armle/sbin/refresh_tool -t path=/mnt/persist/var -h path=/mnt/persist/var &
}

#############################################################################
##
##  SWDL Startup
##
#############################################################################

swdl_startup()
{
    set_environment_variables_swdl
    set_environment_variables
    start_early_drivers
    check_filesystems

    start_drivers &
    ## AISIN specific for Navi app
    /armle/sbin/mqueue &
    create_sysramdisk 256
    create_ramdisk 10 organizer /organizerdisk
    move_etc_to_ramdisk
    copy_mntapp_libs_ramdisk
    start_network &

    start_system_services &
    cleanup_ifs
    start_watchdog
    start_early_framework
    waitfor_quick /mnt/app/eso $TIMEOUT || Error "waitfor_quick failed on /mnt/app/eso $TIMEOUT in swdl_startup; continue..."
    start_framework
    start_hmi &

    start_dvdrom_driver &
    start_late_drivers
}

#############################################################################
##
##  Test-mode Startup
##
#############################################################################

hb_testmode_startup()
{
    ## HB Testmode requires nvgpio in a different mode; as it is initially
    ## started in boot.sh, where we don't know about RUN_MODE yet, we have
    ## to slay and restart here
    slay devg-nvgpio
    /sbin/devg-nvgpio extra_gpios

    set_environment_variables

    check_filesystems

    start_drivers &

    waitfor_quick /tmp/usb-stack $TIMEOUT || Error "waitfor_quick failed on /tmp/usb-stack $TIMEOUT in hb_testmode_startup; continue..."
    start_usblauncher

    waitfor_quick /ramdisk/pps $TIMEOUT || Error "waitfor_quick failed on /ramdisk/pps $TIMEOUT in hb_testmode_startup; continue..."
    mmcsdpub -l -f /dev/sda0 -f /dev/sdb0 -m /ramdisk/pps -s /mnt/app/armle/lib/dll/pubs &

    mcd -Vv /etc/mcd.conf &

    start_early_framework &
    start_nvcapture &

    ## slay ooc
    slay -f -9 -Q ooc

    start_wlan

    start_production_test_server &
}

#############################################################################
##
##  ULP (Online) Startup
##
#############################################################################

ulp_startup()
{
    info "Start ulp_startup"
    set_environment_variables_ulp

    check_filesystems
    cleanup_ifs
    start_watchdog

    start_network_ulp &
    info "create ramdisk ..."
    create_sysramdisk 20
    create_ramdisk 10 organizer /organizerdisk

    waitfor_quick /mnt/app/img_ver.txt $TIMEOUT || Error "waitfor_quick failed on /mnt/app/img_ver.txt $TIMEOUT in ulp_startup; continue..."

    ## Mounting icu.iso as requested by A. Weizel
    { read IMG_VER1; read IMG_VER2; } < /mnt/app/img_ver.txt
    info "MMX BENCH_Startup IMG_VER $IMG_VER1 $IMG_VER2"
    echo "MMX BENCH_Startup IMG_VER $IMG_VER1 $IMG_VER2"
    start_system_services_ulp &
    start_system_tools_ulp

    export IPL_CONFIG_DIR=/etc/eso/production
    export IPL_CONFIG_FILE_TRACING=/etc/eso/production/tracing.ulp.json
    cd /mnt/app/eso
    /eso/bin/broker &
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/eso/lib/tracingPlugins /eso/bin/traceserver &
    LD_PRELOAD=/proc/boot/libGLESv2.so.1:/proc/boot/libEGL.so.1 /eso/bin/servicemgrmibhigh &

    echo "####################\nOnline Startup Ready.\n####################"

    java_startup &
    start_drivers_ulp &
}

#############################################################################
##
##  print some info to console and to /tmp/Version_Info_* (this makes the
##  info available in  GEM main/version/Get Version info)
##
#############################################################################

## This command tries to get version numbers of SBL1, SBL3 and LK by comparing md5 sums with known values

set -A description_LK                                                 \
    266676 14C6DC589B34F2A2CC25C2E783891472 ES9.3                     \
    266516 4F33DF0D8EF1B3E5BDCFEDCB34D96278 ES8.0

set -A description_SBL1                                               \
    232612 2B2D4889CDCDB3FFE4317F04C1ED0E1A C8REL01.02A               \
    232612 976355911F195F2F09F90BF0FC0DD437 ES10.14A                  \
    232612 2F0488499CE5903C23ABEE826E2D0D28 ES10.12A                  \
    232604 2F678DD0579C75C97442498C2DC5B4FB ES10.8                    \
    232604 ECAB508ED383888D187BF4E95037FBF3 ES10.5                    \
    232604 55B69C594AD1C5959B3CC13B502C5E7F ES10.4                    \
    232604 B85E82D8C0E268B8324E0907FB372B5B ES9.7A                    \
    232604 0DD3FABB1CCD8CDDC70C8ADFDDD3436D ES9.6A                    \
    232604 87876F0A22F7C8B43CA0ECE2CC8F7B2E ES9.3                     \
    232412 458D3BC3EBF1BDE6500EE53A5AF31E31 ES9.1A                    \
    232404 6D84E041F7DE6837C4BCC3A4447A2109 ES8.2B_updtd_QC_bl        \
    232404 0846C4FC5ABA91DB5772C3DF954C3CC8 ES7.1,ES8.2               \
    232404 7AD972443DAA6E0D9ACE29A64EE4C51B ES8.1A                    \
    232404 6DDB3087D2E77CE026EDE2A297C58816 ES8.0                     \
    232412 280F8F2DCBC158ACF395413DA277C17D ES6.1,ES7.0_rollback      \
    233524 B26605EB32355965A1B85B9EB3EEC9D9 2015_08_04_new_BL         \
    224692 788E188846AEBE992C03198A5488D8BD 2015_07_27_BL_regenerate

set -A description_SBL3                                               \
    384280 FDFA34CDF6F456B968A3EFC8E1B358CA C8REL01.02A               \
    384280 2428642B148E892DAF469046FE61B549 ES10.14A                  \
    384280 B96DD2DC8AA48EFF7D6F8B5731C25440 ES10.12A                  \
    384280 490A96CAA91E70677131DDCD3CB7814E ES10.8                    \
    384280 056420EC40F795CE7DCA8C621F17695D ES10.6                    \
    384296 998E5E3306A5E3822023D1A4BA672478 ES10.5                    \
    384280 FE59D6F2C52930C6F3F85B9E43DF25C2 ES10.4                    \
    384276 9C4A11E18613D01FA72FD7D2CDA740C9 ES10.1A                   \
    384276 0C5014002D26BCEBC270EA32CE6D3BD5 ES9.7A                    \
    384276 389A54C4EFC574461EEA3B54154943E8 ES9.6A                    \
    384276 C705A320657473EA1732A423A14AC36A ES9.3                     \
    384052 EF3D3B89E5F343E1AB28CC9D00111B6F ES9.1A                    \
    384044 AACC5D9643A1488E94C9B2889629D640 ES8.2B_updtd_QC_bl        \
    384044 E7FD29B8B3638CE644EB3A0C239A8DC8 ES7.1,ES8.2               \
    384044 8593E8127E2A08169549971A8ADDF4AD ES8.1A                    \
    384044 7DF7ED05BC00C6FD2E2FC0337D79497F ES8.0                     \
    379824 BDD3B44CC2D6C19D0922E843701A3C12 ES6.1,ES7.0_rollback      \
    379824 4B8D6D58BA0AD035C74B0029DF053F27 2015_08_04_new_BL         \
    330088 0597063376876D946057E3A481D36474 2015_07_27_BL_regenerate

check_bootloaderversion()
{
    NAME=$1 ; shift
    DEVICE=$1 ; shift
    set -A DESCRIPTION $*

    i=0
    while [ $i -lt ${#DESCRIPTION[*]} ]
    do
        LENGTH=${DESCRIPTION[$(( $i ))]}
        CHECKSUM=`dd if=$DEVICE of=/dev/stdout 2>/dev/null bs=$LENGTH count=1 2>/dev/null | /mnt/app/armle/sbin/fsutil checksum -d MD5 -f /dev/stdin`
        if [ "$CHECKSUM" = "${DESCRIPTION[$(( $i + 1 ))]}" ]
        then
            echo "$NAME version found: " ${DESCRIPTION[$(( $i + 2 ))]}
            return
        fi
        i=$(( $i + 3 ));
    done
    echo "no version found for $NAME"
}

print_version_info()
{
    waitfor /dev/pdbg/qcore/image_version/version_table 60000
    echo "Info startup.sh QC bootloader version:"
    (
        cat /dev/pdbg/qcore/image_version/version_table
        check_bootloaderversion LK /dev/emmc/lk "${description_LK[@]}"
        check_bootloaderversion SBL1 /dev/emmc/sbl1 "${description_SBL1[@]}"
        check_bootloaderversion SBL3 /dev/emmc/sbl3 "${description_SBL3[@]}"
    ) | tee /tmp/Version_Info_QC_bootloader.txt

    echo "SKU info:"
    (
        echo " - project:   ${PROJ_ID}"
        echo " - revision:  ${REVISION}"
        echo " - SKU:       ${SKU_ID}"
        echo " - serial:    ${SERIAL_NO}"
    ) | tee /tmp/Version_Info_Hardware.txt

    ## Print EMMC FW to console
    echo "Info startup.sh: eMMC FW info:"
    /mnt/app/armle/bin/read-cardreg -d /dev/emmc/uda0 -r ext_csd_parsed  | tee /tmp/Version_Info_eMMC_FW.txt

    ## Print eMMC size
    EMMC_SIZE=$( get_diskdensity )
    echo "Info startup.sh: eMMC size:"
    echo $EMMC_SIZE " blocks of size 512 bytes = $(( $EMMC_SIZE / 2 )) kB = $(( $EMMC_SIZE / 2 / 1024 )) MB = $(( $EMMC_SIZE / 2 / 1024 / 1024 )) GB" | tee /tmp/Version_Info_eMMC_size.txt

    ## Print out the unique serial num of APQ.
    /bin/in32 0x7000B8 | awk '{print "Serial Num = " $3}' | tee /tmp/Version_Info_QC_Serial_number_of_APQ.txt

    ## Print clock driver bin information.
    /mnt/app/armle/bin/clock.sh info top | tee /tmp/Version_Info_QC_clock_driver_info_top.txt

}

print_warn()
{
    echo "   \\|/ ____ \\|/"
    echo "   \"@'/ .. \\\`@\""
    echo "   /_| \\__/ |_\\"
    echo "      \\__U_/"
}

#############################################################################
##
##  Startup
##
#############################################################################

if [ "$REGION" = "__REGION""-""VARIABLE__" ]
then
    echo "* startup.sh: This script is invalid. It should be pre-processed before it is used on the device"
    echo "* startup.sh: script processing will be terminated"
    print_warn
    sleep 10
    exit 1
fi

QUIET=0

info "Starting /etc/boot/startup.sh ..."

export PROJECT=MMX2

## directory to mark settings with touch
export QC_TOUCH_BASEFS=/armle
## if $QC_TOUCH_BASEFS is mounted ro normally then set QC_TOUCH_BASEFS_REQUIRED_REMOUNT_RW to 1.
## In this case $QC_TOUCH_BASEFS_REQUIRED_REMOUNT_PATH will be remounted rw to touch and ro after that.
## If QC_TOUCH_BASEFS_REQUIRED_REMOUNT_RW is 0 then no remount will occur and QC_TOUCH_BASEFS_REQUIRED_REMOUNT_PATH will be ignored.
export QC_TOUCH_BASEFS_REQUIRED_REMOUNT_RW=1
export QC_TOUCH_BASEFS_REQUIRED_REMOUNT_PATH=/mnt/app


## PROJ_ID required by media team
read PROJ_ID < $SKUDIR/project
export PROJ_ID

read   SKU_ID    < $SKUDIR/sku
export SKU_ID

read   REVISION  < $SKUDIR/rev
export REVISION

read   SERIAL_NO < $SKUDIR/serial_num
export SERIAL_NO

if [ -e ${QC_TOUCH_BASEFS}/ENABLE_USB_DEVICE ]
then
    echo "Info startup.sh: RNDIS enabled (${QC_TOUCH_BASEFS}/ENABLE_USB_DEVICE)"
fi

waitfor_quick /dev/ooc/startup $TIMEOUT || Error "waitfor_quick failed on /dev/ooc/startup $TIMEOUT; continue..."
read RUN_MODE < /dev/ooc/startup
export RUN_MODE

## Some initial environment setup

export BASEFS=/armle

MEDIA_DIR=/media
enable_bmetrics="true"

if [ -e /armle/scripts/env.sh ]
then
    . "/armle/scripts/env.sh"
fi
if [ -e /armle/scripts/common.sh ]
then
    . "/armle/scripts/common.sh"
fi

export LOGDIR="/mnt/ota/system/core" # TODO eso: remove? same in boot.sh

move_core_files_from_tmp_to_ota

( sleep 60; print_version_info ) &

log_launch "mode ${RUN_MODE}"
case $RUN_MODE in
    "normal")
        normal_startup
        ;;

    "swdl")
        swdl_startup
        ;;

    "hb_production")
        normal_startup
        ;;

    "eso_screening")
        normal_startup
        ;;

    "hb_testmode")
        hb_testmode_startup
        ;;

    "ulp")
        ulp_startup
        ;;

    *)
        echo "Run mode \"$RUN_MODE\" is unknown."
        ;;
esac

############################################################################

