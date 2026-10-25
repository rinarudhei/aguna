module Pages.Home exposing (Model, Msg, init, update, view)

import Element exposing (Device, DeviceClass(..), Element, alignLeft, alignRight, centerX, centerY, column, el, fill, height, image, maximum, paddingXY, px, rgba, row, spacing, text, width)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes as HA
import Style exposing (clashDisplay, lineHeight, lineHeight150, paddings)


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
        Phone ->
            column [ width fill ]
                [ row [ width fill, clashDisplay, lineHeight150, Font.size 24, paddings 20 20 20 24 ]
                    [ el [ alignLeft, paddingXY 2 2 ] (text "Aguna")
                    , row [ alignRight, spacing 20 ]
                        [ image [ width (px 16), height (px 16), Font.alignLeft, onClick SearchMenuClicked ] { src = "/icons/search.svg", description = "header search button" }
                        , image [ width (px 16), height (px 16), Font.alignRight, onClick HeaderMenuClicked ] { src = "/icons/menu.svg", description = "header menu button" }
                        ]
                    ]
                ]

        _ ->
            column [ width fill ]
                [ -- Top Header
                  row [ width fill, paddings 20 28 20 28 ]
                    [ el [ alignLeft ] (image [ width (px 16), height (px 16), Font.alignLeft, onClick SearchMenuClicked ] { src = "/icons/search.svg", description = "header search button" })
                    , el [ Font.size 24, clashDisplay, lineHeight150, centerX, paddingXY 2 2 ] (text "Aguna")
                    , row [ alignRight, spacing 16 ]
                        [ image [ width (px 16), height (px 16), Font.alignLeft ] { src = "/icons/cart.svg", description = "header cart button" }
                        , image [ width (px 16), height (px 16), Font.alignRight ] { src = "/icons/user.svg", description = "header user button" }
                        ]
                    ]

                -- Separator
                , el [ width fill, paddings 0 28 0 28 ]
                    (el [ width fill, height (px 1), Background.color (rgba 0 0 0 0.1) ] Element.none)
                ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


view : Device -> Model -> Html Msg
view device model =
    Element.layout
        [ width fill ]
        (column [ width (fill |> maximum 1440), centerX ]
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
