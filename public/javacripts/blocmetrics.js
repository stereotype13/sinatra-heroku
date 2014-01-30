 $(document).ready(function(){
    $(".blocmetrics").click(function(event){
    var clickedObject = $(event.target);
    var obj_id = clickedObject.prop('id');
    var obj_type = clickedObject.prop('type');
    
    $.ajax({
      type: "POST",
      url: "http://stereotype13-blocmetrics.herokuapp.com/event/data",
      data: { parameter_1: "Hello",
              parameter_2: "World"
            }
    })
    });
  });
 });
 