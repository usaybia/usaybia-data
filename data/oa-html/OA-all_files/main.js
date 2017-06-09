$(document).ready(function () {
	
	$(document).tooltip({
		'track' : true
	});

	//dialogue de confirmation
	$('.confirm').click(function () {
		confirm_oa();
		return false;
	});
	
	$('#form_login_display').click(function () {
		$('#form_login').show()
	});
	
	$('#btnUp').click(function() {
		$('html, body').animate({scrollTop: 0}, 'slow');
	});

	$('#btnDown').click(function() {
		$('html, body').animate({scrollTop: $(document).height()}, 'slow');
	});
	
	$(window).scroll(function() {
		if ($(window).scrollTop() < 500) {
			$('#btnUp').fadeOut();
		} else {
			$('#btnUp').fadeIn();
		}

		//on récupère la hauteur de la fenetre et fait apparaître la fleche si elle n'est pas trop pres du bas
		windowHeight = $(document).height();
		windowTop = $(window).scrollTop();
		windowDiff = windowHeight - windowTop;
		if (windowHeight > 500 && windowDiff > $(window).height()) {
			$('#btnDown').fadeIn();
		} else {
			$('#btnDown').fadeOut();
		}

	});

	managerType();	

	$('#displayCat').on('click', function(e) {
		e.preventDefault();
		url = $(this).attr('href');
		$.get(url, function(data) {
			$mydata = $(data);
			$('#criteriaDefinition').html($mydata);
			var $dialog = $mydata.dialog({
				appendTo: '#criteriaDefinition',
				modal: false,
				minWidth: 400,
				height: 500,
			});
		});
		
	});
	
	$('.showMore').on('click', function() {
		$('.sourceMore').toggle();
		$('.showMore').toggle();
	});
});			
			
function confirm_oa() {
	if(confirm('Are you sure')) {
		if (this.attr('href'))
			document.location.href = this.attr('href');
	}
	return false;
}

/*    index    */
/*-------------*/
	
function loginFront() {
	$('#form_login').css('display','block');
	return 0;
}

function managerType() {
	$('.changeType').hover(
		function(e) {
			if (!$(this).hasClass('saving')) { 
				$(this).one('click', function() {
					changeType($(this));
				});
				$(this).children('span').hide();
				if ($(this).hasClass('btn-green'))
					$(this).addClass('addred btn-red').removeClass('btn-green');
				else if ($(this).hasClass('btn-red'))
					$(this).addClass('addgreen btn-green').removeClass('btn-red');
			}
			
		},
		function(e) {
			$(this).children('span').show();
			if ($(this).hasClass('addred'))
				$(this).removeClass('addred btn-red').addClass('btn-green');
			else if ($(this).hasClass('addgreen'))
				$(this).removeClass('addgreen btn-green').addClass('btn-red');
			$(this).off('click');
			if ($(this).hasClass('saving'))
				$(this.removeClass('saving'));
		}
		
	);
}

function changeType(elem) {
	id = $(elem).parents('ul.listActions').prev('table.entry').data('id');
	if (id) {
		url = $(elem).data('url');
		$(elem).addClass('saving');

		if ($(elem).hasClass('addred')) {
			params = {
				mode : 'changeType',
				idEntry : id,
				type : '1'
			};			
		}
		else if ($(elem).hasClass('addgreen')) {
			params = {
				mode : 'changeType',
				idEntry : id,
				type : '0'
			};		
		}
		else { params = null; }

		$.post(url, params, function(data) {
			if (data == 1) {
				$(elem).children('span').text('private')
				$(elem).addClass('addgreen').removeClass('btn-green addred');
			} else if (data == 0) {
				$(elem).children('span').text('public');
				$(elem).addClass('addred').removeClass('btn-red addgreen');				
			}
			$(elem).removeClass('saving');
			
		});
	}
}
