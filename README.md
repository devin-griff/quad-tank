# Quad-tank Open-loop Optimizer

A Streamlit app for the quadruple-tank process: open-loop optimal control of
inlet flows driving tank levels to setpoints (Pyomo + ripopt NLP).

**Live demo:** https://quadtank.griffith-pse.com  
**Home:** https://griffith-pse.com

## Run locally

    pip install -r requirements.txt
    streamlit run app.py

The solver is **ripopt** — a Rust reimplementation of IPOPT, distributed via
the [`pyomo-ripopt`](https://pypi.org/project/pyomo-ripopt/) wheel, which
bundles the solver binary. No separate solver install needed; `pip install`
takes care of everything.

## Deployment

Auto-deploys to Fly.io on every push to `main` via
`.github/workflows/deploy.yml`. The `Dockerfile` builds a Python 3.12 image
and installs the app's Python dependencies (including the ripopt binary
bundled in the wheel); `fly.toml` configures auto-stop machines (idle =
$0/mo). Custom domain wired through Cloudflare DNS.

## Files

- `app.py` — Streamlit UI, Pyomo model, ripopt wrapper
- `Quad tank open loop.ipynb` — formulation in a notebook
- `requirements.txt`, `packages.txt` — Python and system deps
- `Dockerfile`, `fly.toml`, `.dockerignore` — Fly.io production image config
- `.github/workflows/deploy.yml` — auto-deploy pipeline
