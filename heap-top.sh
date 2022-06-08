#!/bin/bash
#
#    Script Name: heap-top.sh
#          Usage: ./heap-top.sh
#     Written By: Shimon Bitton , June-2022
#    Description: Print the list of JVM currently running and order them by Heap Memory size (Descending) 
#                 Finding the current Heap size is not straight forward, it has to be calculated
#
#  Prerequisites:
#    - OpenJDK
#    - Ubuntu 18.04 and above
#

JPROCS=$(jps | grep -v "Jps" )       # List all Java processes and ignore JPS process itself (invert match)

str1=""
str2=""

while IFS= read -r line ;
 do
       PID=$(echo $line | awk '{print $1}')
       APP=$(echo $line | awk '{print $2}')
       HEAP=$(jstat -gc $PID | tail -n 1 | awk '{s+=$3+$4+$6+$8} END {print s/1024}')
       str1=("${PID} ${APP} ${HEAP} \n")
       str2+=$str1

done <<< "$JPROCS"


(printf "Pid:   JVM.Name:   Cur.Heap.Size(Mb): \n" ; \
        echo -e $str2 | sort -n -r -k3) | column -t

