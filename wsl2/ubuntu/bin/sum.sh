#!/bin/sh

cat | awk '{sum+=$0} END {print sum}'
