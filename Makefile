VERSION=0.1
REVISION=1
SPEC_FILE=luastatsd-${VERSION}-${REVISION}.rockspec
TAR_FILE=luastatsd-${VERSION}-${REVISION}.tar.gz
SRC_ROCK=luastatsd-${VERSION}-${REVISION}.src.rock

all: build

build:
	rm -rf tmp
	mkdir tmp
	git archive -o tmp/luastatsd-${VERSION}.zip --prefix luastatsd-${VERSION}/ HEAD
	cd tmp && unzip luastatsd-${VERSION}.zip && rm -rf luastatsd-${VERSION}/rockspec && tar -czvpf ${TAR_FILE} luastatsd-${VERSION}

dist: build
	cd tmp && luarocks pack ../rockspec/luastatsd-${VERSION}-${REVISION}.rockspec

clean:
	rm -rf tmp

 