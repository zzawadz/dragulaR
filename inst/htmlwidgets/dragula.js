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


        if(x.simple)
        {
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

          return(null);
        }


        var uqId = el.id; // element id
        var tables = x.x;

        if(!Array.isArray(tables[0]))
        {
          // convert string vector into array of arrays
          // this is used when list with all elements of length one
          // was pushed from R
          tablesTmp = [];

          for(var i = 0; i < tables.length; i++)
          {
            tablesTmp[i] = [];
            tablesTmp[i].push(tables[i]);
          }

          tables = tablesTmp;
        }

        //initialize empty dragula object
        instance.drag = dragula();

        //create main div for holding all containers
        var bodyDiv = document.createElement('div');
        bodyDiv.id = "id-" + uqId + "-" + "body";
        bodyDiv.className = "dragura-body row";


        for(var i = 0; i < tables.length; i++)
        {
          var outerDiv = document.createElement('div');
          var tmpId = "id-" + uqId + "-" + i;
          outerDiv.id = tmpId;
          outerDiv.className = "dragura-container col-sm-3";


          for(var j = 0 ; j < tables[i].length; j++)
          {
            var innerDiv = document.createElement('div');
            innerDiv.className = "dragula-element";
            innerDiv.innerHTML = tables[i][j];
            outerDiv.appendChild(innerDiv);
          }

          instance.drag.containers.push(outerDiv);
          bodyDiv.appendChild(outerDiv);
        }


        // Add empty container
        var outerDiv = document.createElement('div');
        var tmpId = "id-" + uqId + "-" + tables.length;
        outerDiv.id = tmpId;
        outerDiv.className = "dragura-container col-sm-3";

        instance.drag.containers.push(outerDiv);
        bodyDiv.appendChild(outerDiv);


        el.appendChild(bodyDiv);


        var onDrop = function (el) {

          var container = document.getElementById(bodyDiv.id);
          var outer = container.children;
          var result = {};

          for(var i = 0; i < outer.length; i++)
          {
            result[i] = [];
            var inner = outer[i].children;

            for(var j = 0; j < inner.length; j++)
            {
                result[i].push(inner[j].innerHTML);
            }
          }


          if(outer[outer.length - 1].children.length > 0)
          {
            // Add empty container
              var outerDiv = document.createElement('div');
              var tmpId = "id-" + uqId + "-" + tables.length;
              outerDiv.id = tmpId;
              outerDiv.className = "dragura-container col-sm-3";

              container.appendChild(outerDiv);
              instance.drag.containers.push(outerDiv);
          }

          Shiny.onInputChange(uqId, result);
        };

        onDrop(el);
        instance.drag.on('drop', onDrop);
      },

      resize: function(width, height) {
      }

});
