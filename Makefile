PREFIX        ?=  /usr/local
GZIP          ?=  gzip -f9
RM            ?=  rm -f
INSTALL_DIR   ?=  install -m755 -d
INSTALL_PROG  ?=  install -m755 -D
INSTALL_FILE  ?=  install -m644 -D

all:
	@echo Run \'make install\' to install ScreenFetch

install: install-data install-hook

install-data:
	$(INSTALL_DIR) $(DESTDIR)/$(PREFIX)/bin
	$(INSTALL_DIR) $(DESTDIR)/$(PREFIX)/share/man/man1
	$(INSTALL_PROG) screenfetch-dev $(DESTDIR)/$(PREFIX)/bin/screenfetch
	$(INSTALL_FILE) screenfetch.1 $(DESTDIR)/$(PREFIX)/share/man/man1

install-hook:
	$(GZIP) $(DESTDIR)/$(PREFIX)/share/man/man1/screenfetch.1

uninstall:
	$(RM) $(DESTDIR)/$(PREFIX)/bin/screenfetch
	$(RM) $(DESTDIR)/$(PREFIX)/share/man/man1/screenfetch.1.gz

