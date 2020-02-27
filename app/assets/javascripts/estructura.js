function getHost(){
	if (window.location.pathname.includes("coesapp") || window.location.pathname.includes("coes_dev")){
		let aux = window.location.pathname.split("/")[1]
		return `/${aux}`
	}else {
		return ""
	}

}

function hexToRgbA (hex){
    var c;
    if(/^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)){
        c= hex.substring(1).split('');
        if(c.length== 3){
            c= [c[0], c[0], c[1], c[1], c[2], c[2]];
        }
        c= '0x'+c.join('');
        return 'rgba('+[(c>>16)&255, (c>>8)&255, c&255].join(',')+',0.5)';
    }
    throw new Error('Bad Hex');
}


function loadData(type, id, callback) {
	let currentUrl = window.location.href
	let controller = (currentUrl.includes('inscripcionsecciones')) ? 'inscripcionsecciones' : 'secciones'
	if (type == 'asignatura' || ((controller == 'secciones') && (type == 'catedra' || id == 'pci'))){
		getSecciones(type, id, controller)
	}else{
		paintTabObjects(type,id, controller, callback)
	}
}

function updatePage(type, id){
	limpiarResultados()
	setTab(type, id)
	setHeader()
	loadData(type, id)
}

function setHeader(){
	// console.log(sessionStorage.getItem('escuela'))
	if(sessionStorage.getItem('escuela') == 'pci') {
		$('#normalHeader').addClass('d-none')
		$('#pciHeader').removeClass('d-none')
	}else{
		$('#normalHeader').removeClass('d-none')
		$('#pciHeader').addClass('d-none')
	}
}

function limpiarResultados(){
	$('#responseTotal').hide()
	$('#tableResponse').html("")
	$('#noEncontrado').hide()
	$("#resultado tbody").html("")
	$("#horarioResponse").html("")
	
	$("#descAsignatura").html("") 
	$('#btnNewSeccion').hide()
}

function setAsignaturaToNewSeccion(id, desc){
	$('#_seccionasignatura_id').val(`${id}`)
	$('#newSeccionTitle').html(`Nueva Sección para ${desc}`)
}

function showNewAsig(id) {
	let desc = document.getElementById(`asignatura_${id}`).textContent.split("\n")[0]
	console.log(`desc: ${desc}, id: ${id}`)
	// let desc = $('#asignatura_'+id).text()
	setAsignaturaToNewSeccion(id, desc)

	$('#btnNewSeccion a').attr('onclick', "$('#newSeccion').modal()")
	$('#btnNewSeccion').show()
}

function getSecciones(type, id, controller) {
	$.ajax({
		url: `${getHost()}/secciones/get_secciones`,
		data: {id: id, type: type, controlador: controller},
		dataType: 'json', 
		beforeSend: function() {$('#cargando').modal({keyboard: false, show: true, backdrop: 'static'});},
		success: function(data){
			if(data.secciones_length === 0){
				$('#noEncontrado').show();
			}else{
				$('#tableResponse').html(data.th)
				if (type == 'asignatura' && controller == 'inscripcionsecciones'){
					let radios = document.getElementsByClassName(id)
					for (var i=0; i<radios.length; i++)  {
						
						let aux = document.getElementById('tr'+radios[i].id)
						if (aux !== null) radios[i].checked = true
					}
				}

			}
		},
		complete: function(){
			if (type != 'asignatura'){
				paintTabObjects(type,id, controller)
			}

			if (type == 'asignatura'){
				// let desc = $('#asignatura_'+id).text()
				let desc = document.getElementById("asignatura_"+id).firstChild.textContent
				let cred = document.getElementById("bagCreditos"+id).firstChild.textContent
				desc += " ("+cred+" Unidades de Créditos)"
				
				asig = $('#descAsignatura')
				asig.html(`${desc}`)
				asig.attr('href', `${getHost()}/asignaturas/${id}`)
				if (controller == 'secciones') showNewAsig(id)
			}
			$('#responseTotal').show()

			$('.modal').modal('hide')
			$('.tooltip-btn').tooltip()
		}
	});
}

function paintTabObjects(type, id,controller, callback){

	let ele = $(`#${type}Tabs`)
	ele.nextAll('.tabs').remove()

	$.ajax({

		url: `${getHost()}/secciones/get_tab_objects`,
		data: {type: type, value: id, controlador: controller},
		dataType: 'json', 
		success: function(data){
			$('#filterTabs').append(data.tabs)
		},
		beforeSend: function(){
			$('#cargando a').html(`Cangando ${type}... `)
			$('#cargando').modal({keyboard: false, show: true, backdrop: 'static'})
		},
		complete: function(){
			$('.modal').modal('hide')
			$('.tooltip-btn').tooltip()
		}

	});
	if (callback) callback()
}


function setTab(type, id){
	$.ajax({
		url: `${getHost()}/principal_admin/set_tab`, 
		data: {type: type, value: id}, 
		dataType: 'json'
		});
	sessionStorage.setItem(type, id)
}


// function sendFormViaAjax(event, este){
// 	event.preventDefault();
// 	console.log(este);
// 	var url = $(este)[0].form['action'];
// 	// var form = $('#newSeccionForm')[0]
// 	var form = $(este)[0].form
// 	// var form = document.getElementById('newSeccionForm');
// 	var data = new FormData(form);
// 	console.log(data)
// 	console.log(url);

// 	// $.post(url, data);

// 	$.ajax({
// 		url: `${getHost()}/secciones/10389`,
// 		data: {id: 'x', numero: 'A2'},
// 		type: 'POST',
// 		success: function(dataConfi){
// 			alert(dataConfi);
// 		}
// 	})

// 	// alert('Hola mundo');
// }

// $('#newSeccionBtnSubmitForm').on('click', function(event){
// 	event.preventDefault();
// 	let formu = $("#newSeccionForm").serialize();
// 	$.post(url, formu);
// })


function setAtributosSeccionForm(ele){

	let dataSon = ele.attributes['data-seccion'].value;
	dataSon = JSON.parse(dataSon);

	//console.log(dataSon);
	//$('#newSeccionForm').prop('action', `/secciones/${dataSon.id}`);

	let formulario = $('#newSeccionForm');
	let metodo = document.createElement('input');

	metodo.setAttribute('name', '_method');
	metodo.setAttribute('type', 'hidden');
	metodo.setAttribute('value', 'patch');
	metodo.setAttribute('id', 'patch');
	formulario.prop('action', `/secciones/${dataSon.id}`)
	formulario.append(metodo);
	formulario.find('input#_seccionnumero')[0].value = dataSon.numero;
	formulario.find('input#_seccioncapacidad')[0].value = dataSon.capacidad;
	formulario.find(`input#_secciontipo_seccion_id_${dataSon.tipo_seccion_id}`).prop('checked', true);


	formulario.find(`#seccion_profesor_id`).val(dataSon.profesor_id);
	formulario.find(`#seccion_profesor_id`).select2().trigger('change');
	// formulario.find(`#_seccion_profesor_id option[value=${dataSon.profesor_id}]`).attr('selected', 'selected');

	formulario.find('#_seccionasignatura_id').val(`${dataSon.asignatura_id}`)
	$('#newSeccionTitle').html(`Editar Sección ${dataSon.numero} de ${dataSon.asignatura_id}`)

	//$('#newSeccionForm input#_seccionnumero')[0].value = dataSon.numero;
	//$(`#newSeccionForm input#_secciontipo_seccion_id_${dataSon.tipo_seccion_id}`).prop('checked', true);
	//$('#newSeccionForm input#_seccioncapacidad')[0].value = dataSon.capacidad;
	//$(`#newSeccionForm input#_seccion_profesor_id option[value=${dataSon.profesor_id}]`).attr('selected', 'selected')


}
