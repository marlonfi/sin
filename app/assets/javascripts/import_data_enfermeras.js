$(function() {
  $("#btnActDataEnf").click(function(){
    $.ajax({
         type : 'get',
         url : '/enfermeras/import_data_actualizada', // in here you should put your query 
         success : function(r){
            $('.modal-bodyActualizarData').show().html(r);     
        }
    });
  });
});
