module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation as Nav
import Element
    exposing
        ( Device
        , DeviceClass(..)
        , Orientation(..)
        , classifyDevice
        , text
        )
import Html exposing (Html)
import Lamdera
import Pages.Home as Home
import Routes exposing (Route, match)
import Task
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


processUpdatePage :
    (pageModel -> Page)
    -> (pageMsg -> FrontendMsg)
    -> Model
    -> ( pageModel, Cmd pageMsg )
    -> ( Model, Cmd FrontendMsg )
processUpdatePage createPage msgWrapper model ( pageModel, cmdPageMsg ) =
    ( { model | page = createPage pageModel }, Cmd.map msgWrapper cmdPageMsg )


setNewPage : Maybe Route -> Model -> ( Model, Cmd FrontendMsg )
setNewPage maybeRoute model =
    let
        cmd =
            Task.perform GotWindowSize Dom.getViewport
    in
    case maybeRoute of
        Just Routes.Home ->
            Home.init
                |> processUpdatePage Home HomeMsg model

        Just Routes.Login ->
            ( { model | page = NotFound }, cmd )

        Nothing ->
            ( { model | page = NotFound }, cmd )


setDevice : Int -> Int -> Model -> ( Model, Cmd FrontendMsg )
setDevice w h model =
    ( { model | device = classifyDevice { width = w, height = h } }, Cmd.none )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case ( msg, model.page ) of
        ( HomeMsg homeMsg, Home homeModel ) ->
            Home.update homeMsg homeModel
                |> processUpdatePage Home HomeMsg model

        ( UrlClicked urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            setNewPage (match url) model

        ( GotWindowSize viewport, _ ) ->
            setDevice (round viewport.viewport.width) (round viewport.viewport.height) model

        ( WindowResized w h, _ ) ->
            ( { model | device = classifyDevice { width = w, height = h } }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


deviceToString : Device -> String
deviceToString device =
    case device.class of
        Phone ->
            "Phone"

        Tablet ->
            "Tablet"

        Desktop ->
            "desktop"

        BigDesktop ->
            "big"


viewContent : Model -> ( String, Html FrontendMsg )
viewContent model =
    case model.page of
        Home homeModel ->
            ( "Aguna Home - Find good stuff with great price"
            , Home.view
                model.device
                homeModel
                |> Html.map HomeMsg
            )

        _ ->
            ( "Aguna Home - Find good stuff with great price", Element.layout [] (text "abcd") )


view : Model -> Browser.Document FrontendMsg
view model =
    let
        ( title, content ) =
            viewContent model
    in
    { title = title
    , body =
        [ content
        ]
    }


initialModel : Nav.Key -> Model
initialModel key =
    { page = NotFound
    , device =
        { class = Phone
        , orientation = Portrait
        }
    , key = key
    }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    setNewPage (match url) (initialModel key)


sub : Model -> Sub FrontendMsg
sub model =
    Browser.Events.onResize (\w h -> WindowResized w h)


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = sub
        , view = view
        }
