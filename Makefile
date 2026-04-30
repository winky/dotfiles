DOTPATH			:= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILESS 		:= $(wildcard .??*)
EXCLUDES 		:= .DS_Store .git .gitmodules .gitignore .github
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

homeConfig: ## Create symlinks for XDG Base Directory configs (nvim, git, karabiner, claude)
	ln -sfnv $(abspath config/nvim) $(HOME)/.config/nvim
	ln -sfnv $(abspath config/git) $(HOME)/.config/git
	-@rm $(HOME)/.config/karabiner/karabiner.json
	ln -s $(abspath config/karabiner)/karabiner.json $(HOME)/.config/karabiner/karabiner.json
	@mkdir -p $(HOME)/.claude
	ln -sfnv $(abspath config/claude/settings.json) $(HOME)/.claude/settings.json
	ln -sfnv $(abspath config/claude/CLAUDE.md) $(HOME)/.claude/CLAUDE.md
	ln -sfnv $(abspath config/claude/statusline-command.sh) $(HOME)/.claude/statusline-command.sh

clean: ## Remove all dotfiles symlinks from home directory (does not remove this repository)
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DEPLOY_TARGET), rm -vrf $(HOME)/$(val);)

install: clean update deploy ## Full installation: clean existing dotfiles, update from remote, deploy symlinks, and reload shell
	@exec $$SHELL

test: ## Run test suite for dotfiles and scripts (used by CI)
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

help: ## Print usage information and list all available commands
	@echo ''
	@echo 'Usage: Make COMMAND for dotfiles'
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m\t%-30s\033[0m %s\n", $$1, $$2}'
