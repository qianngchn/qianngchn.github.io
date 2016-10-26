MARK=$(shell find -name "*.markdown" | sort)
HTML=$(MARK:%.markdown=%.html)
INDEX=$(shell find -name "*index.sh" | sort)

.PHONY:all index clean

all:$(HTML)

index:
	@for script in $(INDEX); do $$script; done

%.html:%.markdown pandoctpl.html html_generate.sh
	@./html_check.sh $<
	@./html_generate.sh $< $@

clean:
	rm -f $(HTML)
