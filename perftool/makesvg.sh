#!/bin/sh

perf_file=$1

if [ "x" = "x${perf_file}" ]; then
        echo "perf_file is null"
        exit -1
fi

if [ ! -f ${perf_file} ]; then
        echo "no file ${perf_file}"
        exit -2
fi


perf script -i ${perf_file} &> perf.unfold.tmp #使用 perf script 工具对 perf.data 进行解析
~/FlameGraph/stackcollapse-perf.pl perf.unfold.tmp &> perf.foled.tmp #使用 Flame Graph 工具将 perf.unfold 中的符号折叠 //生成脚本文件
~/FlameGraph/flamegraph.pl perf.foled.tmp &> ${perf_file}.svg  #生成火焰图
rm perf.foled.tmp
rm perf.unfold.tmp