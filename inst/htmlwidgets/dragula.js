HTMLWidgets.widget({

  name: 'dragula',

  type: 'output',

      initialize: function(el, width, height) {
        return {};
      },

      renderValue: function(el, x, instance) {

        if(instance.drag !== null)
        {
          // remove old instance of dragula
          instance.drag = null;
          instance.id   = null;
        }

        while(el.firstChild)
        {
          // remove old divs inside this object
          el.removeChild(el.firstChild);
        }


        // this code is used when x.x was created from string vector
        // in that case - values from that vector will be treated as a
        // elments' ids, and they will be pushed into dragula.

        instance.drag = dragula();


        if (typeof x.elid !== 'undefined' && x.elid !== null) {
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



        var onDrop = function (el) {

          var result = {}

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

         if (typeof Shiny === 'undefined') {
           $(document).on('shiny:connected', function(event) {
              if(typeof dragulaR === 'undefined') {
                dragulaR = new Map();
              }
              dragulaR.set(instance.id, onDrop);
              onDrop(el);
              instance.drag.on('drop', onDrop);
            });
         } else {
           if(typeof dragulaR === 'undefined') {
                dragulaR = new Map();
           }
           dragulaR.set(instance.id, onDrop);
           onDrop(el);
           instance.drag.on('drop', onDrop);
         }



      },

      resize: function(width, height) {
      }

});
