$(document).ready(function() {
    $.getJSON("https://api.myjson.com/bins/10rem", function(data) {
        var template = $('#template').html();
        Mustache.parse(template);
        var $list = Mustache.render(template, data);
        $("#app").html($list);
    });
});