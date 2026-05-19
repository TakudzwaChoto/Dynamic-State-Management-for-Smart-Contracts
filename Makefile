.PHONY: build test clean

build:
forge build

test:
forge test -vvv

clean:
rm -rf out cache
