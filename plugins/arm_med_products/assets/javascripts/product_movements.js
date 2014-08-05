jQuery(document).ready(function($) {
  $('select.select2').select2();

  $('.product-movement-new').click(function(event) {
    event.preventDefault();
    event.stopPropagation();
    showModal('form-for-product-movement', '900px');
    $(".select2").select2();
  });
  $('#product-movement-submit, #product-movement-cancel').click(function() {
    hideModal(this);
  });

//    выбор "откуда - переренер product select"
    $('#form-for-product-movement').on('change', ".movement-from-select", function(){
        updateMovementProductSelect($(this));
    });

//    выбор "товар - утсанавливается макс и мин значение для возможности перенести"
    $('#form-for-product-movement').on('change', ".movement-product-select", function(){
        updateMaxProductCount($(this));
    });
});

function updateMovementProductSelect(elem) {
    var storage_id = elem.val();
    var product_select_id = elem.parents('.one-product-movement').find(".movement_product_select").attr("id");

    $.get("/products/get_products_in_movements"
        + "/?storage_id=" + storage_id
        + "&movement_product_select=" + product_select_id).done();
}

function updateMaxProductCount(elem) {
    var frame = elem.parents(".one-product-movement");

    var product_id = elem.val();
    var storage_id = frame.find(".movement-from").find('select').val();
    var product_count_input_id = frame.find("input[type=number]").attr('id');
    $.get("/products/get_max_in_movements"
        + "/?storage_id=" + storage_id
        + "&product_id=" + product_id
        + "&product_count_input_id=" + product_count_input_id).done();
}