# Emacs customization

Copy `.emacs` and `.emacs.d/` to your home folder & install the needed packages: dashboard, ess, evil, markdown-mode, poly-R, doom-themes, undo-tree.


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

## ESS/R

There is an issue with ESS where the console font color changes after printing certain objects. This is fixed in `.Rprofile`. In order for this to work, you need the `crayon`-package:

```
R -e "install.packages('crayon')"
```
