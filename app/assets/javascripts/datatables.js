// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require others/jquery.dataTables.js
//= require others/DT_bootstrap.js
$(function() {
  $('#example').dataTable( {
      "aaSorting": [[ 4, "desc" ]],
      "iDisplayLength": 25,
      "oLanguage": {
								    "sProcessing":     "Procesando...",
								    "sLengthMenu":     "Mostrar _MENU_ registros",
								    "sZeroRecords":    "No se encontraron resultados",
								    "sEmptyTable":     "Ningún dato disponible en esta tabla",
								    "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
								    "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
								    "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
								    "sInfoPostFix":    "",
								    "sSearch":         "Buscar:",
								    "sUrl":            "",
								    "sInfoThousands":  ",",
								    "sLoadingRecords": "Cargando...",
								    "oPaginate": {
								        "sFirst":    "Primero",
								        "sLast":     "Último",
								        "sNext":     "Siguiente",
								        "sPrevious": "Anterior"
								    },
								    "oAria": {
								        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
								        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
								    }
								}
  });
});