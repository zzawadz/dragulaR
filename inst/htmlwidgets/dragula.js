HTMLWidgets.widget({

  name: 'dragula',

  type: 'output',

    factory: function(el, width, height) {

        var shinyInputChange = function (el) {
            var result = {};
            for(var i = 0; i < instance.drag.containers.length; i++) {
                var container = instance.drag.containers[i];
                var res = [];
                document
          .querySelectorAll("#" + container.getAttribute('id') + ' > [drag]')
          .forEach(function(x, id) { res[id] = x.getAttribute("drag");});
                result[container.getAttribute('id')] = res;
            }

            if (typeof Shiny.onInputChange !== 'undefined') {
                Shiny.onInputChange(instance.id, result);
            }
        };

        // Is this necessary? Does dragula even use this element for anything?
        while(el.firstChild)
        {
            // remove old divs inside this object
            el.removeChild(el.firstChild);
        }

        var instance = {
            drag: dragula(),
            id: el.id
        };

        return {
            renderValue: function(x) {
                if (x.settings !== null) {
                    if (instance.drag !== null) {
                        instance.drag.destroy();
                        instance.drag = null;
                    }
                    instance.drag = dragula(x.settings)
                                             .on('drop', shinyInputChange)
                                             .on('remove', shinyInputChange);
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
                    instance.drag.containers.push(document.getElementById(ids));
                } else {
                    for(var i = 0; i < ids.length; i++)
                    {
                        instance.drag.containers.push(document.getElementById(ids[i]));
                    }
                }

                if (typeof Shiny === 'undefined') {
                    $(document).on('shiny:connected', function(event) {
                        if(typeof dragulaR === 'undefined') {
                            dragulaR = new Map();
                        }
                        dragulaR.set(instance.id, shinyInputChange);
                        shinyInputChange(el);
                    });
                } else {
                    if(typeof dragulaR === 'undefined') {
                        dragulaR = new Map();
                    }
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
