BOOTSTRAP = ./docs/assets/css/bootstrap.css
BOOTSTRAP_LESS = ./less/bootstrap.less
BOOTSTRAP_RESPONSIVE = ./docs/assets/css/bootstrap-responsive.css
BOOTSTRAP_RESPONSIVE_LESS = ./less/responsive.less
DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#


#
# BUILD
#

build: bootstrap-font bootstrap-img bootstrap-css bootstrap-js

#
# CLEAN
#

clean: rm -r bootstrap

bootstrap-js: bootstrap/js/*.js

bootstrap/js/*.js: js/*.js
	mkdir -p bootstrap/js
	cat js/bootstrap-transition.js js/bootstrap-alert.js js/bootstrap-button.js js/bootstrap-carousel.js js/bootstrap-collapse.js js/bootstrap-dropdown.js js/bootstrap-modal.js js/bootstrap-tooltip.js js/bootstrap-popover.js js/bootstrap-scrollspy.js js/bootstrap-tab.js js/bootstrap-typeahead.js js/bootstrap-affix.js > bootstrap/js/bootstrap.js
	./node_modules/.bin/uglifyjs -nc bootstrap/js/bootstrap.js > bootstrap/js/bootstrap.min.tmp.js
	echo "/*!\n* Bootstrap.js by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > bootstrap/js/copyright.js
	cat bootstrap/js/copyright.js bootstrap/js/bootstrap.min.tmp.js > bootstrap/js/bootstrap.min.js
	rm bootstrap/js/copyright.js bootstrap/js/bootstrap.min.tmp.js

#
# CSS COMPLILE
#

bootstrap-css: bootstrap/css/*.css

bootstrap/css/*.css: less/*.less
	mkdir -p bootstrap/css
	./node_modules/.bin/recess --compile ${BOOTSTRAP_LESS} > bootstrap/css/bootstrap.css
	./node_modules/.bin/recess --compress ${BOOTSTRAP_LESS} > bootstrap/css/bootstrap.min.css
	./node_modules/.bin/recess --compile ${BOOTSTRAP_RESPONSIVE_LESS} > bootstrap/css/bootstrap-responsive.css
	./node_modules/.bin/recess --compress ${BOOTSTRAP_RESPONSIVE_LESS} > bootstrap/css/bootstrap-responsive.min.css

#
# IMAGES
#

bootstrap-img: bootstrap/img/*

bootstrap/img/*: img/*
	mkdir -p bootstrap/img
	cp img/* bootstrap/img/

#
# FONTS
#

bootstrap-font: bootstrap/font/*

bootstrap/font/*: font/*
	mkdir -p bootstrap/font
	cp font/* bootstrap/font/


#
# WATCH LESS FILES
#

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: watch bootstrap-font bootstrap-img bootstrap-css bootstrap-js