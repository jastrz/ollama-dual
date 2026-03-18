# Ollama Dual

Simple script to run two Ollama instances simultaneously—one for chat/agent, one for autocomplete.

Requires: [Ollama](https://github.com/ollama/ollama) installed.

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
| CHAT_HOST | 127.0.0.1:11435 |
| AUTOCOMPLETE_HOST | 127.0.0.1:11436 |
| CHAT_MODEL | minimax-m2.7:cloud |
| AUTOCOMPLETE_MODEL | qwen2.5-coder:3b |

Logs: `~/.ollama/logs/`
