all: build test-build

build:
	coffee -c -o lib src

test-build:
	coffee -c -o test test/src

watch:
	coffee -o lib -cw src

test-watch:
	coffee -o test -cw test/src

test-cov:
	jscoverage --no-highlight lib lib-cov
	EXAMPLE_NAME_SPACE=1 mocha -R html-cov > test/coverage.html
	rm -rf lib-cov

.PHONY: build test-build clean watch test-watch test-cov
