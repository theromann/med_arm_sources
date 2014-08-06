jQuery(document).ready(function($) {
    $('.issues .status').each(function() {
        if($(this).html().trim()=="Критично"){
            $(this).css('backgroundColor', '#FF3F4C');
            $(this).css('color', 'white');
        }
        if($(this).html().trim()=="Мало"){
            $(this).css('backgroundColor', '#F9966B');
            $(this).css('color', 'white');
        }
        if($(this).html().trim()=="Нормально"){
            $(this).css('backgroundColor', '#FBF6D9');
        }
        if($(this).html().trim()=="Много"){
            $(this).css('backgroundColor', '#93CC67');
            $(this).css('color', 'white');
        }
    });
});




