#!/usr/bin/env Rscript
#
# Build the pkgdown site into docs/.
#
# Usage:
#   Rscript tools/build-docs.R
#
# pkgdown renders every top-level .md file it finds into a page of the site
# (see pkgdown:::package_mds), with no way to opt one out. AGENTS.md is
# guidance for AI agents working on the package, not user documentation, so it
# is moved aside for the duration of the build and put back afterwards.

build_docs <- function() {
  if (!requireNamespace("pkgdown", quietly = TRUE)) {
    stop("pkgdown is required: install.packages('pkgdown')")
  }

  if (!file.exists("DESCRIPTION")) {
    stop("Run this from the package root (the directory holding DESCRIPTION).")
  }

  internal <- "AGENTS.md"
  # Stash inside the package root: tempdir() is often on another filesystem,
  # and file.rename() cannot move across devices.
  stash <- ".AGENTS.md.pkgdown-stash"

  if (file.exists(stash)) {
    stop("Leftover ", stash, " from an interrupted build - restore it to ",
         internal, " before building again.")
  }

  if (file.exists(internal)) {
    if (!file.rename(internal, stash)) {
      stop("Could not move ", internal, " aside for the build.")
    }
    on.exit(file.rename(stash, internal), add = TRUE)
  }

  pkgdown::build_site(preview = FALSE)
}

build_docs()
