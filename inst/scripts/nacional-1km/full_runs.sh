#!/bin/bash
ulimit -n 65536
ulimit -s unlimited

Rscript full_prioritization_runs.R