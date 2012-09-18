{-# LANGUAGE OverloadedStrings #-}
import Control.Arrow ((>>>))

import Hakyll

main :: IO ()
main = hakyll $ do
    match "template.html" $ compile templateCompiler

    match "*.md" $ do
        route   $ setExtension "html"
        compile $ pageCompiler
            >>> applyTemplateCompiler "template.html"
            >>> relativizeUrlsCompiler

    match "img/*" $ do
        route $ idRoute
        compile $ copyFileCompiler

    match "css/*" $ do
        route $ idRoute
        compile $ compressCssCompiler
