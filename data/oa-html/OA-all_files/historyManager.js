$(document).ready(function () {

	$('#searchManager').on('click', function(e) {
		e.preventDefault();
		var url = $(this).attr('href');
		$.get(url, function(data) {
			
			mydialog = $(data).dialog({
				modal: true,
				minWidth: 600,
				title: 'Your saved request'
			});

					//dialogue de confirmation
			$('.confirm').click(function () {
				confirm_oa();
				return false;
			});

			$('.historyEdit').on('click', function(e) {
				e.preventDefault();
				$name = $(this);
				var url = $name.attr('href');
				var params = {'name' : $(this).text()}
				$.get(url, params, function(data) {

					mydialog = $(data).dialog({
						modal: true,
						
						title: "Edit your request name"
					}); 

					$('#submitRequestName').on('click', function(e) {
						e.preventDefault();
						input = $('#requestName').val();
						$.post(url, {'name': input}, function() {
							$name.text(input);
							mydialog.dialog('close');
							mydialog.dialog('destroy');
						});
					});
				});
				
			});
	
			$('.putRequest').on('click', function(e) {
				e.preventDefault();
				var url = $(this).attr('href');
				$('#searchBlock').html('');
				$('#searchBlock').load(url, function() {
					$('form#frontmainBundle_advancedSearch').submit();
				});
				mydialog.dialog('close');
				mydialog.dialog('destroy');

				
			});

		});
	});

	//on va gérer ici la sauvegarde de l'historique de recherche
	$('#saveRequest').on('click', function(e) {
		e.preventDefault();
		$mybutton = $(this);
		if (!$mybutton.hasClass('disabled')) {
			var url = $mybutton.attr('href');
			var oForm = {};
				$('form#formCriteria [name]').each(function() {
					oForm[this.name] = this.value;
				});
			$.post(url, oForm, function(data) {
				$mybutton.addClass('disabled');
			});
		}

	});

	
});
