set dotfiles_dir "$HOME/dotfiles2"
set -l dependency_file "$dotfiles_dir/shell-env/"(hostname)".fish"
set -l interactive_dependency_file "$dotfiles_dir/shell-env/"(hostname)".intr.fish"

# Load dependency file
if [ -e "$dependency_file" ]
  builtin source "$dependency_file"
else if status is-interactive
  set_color -ro -b white red
  echo "Dependency file for "(hostname)" was not found!"
  set_color reset
end

# Load interactive dependency file
if status is-interactive;
  # Install fisher if not exist
  if not type -q "fisher"
    curl -sL "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" | builtin source
    fisher install "jorgebucaran/fisher"
  end

  if [ -e "$interactive_dependency_file" ]
    builtin source "$interactive_dependency_file"
    echo "Interavtive dependency file loaded."
  end
end
