# Quad-tank Open-loop Optimizer

A Streamlit app for the quadruple-tank process: open-loop optimal control of
inlet flows driving tank levels to setpoints (Pyomo + IPOPT NLP).

**Live demo:** https://quadtank.griffith-pse.com  
**Home:** https://griffith-pse.com

## Run locally

    pip install -r requirements.txt
    streamlit run app.py

IPOPT must be on PATH. Easiest cross-platform install is via conda-forge:

    conda install -c conda-forge ipopt

(The Fly.io image installs IPOPT via micromamba — see the Dockerfile.)

## Deployment

Auto-deploys to Fly.io on every push to `main` via
`.github/workflows/deploy.yml`. The `Dockerfile` builds a Python 3.12 image
and pulls IPOPT from conda-forge into a self-contained prefix; `fly.toml`
configures auto-stop machines (idle = $0/mo). Custom domain wired through
Cloudflare DNS.

## Files

- `app.py` — Streamlit UI, Pyomo model, IPOPT wrapper
- `Quad tank open loop.ipynb` — formulation in a notebook
- `requirements.txt`, `packages.txt` — Python and system deps
- `Dockerfile`, `fly.toml`, `.dockerignore` — Fly.io production image config
- `.github/workflows/deploy.yml` — auto-deploy pipeline
