A simple command-line application that creates Fastlane directories and files from the given translation files.

Script accepts arguments:
- `--stringsDir "path_to_the_folder_with_translation_files"`
- `--updatedDir "path_to_the_folder_with_faslane_dirs"`
- `--flavor "for managing_flavors"`

Command to run the script

iOS

```dart bin/dart_update_locales_fastlane.dart --stringsDir "/Users/mavbook/projects/agoradesk-app-foss/assets/translations" --updatedDir "/Users/mavbook/projects/agoradesk-app-foss/ios/fastlane/metadata" --flavor "agoradesk" --os "ios"```

Android

```dart bin/dart_update_locales_fastlane.dart --stringsDir "/Users/mavbook/projects/agoradesk-app-foss/assets/translations" --updatedDir "/Users/mavbook/projects/agoradesk-app-foss/android/fastlane/metadata" --flavor "agoradesk" --os "android"```


## Credits

This is a project by [Agoradesk](https://agoradesk.com/), P2P cryptocurrency trading platform.
Created by the team behind LocalMonero, the biggest and most trusted Monero P2P trading platform.
