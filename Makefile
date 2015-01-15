build: clean
	xcodebuild clean build
	mkdir bin/
	mv build/Release/dshb bin/
clean: 
	rm -rf bin build
