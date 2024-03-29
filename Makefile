ARCH ?= $(shell uname -m)

ifeq ($(ARCH),arm64)
  # Apple Silicon
  PREFIX ?= /opt/homebrew
else
  # Intel
  PREFIX ?= /usr/local
endif

HOMEBREW_PREFIX := $(PREFIX)

UPDATE_TIME ?= 00:00
UPDATE_TIME_WORDS := $(subst :, ,$(UPDATE_TIME))
UPDATE_HOUR := $(shell printf '%d' $(firstword $(UPDATE_TIME_WORDS)))
UPDATE_MINUTE := $(shell printf '%d' $(lastword $(UPDATE_TIME_WORDS)))

LAUNCH_AGENT_DIR := Library/LaunchAgents
LAUNCH_AGENT_LABEL := net.homebrew.update
LAUNCH_AGENT_PLIST := $(LAUNCH_AGENT_LABEL).$(ARCH).plist

all: brew-update-log brew-cacheclean terminal-notifier uninstall

brew-update-log:
	sed 's#{{HOMEBREW_PREFIX}}#$(HOMEBREW_PREFIX)#g' bin/$@.in > $(HOMEBREW_PREFIX)/bin/$@
	chmod +x $(HOMEBREW_PREFIX)/bin/$@
	sed -e 's#{{HOMEBREW_PREFIX}}#$(HOMEBREW_PREFIX)#g' \
		-e 's#{{ARCH}}#$(ARCH)#' \
		-e 's#{{UPDATE_HOUR}}#$(UPDATE_HOUR)#' \
		-e 's#{{UPDATE_MINUTE}}#$(UPDATE_MINUTE)#' \
		$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_LABEL).plist.in > $(HOME)/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST)
	launchctl load $(HOME)/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST)

brew-cacheclean:
	install -p bin/$@ $(HOMEBREW_PREFIX)/bin

terminal-notifier:
	$(HOMEBREW_PREFIX)/bin/brew install $@

uninstall:
	rm -f $(HOMEBREW_PREFIX)/bin/brew-cacheclean $(HOMEBREW_PREFIX)/bin/brew-update-log
	launchctl unload $(HOME)/$(LAUNCH_AGENT_DIR)/$(LAUNCH_AGENT_PLIST)
