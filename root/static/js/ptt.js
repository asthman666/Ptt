$(function() {
    $("#eanlookup").click(function() {
	var data_q = $("#data-q").val();
	$.ajax({url:"/item?q=" + escape(data_q), success:function(result) {
	    $("#info").html(result);
	}});
    }
    );
});

$(function() {
    $("#q").click(function() {
	$("#q").val("");
    }
    );
});

