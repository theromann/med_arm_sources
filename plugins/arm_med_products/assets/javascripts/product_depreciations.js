jQuery(document).ready(function($) {

  $('select.select2').select2();

  $('.product-depreciation-new').click(function(event) {
    event.preventDefault();
    event.stopPropagation();
    showModal('form-for-product-depreciation', '900px');
    $(".select2").select2();
  });
  $('#product-depreciation-submit, #product-depreciation-cancel').click(function() {
    hideModal(this);
  });

  eventOnMovementFromSelect();
  eventOnMovementProductSelect();
});

function eventOnMovementFromSelect() {
    //    выбор "откуда - переренер product select"
    $('#form-for-product-depreciation').on('change', ".depreciation-from-select", function(){
        updateMovementProductSelect($(this));
    });
}

function eventOnMovementProductSelect() {
    //    выбор "товар - утсанавливается макс и мин значение для возможности перенести"
    $('#form-for-product-depreciation').on('change', ".depreciation-product-select", function(){
        updateMaxProductCount($(this));
    });
}

function updateMovementProductSelect(elem) {
    var storage_id = elem.val();
    var product_select_id = elem.parents('.one-product-movement').find(".movement_product_select").attr("id");

    $.get("/products/get_products_in_depreciations"
        + "/?storage_id=" + storage_id
        + "&depreciation_product_select=" + product_select_id).done();
}

function updateMaxProductCount(elem) {
    var frame = elem.parents(".one-product-movement");

    var product_id = elem.val();
    var storage_id = frame.find(".movement-from").find('select').val();
    var product_count_input_id = frame.find("input[type=number]").attr('id');
    $.get("/products/get_max_in_depreciations"
        + "/?storage_id=" + storage_id
        + "&product_id=" + product_id
        + "&product_count_input_id=" + product_count_input_id).done();
}