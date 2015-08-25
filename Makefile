INSTALL_FOLDER  = /usr/local/bin
MANPAGE_FOLDER  = /usr/local/share/man/man1
XCODE_CONFIG    = Release
DSHB_VERSION    = 0.1.0-dev
ARCHIVE_FOLDER  = archive
ARCHIVE_NAME    = dshb-${DSHB_VERSION}-source
SUBMODULES_PATH = libs
SUBMODULES      = `find ${SUBMODULES_PATH} -type d -depth 1 | \
                   sed 's/${SUBMODULES_PATH}//' | tr -d '/'`
REPO_URL        = https://github.com/beltex/dshb

.PHONY: help install machine release debug build uninstall archive-local \
        archive-remote ronn clean distclean

help: ._hello
	@echo "Usage: make [targets]                                                 \
\n  install  \tBuilds in release mode, placing the binary & manual page in your path \
\n  uninstall\tDeletes the binary & manual page from your path                       \
\n  release  \tRelease mode build with compiler optimizations & symbol removal       \
\n  debug    \tDebug mode build                                                      \
\n  clean    \tCleans the build folder                                               \
\n  distclean\tDeletes the build, bin, & archive folders"
._hello:
	@echo "Hello `whoami`! I'm the Makefile for dshb. Nice to meet you! How" \
	      "can I help?\n"; touch ._hello
install: machine release
	cp bin/dshb ${INSTALL_FOLDER}
	cp doc/dshb.1 ${MANPAGE_FOLDER}
	du -sh ${INSTALL_FOLDER}/dshb
machine:
	@sysctl hw.model;                                             \
	 sw_vers;                                                     \
	 uname -v;                                                    \
	 ioreg -lbrc AppleSMC | grep smc-version | tr -d "|" | xargs; \
	 xcodebuild -version;                                         \
	 swiftc -v
release: build
	strip bin/dshb
debug: XCODE_CONFIG=Debug
debug: build
build:
	$(if $(wildcard .git), git submodule update --init, \
            $(if $(wildcard libs/SMCKit/README.md), , $(call bad-archive)))
	xcodebuild -configuration ${XCODE_CONFIG} build
	mkdir -p bin
	cp build/${XCODE_CONFIG}/dshb bin
define bad-archive
	@echo "\n Sorry to say this `whoami` but we have a problem!            \n\n\
Looks like you downloaded an archive of dshb from GitHub via the 'Download ZIP'  \n\
option or one of the 'Source code' archives on the release page. These do not    \n\
contain the Git submodules and thus you can't build dshb. Here's what you can do \n\
instead though!                                                                \n\n\
[1] Clone the repository via Git                                               \n\n\
    git clone --recursive ${REPO_URL}                                          \n\n\
[2] Download the 'dshb-<VERSION>-source.zip' archive which is complete at      \n\n\
    ${REPO_URL}/releases/latest\n";                                                \
	 exit 1
endef
uninstall:
	rm ${INSTALL_FOLDER}/dshb
	rm ${MANPAGE_FOLDER}/dshb.1
ronn:
	ronn --organization=${DSHB_VERSION} --style=toc doc/dshb.1.ronn
archive-local:
	@rm -rf ${ARCHIVE_FOLDER}/*;                                       \
	 mkdir -p ${ARCHIVE_FOLDER};                                       \
	 git archive --format zip -o ${ARCHIVE_FOLDER}/tmp HEAD;           \
	 unzip -d ${ARCHIVE_FOLDER}/${ARCHIVE_NAME} ${ARCHIVE_FOLDER}/tmp; \
	 for submodule in ${SUBMODULES}; do                                \
	   cd ${SUBMODULES_PATH}/$$submodule;                              \
	   git archive -o ../../${ARCHIVE_FOLDER}/$$submodule.zip HEAD;    \
	   cd ../../${ARCHIVE_FOLDER};                                     \
	   unzip -d ${ARCHIVE_NAME}/${SUBMODULES_PATH}/$$submodule         \
	                                                  $$submodule.zip; \
	   cd ..;                                                          \
	 done;                                                             \
	 cd ${ARCHIVE_FOLDER};                                             \
	 rm -rf *.zip;                                                     \
	 zip -r ${ARCHIVE_NAME}.zip ${ARCHIVE_NAME};                       \
	 rm -rf tmp ${ARCHIVE_NAME}
archive-remote:
	@rm -rf ${ARCHIVE_FOLDER}/*;                                          \
	 mkdir -p ${ARCHIVE_FOLDER};                                          \
	 git clone --depth 1 --recursive ${REPO_URL}                          \
	                                   ${ARCHIVE_FOLDER}/${ARCHIVE_NAME}; \
	 cd ${ARCHIVE_FOLDER};                                                \
	 zip -r ${ARCHIVE_NAME}.zip ${ARCHIVE_NAME} --exclude \*.git *.git/*; \
	 rm -rf ${ARCHIVE_NAME}
clean:
	xcodebuild -configuration Debug clean
	xcodebuild -configuration Release clean
distclean:
	rm -rf bin build ._hello ${ARCHIVE_FOLDER}
