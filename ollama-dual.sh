#!/bin/bash
CHAT_HOST="127.0.0.1:11434"
AUTOCOMPLETE_HOST="127.0.0.1:11435"
CHAT_MODEL="minimax-m2.5:cloud"
AUTOCOMPLETE_MODEL="qwen3.5:4b"
LOG_DIR="$HOME/.ollama/logs"
mkdir -p "$LOG_DIR"

start() {
  echo "Starting Ollama instances..."
  if curl -s "http://$CHAT_HOST/api/tags" > /dev/null 2>&1; then
    echo "  [chat] Already running on $CHAT_HOST"
  else
    OLLAMA_HOST=$CHAT_HOST ollama serve > "$LOG_DIR/chat.log" 2>&1 &
    echo "  [chat] Started on $CHAT_HOST (log: $LOG_DIR/chat.log)"
  fi

  if curl -s "http://$AUTOCOMPLETE_HOST/api/tags" > /dev/null 2>&1; then
    echo "  [autocomplete] Already running on $AUTOCOMPLETE_HOST"
  else
    OLLAMA_HOST=$AUTOCOMPLETE_HOST ollama serve > "$LOG_DIR/autocomplete.log" 2>&1 &
    echo "  [autocomplete] Started on $AUTOCOMPLETE_HOST (log: $LOG_DIR/autocomplete.log)"
  fi

  echo "Waiting for servers to be ready..."
  sleep 3

  echo "Pulling models if needed..."
  pull

  echo "Preloading models into memory..."
  curl -s -X POST "http://$CHAT_HOST/api/generate" \
    -d "{\"model\": \"$CHAT_MODEL\", \"keep_alive\": -1}" > /dev/null &
  curl -s -X POST "http://$AUTOCOMPLETE_HOST/api/generate" \
    -d "{\"model\": \"$AUTOCOMPLETE_MODEL\", \"keep_alive\": -1}" > /dev/null &

  status
}

stop() {
  echo "Stopping Ollama instances..."
  pkill -f "ollama serve" && echo "  Stopped all instances." || echo "  No instances running."
}

status() {
  echo "--- Ollama Status ---"
  if curl -s "http://$CHAT_HOST/api/tags" > /dev/null 2>&1; then
    echo "  [chat]         ✓ running on $CHAT_HOST"
  else
    echo "  [chat]         ✗ not running"
  fi
  if curl -s "http://$AUTOCOMPLETE_HOST/api/tags" > /dev/null 2>&1; then
    echo "  [autocomplete] ✓ running on $AUTOCOMPLETE_HOST"
  else
    echo "  [autocomplete] ✗ not running"
  fi
}

models() {
  echo "--- Loaded Models ---"

  if curl -s "http://$CHAT_HOST/api/tags" > /dev/null 2>&1; then
    echo "  [chat] $CHAT_HOST:"
    RESPONSE=$(curl -s "http://$CHAT_HOST/api/ps")
    MODELS=$(echo "$RESPONSE" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    if [ -z "$MODELS" ]; then
      echo "    (no models currently loaded)"
    else
      echo "$MODELS" | while read -r model; do
        echo "    • $model"
      done
    fi
  else
    echo "  [chat]         ✗ not running"
  fi

  echo ""

  if curl -s "http://$AUTOCOMPLETE_HOST/api/tags" > /dev/null 2>&1; then
    echo "  [autocomplete] $AUTOCOMPLETE_HOST:"
    RESPONSE=$(curl -s "http://$AUTOCOMPLETE_HOST/api/ps")
    MODELS=$(echo "$RESPONSE" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    if [ -z "$MODELS" ]; then
      echo "    (no models currently loaded)"
    else
      echo "$MODELS" | while read -r model; do
        echo "    • $model"
      done
    fi
  else
    echo "  [autocomplete] ✗ not running"
  fi
}

pull() {
  if ! OLLAMA_HOST=$CHAT_HOST ollama list | grep -q "$CHAT_MODEL"; then
    echo "Pulling $CHAT_MODEL on chat instance..."
    OLLAMA_HOST=$CHAT_HOST ollama pull $CHAT_MODEL
  else
    echo "  [chat] $CHAT_MODEL already exists, skipping."
  fi
  if ! OLLAMA_HOST=$AUTOCOMPLETE_HOST ollama list | grep -q "$AUTOCOMPLETE_MODEL"; then
    echo "Pulling $AUTOCOMPLETE_MODEL on autocomplete instance..."
    OLLAMA_HOST=$AUTOCOMPLETE_HOST ollama pull $AUTOCOMPLETE_MODEL
  else
    echo "  [autocomplete] $AUTOCOMPLETE_MODEL already exists, skipping."
  fi
}

logs() {
  tail -f "$LOG_DIR/chat.log" "$LOG_DIR/autocomplete.log"
}

help() {
  echo "Usage: $0 {start|stop|restart|status|pull|logs|models|help}"
  echo ""
  echo "  start    - Start both Ollama instances"
  echo "  stop     - Stop all instances"
  echo "  restart  - Restart both instances"
  echo "  status   - Check if instances are running"
  echo "  pull     - Pull models on both instances"
  echo "  logs     - Tail logs from both instances"
  echo "  models   - Show currently loaded models on each instance"
  echo "  help     - Show this help message"
}

case "$1" in
  start)   start ;;
  stop)    stop ;;
  restart) stop; sleep 2; start ;;
  status)  status ;;
  pull)    pull ;;
  logs)    logs ;;
  models)  models ;;
  help)    help ;;
  *)
    help ;;
esac
