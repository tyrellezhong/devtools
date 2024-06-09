#!/bin/sh

echo 'process_id=$1 time=$2 fre=$3'
process_id=$1  # 进程id
time=$2   # 采样持续时间
fre=$3  # 采样频率

if [ "x" = "x${process_id}" ];then
        echo "no process_id"
        exit -1
fi

if [ ! -f /proc/${process_id}/status ]; then
        echo "pid ${process_id} no exist"
        exit -2
fi

if [ "x" = "x${fre}" ]; then
        fre=59
fi

if [ "x" = "x${time}" ]; then
        time=60
fi

output_dir="perflog"
mkdir -p ./${output_dir}

date_str=`date "+%Y%m%d-%H%M%S"`
perf_file=pid${process_id}-${date_str}.perf

echo "record to file:${output_dir}/${perf_file}"

#开始采样
perf record -F ${fre} -p ${process_id} -o ./${output_dir}/${perf_file} -m 2 -g -- sleep ${time}

#生成火焰图
if [ -f ./${output_dir}/${perf_file} ]; then
        echo "change to svg......"
        sh makesvg.sh ./${output_dir}/${perf_file}
fi

echo "succ"