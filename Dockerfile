# Streamlit + Pyomo + ripopt on Python 3.12 slim.
# Quad tank is a nonlinear optimal control problem (4-state coupled dynamics).
# We use ripopt — a Rust reimplementation of IPOPT — via the pyomo-ripopt
# wheel, which bundles the solver binary. No system solver install needed.
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py favicon.png ./

# Overwrite Streamlit's default static index.html: title, favicon, and
# inject Open Graph + Twitter Card meta tags so links to this app on
# *.griffith-pse.com unfurl as a rich card on LinkedIn / Slack / iMessage.
RUN STATIC=$(python -c "import streamlit, os; print(os.path.join(os.path.dirname(streamlit.__file__), 'static'))") \
    && sed -i 's|<title>Streamlit</title>|<title>Quad Tank Control</title>|' "$STATIC/index.html" \
    && sed -i 's|</head>|<link rel="icon" type="image/png" href="./favicon.png"/><meta property="og:type" content="website"/><meta property="og:title" content="Quad Tank Control"/><meta property="og:description" content="Open-loop optimal control of the four-tank benchmark via Pyomo + rIPOPT. Set initial heights, hit Solve, watch trajectories."/><meta property="og:image" content="https://griffith-pse.com/images/quad-tank.png"/><meta property="og:site_name" content="Griffith PSE"/><meta name="twitter:card" content="summary_large_image"/><meta name="twitter:title" content="Quad Tank Control"/><meta name="twitter:description" content="Open-loop optimal control of the four-tank benchmark via Pyomo + rIPOPT. Set initial heights, hit Solve, watch trajectories."/><meta name="twitter:image" content="https://griffith-pse.com/images/quad-tank.png"/></head>|' "$STATIC/index.html" \
    && cp /app/favicon.png "$STATIC/favicon.png" && cp /app/favicon.png "$STATIC/favicon.ico"

# Run as a non-root user. If a future Streamlit (or transitive dep) RCE
# lands in the container, the attacker doesn't get root. Defense in depth.
RUN useradd -m -u 1000 streamlit && chown -R streamlit:streamlit /app
USER streamlit

EXPOSE 8080
CMD ["streamlit", "run", "app.py", \
     "--server.port=8080", \
     "--server.address=0.0.0.0", \
     "--server.headless=true", \
     "--browser.gatherUsageStats=false"]
