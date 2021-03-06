NAME = Youtube disable lightsaber sound
DESCRIPTION = Removes the annoying youtube lightsaber sound
VERSION = 1.0.3

all: chrome firefox userscript

clean:
	rm -f chrome/manifest.json
	rm -f chrome/content.js
	rm -f firefox/data/content.js
	rm -f firefox/package.json
	rm -f firefox/*.xpi
	rm -f userscript/youtube_no_lightsaber.user.js
	rm -f userscript/head.js

%: %.in Makefile
	sed -e "s:@@NAME@@:$(NAME):g" \
	    -e "s:@@DESC@@:$(DESCRIPTION):g" \
	    -e "s:@@VERSION@@:$(VERSION):g" $< > $@

chrome/content.js: youtube_no_lightsaber.js
	cp $< $@

firefox/data/content.js: youtube_no_lightsaber.js
	[ -d firefox/data ] && rm -rf firefox/data;:
	mkdir firefox/data
	cp $< $@

userscript/youtube_no_lightsaber.user.js: userscript/head.js youtube_no_lightsaber.js
	cat userscript/head.js youtube_no_lightsaber.js > $@

firefox/@youtubelightsaber-$(VERSION).xpi: firefox/package.json firefox/data/content.js
	find firefox | grep '\~$$' | xargs rm -f
	rm -f firefox/install.rdf
	rm -f firefox/bootstrap.js
	rm -f firefox/@youtubelightsaber-$(VERSION).xpi
	cd firefox && jpm xpi
	zip -d firefox/@youtubelightsaber-$(VERSION).xpi package.json.in


chrome: chrome/manifest.json chrome/content.js

firefox: firefox/@youtubelightsaber-$(VERSION).xpi

userscript: userscript/youtube_no_lightsaber.user.js
