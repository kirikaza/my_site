hakyll: hakyll.hs
	ghc --make hakyll

clean:
	rm hakyll.hi hakyll.o hakyll

.PHONY: clean
