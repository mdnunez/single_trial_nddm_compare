#!/bin/bash
set -e

# If the container is given explicit arguments, run those instead of the default pipeline
# (e.g. `docker run <image> scripts/integrative_ddm_analyze.py`).
if [ "$#" -gt 0 ]; then
    exec uv run "$@"
fi

uv run scripts/integrative_ddm_train.py
uv run scripts/integrative_ddm_generate_factorial_new_sigma.py
uv run scripts/integrative_ddm_data_check.py
uv run scripts/integrative_ddm_analyze_results_factorial.py
