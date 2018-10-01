#!/bin/bash

###################################################################
#Description    : Stupid and ugly script to monitor memory consumption by a group of processes, and kill them if they are too big.
#Args           : process name                                                                                             
#Author         : Krzysztof Mendalka                                                
###################################################################

LANG=C
LC_ALL=C
process_name="${1:?Give me process name.}"
process=`echo ${process_name} | sed 's/^.\|[a-z][A-Z] /\[&]/g'`
tmp_output=`ps aux | grep "$process" | grep -v $0`
if [ -z "$tmp_output" ]
then
    echo "CRITICAL - Process ${process_name} is not running!"
    exit $ST_CR
fi


ps_fmem=`echo ${tmp_output} | awk '{print $4}' `
ps_mem=`printf "%.0f" "${ps_fmem}"`

if [ "$ps_mem" -gt 90 ] ; then date; echo "Memory problem for $process_name , now is  ${ps_mem}%. Restart." ; /etc/init.d/ais.run restart; echo; fi;
