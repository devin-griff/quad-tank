# Streamlit + Pyomo + ripopt on Python 3.12 slim.
# Quad tank is a nonlinear optimal control problem (4-state coupled dynamics).
# We use ripopt — a Rust reimplementation of IPOPT — via the pyomo-ripopt
# wheel, which bundles the solver binary. No system solver install needed.
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py favicon.png ./

EXPOSE 8080
CMD ["streamlit", "run", "app.py", \
     "--server.port=8080", \
     "--server.address=0.0.0.0", \
     "--server.headless=true", \
     "--browser.gatherUsageStats=false"]
