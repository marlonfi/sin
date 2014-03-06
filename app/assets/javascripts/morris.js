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

$(function() {
	Morris.Donut({
	  element: 'regimenes',
	  data: [
	    {value: $('#regimenes').data('cas'), label: 'CAS'},
	    {value: $('#regimenes').data('nombrados'), label: 'NOMBRADOS'},
	    {value: $('#regimenes').data('contratados'), label: 'CONTRATADOS'}
	  ],
	  backgroundColor: '#ccc',
	  labelColor: '#060',
	  colors: [
	    '#0BA462',
	    '#95D7BB',
	    '#39B580'
	  ],
	  formatter: function (x) { return x + " enfermeras"}
	});

	var day_data = $('#flujo_mensual').data('cen');
  Morris.Area({
	  element: 'flujo_mensual',
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
	  ymax: 180000,
  });
});


