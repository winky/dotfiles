zinit ice multisrc'_*.zsh'
zinit light "$DOTFILES/.zsh"

zinit lucid wait'!0' light-mode for \
  'zsh-users/zsh-autosuggestions' \
  'zsh-users/zsh-syntax-highlighting' \
  'zsh-users/zsh-history-substring-search' \

zinit ice lucid wait'!0' pick'init.sh' \
  atload'ENHANCD_FILTER=fzf; export ENHANCD_FILTER;'
zinit light 'b4b4r07/enhancd'

# Release binaries, fetched only when the tool is not already on PATH. On macOS these
# come from the Brewfile in winky/mac-provisioning, so these blocks are skipped; on a
# Linux box, or a Mac with the dotfiles but not the Brewfile, they install it.
#
# bpick is per tool: the projects do not agree on how to name release assets.
#   ghq   ghq_darwin_arm64.zip             ghq_linux_amd64.zip
#   gh    gh_x.y.z_macOS_arm64.zip         gh_x.y.z_linux_amd64.tar.gz
#   fzf   fzf-x.y.z-darwin_arm64.zip       fzf-x.y.z-linux_amd64.tar.gz
#   asdf  asdf-vx.y.z-darwin-arm64.tar.gz  asdf-vx.y.z-linux-amd64.tar.gz
# asdf separates the OS from the architecture with a hyphen where the others use an
# underscore. The Linux patterns are taken from the projects' releases and are untested
# here.
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)
    _ghq_asset='*darwin_arm64*' _gh_asset='*macOS_arm64*'
    _fzf_asset='*darwin_arm64*' _asdf_asset='*darwin-arm64*' ;;
  Darwin-x86_64)
    _ghq_asset='*darwin_amd64*' _gh_asset='*macOS_amd64*'
    _fzf_asset='*darwin_amd64*' _asdf_asset='*darwin-amd64*' ;;
  Linux-aarch64)
    _ghq_asset='*linux_arm64*'  _gh_asset='*linux_arm64*'
    _fzf_asset='*linux_arm64*'  _asdf_asset='*linux-arm64*' ;;
  Linux-x86_64)
    _ghq_asset='*linux_amd64*'  _gh_asset='*linux_amd64*'
    _fzf_asset='*linux_amd64*'  _asdf_asset='*linux-amd64*' ;;
esac

if (( ! $+commands[ghq] )); then
  zinit ice lucid wait'!0' from'gh-r' as'program' bpick"$_ghq_asset" mv'ghq*/ghq -> ghq'
  zinit light 'x-motemen/ghq'
fi

if (( ! $+commands[gh] )); then
  zinit ice lucid wait'!0' from'gh-r' as'program' bpick"$_gh_asset" mv'gh*/bin/gh -> gh'
  zinit light 'cli/cli'
fi

# fzf and asdf need shell integration on top of the binary, and it has to run whichever
# way the binary arrived. Keep it in a function so both paths call the same thing.
#
#   fzf   emits its own key bindings and completion since 0.48, so the install script
#         and the shell/*.zsh sources this file used to reference are no longer needed
#   asdf  0.16+ dropped asdf.sh. Its shims exec `asdf` from PATH, so the integration
#         is reduced to putting the shim directory ahead of it -- and the shims break
#         unless `asdf` itself resolves, which is why it must not live under the ghq root
_fzf_integration()  { eval "$(fzf --zsh)" }
_asdf_integration() { export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH" }

if (( $+commands[fzf] )); then
  _fzf_integration
else
  zinit ice lucid wait'!0' from'gh-r' as'program' bpick"$_fzf_asset" \
    atload'_fzf_integration'
  zinit light 'junegunn/fzf'
fi

if (( $+commands[asdf] )); then
  _asdf_integration
else
  zinit ice lucid wait'!0' from'gh-r' as'program' bpick"$_asdf_asset" \
    atload'_asdf_integration'
  zinit light 'asdf-vm/asdf'
fi

# snippet for prompt theme
# Load OMZ Git library
zinit snippet OMZL::git.zsh

zinit ice pic"*.zsh-theme"
zinit light "$DOTFILES/.zsh/themes"

zinit ice lucid wait'!0' blockf atpull'zinit creinstall -q .' atload'zicompinit; zicdreplay'
zinit light 'zsh-users/zsh-completions'
