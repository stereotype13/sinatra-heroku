 $(document).ready(
    function()
    {
     
        $(".blocmetrics").click(
        function(event)
        {
            var clickedObject = $(event.target);
            var obj_id = (clickedObject.prop('id'));
            var obj_type = (clickedObject.prop('tagName'));
            
            alert("I'm here");
            
            $.ajax(
                {
                  type: "POST",
				  url: "http://stereotype13-blocmetrics.herokuapp.com/event/data",
                  data: { 
							webapp_key: "1234",
                            tag_id: obj_id,
                            tag_type: obj_type,
							event_url: $(location).attr('href')
                        }
                }
            )
        });
    });

 