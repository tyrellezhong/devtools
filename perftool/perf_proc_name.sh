#!/bin/sh

process_name=$1
time=$2
dt=$3

if [ "x" = "x${process_name}" ];then
        echo "no process_name arg"
        exit -1
fi

process_info=`pidof ${process_name}`
process_id=`echo ${process_info} | awk -F' ' '{print $1}' | xargs echo -n`

echo "process_name: ${process_name}"
echo "process_id: ${process_id} [${process_info}]"

if [ "x" = "x${process_id}" ];then
        echo "process_name:${process_name} no exist"
        exit -2
fi

if [ "x" = "x${dt}" ]; then
        dt=59
fi

if [ "x" = "x${time}" ]; then
        time=60
fi

output_dir="perflog"
mkdir -p ./${output_dir}

date_str=`date "+%Y%m%d-%H%M%S"`
perf_file=${process_name}-${process_id}-${date_str}.perf

echo "record to file:${output_dir}/${perf_file}"

perf record -F ${dt} -p ${process_id} -o ./${output_dir}/${perf_file} -m 2 -g -- sleep ${time}

if [ -f ./${output_dir}/${perf_file} ]; then
        echo "change to svg......"
        sh makesvg.sh ./${output_dir}/${perf_file}
fi

echo "succ"