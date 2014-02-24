$(function() {
  $("#btnImportPagos").click(function(){
    $.ajax({
         type : 'get',
         url : '/pagos/import', // in here you should put your query 
         success : function(r){
            $('.modal-bodypagos').show().html(r);     
        }
    });
  });
});
