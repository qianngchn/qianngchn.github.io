MARK=$(shell find -name "*.markdown" | sort)
HTML=$(MARK:%.markdown=%.html)

PANDOC_FLAG+= --css=style.css
PANDOC_FLAG+= --template=pandoctpl.html
PANDOC_FLAG+= --tab-stop=4
PANDOC_FLAG+= --toc
PANDOC_FLAG+= --include-in-header temp_in_header.html
PANDOC_FLAG+= --include-before-body temp_before_body.html
PANDOC_FLAG+= --include-after-body temp_after_body.html

.PHONY:
	all index check clean

all:index $(HTML) check

index:
	@echo "Generating wiki.markdown"
	@./wiki_index.sh

%.html:%.markdown pandoctpl.html Makefile html_modify.sh
	@echo "Generating $@"
	@touch temp_in_header.html temp_before_body.html temp_after_body.html
	@sed -n -e "s/<\!---title:\(.\+\)-->/<title>\1 | Another Wiki<\/title>/p" $< >> temp_in_header.html
	@sed -n -e "s/<\!---tags:\(.\+\)-->/<meta name=\"keywords\" content=\"\1, another, wiki\">/p" $< >> temp_in_header.html
	@sed -n -e "s/<\!---title:\(.\+\)-->/<h2>\1<\/h2>/p" $< >> temp_before_body.html
	@echo "<code>" >> temp_before_body.html
	@sed -n -e "s/<\!---category:\(.\+\)-->/==<a href=\"wiki.html#\1\">\1<\/a>==/p" $< >> temp_before_body.html
	@sed -n -e "s/<\!---tags:\(.\+\)-->/| \1/p" $< >> temp_before_body.html
	@sed -n -e "s/<\!---time:\(.\+\)-->/| \1/p" $< >> temp_before_body.html
	@echo "| `stat $< | tail -n2 | head -n1 | cut -d'.' -f1`" >> temp_before_body.html
	@echo "</code>" >> temp_before_body.html
	@echo "<hr/>" >> temp_before_body.html
	@echo "<hr/>" >> temp_after_body.html
	@echo "<code>| Author: qianngchn | Index: <a href=\"#\">$@</a></code>" >> temp_after_body.html
	@pandoc $(PANDOC_FLAG) --from=markdown --to=html $< -o $@
	@rm -f temp_in_header.html temp_before_body.html temp_after_body.html
	@./html_modify.sh $@

check:
	@./html_check.sh

clean:
	@rm $(HTML) -f
