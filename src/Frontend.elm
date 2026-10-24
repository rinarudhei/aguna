module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation as Nav
import Element exposing (Device, DeviceClass(..), Orientation(..), classifyDevice, column, el, image, paddingXY, px, row, text, width)
import Element.Font as Font
import Lamdera
import Routes exposing (Route, match)
import Style exposing (clashDisplay, lineHeight150)
import Task
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


setNewPage : Maybe Route -> Model -> ( Model, Cmd FrontendMsg )
setNewPage maybeRoute model =
    let
        cmd =
            Task.perform GotWindowSize Dom.getViewport
    in
    case maybeRoute of
        Just Routes.Home ->
            ( { model | page = Home }, cmd )

        Just Routes.Login ->
            ( { model | page = Login }, cmd )

        Nothing ->
            ( { model | page = NotFound }, cmd )


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


viewHeader : Element.Element msg
viewHeader =
    column []
        [ row []
            [ text "Avion" ]
        , row
            []
            []
        ]


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


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Aguna - Jual Barang Berguna - Homepage"
    , body =
        [ Element.layout [ clashDisplay, lineHeight150 ]
            (column []
                [ viewHeader
                , column [ Font.center, paddingXY 40 0 ]
                    [ image [ width (px 150) ] { src = "https://lamdera.app/lamdera-logo-black.png", description = "lamdera logo" }
                    , el
                        [ paddingXY 40 0
                        ]
                        (text ("Mantap Mantap yuk " ++ deviceToString model.device))
                    ]
                ]
            )
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
