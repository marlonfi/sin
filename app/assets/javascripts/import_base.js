$(function() {
  $("#btnImportBase").click(function(){
    $.ajax({
         type : 'get',
         url : '/bases/import', // in here you should put your query 
         success : function(r){
            $('.modal-bodyra').show().html(r);     
        }
    });
  });
});
