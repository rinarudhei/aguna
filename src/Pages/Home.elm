module Pages.Home exposing (Model, Msg, init, update, view)

import Element exposing (Device, DeviceClass(..), Element, alignLeft, alignRight, column, el, fill, height, image, px, row, spacing, text, width)
import Element.Events exposing (onClick)
import Element.Font as Font
import Html exposing (Html)
import Style exposing (clashDisplay, lineHeight150, paddings)


type alias Model =
    { mobileMenuIsOpened : Bool
    , searchMenuOpened : Bool
    , searchMenuText : String
    }


initialModel : Model
initialModel =
    { mobileMenuIsOpened = False
    , searchMenuOpened = False
    , searchMenuText = ""
    }


viewHeader : DeviceClass -> Element Msg
viewHeader deviceClass =
    case deviceClass of
        _ ->
            column [ width fill ]
                [ row [ width fill, height (px 69), clashDisplay, lineHeight150, Font.size 24, paddings 20 20 20 24 ]
                    [ el [ alignLeft ] (text "Aguna")
                    , row [ alignRight, spacing 20 ]
                        [ image [ width (px 20), height (px 20), Font.alignLeft ] { src = "/icons/search.svg", description = "header search button" }
                        , image [ width (px 20), height (px 20), Font.alignRight, onClick HeaderMenuClicked ] { src = "/icons/menu.svg", description = "header menu button" }
                        ]
                    ]
                ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


view : Device -> Model -> Html Msg
view device model =
    Element.layout
        [ width fill ]
        (column [ width fill ]
            [ viewHeader device.class ]
        )


type Msg
    = HeaderMenuClicked
    | SearchMenuClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchMenuClicked ->
            ( { model | searchMenuOpened = not model.searchMenuOpened }, Cmd.none )

        HeaderMenuClicked ->
            ( { model | mobileMenuIsOpened = not model.mobileMenuIsOpened }, Cmd.none )
