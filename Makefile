DOTPATH			:= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILESS 		:= $(wildcard .??*)
EXCLUDES 		:= .DS_Store .git .gitmodules .gitignore
DEPLOY_TARGET	:= $(filter-out $(EXCLUDES), $(DOTFILESS))
VSCODE_SETTING_DIR := $(HOME)/Library/Application\ Support/Code/User
VSCODE_SCRIPT_PATH := $(abspath config/vscode)

.DEFAULT_GOAL	:= help

all:

list: ## Show all dotfiles in this repository
	@$(foreach val, $(DEPLOY_TARGET), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory
	@echo 'Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DEPLOY_TARGET), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@echo ''

init: ## Setup environment settings
	@bash $(DOTPATH)/etc/init/init.sh

update: ## Update dotfiles settings
	git pull origin master
	git submodule update --init --recursive

homeConfig: ## Init config
	ln -sfnv $(abspath config/nvim) $(HOME)/.config/nvim
	ln -sfnv $(abspath config/git) $(HOME)/.config/git
	-@rm $(HOME)/.config/karabiner/karabiner.json
	ln -s $(abspath config/karabiner)/karabiner.json $(HOME)/.config/karabiner/karabiner.json

vscodeConfig: ## Init vscode json
	-@rm $(VSCODE_SETTING_DIR)/settings.json
	ln -s $(VSCODE_SCRIPT_PATH)/settings.json $(VSCODE_SETTING_DIR)/settings.json
	-@rm $(VSCODE_SETTING_DIR)/keybindings.json
	ln -s $(VSCODE_SCRIPT_PATH)/keybindings.json $(VSCODE_SETTING_DIR)/keybindings.json

vscodeExtensionsSync: ## sync extensions
	@bash $(VSCODE_SCRIPT_PATH)/sync.sh

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DEPLOY_TARGET), rm -vrf $(HOME)/$(val);)

install: clean update deploy ## Run make update, deploy
	@exec $$SHELL

test: ## Run test of dotfiles and scripts
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

help: ## Print Usge
	@echo ''
	@echo 'Usage: Make COMMAND for dotfiles'
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m\t%-30s\033[0m %s\n", $$1, $$2}'
