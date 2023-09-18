# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # Changes values in product type according to value of product group
  $('#rate_calculator_form_product_group').change ->
    if $('#rate_calculator_form_product_group').val() is "DOM"
      # "Show options for DOM"
      $("#rate_calculator_form_product_type").html "<option value=\"ONP\" selected=\"selected\">Overnight Parcel</option><option value=\"PEC\">Economy Delivery</option><option value=\"CDA\">CDA</option>"
    else
      # "Show options for EXP"
      $("#rate_calculator_form_product_type").html "<option value=\"DPX\">Deferred Parcel Express</option>\n<option value=\"EPX\">Economy Parcel Express</option>\n<option value=\"GPX\">Ground Parcel Express</option>\n<option value=\"PPX\" selected=\"selected\">Priority Parcel Express</option></select>"
