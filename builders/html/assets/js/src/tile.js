// tile
	$(document).on('click', function(e) {
		var $target = $(e.target);

		if ($target.is('[data-toggle="tile"], [data-toggle="tile"] *') && !$target.is('[data-ignore="tile"], [data-ignore="tile"] *')) {
			e.stopPropagation(); // Prevent event from triggering other handlers
			var $trigger = $target.closest('[data-toggle="tile"]');
			var targetSelector = getTargetFromTrigger($trigger);
			var $collapse = $(targetSelector);

			if ($collapse.length) {
				// Close siblings if data-parent is specified (accordion behavior)
				if ($trigger.attr('data-parent') != null) {
					$($trigger.attr('data-parent')).find('.tile-active-show').not($collapse).each(function() {
						$(this).removeClass('in').css({height: 0, overflow: 'hidden'});
					});
				}

				// Toggle this tile
				$collapse.toggleClass('in');
				if ($collapse.hasClass('in')) {
					// Remove inline height/overflow to let CSS take over
				$collapse[0].style.removeProperty('height');
				$collapse[0].style.removeProperty('overflow');
					$trigger.attr('aria-expanded', 'true').removeClass('collapsed');
				} else {
					$collapse.css({height: 0, overflow: 'hidden'});
					$trigger.attr('aria-expanded', 'false').addClass('collapsed');
				}
			}
		} else if ($target.is('[data-dismiss="tile"]')) {
			$target.closest('.tile-collapse').find('.tile-active-show').removeClass('in').css({height: 0, overflow: 'hidden'});
		} else if (!$target.is('.tile-collapse, .tile-collapse *')) {
			tReset();
		}
	});

	$(".expand-a-z").click(function(e){
		e.stopPropagation(); // Prevent triggering tile toggle
		var $el = $(this);
		// jQuery .data() converts string "true"/"false" to boolean automatically
		// But we need to ensure it's initialized from the data-expanded attribute
		if (typeof $el.data("expanded") === 'undefined') {
			// First click - initialize from current state
			var anyExpanded = $('.tile-active-show.in').length > 0;
			$el.data("expanded", anyExpanded);
		}
		var isExpanded = $el.data("expanded");
		var collapseText = $el.data("collapse-text") || "Collapse All";
		var expandText = $el.data("expand-text") || "Expand All";
		$el.text(isExpanded ? collapseText : expandText);
		$('.tile-active-show').each(function(){
			var $collapse = $(this);
			var targetId = this.id;
			var $trigger = targetId ? $('[data-target="#' + targetId + '"]') : $();

			if (isExpanded) {
				// Collapse
				$collapse.removeClass('in').css({height: 0, overflow: 'hidden'});
				$trigger.attr('aria-expanded', 'false').addClass('collapsed');
			} else {
				// Expand
				$collapse.addClass('in');
				$collapse[0].style.removeProperty('height');
				$collapse[0].style.removeProperty('overflow');
				$trigger.attr('aria-expanded', 'true').removeClass('collapsed');
			}
		});
		$el.data("expanded", !isExpanded);
	});

	// Filter for A-Z index pages (functions, tags, recipes, etc)
	$("#az-filter").on('input', function() {
		var filterText = $(this).val().toLowerCase();
		var $tiles = $('.tile-wrap .tile');
		var $sections = $('.tile-collapse');

		if (!filterText) {
			// Show all tiles and sections
			$tiles.show();
			$sections.show();
		} else {
			// Filter tiles
			$tiles.each(function() {
				var $tile = $(this);
				var text = $tile.text().toLowerCase();
				if (text.indexOf(filterText) !== -1) {
					$tile.show();
				} else {
					$tile.hide();
				}
			});

			// Hide empty sections
			$sections.each(function() {
				var $section = $(this);
				var $visibleTiles = $section.find('.tile-active-show .tile:visible');
				if ($visibleTiles.length > 0) {
					$section.show();
					// Auto-expand sections with matches
					var $collapse = $section.find('.tile-active-show');
					$collapse.addClass('in');
					$collapse[0].style.removeProperty('height');
					$collapse[0].style.removeProperty('overflow');
				} else {
					$section.hide();
				}
			});
		}
	});

	// Filter for category pages
	$("#category-filter").on('input', function() {
		var filterText = $(this).val().toLowerCase();
		var $listItems = $('.list-unstyled li');
		var $sections = $('.list-unstyled').parent();

		if (!filterText) {
			// Show all items and section headers
			$listItems.show();
			$sections.find('h2').show();
			$sections.find('ul').show();
		} else {
			// Filter list items
			$listItems.each(function() {
				var $item = $(this);
				var text = $item.text().toLowerCase();
				if (text.indexOf(filterText) !== -1) {
					$item.show();
				} else {
					$item.hide();
				}
			});

			// Hide empty sections
			$sections.find('ul').each(function() {
				var $list = $(this);
				var $h2 = $list.prev('h2');
				var visibleCount = $list.find('li:visible').length;
				if (visibleCount > 0) {
					$h2.show();
					$list.show();
				} else {
					$h2.hide();
					$list.hide();
				}
			});
		}
	});

	var tReset = function () {
		$('.tile-collapse.active').each(function() {
			var $collapse = $('.tile-active-show', $(this));
			if (!$collapse.hasClass('tile-active-show-still')) {
				$collapse.removeClass('in').css({height: 0, overflow: 'hidden'});
			}
		});
	};

// tile hide
	$(document).on('hide.bs.collapse', '.tile-active-show', function() {
		$(this).closest('.tile-collapse').css({
			'-webkit-transition-delay': '',
			'transition-delay': ''
		}).removeClass('active');
	});

// tile show
	$(document).on('show.bs.collapse', '.tile-active-show', function() {
		$(this).closest('.tile-collapse').css({
			'-webkit-transition-delay': '',
			'transition-delay': ''
		}).addClass('active');
	});

// tile wrap animation
	$('.tile-wrap-animation').each(function(index) {
		var tileAnimationDelay = 0,
		    tileAnimationTransform = 100;

		$('> .tile', $(this)).each(function(index) {
			$(this).css({
				'-webkit-transform': 'translate(0, ' + tileAnimationTransform + '%)',
				'-ms-transform': 'translate(0, ' + tileAnimationTransform + '%)',
				'transform': 'translate(0, ' + tileAnimationTransform + '%)',
				'-webkit-transition-delay': tileAnimationDelay + 's',
				'transition-delay': tileAnimationDelay + 's'
			});

			tileAnimationDelay = tileAnimationDelay + 0.1;
			tileAnimationTransform = tileAnimationTransform + 10;
		});
	});

	$(window).on('DOMContentLoaded scroll', function() {
		tileInView();
	});

	var tileInView = function () {
		$('.tile-wrap-animation:not(.isinview)').each(function() {
			var $this = $(this);
			if (tileInViewCheck($this) && (!$this.hasClass('avoid-fout') || ($this.hasClass('avoid-fout') && $this.hasClass('avoid-fout-done'))) && (!$this.hasClass('el-loading') || ($this.hasClass('el-loading') && $this.hasClass('el-loading-done'))) && !$this.parents('.avoid-fout:not(.avoid-fout-done)').length && !$this.parents('.el-loading:not(.el-loading-done)').length) {
				$this.addClass('isinview');
			}
		});
	};

	var tileInViewCheck = function (tile) {
		tile = tile[0];

		var rect = tile.getBoundingClientRect();

		return (
			rect.top <= window.innerHeight &&
			rect.right >= 0 &&
			rect.bottom >= 0 &&
			rect.left <= window.innerWidth
		);
	};
