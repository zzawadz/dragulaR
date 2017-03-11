# Drag'n'drop elements with *dragulaR*

[![Travis-CI Build Status](https://travis-ci.org/zzawadz/dragulaR.svg?branch=master)](https://travis-ci.org/zzawadz/dragulaR)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/zzawadz/dragulaR?branch=master&svg=true)](https://ci.appveyor.com/project/zzawadz/dragulaR)
[![Coverage Status](https://img.shields.io/codecov/c/github/zzawadz/dragulaR/master.svg)](https://codecov.io/github/zzawadz/dragulaR?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/dragulaR)](https://cran.r-project.org/package=dragulaR)

R's interface for ***[dragula](https://github.com/bevacqua/dragula)*** library for moving around elements in shiny app.

## Installation:

```r
source("https://install-github.me/zzawadz/dragulaR")
```

## Demo:

### Drag'n'drop plots:

```r
library(dragulaR)
path <- system.file("apps/example01-dragula", package = "dragulaR")
runApp(path, display.mode = "showcase")
```
![](media/basic.gif)

### Track what is in containers:

![](media/model.gif)
