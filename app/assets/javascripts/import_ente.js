$(function() {
  $("#btnImportEnte").click(function(){
    $.ajax({
         type : 'get',
         url : '/entes/import', // in here you should put your query 
         success : function(r){
            $('.modal-bodyra').show().html(r);     
        }
    });
  });
});
