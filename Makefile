MARK=$(shell find -name "*.markdown" | sort)
HTML=$(MARK:%.markdown=%.html)

.PHONY:
	all index clean

all:index $(HTML)

index:
	@echo "Generating wiki.markdown"
	@./wiki_index.sh

%.html:%.markdown pandoctpl.html Makefile html_generate.sh html_check.sh
	@echo "Checking $<"
	@./html_check.sh $<
	@echo "Generating $@"
	@./html_generate.sh $< $@

clean:
	rm $(HTML) -f
