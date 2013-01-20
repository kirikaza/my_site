generate: hakyll
	@./hakyll build

hakyll: hakyll.hs
	@ghc --make hakyll

publish: .public generate
	@rsync -rvc _site/ .public/

clean:
	@rm -rf _cache _site

distclean: clean
	@rm hakyll.hi hakyll.o hakyll

.PHONY: clean distclean
