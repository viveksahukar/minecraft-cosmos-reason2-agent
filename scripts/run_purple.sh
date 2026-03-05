#!/usr/bin/env bash
set -euo pipefail

# ---- CONFIG (edit if needed) ----
# point this to your local checkout of NVIDIA's cosmos-reason2 (documented in README)
export COSMOS_REPO="${COSMOS_REPO:-/path/to/cosmos-reason2}"
echo "Using COSMOS_REPO=$COSMOS_REPO"

# Ollama / VLM settings used in your reported runs
export VLM_EVAL_BACKEND="${VLM_EVAL_BACKEND:-ollama}"
export VLM_EVAL_MODEL="${VLM_EVAL_MODEL:-qwen2.5vl:7b}"
export OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"

# ---- Start green agent (VLM server) ----
# If you want to run the green VLM server locally (free-model eval), uncomment the following block.
# It runs as a foreground job — open a separate terminal if you prefer to run it manually.
# echo "Starting green (VLM) server using Ollama..."
# VLM_EVAL_BACKEND=${VLM_EVAL_BACKEND} VLM_EVAL_MODEL=${VLM_EVAL_MODEL} uv run python src/server.py --host 0.0.0.0 --port 9009 &

# ---- Run purple agent ----
echo "Running purple agent (rocket1) — logging to logs_example/purple_run.log"
cd "$(dirname "$0")/../purple_agent"
# Use the exact purple command you used for reporting
python -m src.server.app --agent rocket1 2>&1 | tee ../logs_example/purple_run.log

# ---- Run end-to-end evaluation (example) ----
# (run this from repo root or adjust path)
# echo "Running evaluation (smoke test) — logging to logs_example/eval_run.log"
# cd "$(dirname "$0")/../purple_agent"
# uv run python test_evaluation.py test_scenario.toml 2>&1 | tee ../logs_example/eval_run.log

echo "Done. See logs_example/ for outputs."
