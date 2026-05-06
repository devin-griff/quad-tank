# Streamlit + Pyomo + IPOPT on Python 3.12 slim.
# Quad tank is a nonlinear optimal control problem (4-state coupled dynamics),
# so it needs IPOPT (interior-point NLP solver), not GLPK.
#
# Strategy: Debian doesn't ship a usable ipopt binary. We grab the conda-forge
# build of ipopt via micromamba (a single ~5MB static binary), install just
# the ipopt package + its runtime libs into a self-contained prefix, then
# expose `ipopt` on PATH via a symlink. Pyomo finds it the standard way.
FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        glpk-utils \
        ca-certificates \
        wget \
        bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Fetch micromamba (single static binary, no install dependencies).
RUN wget -qO /tmp/mm.tar.bz2 https://micro.mamba.pm/api/micromamba/linux-64/latest \
    && tar -xjf /tmp/mm.tar.bz2 -C /tmp bin/micromamba \
    && mv /tmp/bin/micromamba /usr/local/bin/micromamba \
    && rm -rf /tmp/mm.tar.bz2 /tmp/bin

# Install ipopt + dependencies into /opt/ipopt-env using conda-forge.
# This is independent of the system Python; it's just a binary install.
RUN micromamba create -y -p /opt/ipopt-env -c conda-forge ipopt \
    && micromamba clean --all --yes \
    && ln -s /opt/ipopt-env/bin/ipopt /usr/local/bin/ipopt \
    && /usr/local/bin/ipopt --version || true

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py ./

EXPOSE 8080
CMD ["streamlit", "run", "app.py", \
     "--server.port=8080", \
     "--server.address=0.0.0.0", \
     "--server.headless=true", \
     "--browser.gatherUsageStats=false"]
