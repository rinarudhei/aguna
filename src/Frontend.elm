module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Element exposing (DeviceClass(..), Orientation(..), classifyDevice, column, row)
import Html
import Html.Attributes as Attr
import Lamdera
import Routes exposing (Route, match)
import Task
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


setNewPage : Maybe Route -> Model -> ( Model, Cmd FrontendMsg )
setNewPage maybeRoute model =
    let
        cmd =
            Task.perform GotWindowSize Browser.Dom.getViewport
    in
    case maybeRoute of
        Just Routes.Home ->
            ( { model | page = Home }, Cmd.none )

        Just Routes.Login ->
            ( { model | page = Login }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            setNewPage (match url) model

        GotWindowSize viewport ->
            let
                device =
                    classifyDevice
                        { width = round viewport.viewport.width
                        , height = round viewport.viewport.height
                        }
            in
            ( { model | device = device }, Cmd.none )

        WindowResized w h ->
            ( { model | device = classifyDevice { width = w, height = h } }, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


viewHeader : Html.Html msg
viewHeader =
    Element.layout []
        (column []
            [ row []
                []
            , row
                []
                []
            ]
        )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Aguna - Jual Barang Berguna - Homepage"
    , body =
        [ Html.div [ Attr.style "text-align" "center", Attr.style "padding-top" "40px" ]
            [ Html.img [ Attr.src "https://lamdera.app/lamdera-logo-black.png", Attr.width 150 ] []
            , Html.div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding-top" "40px"
                ]
                [ Html.text "Mantap Mantap yuk" ]
            ]
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
        , subscriptions = \m -> Sub.none
        , view = view
        }
