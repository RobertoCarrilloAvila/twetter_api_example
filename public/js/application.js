$(document).ready(function() {

	$(".loading").hide();

	$("#formulario").submit(function() {
  		$(".other").css("opacity", "0.4")
		$(".loading").show();
	});



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
			$("#result").html("<h4>"+resp+"</h4>");
			$("#twettear > *").prop('disabled', false);
			$(".other").css("opacity", "1");
			$(".loading").hide();
			$("#area").val("");
		});

	});

});
