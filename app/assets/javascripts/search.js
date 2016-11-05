$(document).ready(function() {

  templates = {grouping: $('#pick_value_from_here').html()}

  $('button.add_fields').bind('click', function() {
    add_fields(this, $(this).data('fieldType'), $(this).data('content'));
    return false;
  });

  $('button.remove_fields').bind('click', function() {
    remove_fields(this);
    return false;
  });

  $('button.nest_fields').bind('click', function() {
    nest_fields(this, $(this).data('fieldType'));
    return false;
  });

});

function remove_fields(button) {
  $(button).closest('.fields').remove()
}

function add_fields(button, type, content) {
  new_id = new Date().getTime()
  regexp = new RegExp('new_' + type, 'g')
  $(button).before(content.replace(regexp, new_id))
}

function nest_fields(button, type) {
  new_id = new Date().getTime()
  id_regexp = new RegExp('new_' + type, 'g')
  template = templates[type]
  object_name = $(button).closest('.fields').attr('data-object-name')
  sanitized_object_name = object_name.replace(/\]\[|[^-a-zA-Z0-9:.]/g, '_').replace(/_$/, '')
  template = template.replace(/new_object_name\[/g, object_name + "[")
  template = template.replace(/new_object_name_/, sanitized_object_name + '_')
  $(button).before(template.replace(id_regexp, new_id))
}
