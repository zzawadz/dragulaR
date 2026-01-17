# dragulaR Package Improvement Proposal

## Executive Summary

This document analyzes the dragulaR package (v0.3.3) and proposes improvements across code quality, features, documentation, testing, and user experience. The package provides an excellent foundation for drag-and-drop functionality in Shiny, but several enhancements could improve reliability, developer experience, and functionality.

---

## 1. Code Quality & Bug Fixes

### 1.1 Design Note: `dragulaValue()` Namespace Handling

**Location:** `R/dragula.R:147-157`

**Current behavior:** The function uses `tail(strsplit(...), 1)` to extract container names, returning only the last segment after splitting by `-`.

```r
# Current implementation
names(x) <- vapply(
  names(x),
  FUN.VALUE = "",
  function(y) tail(strsplit(y, split = "-")[[1]], 1))
```

**This is correct by design.** Shiny modules use `-` as the namespace separator, so `ns-child-container` represents:
- `ns` - parent module namespace
- `child` - child module namespace
- `container` - the actual element ID

Using `-` in element IDs is discouraged in Shiny for this reason. The current behavior correctly extracts just the element ID without namespace prefixes.

**Documentation recommendation:** Add a note in `dragulaValue()` documentation explaining this behavior and warning users not to use hyphens in container IDs.

### 1.2 Missing Input Validation

**Location:** `R/dragula.R:37-91`

**Issues:**
1. No validation that container IDs are valid HTML IDs (no spaces, special characters)
2. No check for duplicate container IDs

**Proposed additions:**
```r
# Validate container IDs
validate_container_ids <- function(ids) {
  # Check for duplicates
  if (any(duplicated(ids))) {
    stop("Duplicate container IDs are not allowed: ",
         paste(ids[duplicated(ids)], collapse = ", "))
  }

  # Check for invalid HTML ID characters
  invalid <- grepl("[^a-zA-Z0-9_-]", ids)
  if (any(invalid)) {
    stop("Invalid container IDs (use only letters, numbers, underscores, hyphens): ",
         paste(ids[invalid], collapse = ", "))
  }
}
```

### 1.3 JavaScript Error Handling

**Location:** `inst/htmlwidgets/dragula.js`

**Issue:** Limited error handling when containers don't exist. Currently only logs a warning but continues execution.

**Proposed improvement:** Add optional strict mode that throws errors:
```javascript
if (container !== null) {
    instance.drag.containers.push(container);
} else {
    if (x.strictMode) {
        throw new Error("dragulaR: Container with id '" + ids[i] + "' not found in DOM");
    }
    console.warn("dragulaR: Container with id '" + ids[i] + "' not found in DOM");
}
```

---

## 2. New Features

### 2.1 Event Callbacks

**Priority: High**

Currently, only `drop` and `remove` events trigger Shiny input updates. Dragula supports many more events that would be useful:

- `drag` - when an element starts being dragged
- `dragend` - when dragging ends
- `cancel` - when drag operation is cancelled
- `cloned` - when an element is cloned
- `shadow` - when a shadow element is created
- `over` - when dragging over a container
- `out` - when leaving a container

**Proposed API:**
```r
dragula(
  c("source", "target"),
  onDrag = JS("function(el) { Shiny.setInputValue('drag_started', el.id); }"),
  onCancel = JS("function(el) { Shiny.setInputValue('drag_cancelled', el.id); }")
)
```

### 2.2 Disable/Enable Containers Dynamically

**Priority: High**

Add ability to enable/disable drag-and-drop on specific containers at runtime:

```r
# R API
disableDragula(session, "container_id")
enableDragula(session, "container_id")

# Or via Shiny message handlers
session$sendCustomMessage("dragulaDisable", list(containerId = "source"))
```

### 2.3 Sortable Within Single Container

**Priority: Medium**

Add explicit support for sorting within a single container (reordering list items):

```r
dragulaSort("myList")  # Simpler API for single-container sorting
```

### 2.4 Programmatic Move/Copy

**Priority: Medium**

Allow moving elements programmatically from R:

```r
moveElement(session, elementId = "item1", from = "source", to = "target")
copyElement(session, elementId = "item1", from = "source", to = "target")
```

### 2.5 Animation Support

**Priority: Low**

Add smooth animations for drag operations:

```r
dragula(c("a", "b"), animation = TRUE, animationDuration = 200)
```

### 2.6 Touch Device Improvements

**Priority: Medium**

Dragula supports touch devices, but add explicit configuration options:

```r
dragula(c("a", "b"),
  touchDelay = 100,  # Delay before drag starts on touch
  scrollSensitivity = 20  # Auto-scroll near edges
)
```

---

## 3. Documentation Improvements

### 3.1 Missing Documentation

**Items needing documentation:**

1. **Shiny module usage** - While example04 demonstrates modules, there's no vignette explaining best practices
2. **CSS customization** - No guidance on styling drag operations
3. **Performance considerations** - No documentation on handling large numbers of draggable items
4. **Troubleshooting guide** - Common issues and solutions

### 3.2 Vignette Structure

**Proposed vignettes:**

1. `getting-started.Rmd` - Basic usage and concepts
2. `advanced-options.Rmd` - copyOnly, maxItems, custom accepts functions
3. `shiny-modules.Rmd` - Using dragulaR with Shiny modules
4. `custom-styling.Rmd` - CSS customization guide
5. `troubleshooting.Rmd` - Common issues and solutions

### 3.3 Function Documentation Improvements

**`dragula()`:**
- Add `@seealso` linking to dragula JS documentation
- Document all standard dragula options with examples
- Add return value section describing the widget structure

**`dragulaValue()`:**
- Document edge cases (empty containers, nested namespaces)
- Add more examples showing typical usage patterns

### 3.4 README Improvements

1. **Outdated installation method:**
   ```r
   # Current (deprecated)
   source("https://install-github.me/zzawadz/dragulaR")

   # Should use
   remotes::install_github("zzawadz/dragulaR")
   # Or
   pak::pak("zzawadz/dragulaR")
   ```

2. **Add CRAN installation:**
   ```r
   install.packages("dragulaR")
   ```

3. **Add usage example directly in README** instead of only referencing example apps

---

## 4. Test Coverage Enhancements

### 4.1 Current Coverage Gaps

**Missing test scenarios:**

1. **dragulaValue with nested module namespaces**
   ```r
   test_that("dragulaValue correctly extracts element ID from nested namespaces", {
     # Simulates ns-child-container from nested Shiny modules
     input <- list(`ns-child-container` = list("a", "b"))
     result <- dragulaValue(input)
     expect_equal(names(result), "container")  # Correctly returns just the element ID
   })
   ```

2. **Error conditions**
   ```r
   test_that("dragula throws error for empty container vector", {
     expect_error(dragula(character(0)))
   })

   test_that("dragula throws error for NA values", {
     expect_error(dragula(c("a", NA, "b")))
   })
   ```

3. **Edge cases for copyOnly + maxItems combination**
   ```r
   test_that("copyOnly and maxItems work together correctly", {
     result <- dragula(
       c("Source", "Target"),
       copyOnly = "Source",
       maxItems = list(Target = 2)
     )
     # Verify both constraints are applied
     expect_s3_class(result$x$settings$accepts, "JS_EVAL")
     expect_equal(result$x$maxItems$Target, 2)
   })
   ```

4. **JavaScript integration tests** using shinytest2

### 4.2 Proposed Test Structure

```
tests/
  testthat/
    test-dragula-creation.R      # Basic creation and validation
    test-dragula-options.R       # Options handling
    test-dragulaValue.R          # dragulaValue function
    test-useDragulajs.R          # JavaScript integration
    test-edge-cases.R            # Edge cases and error handling
```

### 4.3 Integration Testing

Add shinytest2 tests for end-to-end testing:

```r
test_that("drag and drop updates input correctly", {
  app <- AppDriver$new(
    system.file("apps/example02-input", package = "dragulaR")
  )

  # Simulate drag operation
  app$run_js("...")

  # Verify input was updated
  expect_equal(app$get_value(input = "dragula"), expected_value)
})
```

---

## 5. Performance Optimizations

### 5.1 Debounce Shiny Input Updates

**Location:** `inst/htmlwidgets/dragula.js:20-34`

**Issue:** Every drag operation immediately triggers `Shiny.onInputChange()`, which can cause performance issues with rapid operations.

**Proposed fix:**
```javascript
var debounce = function(func, wait) {
    var timeout;
    return function() {
        var context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            func.apply(context, args);
        }, wait);
    };
};

var shinyInputChange = debounce(function(el) {
    // ... existing logic
}, 100);  // 100ms debounce
```

### 5.2 Lazy Container Discovery

**Issue:** All containers are queried on initialization even if they're not visible/needed yet.

**Proposed improvement:** Add lazy initialization option for containers rendered via `renderUI`:

```r
dragula(c("a", "b"), lazy = TRUE)
```

### 5.3 Batch Updates

When multiple operations happen quickly (e.g., programmatic moves), batch Shiny updates:

```javascript
var pendingUpdate = false;
var batchShinyInputChange = function() {
    if (!pendingUpdate) {
        pendingUpdate = true;
        requestAnimationFrame(function() {
            shinyInputChange();
            pendingUpdate = false;
        });
    }
};
```

---

## 6. User Experience Improvements

### 6.1 Better Error Messages

**Current:** Generic "x must be a character vector!"

**Proposed:**
```r
if (!is.character(x)) {
  stop(sprintf(
    "Expected character vector for container IDs, got %s. ",
    class(x)[1],
    "Use dragula(c('container1', 'container2')) format."
  ))
}
```

### 6.2 Console Logging Option

Add debug mode for troubleshooting:

```r
dragula(c("a", "b"), debug = TRUE)
```

```javascript
if (x.debug) {
    console.log("dragulaR: Initializing with containers:", ids);
    console.log("dragulaR: Settings:", x.settings);
}
```

### 6.3 Visual Feedback CSS

Provide optional CSS classes for better drag feedback:

```css
/* Bundled optional stylesheet */
.dragula-dragging {
  opacity: 0.7;
  transform: rotate(2deg);
}

.dragula-over {
  background-color: rgba(0, 123, 255, 0.1);
  border: 2px dashed #007bff;
}
```

### 6.4 Accessibility Improvements

Add ARIA attributes for screen readers:

```javascript
container.setAttribute('aria-dropeffect', 'move');
draggableElement.setAttribute('aria-grabbed', 'false');

instance.drag.on('drag', function(el) {
    el.setAttribute('aria-grabbed', 'true');
});
```

---

## 7. Architecture Improvements

### 7.1 Modular JavaScript

Split `dragula.js` into smaller modules:

```
inst/htmlwidgets/
  dragula.js          # Main entry point
  lib/
    dragulaR/
      instance.js     # Instance management
      shiny-binding.js # Shiny integration
      utils.js        # Utility functions
```

### 7.2 TypeScript Migration

Consider migrating JavaScript to TypeScript for better maintainability:

```typescript
interface DragulaRInstance {
    drag: Drake;
    id: string;
    maxItems: Record<string, number> | null;
}
```

### 7.3 Remove V8 Dependency

**Location:** `R/dragula.R:56-61`

The V8 package is imported but `JS()` from htmlwidgets could handle all current use cases. The V8 dependency adds installation complexity (requires external library).

**Current usage:**
```r
settings[['copy']] <- JS("function(el, source) { ... }")
```

This already uses `htmlwidgets::JS`, not V8. The V8 import appears unused and can be removed.

---

## 8. Dependency Updates

### 8.1 Dragula Library Version

**Current:** 3.7.2 (from 2019)

**Latest:** Check for updates at https://github.com/bevacqua/dragula

### 8.2 Consider Optional Dependencies

Move `shinyjs` to Suggests if `useDragulajs()` becomes less commonly needed:

```r
useDragulajs <- function() {
  if (!requireNamespace("shinyjs", quietly = TRUE)) {
    stop("Package 'shinyjs' is required for this function. ",
         "Install it with: install.packages('shinyjs')")
  }
  # ... rest of function
}
```

---

## 9. Implementation Priority

### High Priority (Should Fix)
1. Add input validation for container IDs
2. Update README installation instructions
3. Add missing test coverage
4. Document `dragulaValue()` namespace behavior

### Medium Priority (Nice to Have)
1. Event callbacks for drag/dragend/cancel
2. Disable/enable containers dynamically
3. Debounce Shiny input updates
4. Add vignettes
5. Remove unused V8 dependency

### Low Priority (Future Consideration)
1. TypeScript migration
2. Animation support
3. Programmatic move/copy API
4. Accessibility improvements

---

## 10. Breaking Changes to Consider

If planning a major version bump (0.4.0 or 1.0.0):

1. **Add strict input validation** - May reject previously accepted invalid container IDs
2. **Remove deprecated patterns** if any exist
3. **Standardize option names** to match dragula.js conventions more closely
4. **Remove V8 dependency** - If confirmed unused, removal simplifies installation

---

## Conclusion

The dragulaR package is well-designed and functional. The proposed improvements focus on:

1. **Reliability** - Better error handling and edge case coverage
2. **Developer Experience** - Improved documentation and error messages
3. **Performance** - Optimizations for rapid operations
4. **Features** - Event callbacks and dynamic control

Implementation of these improvements would make dragulaR an even more robust choice for drag-and-drop functionality in Shiny applications.
