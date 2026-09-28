zinit ice multisrc'_*.zsh'
zinit light "$DOTFILES/.zsh"

zinit lucid wait'!0' light-mode for \
  'zsh-users/zsh-autosuggestions' \
  'zsh-users/zsh-syntax-highlighting' \
  'zsh-users/zsh-history-substring-search' \

zinit ice lucid wait'!0' pick'init.sh' \
  atload'ENHANCD_FILTER=fzf; export ENHANCD_FILTER;'
zinit light 'b4b4r07/enhancd'

zinit ice lucid wait'!0' as'program' pick'bin/fzf' \
  atclone'./install --xdg --no-update-rc --completion --key-bindings' \
  atpull'%atclone' multisrc'shell/{key-bindings,completion}.zsh'
zinit light 'junegunn/fzf'

# Release binaries, fetched only when the tool is not already on PATH. On macOS these
# come from the Brewfile in winky/mac-provisioning, so these blocks are skipped; on a
# Linux box, or a Mac with the dotfiles but not the Brewfile, they install it.
#
# bpick is per tool: the projects do not agree on how to name release assets.
#   ghq   ghq_darwin_arm64.zip        ghq_linux_amd64.zip
#   gh    gh_x.y.z_macOS_arm64.zip    gh_x.y.z_linux_amd64.tar.gz
# The Linux patterns are taken from the projects' releases and are untested here.
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)  _ghq_asset='*darwin_arm64*' ; _gh_asset='*macOS_arm64*' ;;
  Darwin-x86_64) _ghq_asset='*darwin_amd64*' ; _gh_asset='*macOS_amd64*' ;;
  Linux-aarch64) _ghq_asset='*linux_arm64*'  ; _gh_asset='*linux_arm64*' ;;
  Linux-x86_64)  _ghq_asset='*linux_amd64*'  ; _gh_asset='*linux_amd64*' ;;
esac

if (( ! $+commands[ghq] )); then
  zinit ice lucid wait'!0' from'gh-r' as'program' bpick"$_ghq_asset" mv'ghq*/ghq -> ghq'
  zinit light 'x-motemen/ghq'
fi

if (( ! $+commands[gh] )); then
  zinit ice lucid wait'!0' from'gh-r' as'program' bpick"$_gh_asset" mv'gh*/bin/gh -> gh'
  zinit light 'cli/cli'
fi

zinit ice lucid wait'!0' from'gh-r' as'program' bpick'*darwin-arm64*' \
  atload'PATH=$HOME/.asdf/shims:$PATH;'
zinit light 'asdf-vm/asdf'

# snippet for prompt theme
# Load OMZ Git library
zinit snippet OMZL::git.zsh

zinit ice pic"*.zsh-theme"
zinit light "$DOTFILES/.zsh/themes"

zinit ice lucid wait'!0' blockf atpull'zinit creinstall -q .' atload'zicompinit; zicdreplay'
zinit light 'zsh-users/zsh-completions'
