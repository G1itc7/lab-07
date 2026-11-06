#!/bin/bash

all_pass=1 #所有的case都没发现错误

for number in 1 2 3 4
do
    folder="Testcase${number}"
    result_folder="${folder}Diff"
    pass=1 #当前的case没有发现错误
    has_differences=0

    for first in "$folder"/*.1.txt
    do
        second="${first%.1.txt}.2.txt"
        file_name=$(basename "$first" .1.txt)
        result_file="$result_folder/${file_name}Diff.txt"

        if cmp -s "$first" "$second" #如果相同就进入then，检查result_file是否为空，如果不同就检查result_file是否为空
        then
            if [ -f "$result_file" ]
            then
                pass=0
            fi
        else
            has_differences=1

            if [ ! -f "$result_file" ]
            then
                pass=0

            else
                if ! cmp -s \
                <(diff -u "$first" "$second" | tail -n +3) \
                <(tail -n +3 "$result_file")
                then
                    pass=0
                fi
            fi
        fi
    done

    if [ "$has_differences" -eq 1 ] && [ ! -d "$result_folder" ]
    then
        pass=0
    fi

    if [ "$has_differences" -eq 0 ] && [ -d "$result_folder" ]
    then
        pass=0
    fi

    if [ "$pass" -eq 1 ]
    then
        echo "$folder: PASS"
    else
        echo "$folder: FAIL"
        all_pass=0
    fi
done

if [ "$all_pass" -eq 1 ]
then
    exit 0
else
    exit 1
fi
