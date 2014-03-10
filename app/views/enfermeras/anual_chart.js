$('#bar_chart').html('<%= escape_javascript(render("enfermeras/ajax_html/anual_chart")) %>');
Morris.Bar({
	element: 'agremiados_mensual',
	data: $('#agremiados_mensual').data('enfermeras'),
	xkey: 'month',
	ykeys: ['enfermeras'],
	labels: ['Agremiados'],
	barColors: ['#FF6B6B'],
});
$('#loadingspan').remove();