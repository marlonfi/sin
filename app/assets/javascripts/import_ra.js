$(function() {
  $("#btnImportRA").click(function(){
    $.ajax({
         type : 'get',
         url : '/red_asistencials/import', // in here you should put your query 
         success : function(r){
            $('.modal-bodyra').show().html(r);     
        }
    });
  });
});
