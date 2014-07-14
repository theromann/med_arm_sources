jQuery(document).ready(function($) {
  $('fieldset.collapsible.collapsed').children('div').hide();
  $('fieldset.collapsible legend').click(function() {
    toggleFieldset(this);
  });
});