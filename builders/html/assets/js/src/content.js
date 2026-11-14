// fixed left/right hand side column affix
	var contentPadding = 0,
	    footerOffset = 0;

	if ($('.content').length) {
		contentPadding = parseInt($('.content').css('padding-bottom').replace('px', ''));
	}

	$(window).on('scroll', function() {
		$('.content-fix').each(function() {
			if ($(this).outerHeight() < $(this).closest('.row-fix').outerHeight()) {
				contentFix($(this));
			}
		});
	});

	var contentFix = function (content) {
		var scrolled = window.innerHeight + window.pageYOffset;

		if (window.pageYOffset >= (content.offset().top - headerHeight)) {
			if ((content.is('[class*="col-xx"]')) || (content.is('[class*="col-xs"]') && $(window).width() >= 480) || (content.is('[class*="col-sm"]') && $(window).width() >= 768) || (content.is('[class*="col-md"]') && $(window).width() >= 992) || (content.is('[class*="col-lg"]') && $(window).width() >= 1440)) {
				if (!content.hasClass('fixed')) {
					content.addClass('fixed');
					$('.content-fix-wrap', content).scrollTop(0);
				}
				if (footerOffset != 0 && footerOffset <= scrolled) {
					$('.content-fix-inner', content).css('padding-bottom', (scrolled - footerOffset + contentPadding));
				}
			}
		} else {
			content.removeClass('fixed');
			$('.content-fix-inner', content).css('padding-bottom', '');
		}
	};

// fixed left/right hand side column padding bottom and width
	var contentFixPushCal = function () {
		$('.content-fix-scroll').each(function() {
			$(this).css('width', $(this).closest('.content-fix').outerWidth());
			$('.content-fix-inner', $(this)).css('width', $(this).closest('.content-fix').width());
		});

		if ($('.footer').length) {
			footerOffset = $('.footer').offset().top;
		}
	};
	// allow hiding descriptions for functions or tags with lots of arguments/attributes
	$(".collapse-description").click(function(){
		var $btn = $(this);
		var data = $btn.data();
		var $tbl = $("#" + data.target);
		$tbl.find('tr > *:nth-child(2)').toggle(!data.expanded);
		$tbl.find('tr > *:nth-child(3)').toggle(!data.expanded);
		var newExpanded = !data.expanded;
		$btn.data("expanded", newExpanded);
		var collapseText = data.collapseText || "Collapse All";
		var expandText = data.expandText || "Expand All";
		$btn.text(newExpanded ? collapseText : expandText);

		if (!data.installed){
			$btn.data("installed", true);
			$("#" + data.target + " TBODY TR").click(function(){
				var $tr = $(this);
				var hidden = $tr.find("*:nth-child(2)").is(":visible");
				$tr.find("*:nth-child(2)").toggle(hidden);
				$tr.find("*:nth-child(3)").toggle(hidden);
			});
		}
	});

	// Filter for function arguments table
	$("#argument-filter").on('input', function() {
		var filterText = $(this).val().toLowerCase();
		var $rows = $("#table-arguments tbody tr");

		if (!filterText) {
			$rows.show();
		} else {
			$rows.each(function() {
				var $row = $(this);
				var text = $row.text().toLowerCase();
				if (text.indexOf(filterText) !== -1) {
					$row.show();
				} else {
					$row.hide();
				}
			});
		}
	});

	// Filter for tag attributes table
	$("#attribute-filter").on('input', function() {
		var filterText = $(this).val().toLowerCase();
		var $rows = $("#tag-attributes tbody tr");

		if (!filterText) {
			$rows.show();
		} else {
			$rows.each(function() {
				var $row = $(this);
				var text = $row.text().toLowerCase();
				if (text.indexOf(filterText) !== -1) {
					$row.show();
				} else {
					$row.hide();
				}
			});
		}
	});
	// Filter for system properties/environment variables listing
	$('#sysprop-filter').on('input', function() {
		var filterText = $(this).val().toLowerCase();
		var $listing = $('.sysprop-envvar-listing');
		var $sections = $listing.find('h2');

		if (!filterText) {
			// Show all
			$listing.find('h2, h4, p').show();
		} else {
			// Filter entries - each entry is h4 followed by p tags until next h4 or h2
			$listing.find('h4').each(function() {
				var $h4 = $(this);
				var $entry = $h4.add($h4.nextUntil('h2, h4'));
				var text = $entry.text().toLowerCase();

				if (text.indexOf(filterText) !== -1) {
					$entry.show();
				} else {
					$entry.hide();
				}
			});

			// Hide empty category sections
			$sections.each(function() {
				var $h2 = $(this);
				var visibleCount = $h2.nextUntil('h2', 'h4:visible').length;
				if (visibleCount > 0) {
					$h2.show();
				} else {
					$h2.hide();
				}
			});
		}
	});

