// menu backdrop
	if ((($('html').hasClass('touch') && $('.menu').length) || $('.nav-drawer').length) && !$('.menu-backdrop').length) {
		$('body').append('<div class="menu-backdrop"></div>');
	}

	var menuBD = document.getElementsByClassName('menu-backdrop')[0];

	if (menuBD !== undefined) {
		// Click events work for both mouse and touch on modern browsers
		menuBD.addEventListener('click', function(e) {
			if ($('.menu.open').length) {
				mReset();
			}
		});
	}

// menu close
	$(document).on('click', function(e) {
		var $target = $(e.target);

		if ($('.menu.open').length && !$target.is('.fbtn-container *, .menu *')) {
			mReset();
		}
	});

	var mReset = function () {
		var $bd = $('body');

		if ($bd.hasClass('menu-open')) {
			$bd.removeClass('menu-open');
		}

		if ($bd.hasClass('nav-drawer-open')) {
			$bd.removeClass('nav-drawer-open');
		}

		$('.menu-toggle').closest('.active').removeClass('active');

		if ($('.menu.open .menu-search-focus').length) {
			$('.menu.open .menu-search-focus').blur();
		}

		$('.menu.open').removeClass('open');
	};

// menu open
	$(document).on('click', '.menu-toggle', function(e) {
		e.preventDefault();
		e.stopPropagation();

		var $this = $(this),
			$thisLi = $this.parent(),
		    $thisMenu = $(getTargetFromTrigger($this));

		if ($thisLi.hasClass('active')) {
			mReset();
		} else {
			mReset();

			if ($thisMenu.hasClass('nav-drawer')) {
				$('body').addClass('nav-drawer-open');
			} else {
				$('body').addClass('menu-open');
			}

			$thisLi.addClass('active');
			$thisMenu.addClass('open');

			var lastSearch = null;
			if (localStorage)
				lastSearch = localStorage.getItem('lastSearch');
			var menu = $('.menu-search-focus', $thisMenu);
			if ( menu.length) {
				menu.focus();
				if (lastSearch){
					menu.val(lastSearch).trigger("input").select();
				}
			}
		}
	});