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
				  url: "/event/data",
                  data: { 
							webapp_key: "6DMsQrH9qjeIzJROp+slN3lj",
                            tag_id: obj_id,
                            tag_type: obj_type,
							event_url: $(location).attr('href')
                        }
                }
            )
        });
    });

 