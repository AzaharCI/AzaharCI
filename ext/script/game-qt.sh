#!/bin/sh

# This script should be run in azahar/src
# Replaces front-facing instances of "application" with "game" where appropriate.

find citra_qt -type f -exec sed -i 's/Configure Current Application/Configure Current Game/g' {} \;
find citra_qt -type f -exec sed -i 's/Current running application/Current running game/g' {} \;
find citra_qt -type f -exec sed -i 's/Application used in/Game used in/g' {} \;
find citra_qt -type f -exec sed -i 's/Application Location/Game Location/g' {} \;
find citra_qt -type f -exec sed -i 's/Per-Application/Per-Game/g' {} \;

# UI files #

# Only replace after a space or XML statement end
sed -i -e 's/\([ >]\)Application/\1Game/g' -e 's/\([ >]\)application/\1game/g' citra_qt/configuration/configure*.ui
