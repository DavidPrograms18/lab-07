#!/bin/bash

status=0

for n in 1 2 3 4; do
    dir="Testcase$n"
    out="${dir}Diff"
    ok=1
    anydiff=0

    for f1 in "$dir"/*.1.txt; do
        f2="${f1/.1.txt/.2.txt}"
        name=$(basename "$f1" .1.txt)
        file="$out/${name}Diff.txt"

        if ! diff -q "$f1" "$f2" > /dev/null; then
            anydiff=1
            if ! diff -q <(diff -u "$f1" "$f2") "$file" > /dev/null 2>&1; then
                echo "problem with $file" >&2
                ok=0
            fi
        elif [ -e "$file" ]; then
            echo "unexpected $file" >&2
            ok=0
        fi
    done
    
    if [ $anydiff -eq 1 ] && [ ! -d "$out" ]; then
        ok=0
    fi
    if [ $anydiff -eq 0 ] && [ -d "$out" ]; then
        ok=0
    fi

    if [ $ok -eq 1 ]; then
        echo "Testcase$n: PASS"
    else
        echo "Testcase$n: FAIL"
        status=1
    fi
done
exit $status