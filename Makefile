.PHONY: smoke

smoke:
	rg -n 'Routine|idempot|retry|MCP|output' .
