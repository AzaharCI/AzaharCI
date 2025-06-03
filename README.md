# AzaharCI
A CI for Azahar that adds back removed features, with additional patches from Corte-Z and others.

## Core Patches
All patches in the `core` directory are the core patches enabling removed features, including decryption, NUS system file downloads, and more. It's strongly recommended to use these no matter what, as all extension patches require these to be applied first.

### Concat Files
`.cat` files contain additional version-agnostic file fragments, intended to be safely concatenated into existing files within the Azahar codebase.

### Extra Files
New files that are intended to be safely implanted within the code.

## Extensions
All patches and scripts in the `ext` directory are optional enhancements containing PRs and feature patches provided by Corte-Z and other contributors. Rejected or dead PRs that contain desirable changes are included here as well. These patches are often incremental and may depend on previous patches.

### Patch Files
- `turboAndPerGame` - Allows turbo and per-game speed modes to run at the same time, disabling the other if necessary.
  * Credit: Corte-Z
- `multiplayer` (EXPERIMENTAL) - Enables multiplayer features on Android. Known to cause issues right now.
  * Credit: Kleidis
- `perGameDefaults` (EXPERIMENTAL) - Adds per-game defaults to games that need it (e.g. Luigi's Mansion Dark Moon). Currently incomplete.
  * Credit: jbm11208, Corte-Z
- `configHotkeys` - Adds hotkeys for Configure and Configure Current Game.
  * Credit: crueter, Corte-Z
- `keepOldShortcuts` - Keeps old shortcuts in the Windows installer.
  * Credit: RedBlackAka
- `azaharAppID` - Removes the old, unnecessary Lime3DS App ID on the android app.
  * Credit: thopiekar, Corte-Z
- `releaseTag` - Forces the build to use release tags rather than GitHub's CI nonsense.
  * Credit: Corte-Z
- `androidArmOnly` - Removes the (usually) unneeded amd64 target for Android.
  * Credit: Corte-Z

### Shell Scripts
Shell scripts MUST be run after patches in order to prevent conflicts.

- `game-qt` - Replaces certain front-facing instances of "application" with "game" in the Qt (Desktop) frontend
  * Credit: Corte-Z
- `appimage-shortcut` - Replaces the shortcut creator's flatpak handling with AppImage handling.
  * Credit: Corte-Z
  * I have no plans to submit this to FlatHub. If you do, remove this.

## Building
- Enable/disable extensions by modifying `apply.sh`, which handles all patching and scripts.
- Clone the Azahar repository with the provided convenience script `.ci/clone.sh`.
  * If you wish to build nightly, set the `DEVEL` environment variable to `true`, otherwise unset it or set it to `false`.
  * The default behavior is to use the latest stable release.
- Run the shell script for your corresponding platform (linux.sh, windows.sh, etc.)

### Environment Variables
- Android requires the `ANDROID_HOME` environment variable to be set to a valid Android SDK.
- Set `DEVEL=true` to create a nightly build.
- You can set `VERSION` to a custom version (e.g. `2121`) to build a specific version.

## Contributing Patches
After cloning, run `apply.sh` from the azahar directory. The script will automatically create a commit with all patches applied. From there, make any changes needed and run `git diff > ../ext/patch/myPatchName.patch` from the azahar directory. Submit these patches via PR or email (email coming soon).

## Credits
- The original Citra team
- AzaharPlus for some of the patches
- Corte-Z and other Azahar/Lime3DS contributors for extension patches
- Samueru (pkgforge-dev) for the CI structure
