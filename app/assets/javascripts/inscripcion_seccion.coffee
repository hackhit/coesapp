# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


chequear_total_seleccionados = ->
  total = $('input:radio:checked').length
  if total > 0
    $('#btn-confirmacion').removeAttr 'disabled'
    $('#seleccion').show()
  else
    $('#btn-confirmacion').attr 'disabled', 'disabled'
    $('#seleccion').hide()
  return

borrar_seleccion = (asignatura_id) ->
  $('.' + asignatura_id).prop 'checked', false
  $('.sel_' + asignatura_id).hide()
  chequear_total_seleccionados()
  return

agregar_a_seleccion = (asignatura_id, seccion_numero) ->
  $('.sel_' + asignatura_id).hide()
  $('#sel_' + asignatura_id + '_' + seccion_numero).show()
  chequear_total_seleccionados()
  return