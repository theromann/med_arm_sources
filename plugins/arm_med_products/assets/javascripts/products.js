jQuery(document).ready(function($) {
  var path = '/users_select2_autocomplete';
  var limit = 25;
  $('#qa_action_maintainer_id').select2({
    allowClear: true,
    ajax: {
      url: path,
      dataType: 'json',
      data: function (term, page) {
        return {
          term: term,
          page: page
        };
      },
      results: function (data, page) {
        var more = (page * limit) < data.total;
        return {results: data.users, more: more};
      }
    },
    initSelection : function (element, callback) {
      var $element = $(element);
      var id = $element.val();
      if (id!=="") {
        $.ajax(path, {
          data: {
            single: true,
            user_id: id
          },
          dataType: "json"
        }).done(function(data) {
          if(data != null) {
            callback(data);
          }
          else {
            $element.val('');
            callback({id: '', text: ''})
          }
        });
      }
    }
  });
});