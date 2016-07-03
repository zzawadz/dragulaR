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
        var ids = x.x;

        // hack when ids is just single string
        if(!Array.isArray(ids))
        {
          instance.drag.containers.push(document.getElementById(ids));
          return(null);
        }

        for(var i = 0; i < ids.length; i++)
        {
          console.log(document.getElementById(ids[i]));
          instance.drag.containers.push(document.getElementById(ids[i]));
        }

      },

      resize: function(width, height) {
      }

});
