# My Emacs

GNU Emacs setup for coding in R & C++, and note-taking in markdown, with sidebar & Vim-keybindings (evil-mode).

## Setup

after installing emacs, clone repo & copy `.emacs` and `.emacs.d/` into your home folder:

```
git clone https://github.com/kssrr/emacs-custom
cd emacs-custom
cp -r .emacs* ~/
```

If you want to use with EmacsClient:

```
cp emacsclient-desktop ~/.local/share/applications
```

### With systemd:

```
mkdir -p ~/.config/systemd/user
cp emacs.service ~/.config/systemd/user/
```

After that, enable & start the daemon:

```
systemctl enable --user emacs.service
systemctl status --user emacs.service
```

### Without systemd

On Fedora, this does not work; I think the issue is that the daemon starts before the Wayland session...? You can instead launch it from `.config/autostart`:

```
mkdir ~/.config/autostart
cp emacs-daemon.desktop ~/.config/autostart 
```

This will start the Emacs daemon on boot (or session start). To start right away, you can use

```
emacs --daemon
```

## Sidebar/Icons

You can toggle the sidebar with `M-x sidebar`. After installing `all-the-icons`, you should install the necessary fonts: `all-the-icons-install-fonts`. 

## ESS/R

There is an issue with ESS where the console font color changes after printing certain objects (e.g. tibbles & rlang-tracebacks). This is fixed in `.Rprofile`. In order for this to work, you need the `crayon`-package:

```
R -e "install.packages('crayon')"
```

Then put the .Rprofile into your home directory (or put the code into your existing .Rprofile).

## Random

You can try to request a dark title bar in a GTK & X11 context by using `M-x set-selected-frame-dark`. This works *sometimes*.

For C++, you may need to edit the include paths in `.emacs`, otherwise it won't find your headers.
