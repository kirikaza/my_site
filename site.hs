--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Hakyll

--------------------------------------------------------------------------------

googleAnalyticsID = "UA-34888740-1"
goSquaredID = "GSN-366667-M"

main :: IO ()
main = hakyll $ do
    match "styles/*.woff" $ do
        route idRoute
        compile copyFileCompiler

    match "styles/*.css" $ do
        route idRoute
        compile compressCssCompiler

    match "posts/*" $ do
        route $ setExtension "html"
        let ctx = formatDate
               <> boolField "singlePostPage" (const True)
               <> constField "googleAnalyticsID" googleAnalyticsID
               <> constField "goSquaredID" goSquaredID
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
                   <> constField "googleAnalyticsID" googleAnalyticsID
                   <> constField "goSquaredID" goSquaredID
                   <> defaultContext
            getResourceBody
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
formatDate = dateField "date" "%F"
