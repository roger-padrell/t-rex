#!/bin/bash
set -euo pipefail
cobc -x -std=ibm cli.cob trex_*.cob
./cli