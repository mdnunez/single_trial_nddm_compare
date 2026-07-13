# CPU-only image for running the integrative DDM training/analysis scripts.
# Base image bundles uv + the exact Python version pinned in pyproject.toml.
FROM ghcr.io/astral-sh/uv:python3.11-trixie-slim

WORKDIR /app

# Keep uv from writing into a cache dir that busts Docker layer caching,
# and make it copy packages into the venv instead of hardlinking (safer across layers).
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PATH="/app/.venv/bin:$PATH"

# Install dependencies first (separate layer so code-only changes don't reinstall packages).
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-install-project

# Now copy the rest of the repository and install the project itself.
COPY . .
RUN uv sync --locked
RUN chmod +x entrypoint.sh

# By default, runs the training + analysis scripts in sequence:
#   integrative_ddm_train.py -> integrative_ddm_generate_factorial_new_sigma.py
#   -> integrative_ddm_data_check.py -> integrative_ddm_analyze_results_factorial.py
# Pass a different script path as an argument to run just that one instead.
ENTRYPOINT ["./entrypoint.sh"]
