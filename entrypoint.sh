#!/bin/sh
# entrypoint.sh — starts Honeytrap + forwarder in parallel

set -e

echo "==> Starting Honeytrap..."
/honeytrap/honeytrap --config /config/config.toml --data /data/ &
HONEYTRAP_PID=$!

echo "==> Waiting 3s for Honeytrap to initialise..."
sleep 3

echo "==> Starting forwarder → ${INGESTION_URL}"
python /forwarder.py &
FORWARDER_PID=$!

echo "==> Both processes running."
echo "    Honeytrap PID: $HONEYTRAP_PID"
echo "    Forwarder PID: $FORWARDER_PID"

# If either process dies, exit so Railway restarts the container
wait -n
echo "==> A process exited. Restarting container..."
exit 1
