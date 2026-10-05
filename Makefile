DOTPATH			:= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILESS 		:= $(wildcard .??*)
EXCLUDES 		:= .DS_Store .git .gitmodules .gitignore .github .claude
DEPLOY_TARGET	:= $(filter-out $(EXCLUDES), $(DOTFILESS))

.DEFAULT_GOAL	:= help

all:

list: ## Show all dotfiles in this repository (excluding .git, .DS_Store, etc.)
	@$(foreach val, $(DEPLOY_TARGET), /bin/ls -dF $(val);)

deploy: ## Create symlinks to home directory for all dotfiles (e.g., .zshrc, .vimrc, .tmux.conf)
	@echo 'Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DEPLOY_TARGET), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@echo ''

update: ## Update dotfiles from remote repository and initialize/update git submodules
	git pull origin master
	git submodule update --init --recursive

# Pinned CLI tools, installed into BINDIR (on PATH from .zsh/_env.zsh) rather than by zinit
# at shell start: asdf's shims exec `asdf` from PATH on every node/npx call, including ones
# that never pass through zsh (an MCP server, make, launchd), so it has to sit at a fixed
# path before anything runs. The same targets work on Linux.
#
# To add a tool: append it to TOOLS and give it <name>_version and <name>_url -- projects do
# not name their release assets alike. The tarball has to hold the binary at its top level.
BINDIR ?= $(HOME)/.local/bin
OS     := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH   := $(shell uname -m | sed -e 's/^x86_64$$/amd64/' -e 's/^aarch64$$/arm64/')

TOOLS := asdf

asdf_version := 0.20.2
asdf_url     := https://github.com/asdf-vm/asdf/releases/download/v$(asdf_version)/asdf-v$(asdf_version)-$(OS)-$(ARCH).tar.gz

tools: ## Install the pinned CLI tools (asdf) into ~/.local/bin
	@$(foreach t,$(TOOLS),$(DOTPATH)/scripts/install-tool.sh $(t) $($(t)_version) $($(t)_url) $(BINDIR) &&) true

# The absolute path, so that this works from a caller whose PATH lacks BINDIR (an ansible
# role, a launchd job).
ASDF ?= $(BINDIR)/asdf

runtimes: tools ## Install the asdf plugins and versions pinned in .tool-versions (Node for npx, etc.)
	@awk '!/^#/ && NF { print $$1 }' $(DOTPATH)/.tool-versions | while read -r name; do \
		$(ASDF) plugin list 2>/dev/null | grep -qx "$$name" || $(ASDF) plugin add "$$name" || exit 1; \
	done
	cd $(DOTPATH) && $(ASDF) install

homeConfig: ## Create symlinks for XDG Base Directory configs (nvim, git, karabiner)
	mkdir -p $(HOME)/.config/karabiner
	ln -sfnv $(abspath config/nvim) $(HOME)/.config/nvim
	ln -sfnv $(abspath config/git) $(HOME)/.config/git
	ln -sfnv $(abspath config/karabiner)/karabiner.json $(HOME)/.config/karabiner/karabiner.json

clean: ## Remove all dotfiles symlinks from home directory (does not remove this repository)
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DEPLOY_TARGET), rm -vrf $(HOME)/$(val);)

install: clean update deploy ## Full installation: clean existing dotfiles, update from remote, deploy symlinks, and reload shell
	@exec $$SHELL

help: ## Print usage information and list all available commands
	@echo ''
	@echo 'Usage: Make COMMAND for dotfiles'
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m\t%-30s\033[0m %s\n", $$1, $$2}'
