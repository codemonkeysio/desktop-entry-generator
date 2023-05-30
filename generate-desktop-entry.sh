#!/bin/bash

chosen_directory=
desktop_entry_file_name=
file_write_permissions=
name=

check_readme() {
  confirmation=

  while true
  do
    read -r -p "Did you read the README.md file? It's recommended to read the README.md file before generating a desktop entry. [Y/n] " confirmation

    case $confirmation in
      [yY][eE][sS]|[yY]|"")
        printf "\nProceeding with generation...\n\n"
        break
        ;;
      [nN][oO]|[nN])
        printf "\nAlright come back when you have read the README.md file.\n"
        exit 1
        ;;
      *)
        printf "\nInvalid input...\n\n"
        ;;
    esac
  done
}

set_up_sudo_session() {
  printf "Setting up sudo session...\n"
  sudo -v
}

check_directory() {
  printf "\n\n"
  if [ -d "$1" ]; then
    chosen_directory="$1"
  else
    printf "The chosen directory doesn't exist.\n"
    printf "Create the directory or use a different directory.\n"
    exit 1
  fi
}

choose_directory() {
  printf "\nIf you want the desktop entry file to be accessible to all users on your system, then add the file globally using this directory:\n\n"
  printf "/usr/share/applications\n\n"

  printf "If you want the desktop entry file to be accessible to the current user on your system, then add the file locally using one of these directories:\n\n"
  printf "/usr/local/share/applications\n\n"
  printf "$HOME/.local/share/applications\n\n"

  printf "If you want to add the desktop entry file to a custom directory, then specify the path below.\n\n"

  dir0="/usr/share/applications"
  dir1="/usr/local/share/applications"
  dir2="$HOME/.local/share/applications"
  dir3="/path/to/custom/directory"

  PS3="Select the directory where you want to add the desktop entry file: "

  select dir in $dir0 $dir1 $dir2 $dir3 quit; do
    case $dir in
      $dir0)
        check_directory $dir0
        break
        ;;
      $dir1)
        check_directory $dir1
        break
        ;;
      $dir2)
        check_directory $dir2
        break
        ;;
      $dir3)
        read -p "Enter the path to the custom directory: " custom_directory
        check_directory $custom_directory
        break
        ;;
      quit)
        exit 1
        ;;
      *)
        printf "\nInvalid input, choose one of the options above.\n\n"
        ;;
    esac
  done
}

set_desktop_entry_name() {
  printf "Choose a name for your desktop entry file.\n"
  printf "The standard naming convention for desktop entry files is reverse DNS, e.g.,\n\n"
  printf "com.website.AppName.desktop.\n\n"
  printf "You can use a different naming convention if you prefer.\n\n"
  printf 'Also desktop entry files do not need an extension, but for easy classification the ".desktop" extension is used.\n\n'

  read -p "Enter the desktop entry file name: " desktop_entry_file_name
}

create_desktop_entry_file() {
  printf "\n"
  if [ -f "$chosen_directory/$desktop_entry_file_name" ]; then
    printf "The file already exists.\n"
    printf "Delete the file or use a different file name.\n"
    exit 1
  elif [ -w "$chosen_directory" ]; then
    touch "$chosen_directory/$desktop_entry_file_name"
  else
    sudo touch "$chosen_directory/$desktop_entry_file_name"
  fi

  printf "Created the desktop entry file.\n\n"
}

check_file_write_permissions() {
  if [ -w "$chosen_directory/$desktop_entry_file_name" ]; then
    file_write_permissions="true"
  else
    file_write_permissions="false"
  fi
}

add_desktop_entry_and_type() {
  if [ "$file_write_permissions" == "true" ]; then
    echo $'[Desktop Entry]\nType=Application' | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
  else
    echo $'[Desktop Entry]\nType=Application' | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
  fi
}

key_value_pair_notes() {
  printf "We're now going to add some common key-value pairs to the desktop entry file.\n"
  printf "You can add more key-value pairs yourself by editing the desktop entry file directly.\n"
  printf "Setting localization, i.e., the ability to display specified translations isn't supported by this script.\n"
  printf "You can add localization to the key-value pairs yourself by editing the desktop entry file directly.\n\n"
}

add_name() {
  while true
  do
    read -p "Enter the Name of the application (Required): " name
    printf "\n"
    if [ "$name" != "" ]; then
      if [ "$file_write_permissions" == "true" ]; then
        echo "Name=$name" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
      else
        echo "Name=$name" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
      fi
      break
    else
      printf "Name is required...\n\n"
    fi
  done
}

add_comment() {
  printf "The Comment is optional and the value will be used as a tooltip for the desktop entry.\n"
  printf "The value should not have the same value used for Name.\n\n"

  confirmation=

  while true
  do
    read -r -p "Do you want to add a Comment? [Y/n] " confirmation

    case $confirmation in
      [yY][eE][sS]|[yY]|"")
        printf "\n"
        read -p "Enter the Comment for the application: " comment
        printf "\n"

        if [ "$comment" == "$name" ]; then
          printf "The Comment value should not have the same value used for Name.\n"
          printf "If you want to add a Comment, then use a different value.\n\n"
        else
          if [ "$file_write_permissions" == "true" ]; then
            echo "Comment=$comment" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
            break
          else
            echo "Comment=$comment" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
            break
          fi
        fi
        ;;
      [nN][oO]|[nN])
        printf "\n"
        break
        ;;
      *)
        printf "\nInvalid input...\n\n"
        ;;
    esac
  done
}

add_icon() {
  printf "The Icon is optional and will be displayed as a Graphical User Interface (GUI) image.\n"
  printf "If the path to the file is an absolute path, the given file will be used.\n"
  printf "If the path to the file is not an absolute path, the algorithm described in the link below will be used to locate the icon\n\n"
  printf "https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html\n\n"

  confirmation=

  while true
  do
    read -r -p "Do you want to add an Icon? [Y/n] " confirmation

    case $confirmation in
      [yY][eE][sS]|[yY]|"")
        printf "\n"
        read -p "Enter the path to the Icon: " icon
        printf "\n"
        if [ "$file_write_permissions" == "true" ]; then
          echo "Icon=$icon" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
        else
          echo "Icon=$icon" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
        fi
        break
        ;;
      [nN][oO]|[nN])
        printf "\n"
        break
        ;;
      *)
        printf "\nInvalid input...\n\n"
        ;;
    esac
  done
}

add_exec() {
  printf "The Exec value is the path to the program to execute.\n"
  printf "You can also add arguments to the Exec key, see the link below for more details\n\n"
  printf "https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#exec-variables\n\n"
  printf "Exec is required if DBusActivatable is not set to true.\n"
  printf "Even if DBusActivatable is true, Exec should be specified for compatibility with implementations that do not understand DBusActivatable.\n\n"

  confirmation=

  while true
  do
    read -r -p "Do you want to add an Exec key? [Y/n] " confirmation

    case $confirmation in
      [yY][eE][sS]|[yY]|"")
        printf "\n"
        read -p "Enter the path for the Exec key: " exec
        printf "\n"
        if [ "$file_write_permissions" == "true" ]; then
          echo "Exec=$exec" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
        else
          echo "Exec=$exec" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
        fi
        break
        ;;
      [nN][oO]|[nN])
        printf "\n"
        break
        ;;
      *)
        printf "\nInvalid input...\n\n"
        ;;
    esac
  done
}

add_terminal() {
  printf "The Terminal value specifies whether the program runs in a terminal window.\n\n"

  confirmation=

  while true
  do
    read -r -p "Do you want to add a Terminal key? [Y/n] " confirmation
    case $confirmation in
      [yY][eE][sS]|[yY]|"")
        printf "\n"

        option0="true"
        option1="false"

        PS3="Select true if the program runs in the terminal and false if it doesn't run in the terminal: "

        select option in $option0 $option1; do
          case $option in
            $option0)
              if [ "$file_write_permissions" == "true" ]; then
                echo "Terminal=$option0" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
              else
                echo "Terminal=$option0" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
              fi
              break
              ;;
            $option1)
              if [ "$file_write_permissions" == "true" ]; then
                echo "Terminal=$option1" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
              else
                echo "Terminal=$option1" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
              fi
              break
              ;;
            *)
              printf "\nInvalid input, choose one of the options above.\n\n"
              ;;
          esac
        done

        printf "\n"
        break
        ;;
      [nN][oO]|[nN])
        printf "\n"
        break
        ;;
      *)
        printf "\nInvalid input...\n\n"
        ;;
    esac
  done
}

add_categories() {
  printf "The Categories value specifies the categories in which the desktop entry should be shown.\n"
  printf "Each specified category value should be separated using a semicolon, i.e., ';'\n"
  printf "See the link below for possible values\n\n"
  printf "https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html\n\n"
  printf "Here's an example of how to set the Categories value, Network;WebBrowser\n\n"

  confirmation=

  while true
  do
    read -r -p "Do you want to add a Categories key? [Y/n] " confirmation

    case $confirmation in
      [yY][eE][sS]|[yY]|"")
        printf "\n"
        read -p "Enter the Categories value: " categories
        printf "\n"
        if [ "$file_write_permissions" == "true" ]; then
          echo "Categories=$categories" | tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
        else
          echo "Categories=$categories" | sudo tee -a "$chosen_directory/$desktop_entry_file_name" > /dev/null
        fi
        break
        ;;
      [nN][oO]|[nN])
        printf "\n"
        break
        ;;
      *)
        printf "\nInvalid input...\n\n"
        ;;
    esac
  done
}

success_message() {
  printf "Successfully created the desktop entry file $desktop_entry_file_name in $chosen_directory!\n"
}

check_readme
set_up_sudo_session
choose_directory
set_desktop_entry_name
create_desktop_entry_file
check_file_write_permissions
add_desktop_entry_and_type
key_value_pair_notes
add_name
add_comment
add_icon
add_exec
add_terminal
add_categories
success_message
