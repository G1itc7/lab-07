#!/bin/bash

for number in 1 2 3 4
do
    folder="Testcase${number}"
    result_folder="${folder}Diff"
    rm -rf "$result_folder"

    for first in "$folder"/*.1.txt #（*）wildcard可以用来匹配任何文件名的部分
    do
        second="${first%.1.txt}.2.txt" #用%删除之前得到文件的后缀然后加上.2.txt，因为我们不知道每次循环遇见的是哪个文件
        file_name=$(basename "$first" .1.txt) #basename用来提取文件名，也可以删除指定后缀，然后 $( 是指令替换意思是先运行括号内的然后作为这块的值
        result_file="$result_folder/${file_name}Diff.txt" #把之前获得的文件名拼接上Diff.txt后缀（见12行）

        if ! cmp -s "$first" "$second" #（如果不同就进入then）以静默模式（-s）（不打印比较结果，只根据退出状态比较）比较（cmp）两个文件是否相同。但是如果发生error 符号！也会成立
        then
            mkdir -p "$result_folder" #创建目录（make directory），（-p）为了防止重复创建同一个文件夹
            diff -u "$first" "$second" > "$result_file" #按照顺序比较文件文本使其像（-xxx +xxx）然后用（>）把输出写进目标文件
        fi
    done
done

exit 0
