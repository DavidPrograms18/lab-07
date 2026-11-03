#!/bin/bash
for dir in Testcase[0-9]*; do
    [[ "$dir" == *Diff ]] && continue
    rm -rf "${dir}Diff"

    for f1 in "$dir"/*.1.txt; do
        f2="${f1%.1.txt}.2.txt"
        name=$(basename "${f1%.1.txt}")

        if ! diff -q "$f1" "$f2" > /dev/null; then
            mkdir -p "${dir}Diff"
            diff -u "$f1" "$f2" > "${dir}Diff/${name}Diff.txt"
        fi
    done
done