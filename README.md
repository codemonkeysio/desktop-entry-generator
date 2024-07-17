# Desktop Entry Generator

This script will create a desktop entry file in Linux.

> The script has only been tested on Arch Linux 6.3.4-arch1-1 with Zsh 5.9 and GNOME 44.1, but it should work in other Linux distributions, shells, and desktop environments.

🐒 Check out the [Code Monkeys Blog!](https://www.codemonkeys.tech/ "Code Monkeys Blog!")

🎥 Subscribe to the [Code Monkeys YouTube Channel!](https://www.youtube.com/@codemonkeystech "Code Monkeys YouTube Channel!")

## Choosing a Directory

If you want the desktop entry file to be accessible to all users on your system, then you can add the file globally using this common default directory:

- `/usr/share/applications`

If you want the desktop entry file to be accessible to the current user on your system, then you can add the file locally using one of these common default directories:

- `/usr/local/share/applications`
- `$HOME/.local/share/applications`

- If you don't want to or you are unable to use one of the common default directories above, then you also have the option of adding the desktop entry file to a custom directory that you specify.

## Choosing a File Name

The standard naming convention for desktop entry files is reverse DNS, e.g.,

- `com.website.AppName.desktop`

You can use a different naming convention if you prefer.

> Desktop entry files do not need an extension, but for easy classification the `.desktop` extension is used.

## Key-value Pairs

The script supports commonly used key-value pairs in desktop entry files including:

- `Name` (Required) - This key specifies the name of the application.

- `Comment` (Optional) - Used as a tooltip for the desktop entry and should not have the same value as the `Name` key.

- `Icon` (Optional) - The icon is displayed as a Graphical User Interface (GUI) image. If the path to the file is an absolute path, the given file will be used. If the path to the file is not an absolute path, the algorithm described in the [Icon Themes](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html) documentation will be used to locate the icon.

- `Exec` (Recommended) - The path to the program to execute. You can also add arguments to the `Exec` key, see the [The Exec Key](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#exec-variables) documentation for more details. The key is required if `DBusActivatable` is not set to true. Even if `DBusActivatable` is true, the key should be specified for compatibility with implementations that do not understand `DBusActivatable`.

- `Terminal` (Optional) - This key specifies whether the program runs in a terminal window. The value should be set to `true` if the program runs in the terminal and `false` if it doesn't run in the terminal.

- `Categories` (Optional) - This key specifies the categories in which the desktop entry should be shown. Each specified category value should be separated using a semicolon, i.e., `;`. Here's an example of how to set the value, `Network;WebBrowser`. See the [Desktop Menu Specification](https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html) documentation for more possible values.

> Only desktop entry files with a `Type` of `Application` are supported. You can change the `Type` yourself by editing the desktop entry file directly. Setting localization, i.e., the ability to display specified translations isn't supported by this script. You can add localization to the key-value pairs yourself by editing the desktop entry file directly.

You can add more key-value pairs yourself by editing the desktop entry file directly.

## Running the Script

To be able to execute the script run the following command:

```sh
chmod u+x generate-desktop-entry.sh
```

## Resources

Here are some links related to desktop entries if you have questions or are interested in learning more:

- [XDG Desktop Entry Specifications](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html) - Documentation for the desktop entry file specification

- [Icon Themes](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html) - Documentation related to the `Icon` key-value pair

- [The Exec Key](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#exec-variables) - Documentation related to the `Exec` key-value pair

- [Desktop Menu Specification](https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html) - Documentaion related to the Desktop Menu Specification which includes information about the `Categories` key-value pair

- [Desktop entries](https://wiki.archlinux.org/title/desktop_entries) - Arch Linux documentation on desktop entries

- [desktop-file-utils](https://www.freedesktop.org/wiki/Software/desktop-file-utils/) - Command line utilities for working with desktop entry files which inlcudes validation of the files, installing a file to the applications directory, etc.
