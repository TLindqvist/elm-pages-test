module Article exposing (ArticleContent, ArticleMetadata, loadContent, loadMetadata, renderArticleContent)

{-| Module for working with Articles.

    Articles will be loaded from GitHub and is a markdown file in a specific folder.

    @docs Article
    @docs loadContent
    @docs loadMetadata
    @docs renderArticleContent

-}

import BackendTask exposing (allowFatal, fail, onError)
import BackendTask.Http exposing (CacheStrategy(..), expectJson, expectString, getWithOptions)
import Dict exposing (Dict, keys)
import FatalError exposing (FatalError)
import Html exposing (Html, p)
import Html.Attributes as Attr
import Json.Decode as Decode
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser exposing (deadEndToString)
import Markdown.Renderer



-- ArticleMetadata


{-| Articles has a title as of now.
-}
type alias ArticleMetadata =
    { title : String
    }


{-| The url where articles are stored.
-}
metadaUrl : String
metadaUrl =
    "https://github.com/TLindqvist/elm-pages-test/tree-commit-info/master/content/articles"


{-| Helper for creating articles.
-}
createArticles : Dict String v -> Decode.Decoder (List ArticleMetadata)
createArticles articlesDict =
    let
        createTitle : String -> Maybe String
        createTitle fileName =
            fileName
                |> String.split "."
                |> List.head
    in
    articlesDict
        |> keys
        |> List.map createTitle
        |> List.filterMap identity
        |> List.map ArticleMetadata
        |> Decode.succeed


{-| Decoder for getting a list of article names.
-}
decodeMetadatas : Decode.Decoder (List ArticleMetadata)
decodeMetadatas =
    Decode.dict Decode.value
        |> Decode.andThen createArticles


{-| BackendTask for loading metadata.
-}
loadMetadata : BackendTask.BackendTask FatalError (List ArticleMetadata)
loadMetadata =
    getWithOptions
        { url = metadaUrl
        , expect = expectJson decodeMetadatas
        , headers = [ ( "Accept", "application/json" ) ]
        , cacheStrategy = Just ForceCache
        , retries = Nothing
        , timeoutInMs = Just 10000
        , cachePath = Nothing
        }
        |> onError (\error -> fail error |> allowFatal)



-- ArticleContent


{-| The content of an article.
-}
type ArticleContent
    = Markdown String


{-| The url where articles are stored.
-}
contentUrl : String
contentUrl =
    "https://raw.githubusercontent.com/TLindqvist/elm-pages-test/master/content/articles/"


{-| BackendTask for loading content.
-}
loadContent : ArticleMetadata -> BackendTask.BackendTask FatalError ArticleContent
loadContent metadata =
    let
        url =
            contentUrl ++ metadata.title ++ ".md"
    in
    getWithOptions
        { url = url
        , expect = expectString
        , headers = []
        , cacheStrategy = Just IgnoreCache
        , retries = Nothing
        , timeoutInMs = Just 10000
        , cachePath = Nothing
        }
        |> onError (\error -> fail error |> allowFatal)
        |> BackendTask.map Markdown


{-| Renders the content of an article as HTML.
-}
renderArticleContent : ArticleContent -> List (Html msg)
renderArticleContent content =
    case content of
        Markdown markdown ->
            markdown
                |> Markdown.Parser.parse
                |> Result.mapError (List.map Markdown.Parser.deadEndToString >> String.join "\n")
                |> Result.andThen (Markdown.Renderer.render renderMarkdown)
                |> Result.withDefault [ Html.text "Ooops!" ]


{-| Custom renderer for articles in markdown.
-}
renderMarkdown : Markdown.Renderer.Renderer (Html msg)
renderMarkdown =
    let
        renderer =
            Markdown.Renderer.defaultHtmlRenderer
    in
    { renderer
        | paragraph = Html.p [ Attr.style "color" "darkgray" ]
        , strikethrough =
            Html.span
                [ Attr.style "text-decoration-line" "line-through"
                , Attr.style "color" "red"
                ]
    }
