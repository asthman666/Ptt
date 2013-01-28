$.getJSON('/api/init_q', function(data) {
    var init_q = data.init_q;
    if ( $("#q").attr("value") == "" ) {
        $("#q").val("输入手机型号, 例如: " + init_q);
        $("#cq").val("输入手机型号, 例如: " + init_q);
    }
});

$(function() {
    var regex = new RegExp("^输入手机型号");
    $('#q').focus(function() {
        var init_val = $("#q").attr("value");
        if(regex.test(init_val)) {
            $(this).val("");
        }
    });
    $('#q').blur(function() {
        var init_val = $("#cq").attr("value");
        if($(this).attr("value") == "") {
            $(this).val(init_val);
        }
    });
});

