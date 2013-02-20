{-# LANGUAGE OverloadedStrings #-}

import Hakyll

main :: IO ()
main = hakyll $ do
    match "template.html" $ compile templateCompiler

    match "text/*.md" $ do
	route $ let move = gsubRoute "text/" (const "")
                    rename = setExtension "html"
                in composeRoutes move rename
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "template.html" defaultContext
            >>= relativizeUrls

    match "img/*" $ do
        route $ idRoute
        compile $ copyFileCompiler

    match "css/*" $ do
        route $ idRoute
        compile $ compressCssCompiler
