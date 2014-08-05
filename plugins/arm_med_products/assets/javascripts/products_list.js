jQuery(document).ready(function($) {
  $('.product-movement-new').click(function(event) {
    event.preventDefault();
    event.stopPropagation();
    showModal('form-for-product-movement', '900px');
    $(".select2").select2();
  });
  $('#product-movement-submit, #product-movement-cancel').click(function() {
    hideModal(this);
  });

  var currentScrollBar = null;

  $(".sync-scroll-bars").scroll(function() {
    if (!$(this).is(currentScrollBar)) return;
    var percentsToScroll = $(this).scrollLeft() /
        ( $(this).width() - $(".sync-scroll-bars table").width() );
    var pixelsToScroll = ( $("#hor-scroll-wrapper").width() -
        $("#hor-scroll").width() ) * percentsToScroll;
    $("#hor-scroll-wrapper").scrollLeft( pixelsToScroll );
  });

  $("#hor-scroll-wrapper").scroll(function() {
    if (!$(this).is(currentScrollBar)) return;
    var percentsToScroll = $(this).scrollLeft() /
        ( $(this).width() - $("#hor-scroll").width() );
    var pixelsToScroll = ( $(".sync-scroll-bars").width() -
        $(".sync-scroll-bars table").width() ) * percentsToScroll;
    $(".sync-scroll-bars").scrollLeft( pixelsToScroll );
  });

  $(".sync-scroll-bars, #hor-scroll-wrapper").mousedown(function() {
    currentScrollBar = $(this);
  });

  $(window).resize(function() {
    adjustScrollBars();
  });

  adjustScrollBars();

  function adjustScrollBars() {
    var scrollChange =  ($(".sync-scroll-bars table").width() /
        $(".sync-scroll-bars").width() ) * $("#hor-scroll-wrapper").width();
    $("#hor-scroll").width(scrollChange);
  }
});
