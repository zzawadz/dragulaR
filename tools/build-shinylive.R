#!/usr/bin/env Rscript
#
# Export every example app in inst/apps/ to a static Shinylive site.
#
# The result is plain HTML/JS/wasm that runs entirely in the browser - no R
# server - so it can be dropped on GitHub Pages or any static host.
#
# Usage:
#   Rscript tools/build-shinylive.R [output_dir] [--allow-cran-fallback]
#
# Then preview locally with:
#   Rscript -e 'httpuv::runStaticServer("_shinylive")'
#
# How package versions are resolved
# ---------------------------------
# shinylive::export() vendors WebAssembly binaries into the site at build time.
# It picks where to fetch each one from by reading the DESCRIPTION of the copy
# installed *locally*: a "Repository: https://<user>.r-universe.dev" field sends
# it to r-universe, anything else falls back to repo.r-wasm.org, which mirrors
# CRAN.
#
# That matters here because CRAN still has dragulaR 0.3.1, which predates
# maxItems and copyOnly - examples 07 and 08 need >= 0.3.3. So dragulaR must be
# installed from r-universe before running this script:
#
#   install.packages("dragulaR", repos = "https://zzawadz.r-universe.dev")
#
# Otherwise the site builds "successfully" but ships an old dragulaR and those
# two examples break at runtime. The check below refuses to do that quietly.

args <- commandArgs(trailingOnly = TRUE)
allow_fallback <- "--allow-cran-fallback" %in% args
args <- setdiff(args, "--allow-cran-fallback")
site <- if (length(args) > 0) args[[1]] else "_shinylive"

apps_dir <- "inst/apps"
if (!dir.exists(apps_dir)) {
  stop("Run this from the package root (the directory holding DESCRIPTION).")
}

runiverse <- "https://zzawadz.r-universe.dev"

# --- Verify the dragulaR that will be vendored ------------------------------

if (!requireNamespace("dragulaR", quietly = TRUE)) {
  stop(
    "dragulaR must be installed for shinylive to resolve its wasm binary.\n",
    "  install.packages(\"dragulaR\", repos = \"", runiverse, "\")"
  )
}

desc <- utils::packageDescription("dragulaR")
repo <- desc$Repository
from_runiverse <- !is.null(repo) && grepl("r-universe\\.dev$", repo)
needed <- package_version("0.3.3")

if (!from_runiverse) {
  msg <- paste0(
    "The installed dragulaR (", desc$Version, ") has Repository: ",
    if (is.null(repo)) "<none>" else repo, ".\n",
    "shinylive will therefore vendor the CRAN build from repo.r-wasm.org, ",
    "which is older than ", needed, " and will break examples 07 and 08 ",
    "(maxItems / copyOnly) in the exported site.\n",
    "Fix with:\n  install.packages(\"dragulaR\", repos = \"", runiverse, "\")\n",
    "Or pass --allow-cran-fallback to build anyway."
  )
  if (allow_fallback) message("NOTE: ", msg) else stop(msg)
} else if (package_version(desc$Version) < needed) {
  stop(
    "dragulaR ", desc$Version, " from ", repo, " is older than ", needed, ". ",
    "r-universe may not have rebuilt master yet."
  )
}

# --- Export -----------------------------------------------------------------

apps <- sort(list.dirs(apps_dir, recursive = FALSE, full.names = FALSE))
apps <- apps[file.exists(file.path(apps_dir, apps, "app.R"))]
if (length(apps) == 0) stop("No app.R found under ", apps_dir)

message("Exporting ", length(apps), " apps to ", site, "/")

for (app in apps) {
  message("  - ", app)
  shinylive::export(file.path(apps_dir, app), site, subdir = app)
}

# --- Landing page -----------------------------------------------------------

links <- paste0(
  '      <li><a href="', apps, '/">', apps, '</a></li>',
  collapse = "\n"
)

writeLines(c(
  '<!doctype html>',
  '<html lang="en">',
  '  <head>',
  '    <meta charset="utf-8">',
  '    <meta name="viewport" content="width=device-width, initial-scale=1">',
  '    <title>dragulaR examples</title>',
  '    <style>',
  '      body { font-family: system-ui, sans-serif; max-width: 46rem;',
  '             margin: 3rem auto; padding: 0 1rem; line-height: 1.6; }',
  '      li { margin: .35rem 0; }',
  '      code { background: #f3f3f3; padding: .1rem .3rem; border-radius: 3px; }',
  '    </style>',
  '  </head>',
  '  <body>',
  '    <h1>dragulaR examples</h1>',
  '    <p>The example apps from <code>inst/apps/</code>, running entirely in',
  '       your browser via',
  '       <a href="https://posit-dev.github.io/r-shinylive/">Shinylive</a>.',
  '       The first load takes a few seconds while webR starts up.</p>',
  '    <ul>',
  links,
  '    </ul>',
  '    <p><a href="https://github.com/zzawadz/dragulaR">Source on GitHub</a></p>',
  '  </body>',
  '</html>'
), file.path(site, "index.html"))

message("Done. Preview with: Rscript -e 'httpuv::runStaticServer(\"", site, "\")'")
