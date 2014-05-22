# Pull in all alias files

for file in ~/projects/mpeteuil/dotfiles/aliases/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
