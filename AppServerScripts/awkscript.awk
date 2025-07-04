#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Input FileName Required as Argument"
    exit 1
fi

filename="$1"
if [ ! -e "$filename" ]; then
    echo "File '$filename' does not exist."
    exit 1
fi

count=0
awk -v filename="$filename" '
BEGIN {
    call_index = 0
}
{
    if ($0 == "--") {
        # Extract timestamp and unique ID from the first and last lines
        split(call_lines[0], a, "]")
        split(a[1], b, "[")
        time1 = b[2]

        last_line = call_lines[call_index - 1]
        split(last_line, c, "]")
        split(c[1], d, "[")
        time2 = d[2]

        split(last_line, parts, ":")
        split(parts[5], subparts, " ")
        uniqueid = subparts[4]

        printf "%s|%s|%s\n", time1, time2, uniqueid

        delete call_lines
        call_index = 0
    } else {
        call_lines[call_index++] = $0
    }
}
' "$filename" | while IFS="|" read -r time1 time2 uniqueid; do
    epoch1=$(date -d "$time1" +%s)
    epoch2=$(date -d "$time2" +%s)
    diff=$((epoch2 - epoch1))
    count=$((count + 1))
    if [ "$diff" -gt 1 ]; then
        echo "$count Time stamp: $time1 Time difference for Uniqueid : $uniqueid is $diff Seconds"
    fi
done
