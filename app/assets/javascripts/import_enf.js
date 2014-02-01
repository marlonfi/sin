$(function() {
  $("#btnImportEnf1").click(function(){
    $.ajax({
         type : 'get',
         url : '/enfermeras/import_essalud', // in here you should put your query 
         success : function(r){
            $('.modal-bodyra').show().html(r);     
        }
    });
  });
});
