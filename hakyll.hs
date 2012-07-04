{-# LANGUAGE OverloadedStrings #-}
import Control.Arrow ((>>>))

import Hakyll

main :: IO ()
main = hakyll $ do
    match "template.html" $ compile templateCompiler

    match "index.markdown" $ do
        route   $ setExtension "html"
        compile $ pageCompiler
            >>> applyTemplateCompiler "template.html"
            >>> relativizeUrlsCompiler
