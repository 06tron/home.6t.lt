to_static = static/$(shell echo $(1) | cut -d / -f 4-)

.SECONDEXPANSION:

%.html: html5.jq %.jq.xml $$(wildcard $$*.css $$*.js)
	bash -x join-jq-html.sh $* $< > $(call to_static,$@)

%.xht: xht.jq %.jq.xml $$(wildcard $$*.css $$*.js)
	{ printf %b "<!DOCTYPE\nhtml><html\nxmlns='http://www.w3.org/1999/xhtml'\nclass='h-entry'\nlang='en'><head><meta\ncharset='utf-8'/>"; bash -x join-jq-html.sh $* $<; } > $(call to_static,$@)

%.ht16.htm: xht.jq %.jq.xml $$(wildcard $$*.css $$*.js)
	{ printf %b "<?xml\nversion='1.0'\nencoding='utf-16'?><html\nxmlns='http://www.w3.org/1999/xhtml'\nclass='h-entry'\nlang='en'><head>"; bash -x join-jq-html.sh $* $<; } | iconv -f UTF-8 -t UTF-16 > $(call to_static,$@)
