$(function() {
    $("#eanlookup").click(function() {
	var data_ean = $("#data-ean").val();
	$.ajax({url:"/ean/" + data_ean, success:function(result) {
	    $("#info").html(result);
	}});
    }
    );
});
