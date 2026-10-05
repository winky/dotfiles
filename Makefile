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

# Overridable so that a caller without asdf on PATH (an ansible role, a launchd job) can
# pass the absolute path.
ASDF ?= asdf

runtimes: ## Install the asdf plugins and versions pinned in .tool-versions (Node for npx, etc.)
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
