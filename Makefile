INSTALL_DIR  = /usr/local/bin
MANPAGE_DIR  = /usr/local/share/man/man1
XCODE_CONFIG = Release

.PHONY: install machine release debug build uninstall ronn clean distclean

install: machine release
	cp bin/dshb ${INSTALL_DIR}
	cp doc/dshb.1 ${MANPAGE_DIR}
	du -sh ${INSTALL_DIR}/dshb
machine:
	@sysctl hw.model
	@sw_vers
	@uname -v
	@ioreg -lbrc AppleSMC | grep smc-version | tr -d "|" | xargs
	@xcodebuild -version
	@swiftc -v
release: build
	strip bin/dshb
debug: XCODE_CONFIG=Debug
debug: build
build: libs/SMCKit/README.md
	xcodebuild -configuration ${XCODE_CONFIG} build
	mkdir -p bin
	cp build/${XCODE_CONFIG}/dshb bin
libs/SMCKit/README.md:
	git submodule update --init
uninstall:
	rm ${INSTALL_DIR}/dshb
	rm ${MANPAGE_DIR}/dshb.1
ronn:
	ronn --style=toc doc/dshb.1.ronn
clean:
	xcodebuild -configuration Debug clean
	xcodebuild -configuration Release clean
distclean:
	rm -rf bin build
