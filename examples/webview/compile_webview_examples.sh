#!/bin/bash
for d in ./*/*.v ; do
    echo $ v $1 "$d" -o "$d.out"
    v $1 "$d" -o "$d.out"
done
