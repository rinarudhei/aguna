module Pages.Home exposing (Model, Msg, init, update, view)

import Element
    exposing
        ( Device
        , DeviceClass(..)
        , Element
        , alignLeft
        , alignRight
        , centerX
        , column
        , el
        , fill
        , height
        , image
        , inFront
        , link
        , maximum
        , mouseOver
        , none
        , paragraph
        , px
        , rgb255
        , rgba
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Style exposing (bodyMedium, borderGrey, clashDisplay, darkPrimary, lightGrey, paddings, satoshi, white)


type alias Model =
    { headerMenuIsOpened : Bool
    , searchMenuOpened : Bool
    , searchMenuText : String
    }


initialModel : Model
initialModel =
    { headerMenuIsOpened = False
    , searchMenuOpened = False
    , searchMenuText = ""
    }


baseLink : String -> String -> Element Msg
baseLink url label =
    link [ Border.width 1, Border.color white, Element.focused [ Border.color darkPrimary ] ]
        { url = url, label = text label }


categories : List (Element Msg)
categories =
    [ baseLink "" "Books"
    , baseLink "" "Electronics"
    , baseLink "" "Cutlery"
    , baseLink "" "Furnitures"
    , baseLink "" "Tools"
    , baseLink "" "Tumblrs"
    ]


viewMobileMenu : Device -> Model -> Element Msg
viewMobileMenu device model =
    case ( device.class, model.headerMenuIsOpened ) of
        ( Phone, True ) ->
            column [ spacing 24, paddings 20 20 20 20, height fill, width fill, Background.color white ]
                [ -- Panel Header
                  row [ width fill ]
                    [ el [ alignLeft, paddings 2 0 2 0 ] (text "Aguna")
                    , image [ alignRight, width (px 16), height (px 16), Font.alignLeft, onClick HeaderMenuClicked, Border.width 1, Border.color white, Element.focused [ Border.color darkPrimary ] ]
                        { src = "/icons/close.svg", description = "close menu button" }
                    ]
                , column [ Font.alignLeft, spacing 44, satoshi, Font.size 16, Font.color (rgb255 114 110 141), paddings 20 0 20 0 ]
                    categories
                ]

        _ ->
            Element.none


baseIconButton : Maybe msg -> Element msg -> Element msg
baseIconButton maybeMsg child =
    Input.button
        [ Border.width 1
        , Border.color white
        , Element.focused [ Border.color darkPrimary ]
        ]
        { onPress = maybeMsg, label = child }


viewHeader : Device -> Element Msg
viewHeader device =
    case device.class of
        Phone ->
            column [ width fill ]
                [ row [ width fill, clashDisplay, Font.size 24, paddings 20 20 20 24 ]
                    [ el [ alignLeft, paddings 2 0 2 0 ] (text "Aguna")
                    , row [ alignRight, spacing 20 ]
                        [ baseIconButton
                            (Just SearchMenuClicked)
                            (image [ width (px 16), height (px 16), Font.alignLeft, onClick SearchMenuClicked ]
                                { src = "/icons/search.svg", description = "header search button" }
                            )
                        , baseIconButton
                            (Just HeaderMenuClicked)
                            (image [ width (px 16), height (px 16), Font.alignRight, onClick HeaderMenuClicked ]
                                { src = "/icons/menu.svg", description = "header menu button" }
                            )
                        ]
                    ]
                ]

        _ ->
            column [ width fill ]
                [ -- Top Header
                  row [ width fill, paddings 20 28 20 28 ]
                    [ el [ alignLeft ]
                        (baseIconButton
                            (Just SearchMenuClicked)
                            (image [ width (px 16), height (px 16), Font.alignLeft, onClick SearchMenuClicked ]
                                { src = "/icons/search.svg", description = "header search button" }
                            )
                        )
                    , el [ Font.size 24, clashDisplay, centerX, paddings 2 0 2 0 ] (text "Aguna")
                    , row [ alignRight, spacing 16 ]
                        [ baseIconButton
                            Nothing
                            (image
                                [ width (px 16), height (px 16), Font.alignLeft ]
                                { src = "/icons/cart.svg", description = "header cart button" }
                            )
                        , baseIconButton
                            Nothing
                            (image [ width (px 16), height (px 16), Font.alignRight ]
                                { src = "/icons/user.svg", description = "header user button" }
                            )
                        ]
                    ]

                -- Separator
                , el [ width fill, paddings 0 28 0 28 ]
                    (el [ width fill, height (px 1), Background.color (rgba 0 0 0 0.1) ] Element.none)

                -- Categories
                , row [ centerX, spacing 44, satoshi, Font.size 16, Font.color (rgb255 114 110 141), paddings 20 0 20 0 ]
                    categories
                ]


viewHero : Device -> Element msg
viewHero device =
    column [ spacing 32, centerX, width fill, paddings 47 25 32 24 ]
        [ -- Hero Content
          column [ Font.color darkPrimary, spacing 12 ]
            [ paragraph [ clashDisplay, Font.size 24 ]
                [ text "Secondhand finds for people who love good stuff at great prices"
                ]
            , paragraph [ satoshi, Font.size 16 ]
                [ text
                    "With dozens of unique pieces and new finds arriving often, explore books, tools, furniture, electronics, and more"
                ]
            ]

        -- Hero Button
        , Input.button
            [ paddings 20 16 20 16
            , Background.color lightGrey
            , mouseOver [ Background.color borderGrey ]
            , Border.color lightGrey
            , Border.width 1
            , Element.focused [ Border.color darkPrimary ]
            , width fill
            ]
            { onPress = Nothing
            , label =
                el
                    [ Font.center
                    , Font.size 16
                    , bodyMedium
                    , satoshi
                    , width fill
                    ]
                    (text "View Collection")
            }
        ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


view : Device -> Model -> Html Msg
view device model =
    Element.layout []
        (column
            [ width (fill |> maximum 1440)
            , centerX
            , height fill
            , inFront (viewMobileMenu device model)
            ]
            [ viewHeader device
            , viewHero device
            ]
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
            ( { model | headerMenuIsOpened = not model.headerMenuIsOpened }, Cmd.none )
