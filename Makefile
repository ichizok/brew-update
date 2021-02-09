ARCH ?= $(shell uname -m)

ifeq ($(ARCH),arm64)
  # Apple Silicon
  PREFIX ?= /opt/homebrew
else
  # Intel
  PREFIX ?= /usr/local
endif

UPDATE_TIME ?= 12:00
UPDATE_TIME_WORDS := $(subst :, ,$(UPDATE_TIME))
UPDATE_HOUR := $(shell printf '%d' $(firstword $(UPDATE_TIME_WORDS)))
UPDATE_MINUTE := $(shell printf '%d' $(lastword $(UPDATE_TIME_WORDS)))

HOMEBREW_PREFIX := $(PREFIX)
LAUNCH_AGENT_DIR := Library/LaunchAgents
LAUNCH_AGENT_PLIST := net.homebrew.update.plist

all: brew-update terminal-notifier

brew-update:
	sed 's#{{HOMEBREW_PREFIX}}#$(HOMEBREW_PREFIX)#g' bin/$@.in > $(PREFIX)/bin/$@
	chmod +x $(PREFIX)/bin/$@
	sed -e 's#{{HOMEBREW_PREFIX}}#$(HOMEBREW_PREFIX)#g' \
		-e 's#{{ARCH}}#$(ARCH)#' \
		-e 's#{{UPDATE_HOUR}}#$(UPDATE_HOUR)#' \
		-e 's#{{UPDATE_MINUTE}}#$(UPDATE_MINUTE)#' \
		$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST).in > ~/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST:.plist=.$(ARCH).plist)
	launchctl load ~/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST)

terminal-notifier:
	$(HOMEBREW_PREFIX)/bin/brew install $@

