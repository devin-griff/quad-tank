# Quad-tank Open-loop Optimizer

A Streamlit app for the quadruple-tank process: open-loop optimal control of
inlet flows driving tank levels to setpoints (Pyomo + IPOPT NLP).

## Run locally

    pip install -r requirements.txt
    streamlit run app.py

IPOPT must be on PATH. On Streamlit Cloud, packages.txt handles the system deps.

## Files

- `app.py` — Streamlit UI, Pyomo model, IPOPT wrapper
- `Quad tank open loop.ipynb` — formulation in a notebook
- `requirements.txt`, `packages.txt` — Python deps and system packages
