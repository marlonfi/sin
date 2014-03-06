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
//= require chosen/chosen.jquery.min.js
//= require chosen/prism.js

$(function() {
 $("#ente_red_asistencial_id").chosen();
 $("#enfermera_ente_id").chosen();
 $("#ente_base_id").chosen();
 $("#bitacora_ente_inicio").chosen();
 $("#bitacora_ente_fin").chosen();
 $("#base_codigo_base").chosen();
 $("#base_miembros").chosen();
});


