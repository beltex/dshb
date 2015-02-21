INSTALL_DIR = /usr/local/bin/

clean:
	rm -rf bin build
build: clean
	xcodebuild clean build
	mkdir bin/
	mv build/Release/dshb bin/
install: build
	# TODO: Better install dir (this is via Homebrew)
	cp bin/dshb ${INSTALL_DIR}
	# TODO: Place manual page in correct dir
