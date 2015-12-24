#configurable stuff
INSTALL_DIR = www
default: build

#
#commands
#
WEBPACK := node_modules/webpack/bin/webpack.js
COFFEE := node_modules/coffee-script/bin/coffee

#
#main files
#
BUNDLE := lib/bundle.js

#
#initial setup stuff
#
NPM_DEPS := $(WEBPACK)
npm-sentinel := node_modules/.ns
$(npm-sentinel): $(NPM_DEPS) package.json
	@command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed.  Aborting."; exit 1; }
	@command -v node >/dev/null 2>&1 || { echo >&2 "I require node but it's not installed.  Aborting."; exit 1; }
	npm install
	touch $(npm-sentinel)
$(NPM_DEPS):
	npm install
update:
	npm install

#
#bundles
#
$(BUNDLE): $(shell find src -wholename 'src/*') webpack.config.js
	@mkdir -p lib/
	node node_modules/webpack/bin/webpack.js --progress --colors

#
# config stuff
#
webpack.config.js: webpack.config.coffee $(npm-sentinel)
	./$(COFFEE) --compile --bare webpack.config.coffee

#
# watching
#
watch: webpack.config.js
	node node_modules/webpack/bin/webpack.js --watch --progress --colors
#
# building
#
build: $(BUNDLE)

#
# development
#
dev: webpack.config.js
	node node_modules/webpack-dev-server/bin/webpack-dev-server.js

#
#clean built files
#
clean:
	$(RM) lib/*

#
# installing everything including static resources
#
IMG := $(wildcard img/*)
HTML := $(wildcard ./*.html)
LIB := $(wildcard lib/*)
PREINSTALL := $(LIB) $(IMG) $(HTML)
POSTINSTALL := $(addprefix $(INSTALL_DIR)/,$(PREINSTALL))
$(INSTALL_DIR)/%: %
	install -m 644 -D $< $@
install: $(POSTINSTALL) $(BUNDLE)

.PHONY: update install default build watch dev clean
