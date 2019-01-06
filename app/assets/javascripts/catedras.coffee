# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.upcase').on 'input', (evt) ->
  node = $(this)
  node.val node.val().replace(/[^a-zA-Z]/g, '')
  node.val node.val().toUpperCase()
  return