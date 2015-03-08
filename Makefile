INSTALL_DIR = /usr/local/bin/
MANUAL_DIR = /usr/local/share/man/man1/

clean:
	rm -rf bin build
build: clean
	xcodebuild clean build
	mkdir bin/
	mv build/Release/dshb bin/
install: build
	# TODO: Better install dir (this requires Homebrew)
	cp bin/dshb ${INSTALL_DIR}
	cp doc/dshb.1 ${MANUAL_DIR}
