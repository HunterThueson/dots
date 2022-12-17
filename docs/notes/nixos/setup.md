# NixOS Setup

## Creating a shared `bin/` folder
    Scripts created by me (the system administrator) intended for use by all
users on the system should be placed in `/usr/local/`, with binary files and/or
scripts intended to be executed directly going in `/usr/local/bin/`, libraries
going in `/usr/local/lib/`, and so on.

    If there is no `/usr/local/` (including the appropriate subdirectories,
listed below), create it. To do so, run the following script as root:

```
for $folder in "bin/" "etc/" "lib/" "man/"; do
[[ ! -d /usr/local/${folder} ]] && mkdir -p /usr/local/${folder}

chgrp -hR wizards /usr/local/
chmod 775 /usr/local/
```

    Until you get a nice little script built to take care of this, you'll need
to run the last two lines of the aforementioned script on every new file and/or
directory you create.

