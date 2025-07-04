#!/bin/bash

current_ip=""
max_disk=""
max_use=0
swap_line=""
mem_line=""
uptime_line=""


if [ $# -lt 1 ]; then
	echo "Please Provide the Input file to Read Data and Try Again"
	exit 1
fi

INPFILE=$1
if [ ! -f "$INPFILE" ]; then
	echo "Input File $INPFILE does'nt Exist Provide a valid file name"
	exit 1
fi

while IFS= read -r line; do
  # Capture IP at end of block
  if [[ $line =~ Connection\ to\ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\ closed ]]; then
     max_disk_usage=$(echo $max_disk|cut -d " " -f5,6) 
    swap_usage=$(echo $swap_line | cut -d " " -f3)
    mem_usage=$(echo $mem_line | cut -d " " -f3)
    echo "$max_disk_usage"
    echo "Mem: $mem_usage"
    echo "Swap: $swap_usage"
    echo $uptime_line
    echo "${BASH_REMATCH[1]}"
    echo "--"

    # Reset for next block
    current_ip=""
    max_disk=""
    max_use=0
    swap_line=""
    uptime_line=""
    mem_line=""
    continue
  fi

  # Capture highest disk usage line
  if [[ $line =~ [0-9]{1,3}%[[:space:]]+/ ]]; then
    USE=$(echo $line | cut -d " " -f5)
    DRV=$(echo $line | cut -d " " -f6)
    use=$(echo $USE | cut -d "%" -f1)
    if (( use > max_use )); then
      max_use=$use
      max_disk=$line
    fi
  fi

  # Capture Mem line
  if [[ $line == Mem:* ]]; then
    mem_line=$line
  fi 

  # Capture swap line
  if [[ $line == Swap:* ]]; then
    swap_line=$line
  fi
  # Capture uptime line (heuristic: has "up" and "load average")
  if [[ $line == *"load average"* ]]; then
    uptime_line=$line
  fi

done < $INPFILE

