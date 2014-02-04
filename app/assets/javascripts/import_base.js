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
  $("#btnImportJuntas").click(function(){
    $.ajax({
         type : 'get',
         url : '/bases/import_juntas', // in here you should put your query 
         success : function(r){
            $('.modal-bodyjunta').show().html(r);     
        }
    });
  });
});
