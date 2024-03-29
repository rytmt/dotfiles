#!/usr/bin/env python3

# usage: cat csvfile | cutcsv.py 1 3

import sys
import io
import csv

# 引数には取り出す対象の列の数値が指定される想定
args = sys.argv

try:
    # 標準入力を一行ずつ読み込む
    for line in sys.stdin:
        f = io.StringIO()
        f.write(line)
        f.seek(0)

        # 標準入力をcsv形式として扱い一行読み込む
        for row in csv.reader(f):
            # 引数の個数だけループする
            for i in range(len(args)-1):
                # ループの終わりの場合は末尾にカンマを付けない
                if i == len(args)-2:
                    separator = ''
                else:
                    separator = ','
                # 引数で指定された列の値をvalueに代入
                value=row[int(args[i+1])-1]
                # value にカンマが含まれる場合には、ダブルクォートを付与する
                if ',' in value:
                    print(f'"{value}"{separator}', end='')
                else:
                    print(f'{value}{separator}', end='')

            # 引数で指定された列の出力を終えたら改行する
            print(f'')
# | head コマンドなどで標準入力が閉じられてしまった場合
except BrokenPipeError as e:
    sys.exit(1)
