{-# LANGUAGE OverloadedStrings #-}
import Control.Arrow ((>>>))

import Hakyll

main :: IO ()
main = hakyll $ do
    match "template.html" $ compile templateCompiler

    match "text/*.md" $ do
	route $ let move = gsubRoute "text/" (const "")
                    rename = setExtension "html"
                in composeRoutes move rename
        compile $ pageCompiler
            >>> applyTemplateCompiler "template.html"
            >>> relativizeUrlsCompiler

    match "img/*" $ do
        route $ idRoute
        compile $ copyFileCompiler

    match "css/*" $ do
        route $ idRoute
        compile $ compressCssCompiler
