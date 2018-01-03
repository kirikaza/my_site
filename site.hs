--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route idRoute
        compile compressCssCompiler

    match "about.md" $ do
        route $ setExtension "html"
        let ctx = boolField "aboutPage" (const True)
               <> defaultContext 
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        let ctx = formatDate
               <> boolField "singlePostPage" (const True)
               <> defaultContext 
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let ctx = listField "posts" (formatDate <> defaultContext) (return posts)
                   <> constField "title" "Мои статьи"
                   <> boolField "postsListPage" (const True)
                   <> defaultContext
            getResourceBody
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
formatDate = dateField "date" "%F"