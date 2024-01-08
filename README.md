# My Emacs

Emacs set up for R-coding & note taking in md/rmd. Sidebar, Vim-keybindings.

## Setup

Copy `.emacs` and `.emacs.d/` to your home folder & install the needed packages: dashboard, ess, evil, markdown-mode, poly-R, doom-themes, undo-tree, dired-sidebar, all-the-icons.


If you want to use with EmacsClient:

```
cp emacsclient-desktop ~/.local/share/applications
mkdir ~/.config/systemd/user
cp emacs.service ~/.config/systemd/user/
```

After that, enable & start the daemon:

```
systemctl enable --user emacs.service
systemctl status --user emacs.service
```
On Fedora, this does not work; I think the issue is that the daemon starts before the Wayland session...? You can instead launch it from `.config/autostart`:

```
mkdir ~/.config/autostart
cp emacs-daemon.desktop ~/.config/autostart 
```

## Sidebar/Icons

You can toggle the sidebar with `M-x sidebar`. After installing `all-the-icons`, you should install the necessary fonts: `all-the-icons-install-fonts`. 

## ESS/R

There is an issue with ESS where the console font color changes after printing certain objects. This is fixed in `.Rprofile`. In order for this to work, you need the `crayon`-package:

```
R -e "install.packages('crayon')"
```

Then put the .Rprofile into your home directory (or put the code into your existing .Rprofile).
