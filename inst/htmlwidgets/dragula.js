// Global map to store dragulaR instances for refresh callbacks
if (typeof dragulaR === "undefined") {
    var dragulaR = new Map();
}

HTMLWidgets.widget({

  name: "dragula",

  type: "output",

    factory: function(el, width, height) {

        var instance = {
            drag: dragula(),
            id: el.id,
            maxItems: null
        };

        var shinyInputChange = function (el) {
            var result = {};
            for(var i = 0; i < instance.drag.containers.length; i++) {
                var container = instance.drag.containers[i];
                var res = [];
                document
          .querySelectorAll("#" + container.getAttribute("id") + " > [drag]")
          .forEach(function(x, id) { res[id] = x.getAttribute("drag");});
                result[container.getAttribute('id')] = res;
            }

            if (typeof Shiny.onInputChange !== "undefined") {
                Shiny.onInputChange(instance.id, result);
            }
        };

        // Is this necessary? Does dragula even use this element for anything?
        while(el.firstChild)
        {
            // remove old divs inside this object
            el.removeChild(el.firstChild);
        }

        return {
            renderValue: function(x) {
                // Store maxItems configuration
                instance.maxItems = x.maxItems || null;

                if (x.settings !== null) {
                    if (instance.drag !== null) {
                        instance.drag.destroy();
                        instance.drag = null;
                    }

                    // If maxItems is specified, wrap the accepts function
                    if (instance.maxItems !== null) {
                        var originalAccepts = x.settings.accepts;
                        x.settings.accepts = function(el, target, source, sibling) {
                            // Guard against null target (happens when dragging over non-container areas)
                            if (target === null) {
                                return false;
                            }

                            var targetId = target.getAttribute('id');

                            // Check maxItems constraint
                            if (instance.maxItems && instance.maxItems.hasOwnProperty(targetId)) {
                                var maxCount = instance.maxItems[targetId];
                                var currentCount = target.querySelectorAll('[drag]').length;

                                // If source is not the same as target, we're adding an item
                                if (source !== target && currentCount >= maxCount) {
                                    return false;
                                }
                            }

                            // Call original accepts function if it exists
                            if (typeof originalAccepts === 'function') {
                                return originalAccepts(el, target, source, sibling);
                            }

                            return true;
                        };
                    }

                    instance.drag = dragula(x.settings)
                                             .on("drop", shinyInputChange)
                                             .on("remove", shinyInputChange);
                }

                if (typeof x.elid !== "undefined" && x.elid !== null) {
                    instance.id = x.elid;
                } else {
                    instance.id = el.id;
                }

                var ids = x.x;

                // hack when ids is just single string
                if(!Array.isArray(ids))
                {
                    var container = document.getElementById(ids);
                    if (container !== null) {
                        instance.drag.containers.push(container);
                    } else {
                        console.warn("dragulaR: Container with id '" + ids + "' not found in DOM");
                    }
                } else {
                    for(var i = 0; i < ids.length; i++)
                    {
                        var container = document.getElementById(ids[i]);
                        if (container !== null) {
                            instance.drag.containers.push(container);
                        } else {
                            console.warn("dragulaR: Container with id '" + ids[i] + "' not found in DOM");
                        }
                    }
                }

                if (typeof Shiny === "undefined") {
                    $(document).on("shiny:connected", function(event) {
                        dragulaR.set(instance.id, shinyInputChange);
                        shinyInputChange(el);
                    });
                } else {
                    dragulaR.set(instance.id, shinyInputChange);
                    shinyInputChange(el);
                }

            },

            resize: function(width, height) {
            },

            drag: instance.drag
        };
    }
});
