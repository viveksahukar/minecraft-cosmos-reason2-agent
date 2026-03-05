
# Minecraft Purple Agent with NVIDIA Cosmos Reason2 Integration

This repository contains a modified **MCU Purple Agent Baseline** for the **AgentX / AgentBeats Minecraft (MineStudio) Phase 2 environment**, enhanced with **NVIDIA Cosmos Reason2 visual reasoning**.

This project was developed for the **NVIDIA Cosmos Cookoff**.

---

## 🧠 What This Project Does

AgentX–AgentBeats is a multi-agent Minecraft evaluation platform.

* **Green agent**: Evaluates and scores behavior.
* **Purple agent**: The acting policy that observes Minecraft and outputs actions.

This project integrates **Cosmos Reason2** into the Purple agent's perception pipeline to enable structured visual reasoning before action selection.

**The Pipeline:**
`Minecraft Frame` → `Cosmos Reason2` → `Structured JSON (Objects / Mobs / Threats / Resources)` → `Sanitization` → `Purple Policy (Rocket1 / VPT / etc.)` → `Action` → `Green Evaluator`

Unlike a no-op baseline, this agent produces structured world interpretations prior to selecting actions.

---

## 🚀 Features

* A2A-compliant Purple Agent server
* Cosmos Reason2 integration into perception
* Structured JSON extraction and sanitization
* Compatible with MCU evaluator
* Compatible with AgentBeats Green agent
* Ollama-based free VLM evaluation backend
* Reproducible run commands
* Baseline vs Reason2 comparison included

---

## 📦 Repository Structure

```text
minecraft-cosmos-reason2-agent/
│
├── purple_agent/          # Modified Purple agent (core implementation)
├── scripts/               # Helper run script
├── logs_example/          # Canonical reproduction commands
├── README.md
└── .gitignore

```

**Within `purple_agent/src/`:**

```text
├── agent/
├── perception/
│   ├── reason2_client.py
│   ├── reason2_worker.py
│   └── sanitizer_adapter.py
├── config/
│   └── reason2_config.py
├── protocol/
└── server/

```

---

## 🔍 Where Cosmos Reason2 Is Integrated

Key files for the integration:

* `purple_agent/src/perception/reason2_client.py`
* `purple_agent/src/perception/reason2_worker.py`
* `purple_agent/src/perception/sanitizer_adapter.py`
* `purple_agent/src/config/reason2_config.py`

Reason2 is configured via environment variables:

```python
COSMOS_REPO = os.environ.get("COSMOS_REPO", "/path/to/cosmos-reason2")

```

*Note: The upstream NVIDIA cosmos-reason2 repository is NOT bundled here and must be installed separately.*

---

## ⚙️ Requirements

* **Python**: ≥ 3.10 (3.11 recommended)
* **OS**: Linux / WSL recommended
* **Hardware**: CUDA GPU recommended (CPU supported but slower)
* **Tools**: `uv` package manager, Ollama (for local VLM evaluation)
* **Model**: NVIDIA Cosmos Reason2

---

## 🛠 Installation

### 1. Clone This Repository

```bash
git clone [https://github.com/viveksahukar/minecraft-cosmos-reason2-agent.git](https://github.com/viveksahukar/minecraft-cosmos-reason2-agent.git)
cd minecraft-cosmos-reason2-agent

```

### 2. Install Cosmos Reason2 (Required)

```bash
git clone [https://github.com/NVIDIA/cosmos-reason2.git](https://github.com/NVIDIA/cosmos-reason2.git) /path/to/cosmos-reason2
cd /path/to/cosmos-reason2
pip install -e .
export COSMOS_REPO=/path/to/cosmos-reason2

```

### 3. Install Purple Agent Dependencies

```bash
cd purple_agent
uv sync

```

---

## ▶️ Running the System

### Step 1: Start Green Agent (Evaluation Server)

From inside `purple_agent/`:

```bash
VLM_EVAL_BACKEND=ollama \
VLM_EVAL_MODEL=qwen2.5vl:7b \
uv run python src/server.py --host 0.0.0.0 --port 9009

```

### Step 2: Run Purple Agent

```bash
cd purple_agent
python -m src.server.app --agent rocket1

```

### Step 3: Run Evaluation

```bash
cd purple_agent
uv run python test_evaluation.py test_scenario.toml

```

---

## 📊 Evaluation Results (Motion Category)

| Metric | 🔵 With Cosmos Reason2 | 🟣 Baseline (No Reason2) |
| --- | --- | --- |
| **Total Score** | **29.00 / 40.0** | **30.50 / 40.0** |
| Action Control | 9.25 | 9.25 |
| Error Recognition/Correction | 2.5 | 6.75 |
| Task Completion Efficiency | 9.0 | 9.0 |
| Material Selection/Usage | 6.75 | 6.75 |

### 🔬 Key Insight

Motion tasks are primarily low-level control tasks. Adding high-level semantic reasoning does not significantly improve motion performance and may introduce abstraction latency that affects error recognition metrics. Structured reasoning is likely more beneficial for:

* Crafting & Survival tasks
* Multi-step planning
* Long-horizon objectives

---

## 🌐 A2A Protocol Compliance

This agent runs an A2A-compliant HTTP server featuring:

* Agent Card endpoint: `/.well-known/agent-card.json`
* `init` and `obs` message handling
* Evaluator-safe action responses

---

## 🧪 Reproducibility

See `logs_example/` for:

* Canonical reproduction commands
* Example log references

*This repository excludes model weights, virtual environments, and hardcoded local paths.*

---

## 🙏 Acknowledgements

This work builds upon:

* **Green Agent**: [MCU-AgentBeats](https://github.com/KWSMooBang/MCU-AgentBeats)
* **Purple Agent Baseline**: [MCU-Purple-Baseline](https://github.com/KWSMooBang/MCU-Purple-Baseline-Deterministic)

---

## 🏆 NVIDIA Cosmos Cookoff Submission

This project demonstrates structured visual reasoning integration using **NVIDIA Cosmos Reason2** inside a multi-agent Minecraft evaluation framework.

## 📄 License

MIT License. NVIDIA Cosmos Reason2 is governed by its own [license](https://github.com/NVIDIA/cosmos-reason2).

## 👤 Author

**Vivek Sahukar** Arizona State University

vsahukar@asu.edu

