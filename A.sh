#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
MODPATH="/data/adb/modules/Automatic"
[[ ! -e ${MODDIR}/ll/log ]] && mkdir -p ${MODDIR}/ll/log
source "${MODPATH}/scripts/X.sh"
local interval=1
UINT_MAX="4294967295"
km1() {
	echo -e "$@" >>自动.log
	echo -e "$@"
}
km2() {
	echo -e "❗️ $@" >>自动.log
	echo -e "❗️ $@"
}
function log() {
logfile=1000000
maxsize=1000000
if  [[ "$(stat -t ${MODDIR}/ll/log/自动.log | awk '{print $2}')" -eq "$maxsize" ]] || [[ "$(stat -t ${MODDIR}/ll/log/自动.log | awk '{print $2}')" -gt "$maxsize" ]]; then
rm -f "${MODDIR}/ll/log/自动.log"
fi
}
while true; do
cd ${MODDIR}/ll/log
log
for a in $(dumpsys activity|grep mResumed|cut -f8 -d ' '|cut -f1 -d/);do am send-trim-memory $a RUNNING_CRITICAL;chrt -r -p 99 $(pidof $a);done; >/dev/null 2>&1 &
app_list_filter="grep -o -e applist.app.add"
while IFS= read -r applist || [[ -n "$applist" ]]; do
    filter=$(echo "$applist" | awk '!/ /')
    if [[ -n "$filter" ]]; then
        app_list_filter+=" -e "$filter
    fi
done < "${MODPATH}/scripts/file/applist_perf.txt"
window=$(dumpsys window | grep package | $app_list_filter | tail -1)
if [[ "$window" ]]; then
echo "$date *🅰️制定运行*" >>自动.log
su -c cmd shortcut reset-throttling
su -c cmd shortcut reset-all-throttling
su -c cmd power set-adaptive-power-saver-enabled false
su -c cmd power set-fixed-performance-mode-enabled true
su -c cmd power set-mode 0
su -c cmd thermalservice override-status 0
[[ -d /dev/cpuset/ ]] && {
lock_value /dev/cpuset/cpus "0-7"
lock_value /dev/cpuset/background/cpus "0-1"
lock_value /dev/cpuset/system-background/cpus "0-3"
lock_value /dev/cpuset/foreground/cpus "0-7"
lock_value /dev/cpuset/foreground/boost/cpus "5-7"
lock_value /dev/cpuset/top-app/cpus "0-7"
lock_value /dev/cpuset/restricted/cpus "0-5"
lock_value /dev/cpuset/camera-daemon/cpus "0-7"
}
[[ -d "/sys/devices/system/cpu/" ]] && {
lock_value /sys/devices/system/cpu/cpufreq/policy0/scaling_governor "performance"
lock_value /sys/devices/system/cpu/cpufreq/policy7/scaling_governor "performance"
lock_value /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq "556800"
lock_value /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq "2016000"
lock_value /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq "614400" 
lock_value /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq "2803200"
lock_value /sys/devices/system/cpu/cpu2/online "1"
lock_value /sys/devices/system/cpu/cpu3/online "1"
lock_value /sys/devices/system/cpu/cpu4/online "1"
lock_value /sys/devices/system/cpu/cpu5/online "1"
lock_value /sys/devices/system/cpu/cpu0/core_ctl/enable "1"
lock_value /sys/devices/system/cpu/cpu6/core_ctl/enable "1"
lock_value /sys/devices/system/cpu/cpu0/core_ctl/core_ctl_boost "1"
lock_value /sys/devices/system/cpu/cpu6/core_ctl/core_ctl_boost "1"
}
[[ -d /proc/sys/walt ]] && {
lock_value /proc/sys/walt/sched_lib_name "com.miHoYo., com.activision., com.epicgames, com.dts., UnityMain, libunity.so, libil2cpp.so, libmain.so, libcri_vip_unity.so, libopus.so, libxlua.so, libUE4.so, libAsphalt9.so, libnative-lib.so, libRiotGamesApi.so, libResources.so, libagame.so, libapp.so, libflutter.so, libMSDKCore.so, libFIFAMobileNeon.so, libUnreal.so, libEOSSDK.so, libcocos2dcpp.so"
lock_value /proc/sys/walt/sched_lib_mask_force "240"
}
[[ -d /sys/class/kgsl/kgsl-3d0/ ]] && {
lock_value /sys/class/kgsl/kgsl-3d0/force_bus_on "1"
lock_value /sys/class/kgsl/kgsl-3d0/force_clk_on "1"
lock_value /sys/class/kgsl/kgsl-3d0/force_no_nap "1"
lock_value /sys/class/kgsl/kgsl-3d0/force_rail_on "1"
}
[[ -d /sys/block/ ]] && {
lock_value /sys/block/sda/queue/read_ahead_kb "512"
lock_value /sys/block/sdb/queue/read_ahead_kb "512"
lock_value /sys/block/sdc/queue/read_ahead_kb "512"
lock_value /sys/block/sdd/queue/read_ahead_kb "512"
lock_value /sys/block/sde/queue/read_ahead_kb "512"
lock_value /sys/block/sdf/queue/read_ahead_kb "512"
lock_value /sys/block/sda/queue/nr_requests "256"
lock_value /sys/block/sdb/queue/nr_requests "256"
lock_value /sys/block/sdc/queue/nr_requests "256"
lock_value /sys/block/sdd/queue/nr_requests "256"
lock_value /sys/block/sde/queue/nr_requests "256"
lock_value /sys/block/sdf/queue/nr_requests "256"
}
resetprop -n droid.iowait_boost 1
resetprop -n droid.gpu_throttling 0
sync; sync; sync;
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🌸 制定模式 ] /g' "$MODPATH/module.prop"
fi
screen_status=$(dumpsys window | grep "mScreenOn" | grep false)
if [[ "$screen_status" ]]; then
echo "$date *📱关屏运行*" >>自动.log
su -c cmd shortcut reset-throttling
su -c cmd shortcut reset-all-throttling
su -c cmd power set-adaptive-power-saver-enabled true
su -c cmd power set-fixed-performance-mode-enabled false
su -c cmd power set-mode 1
su -c cmd thermalservice override-status 0
[[ -d /dev/cpuset/ ]] && {
lock_value /dev/cpuset/cpus "0-4"
lock_value /dev/cpuset/background/cpus "0-1"
lock_value /dev/cpuset/system-background/cpus "0-3"
lock_value /dev/cpuset/foreground/cpus "0-4"
lock_value /dev/cpuset/foreground/boost/cpus "0-4"
lock_value /dev/cpuset/top-app/cpus "0-4"
lock_value /dev/cpuset/restricted/cpus "0-3"
lock_value /dev/cpuset/camera-daemon/cpus "0-4"
}
[[ -d /sys/class/kgsl/kgsl-3d0/ ]] && {
lock_value /sys/class/kgsl/kgsl-3d0/force_bus_on "0"
lock_value /sys/class/kgsl/kgsl-3d0/force_clk_on "0"
lock_value /sys/class/kgsl/kgsl-3d0/force_no_nap "0"
lock_value /sys/class/kgsl/kgsl-3d0/force_rail_on "0"
}
[[ -d "/sys/devices/system/cpu/" ]] && {
lock_value /sys/devices/system/cpu/cpu2/online "0"
lock_value /sys/devices/system/cpu/cpu3/online "0"
lock_value /sys/devices/system/cpu/cpufreq/policy0/scaling_governor "powersave"
lock_value /sys/devices/system/cpu/cpufreq/policy7/scaling_governor "powersave"
}
[[ -d /sys/block/ ]] && {
lock_value /sys/block/sda/queue/read_ahead_kb "128"
lock_value /sys/block/sdb/queue/read_ahead_kb "128"
lock_value /sys/block/sdc/queue/read_ahead_kb "128"
lock_value /sys/block/sdd/queue/read_ahead_kb "128"
lock_value /sys/block/sde/queue/read_ahead_kb "128"
lock_value /sys/block/sdf/queue/read_ahead_kb "128"
lock_value /sys/block/sda/queue/nr_requests "64"
lock_value /sys/block/sdb/queue/nr_requests "64"
lock_value /sys/block/sdc/queue/nr_requests "64"
lock_value /sys/block/sdd/queue/nr_requests "64"
lock_value /sys/block/sde/queue/nr_requests "64"
lock_value /sys/block/sdf/queue/nr_requests "64"
}
resetprop -n droid.iowait_boost 0
resetprop -n droid.gpu_throttling 1
(rm -rf /data/data/*/cache;rm -rf /sdcard/Android/data/*/cache;pm  trim-caches 999G)>/dev/null 2>&1&
sync; sync; sync;
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🌸 关屏模式 ] /g' "$MODPATH/module.prop"
fi	  
local now=$(date +%s)
sleep $(( interval - now % interval ))
screen_status=$(dumpsys window | grep "mScreenOn" | grep true)
if [[ "$screen_status" ]]; then
echo "$date *📲亮屏运行*" >>自动.log
su -c cmd shortcut reset-throttling
su -c cmd shortcut reset-all-throttling
su -c cmd power set-adaptive-power-saver-enabled false
su -c cmd power set-fixed-performance-mode-enabled true
su -c cmd power set-mode 0
su -c cmd thermalservice override-status 0
[[ -d /dev/cpuset/ ]] && {
lock_value /dev/cpuset/cpus "0-6"
lock_value /dev/cpuset/background/cpus "0-1"
lock_value /dev/cpuset/system-background/cpus "0-3"
lock_value /dev/cpuset/foreground/cpus "0-2,5-6"
lock_value /dev/cpuset/foreground/boost/cpus "5-6"
lock_value /dev/cpuset/top-app/cpus "0-6"
lock_value /dev/cpuset/restricted/cpus "0-3"
lock_value /dev/cpuset/camera-daemon/cpus "0-6"
}
[[ -d "/sys/devices/system/cpu/" ]] && {
lock_value /sys/devices/system/cpu/cpu2/online "1"
lock_value /sys/devices/system/cpu/cpu3/online "1"
lock_value /sys/devices/system/cpu/cpu4/online "1"
lock_value /sys/devices/system/cpu/cpu5/online "1"
lock_value /sys/devices/system/cpu/cpu0/core_ctl/enable "0"
lock_value /sys/devices/system/cpu/cpu6/core_ctl/enable "0"
lock_value /sys/devices/system/cpu/cpu0/core_ctl/core_ctl_boost "0"
lock_value /sys/devices/system/cpu/cpu6/core_ctl/core_ctl_boost "0"
lock_value /sys/devices/system/cpu/cpufreq/policy0/scaling_governor "walt"
lock_value /sys/devices/system/cpu/cpufreq/policy7/scaling_governor "walt"
}
[[ -d /sys/class/kgsl/kgsl-3d0/ ]] && {
lock_value /sys/class/kgsl/kgsl-3d0/force_bus_on "1"
lock_value /sys/class/kgsl/kgsl-3d0/force_clk_on "1"
lock_value /sys/class/kgsl/kgsl-3d0/force_no_nap "1"
lock_value /sys/class/kgsl/kgsl-3d0/force_rail_on "1"
}
[[ -d /sys/block/ ]] && {
lock_value /sys/block/sda/queue/read_ahead_kb "512"
lock_value /sys/block/sdb/queue/read_ahead_kb "512"
lock_value /sys/block/sdc/queue/read_ahead_kb "512"
lock_value /sys/block/sdd/queue/read_ahead_kb "512"
lock_value /sys/block/sde/queue/read_ahead_kb "512"
lock_value /sys/block/sdf/queue/read_ahead_kb "512"
lock_value /sys/block/sda/queue/nr_requests "256"
lock_value /sys/block/sdb/queue/nr_requests "256"
lock_value /sys/block/sdc/queue/nr_requests "256"
lock_value /sys/block/sdd/queue/nr_requests "256"
lock_value /sys/block/sde/queue/nr_requests "256"
lock_value /sys/block/sdf/queue/nr_requests "256"
}
resetprop -n droid.iowait_boost 1
resetprop -n droid.gpu_throttling 0
sync; sync; sync;
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🌸 亮屏模式 ] /g' "$MODPATH/module.prop"
fi	
done

