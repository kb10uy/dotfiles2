use path
use platform

var shell-env-file = $E:HOME"/dotfiles2/shell-env/"(platform:hostname)".elv"
if (path:is-regular $shell-env-file) {
  eval (slurp < $shell-env-file)
}

eval (starship init elvish)
