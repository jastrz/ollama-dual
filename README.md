# Ollama Dual

Simple script to run two Ollama instances simultaneously—one for chat/agent, one for autocomplete.

## Install

```bash
chmod +x installer.sh ollama-dual.sh
./installer.sh
source ~/.bashrc
```

## Usage

```bash
ollama-dual start      # Start both instances
ollama-dual stop       # Stop all instances
ollama-dual restart    # Restart both instances
ollama-dual status     # Check if running
ollama-dual pull       # Pull default models
ollama-dual logs       # View logs
ollama-dual models     # Show loaded models
ollama-dual help       # Show help
```

## Config

Edit variables in `ollama-dual.sh`:

| Variable | Default |
|----------|---------|
| CHAT_HOST | 127.0.0.1:11434 |
| AUTOCOMPLETE_HOST | 127.0.0.1:11435 |
| CHAT_MODEL | minimax-m2.5:cloud |
| AUTOCOMPLETE_MODEL | qwen3.5:2b |

Logs: `~/.ollama/logs/`
