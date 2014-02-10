 $(document).ready(
    function()
    {
     
        $(".blocmetrics").click(
        function(event)
        {
            var clickedObject = $(event.target);
            var obj_id = (clickedObject.prop('id'));
            var obj_type = (clickedObject.prop('tagName'));
            var obj_html = (clickedObject.html());
            
            alert("I'm here: " + obj_html);
            
            $.ajax(
                {
                  type: "POST",
				  //url: "http://stereotype13-blocmetrics.herokuapp.com/event/data",
                  url: "/event/data",
                  data: { 
							webapp_key: "1234",
                            tag_id: obj_id,
                            tag_type: obj_type,
                            tag_html: obj_html,
							event_url: $(location).attr('href')
                        }
                }
            )
        });
    });

 