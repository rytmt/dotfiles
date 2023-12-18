#!/bin/sh

cat | awk '{sum+=$0} END {OFMT="%.6f"; print sum/NR}'
