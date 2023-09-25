use epm
use path
use platform

var dotfiles-dir = $E:HOME"/dotfiles2"
var packages-file = $dotfiles-dir"/config/elvish/packages.txt"
var shell-env-file = $dotfiles-dir"/shell-env/"(platform:hostname)".elv"

# Install packages
for package [(cat $packages-file)] {
  epm:install &silent-if-installed=$true $package
}

# Load shell environments script
if (path:is-regular $shell-env-file) {
  eval (slurp < $shell-env-file)
}

# Initialize Starship
if (has-external "starship") {
  eval (starship init elvish)
}

# Initialize Carapace
if (has-external "carapace") {
  eval (carapace _carapace | slurp)
}
