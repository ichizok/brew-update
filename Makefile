ARCH ?= $(shell uname -m)

ifeq ($(ARCH),arm64)
  # Apple Silicon
  PREFIX ?= /opt/homebrew
else
  # Intel
  PREFIX ?= /usr/local
endif

HOMEBREW_PREFIX = $(PREFIX)
LAUNCH_AGENT_DIR := Library/LaunchAgents
LAUNCH_AGENT_PLIST := net.homebrew.update.plist

all: brew-update terminal-notifier

brew-update:
	sed 's#{{HOMEBREW_PREFIX}}#$(HOMEBREW_PREFIX)#g' bin/$@.in > $(PREFIX)/bin/$@
	chmod +x $(PREFIX)/bin/$@
	sed 's#{{HOMEBREW_PREFIX}}#$(HOMEBREW_PREFIX)#g' $(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST).in > ~/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST:.plist=.$(ARCH).plist)
	launchctl load ~/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST)

terminal-notifier:
	$(HOMEBREW_PREFIX)/bin/brew install $@

