to_static = static/$(shell echo '$(1)' | cut -d / -f 4-)

.SECONDEXPANSION:

%.xht: xhtml5.jq %.jq.xml $$(wildcard $$*.css $$*.js)
	./join-jq-html.sh $* $< > $(call to_static,$@)

%.html: html5.jq %.jq.xml $$(wildcard $$*.css $$*.js)
	./join-jq-html.sh $* $< > $(call to_static,$@)

%.ht16: xht-utf16.jq %.jq.xml $$(wildcard $$*.css $$*.js)
	./join-jq-html.sh $* $< | iconv -f UTF-8 -t UTF-16LE > $(call to_static,$@)
