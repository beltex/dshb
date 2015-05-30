INSTALL_DIR = /usr/local/bin
MANPAGE_DIR = /usr/local/share/man/man1

.PHONY: install uninstall release debug submodule clean distclean ronn

install: release
	cp bin/dshb ${INSTALL_DIR}
	cp doc/dshb.1 ${MANPAGE_DIR}
uninstall:
	rm ${INSTALL_DIR}/dshb
	rm ${MANPAGE_DIR}/dshb.1
release: submodule
	xcodebuild -configuration Release build
	cp build/Release/dshb bin
	strip bin/dshb
debug: submodule
	xcodebuild -configuration Debug build
	cp build/Debug/dshb bin
submodule:
	git submodule update --init
	mkdir -p bin
clean:
	xcodebuild -configuration Debug clean
	xcodebuild -configuration Release clean
distclean:
	rm -rf bin build
ronn:
	ronn --style=toc doc/dshb.1.ronn
