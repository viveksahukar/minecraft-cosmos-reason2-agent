```markdown
# Minecraft Purple Agent with NVIDIA Cosmos Reason2 Integration

This repository contains a modified **MCU Purple Agent Baseline** for the  
**AgentX / AgentBeats Minecraft (MineStudio) environment**, enhanced with  
**NVIDIA Cosmos Reason2 visual reasoning**.

This project was developed for the **NVIDIA Cosmos Cookoff**.

---

# 🧠 What This Project Does

This agent integrates **Cosmos Reason2** into the Purple perception pipeline to enable structured visual reasoning before action selection.

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

---

# 📦 Repository Structure

```

minecraft-cosmos-reason2-agent/
│
├── purple_agent/          # Modified Purple agent (core implementation)
├── scripts/               # Helper run script
├── logs_example/          # Canonical reproduction commands
├── README.md
└── .gitignore

```

Within `purple_agent/`:

```

src/
├── agent/
├── perception/
│    ├── reason2_client.py
│    └── sanitizer_adapter.py
├── config/
│    └── reason2_config.py
├── protocol/
└── server/

````

---

# 🔍 Where Cosmos Reason2 Is Integrated

Key files:

- `purple_agent/src/perception/reason2_client.py`
- `purple_agent/src/perception/sanitizer_adapter.py`
- `purple_agent/src/config/reason2_config.py`

Reason2 is configured using:

```python
COSMOS_REPO = os.environ.get("COSMOS_REPO", "/path/to/cosmos-reason2")
````

The upstream NVIDIA `cosmos-reason2` repository is NOT bundled here and must be installed separately.

---

# ⚙️ Requirements

* Python ≥ 3.10 (3.11 recommended)
* Linux / WSL recommended
* CUDA GPU recommended (CPU works but slower)
* `uv` package manager
* Ollama (for local VLM evaluation backend)
* NVIDIA Cosmos Reason2 (installed separately)

---

# 🛠 Installation

## 1️⃣ Clone This Repository

```bash
git clone https://github.com/YOUR_USERNAME/minecraft-cosmos-reason2-agent.git
cd minecraft-cosmos-reason2-agent
```

## 2️⃣ Install Cosmos Reason2 (Required)

```bash
git clone https://github.com/NVIDIA/cosmos-reason2.git /path/to/cosmos-reason2
cd /path/to/cosmos-reason2
pip install -e .
```

Export the path:

```bash
export COSMOS_REPO=/path/to/cosmos-reason2
```

## 3️⃣ Install Purple Agent Dependencies

```bash
cd purple_agent
uv sync
```

---

# ▶️ Reproducing the Reported Run

All canonical commands are stored in:

```
logs_example/exact_command.txt
```

Below is the full reproduction flow.

---

## Step 1: Start Green Agent (Ollama Backend)

From inside `purple_agent/`:

```bash
VLM_EVAL_BACKEND=ollama \
VLM_EVAL_MODEL=qwen2.5vl:7b \
uv run python src/server.py --host 0.0.0.0 --port 9009
```

---

## Step 2: Run Purple Agent

In a second terminal:

```bash
cd purple_agent
python -m src.server.app --agent rocket1 2>&1 | tee /tmp/purple.log
```

---

## Step 3: Run Evaluation

```bash
cd purple_agent
uv run python test_evaluation.py test_scenario.toml
```

---

# 📊 Evaluation Results

Primary evaluation run:

* non_noop_rate: 1.000
* Stable total score across repeated runs: **30.5 / 40**
* Motion task `sim_score`: 0.0 (current limitation)

Reason2 integration produces non-trivial structured behavior compared to noop baseline.

---

# 🌐 A2A Protocol Compliance

This agent runs an A2A-compliant HTTP server with:

* Agent Card endpoint:
  `/.well-known/agent-card.json`
* `init` message handling
* `obs` message handling
* Evaluator-safe `action` responses

### Example `init`

```json
{
  "type": "init",
  "text": "build a house"
}
```

Response:

```json
{
  "type": "ack",
  "success": true,
  "message": "Initialization success with task: build a house"
}
```

### Example `obs`

```json
{
  "type": "obs",
  "step": 0,
  "obs": "<base64-encoded image>"
}
```

Response:

```json
{
  "type": "action",
  "buttons": [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  "camera": [0.0, 0.0]
}
```

Action contract:

* `buttons`: length 20 (0/1)
* `camera`: length 2 floats

---

# 🐳 Docker Support

A Dockerfile is included in `purple_agent/` for containerized deployment.

---

# 🧪 Reproducibility

See:

```
logs_example/
```

Contains:

* Canonical reproduction commands
* Example log references

This repository intentionally excludes:

* Model weights
* Virtual environments
* Upstream NVIDIA repository
* Hardcoded local paths

---

# 🔐 Notes

* Cosmos Reason2 must be installed separately.
* Performance depends on VLM backend quality.
* Motion tasks currently underperform (future improvement area).

---

# 🏆 NVIDIA Cosmos Cookoff Submission

This project demonstrates structured visual reasoning integration using
NVIDIA Cosmos Reason2 inside a multi-agent Minecraft evaluation environment.

It highlights:

* Perception → reasoning → action loop
* Structured JSON reasoning prior to policy execution
* A2A-compatible deployment

---

# 📄 License

MIT License

Note: NVIDIA Cosmos Reason2 is governed by its own license:
[https://github.com/NVIDIA/cosmos-reason2](https://github.com/NVIDIA/cosmos-reason2)

---

# 👤 Author

Vivek Sahukar
Arizona State University
vsahukar@asu.edu

```


