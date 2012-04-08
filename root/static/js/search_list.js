$(function() {
    $("tr.s-tr:even").css("background", "#eeeeee");
});

$(function() {
    var facet = $('.facet-li:gt(4)');
    facet.hide();
    var toggleBtn = $('div.showmore > a');
    toggleBtn.click(function(){
	if ( facet.is(":visible") ) {
	    facet.hide();
	    $('.showmore a span').text("显示全部品牌");	    
	} else {
	    facet.show();
	    $('.showmore a span').text("精简显示品牌");
	}
    });
});