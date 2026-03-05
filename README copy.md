# Minecraft Purple Agent with NVIDIA Cosmos Reason2 Integration

This repository contains a modified **MCU Purple Agent Baseline** for the  
**AgentX / AgentBeats Minecraft (MineStudio) Phase 2 environment**, enhanced with  
**NVIDIA Cosmos Reason2 visual reasoning**.

This project was developed for the **NVIDIA Cosmos Cookoff**.

---

# 🧠 What This Project Does

AgentX–AgentBeats is a multi-agent Minecraft evaluation platform.

- The **Green agent** evaluates and scores behavior.
- The **Purple agent** is the acting policy that observes Minecraft and outputs actions.

This project integrates **Cosmos Reason2** into the Purple agent's perception pipeline to enable structured visual reasoning before action selection.

Pipeline:

Minecraft Frame  
→ Cosmos Reason2  
→ Structured JSON (Objects / Mobs / Threats / Resources)  
→ Sanitization  
→ Purple Policy (Rocket1 / VPT / etc.)  
→ Action → Green Evaluator  

Unlike a noop baseline, this agent produces structured world interpretations prior to selecting actions.

---

# 🚀 Features

- A2A-compliant Purple Agent server
- Cosmos Reason2 integration into perception
- Structured JSON extraction + sanitization
- Compatible with MCU evaluator
- Compatible with AgentBeats Green agent
- Ollama-based free VLM evaluation backend
- Reproducible run scripts and canonical commands
- Baseline vs Reason2 comparison included

---

# 📦 Repository Structure

minecraft-cosmos-reason2-agent/
│
├── purple_agent/          # Modified Purple agent (core implementation)
├── scripts/               # Helper run script
├── logs_example/          # Canonical reproduction commands
├── README.md
└── .gitignore

Within `purple_agent/`:

src/
├── agent/
├── perception/
│    ├── reason2_client.py
│    ├── reason2_worker.py
│    └── sanitizer_adapter.py
├── config/
│    └── reason2_config.py
├── protocol/
└── server/

---

# 🔍 Where Cosmos Reason2 Is Integrated

Key files:

- `purple_agent/src/perception/reason2_client.py`
- `purple_agent/src/perception/reason2_worker.py`
- `purple_agent/src/perception/sanitizer_adapter.py`
- `purple_agent/src/config/reason2_config.py`

Reason2 is configured using:

```python
COSMOS_REPO = os.environ.get("COSMOS_REPO", "/path/to/cosmos-reason2")

The upstream NVIDIA cosmos-reason2 repository is NOT bundled here and must be installed separately.

⸻

⚙️ Requirements
	•	Python ≥ 3.10 (3.11 recommended)
	•	Linux / WSL recommended
	•	CUDA GPU recommended (CPU works but slower)
	•	uv package manager
	•	Ollama (for local VLM evaluation backend)
	•	NVIDIA Cosmos Reason2 (installed separately)

⸻

# 🛠 Installation

1️⃣ Clone This Repository

git clone https://github.com/viveksahukar/minecraft-cosmos-reason2-agent.git
cd minecraft-cosmos-reason2-agent

2️⃣ Install Cosmos Reason2 (Required)

git clone https://github.com/NVIDIA/cosmos-reason2.git /path/to/cosmos-reason2
cd /path/to/cosmos-reason2
pip install -e .

Export the path:

export COSMOS_REPO=/path/to/cosmos-reason2

3️⃣ Install Purple Agent Dependencies

cd purple_agent
uv sync


⸻

# ▶️ Reproducing the Reported Run

Step 1: Start Green Agent (Evaluation Server)

From inside purple_agent/:

VLM_EVAL_BACKEND=ollama \
VLM_EVAL_MODEL=qwen2.5vl:7b \
uv run python src/server.py --host 0.0.0.0 --port 9009

Step 2: Run Purple Agent

cd purple_agent
python -m src.server.app --agent rocket1

Step 3: Run Evaluation

cd purple_agent
uv run python test_evaluation.py test_scenario.toml


⸻

# 📊 Evaluation Results (Motion Category)

🔵 With Cosmos Reason2 Integrated

Total Score: 29.00 / 40.0
Action Control: 9.25
Error Recognition and Correction: 2.5
Task Completion Efficiency: 9.0
Material Selection and Usage: 6.75

🟣 Baseline Purple Agent (Without Reason2)

Total Score: 30.50 / 40.0
Action Control: 9.25
Error Recognition and Correction: 6.75
Task Completion Efficiency: 9.0
Material Selection and Usage: 6.75


⸻

# 🔬 Key Insight

Motion tasks are primarily low-level control tasks.

Adding high-level semantic reasoning does not significantly improve motion performance and may introduce abstraction or latency that affects error recognition metrics.

This suggests that structured reasoning is likely more beneficial for:
	•	Crafting tasks
	•	Survival tasks
	•	Multi-step planning
	•	Long-horizon objectives

Future work will evaluate these higher-level task categories.

⸻

# 🌐 A2A Protocol Compliance

This agent runs an A2A-compliant HTTP server with:
	•	Agent Card endpoint:
/.well-known/agent-card.json
	•	init message handling
	•	obs message handling
	•	Evaluator-safe action responses

⸻

# 🐳 Docker Support

A Dockerfile is included in purple_agent/ for containerized deployment.

⸻

# 🧪 Reproducibility

See:

logs_example/

Contains:
	•	Canonical reproduction commands
	•	Example log references

This repository intentionally excludes:
	•	Model weights
	•	Virtual environments
	•	Upstream NVIDIA repository
	•	Hardcoded local paths

⸻

# 🙏 Acknowledgements

This work builds upon the following open-source repositories:

Green Agent (Evaluation Server)

https://github.com/KWSMooBang/MCU-AgentBeats

Purple Agent Baseline

https://github.com/KWSMooBang/MCU-Purple-Baseline-Deterministic

We thank the original authors for providing the baseline infrastructure.

⸻

# 🏆 NVIDIA Cosmos Cookoff Submission

This project demonstrates structured visual reasoning integration using
NVIDIA Cosmos Reason2 inside a multi-agent Minecraft evaluation framework.

It highlights:
	•	Perception → reasoning → action loop
	•	Structured JSON reasoning prior to policy execution
	•	Task-dependent reasoning impact
	•	Clean A2A-compatible deployment

⸻

# 📄 License

MIT License

Note: NVIDIA Cosmos Reason2 is governed by its own license:
https://github.com/NVIDIA/cosmos-reason2

⸻

# 👤 Author

Vivek Sahukar
Arizona State University
vsahukar@asu.edu
