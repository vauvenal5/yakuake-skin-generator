#!/bin/bash

# change to 1 for dark mode, 0 for light mode
darkMode=1

# tmp path of creating skin - will be automatically deleted on reboot
tmpDir="/tmp"
# path for local development
# tmpDir="./target"
skinName="breeze-vauvenal5"
tmpPath="$tmpDir/$skinName"

# defaults from original skin
oldAccentColor="#3daee9"
lightHtml="#eff0f1"
darkHtml="#4d4d4d"

mkdir -p "$tmpPath"
cp -r /usr/share/yakuake/skins/default/* "$tmpPath"

# read accent color from kde globals
rgb=$(kreadconfig6 --file ~/.config/kdeglobals --group General --key AccentColor)
IFS=',' read -r r g b <<< "$rgb"
accentColor="$(printf "#%02x%02x%02x" "$r" "$g" "$b")"

# replace colors in svg files
for file in "$tmpPath"/tabs/*.svg; do
  sed -i "s/$oldAccentColor/$accentColor/g" "$file"
done

sed -i "s/red=61/red=$r/g" "$tmpPath/title.skin"
sed -i "s/green=174/green=$g/g" "$tmpPath/title.skin"
sed -i "s/blue=233/blue=$b/g" "$tmpPath/title.skin"

if [ "$darkMode" -eq 1 ]; then
  sed -i "s/$lightHtml/$darkHtml/g" "$tmpPath/tabs/back_image.svg"
  sed -i "s/$lightHtml/$darkHtml/g" "$tmpPath/tabs/close_up.svg"
  # comment this if you want the plus to be in accent color instead of light when hovered
  sed -i "s/$accentColor/$lightHtml/g" "$tmpPath/tabs/close_down.svg"
  # uncomment this if you want the plus to be in dark color instead of accent
  # sed -i "s/$accentColor/$darkHtml/g" "$tmpPath/tabs/add_up.svg"
fi

# update metadata
configureMeta() {
  sed -i "s/$1/$2/g" "$tmpPath/tabs.skin"
  sed -i "s/$1/$2/g" "$tmpPath/title.skin"
}

configureMeta "Skin=Breeze" "Skin=Breeze vauvenal5"
configureMeta "Author=Andreas Kainz" "Author=Andreas Kainz repainted by vauvenal5"
configureMeta "Email=kainz.a@gmail.com" "Email=vauvenal5@gmail.com"

# uncomment if you want to create package for manual install
# tar -cf "$tmpPath.tar" -C "$tmpDir" "$skinName"

# install package and restart yakuake
cp -r "$tmpPath" ~/.local/share/yakuake/skins/
kwriteconfig6 --file yakuakerc --group Appearance --key Skin "$skinName"

killall yakuake
qdbus org.kde.yakuake /yakuake/window org.kde.yakuake.toggleWindowState