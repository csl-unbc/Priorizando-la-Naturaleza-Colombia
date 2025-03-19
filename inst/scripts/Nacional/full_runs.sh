#!/bin/bash

ulimit -s unlimited
export CPL_TMPDIR=/data/tmp

Rscript full_prioritization_runs.Rscript