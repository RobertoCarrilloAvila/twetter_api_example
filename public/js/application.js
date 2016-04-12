$(document).ready(function() {

	$(".loading").hide();

	$("#formulario").submit(function() {
		$(".other").css("opacity", "0.4")
		$(".loading").show();
	});


	var id = "";
	$("#twettear").submit(function( event ) {
		event.preventDefault();
		var variables = $("#twettear").serialize();
		$(".other").css("opacity", "0.4");
		$(".loading").show();
		$("#twettear > *").prop('disabled', true);
		//console.log($("#twettear > *"));
		//console.log("formulario");
		//console.log(variables);
		$.post('/tweet', variables, function(resp) {
			//console.log(resp);
			//$("#result").html("<h4>"+resp+"</h4>");
			id = resp
			console.log(id);
			$("#twettear > *").prop('disabled', false);
			$(".other").css("opacity", "1");
			$(".loading").hide();
			$("#area").val("");
		});


		setInterval(update, 2500);

	});



	var update = function(){

		$.get("/status/"+id, function(resp) {
				//console.log(resp);
				console.log(resp);
				if(resp != "true") {
					$("#result").html("<h4>"+resp+"</h4>");
				}else{
					$("#result").html("<h4>true</h4>");
					clearInterval(update);
				}
			});
	};	

});
