# Web VPython end user docs

RST sources are in `vpdocs/`. Built HTML is generated locally and deployed to GCS — it is not committed to this repo.

## Setup

```bash
python -m venv .venv
.venv/bin/pip install -r requirements.txt
```

## Build and serve locally

```bash
bash build-docs.sh        # builds to docs/VPythonDocs/
bash serve.sh             # serves on http://localhost:8070/docs/VPythonDocs/
```

## Deploy to GCS

```bash
bash do_build.sh          # builds and syncs to gs://glow-docs/VPythonDocs
```

