$('#second_fila').html('<%= escape_javascript(render("bases/ajax_html/anual_money_chart")) %>');
$('#third_fila').html('<%= escape_javascript(render("bases/ajax_html/anual_enfermeras_chart")) %>');

var day_data = $('#base_money_mensual').data('base');
Morris.Area({
  element: 'base_money_mensual',
  data: day_data,
  xkey: 'month',
  ykeys: ['cn', 'cas'],
  labels: ['CN', 'CAS'],
  preUnits: 'S/. ',
  parseTime: false,
  lineColors: [
    '#69D2E7',
    '#F38630'
  ],
});
Morris.Bar({
	element: 'base_enfermeras_chart',
	data: $('#base_enfermeras_chart').data('enfermeras'),
	xkey: 'month',
	ykeys: ['enfermeras'],
	labels: ['Agremiados'],
	barColors: ['#FF6B6B'],
});

$('#loadingspan').remove();