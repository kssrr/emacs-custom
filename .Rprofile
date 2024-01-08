# Rprofile

# Prevent font color changes in interactive R session using ESS.
# There is an issue where the font colors of tibbles and rlang error
# messages leak into the subsequent outputs, often making them unreadable.
# This forces an anscii-reset after every output (remember to install crayon).
# https://github.com/emacs-ess/ESS/issues/1193
invisible(
  addTaskCallback(
    function(...) {
      if (interactive()) {
        try(cat(crayon::reset("")), silent = TRUE)
      }

      TRUE
    },
    name = "ansi_reset"
  )
)
