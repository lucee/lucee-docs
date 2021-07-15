// close menu and/or tile if esc key is pressed
	$(document).keyup(function(e) {
		if ( e.which == '27' ) {
			if ($('.menu.open').length) {
				mReset();
			} else if (!$('body').hasClass('modal-open')) {
				tReset();
			}
		}
	})
	.keydown(function(e) {
		if (/input|textarea/i.test(e.target.tagName)){
			if (e.which === 9 && e.target.tagName == "TEXTAREA"){ // tabs are nice for code examples
				var ta = e.target;
				ta.value = ta.value.slice(0, ta.selectionStart) +
					String.fromCharCode(9) +
					ta.value.slice(ta.selectionStart);
			}
			return;
		}
		if ( e.which === 191 ) { // backslash /
			e.preventDefault();
			$( '.menu-toggle' ).click(); // open search menu
		}
	});