module Route.Articles.Title_ exposing (ActionData, Data, Model, Msg, route)

import Article exposing (ArticleContent, ArticleMetadata, loadContent, loadMetadata, renderArticleContent)
import BackendTask exposing (BackendTask)
import Effect exposing (Effect(..))
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { title : String }


route : StatelessRoute RouteParams ArticleContent ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : BackendTask FatalError (List ArticleMetadata)
pages =
    loadMetadata


type alias Data =
    ArticleContent


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError ArticleContent
data routeParams =
    loadContent routeParams


head :
    App ArticleContent ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    App ArticleContent ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = "TEST"
    , body = renderArticleContent app.data
    }
