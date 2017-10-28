define \n


endef

DESTDIR?=pkg
DESTDIR:=$(patsubst %/,%,$(DESTDIR))
FILES=$(shell find usr -type f)

install: $(DESTDIR)
	$(foreach f,$(FILES),install -m 644 -D $(f) $(DESTDIR)/$(f)${\n})

uninstall:
	$(foreach f,$(FILES),rm $(DESTDIR)/$(f)${\n})

$(DESTDIR):
	mkdir $@

$(DESTDIR)/%:
	@echo "Installing $@"

.PHONY: install uninstall
