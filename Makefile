DOTPATH			:= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES 		:= $(wildcard .??*)
EXCLUDES 		:= .DS_Store .git .gitmodules .gitignore
DEPLOY_TARGET	:= $(filter-out $(EXCLUDES), $(CANDIDATES))

.DEFAULT_GOAL	:= help

list: ## Show dotfiles in this repository
	@$(foreach val, $(DEPLOY_TARGET), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory
	@echo 'Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DEPLOY_TARGET), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init: ## Setup environment settings
	@bash $(DOTPATH)/etc/init/init.sh

update: ## Update dotfiles settings
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

homeConfig: ## Init config
	ln -sfnv $(abspath config/nvim) $(HOME)/.config/nvim

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DEPLOY_TARGET), rm -vrf $(HOME)/$(val);)

install: update deploy ## Run make update, deploy, init
	@exec $$SHELL

help: ## Print Usge
	@echo ''
	@echo 'Usage: Make COMMAND for dotfiles'
	@echo ''
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m\t%s\033[0m\t%s\n", $$1, $$2}'
