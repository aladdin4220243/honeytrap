# ── Honeytrap config for Railway deployment ────────────────────────────────────
# Events are written to /logs/events.jsonl
# The forwarder.py script tails this file and POSTs to Ingestion API

[honeytrap]
sensor_name = "honeytrap-railway"

# ── Listeners ──────────────────────────────────────────────────────────────────
[listener.socket]
type = "socket"

# ── Services ───────────────────────────────────────────────────────────────────
[service.ssh]
type       = "ssh"
port       = "tcp/8022"

[service.http]
type       = "http"
port       = "tcp/8080"

[service.vnc]
type       = "vnc"
port       = "tcp/5900"

# ── Pushers ────────────────────────────────────────────────────────────────────
# Write all events as JSON lines to a file
# forwarder.py tails this file and sends to Ingestion

[pusher.file]
type = "file"
filename = "/logs/events.jsonl"
