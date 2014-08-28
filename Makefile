PREFIX ?= /usr/local
LAUNCH_AGENT_DIR := Library/LaunchAgents
LAUNCH_AGENT_PLIST := net.homebrew.update.plist

all: brew-update terminal-notifier

brew-update:
	cp -X bin/$@ $(PREFIX)/bin
	chmod +x $(PREFIX)/bin/$@
	cp -X $(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST) ~/$(LAUNCH_AGENT_DIR)
	launchctl load ~/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST)

terminal-notifier:
	brew install $@

