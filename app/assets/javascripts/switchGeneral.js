$(document).ready(function(){
	$('.switchGeneral').on('change',function(){
		let obj = $(this);
      	let url = obj.attr('url');
      	toastr.options.timeOut = 1500;
		$.ajax({
			url: url,
			type: 'GET',
			dataType: 'json', 
			beforeSend: function(xhr) {
				xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
				$('#cargando a').html(`Cargando... `);
				$('#cargando').modal({keyboard: false, show: true, backdrop: 'static'});
			},
			success: function(json){
				if (json.type == 'error') {
					obj.prop('checked', !obj[0].checked)
					toastr.error(json.data)
				}else{toastr.success(json.data)}
			},
			error: function(json){
				obj.prop('checked', !obj[0].checked)
				toastr.error(json.data);
			},
			complete: function(){$('#cargando').modal('hide');}
		});
	})
});
