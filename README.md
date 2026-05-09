# Quad-tank Open-loop Optimizer

A Streamlit app for the quadruple-tank process: open-loop optimal control of
inlet flows driving tank levels to setpoints (Pyomo + ripopt NLP). The
in-app **Formulation** tab summarizes the equations and cites the source
papers — see [References](#references) below.

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
bundled in the wheel); `fly.toml` configures auto-stop machines. Custom domain wired through Cloudflare DNS.

- **Machine**: `shared-cpu-1x` · 1 GB RAM · single region (`ord`) · `min_machines_running=0` (auto-stops on idle).
- **Cost ceiling**: ~$3.89/mo if traffic kept the VM awake 24/7.[^fly-pricing] Realistic on idle-heavy demo traffic: well under $1/mo per app. Bandwidth is effectively free under Fly's 100 GB/mo egress allowance.

[^fly-pricing]: Fly.io pricing as of 2026-05; published rates may shift. See https://fly.io/docs/about/pricing/.

## Files

- `app.py` — Streamlit UI, Pyomo model, ripopt wrapper
- `Quad tank open loop.ipynb` — formulation in a notebook
- `requirements.txt`, `packages.txt` — Python and system deps
- `Dockerfile`, `fly.toml`, `.dockerignore` — Fly.io production image config
- `.github/workflows/deploy.yml` — auto-deploy pipeline

## References

[1] T. Raff, S. Huber, Z. K. Nagy, and F. Allgöwer, "Nonlinear Model
Predictive Control of a Four Tank System: An Experimental Stability
Study," in *Proc. 2006 IEEE Int. Conf. on Control Applications*, Munich,
Germany, 2006, pp. 237–242. doi:[10.1109/CCA.2006.285874](https://doi.org/10.1109/CCA.2006.285874)

[2] L. T. Biegler, *Nonlinear Programming: Concepts, Algorithms, and
Applications to Chemical Processes*. Philadelphia, PA: SIAM, 2010.
