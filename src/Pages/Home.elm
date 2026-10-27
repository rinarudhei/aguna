module Pages.Home exposing (Model, Msg, init, update, view)

import Element
    exposing
        ( Device
        , DeviceClass(..)
        , Element
        , alignRight
        , centerX
        , column
        , el
        , fill
        , height
        , htmlAttribute
        , image
        , inFront
        , link
        , maximum
        , mouseOver
        , moveDown
        , moveLeft
        , none
        , paragraph
        , px
        , rgb255
        , rgba
        , row
        , shrink
        , spaceEvenly
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes as Attr
import Style exposing (bodyLarge, bodyMedium, borderGrey, clashDisplay, darkPrimary, headlineTwo, lightGrey, paddings, satoshi, white)


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


baseLink : String -> Element msg -> Element msg
baseLink url label =
    link [ Border.width 1, Border.color white, Element.focused [ Border.color darkPrimary ] ]
        { url = url, label = label }


categories : List (Element Msg)
categories =
    [ baseLink "" (text "Books")
    , baseLink "" (text "Electronics")
    , baseLink "" (text "Cutlery")
    , baseLink "" (text "Furnitures")
    , baseLink "" (text "Tools")
    , baseLink "" (text "Tumblrs")
    ]


viewMobileMenu : Device -> Model -> Element Msg
viewMobileMenu device model =
    case ( device.class, model.headerMenuIsOpened ) of
        ( Phone, True ) ->
            column [ spacing 24, paddings 20 20 20 24, height fill, width fill, Background.color white ]
                [ -- Panel Header
                  row [ width fill, spaceEvenly ]
                    [ el [ paddings 2 0 2 0, clashDisplay, Font.size 24 ] (baseLink "" (text "Aguna"))
                    , baseIconButton
                        (Just HeaderMenuClicked)
                        (image [ width (px 16), height (px 16) ]
                            { src = "/icons/close.svg", description = "close menu button" }
                        )
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
                [ row [ width fill, clashDisplay, Font.size 24, paddings 20 20 20 24, spaceEvenly ]
                    [ el [ paddings 2 0 2 0 ] (baseLink "" (text "Aguna"))
                    , row [ spacing 20 ]
                        [ baseIconButton
                            (Just SearchMenuClicked)
                            (image [ width (px 16), height (px 16) ]
                                { src = "/icons/search.svg", description = "header search button" }
                            )
                        , baseIconButton
                            (Just HeaderMenuClicked)
                            (image [ width (px 16), height (px 16) ]
                                { src = "/icons/menu.svg", description = "header menu button" }
                            )
                        ]
                    ]
                ]

        _ ->
            column [ width fill ]
                [ -- Top Header
                  row [ width fill, paddings 20 28 20 28 ]
                    [ el []
                        (baseIconButton
                            (Just SearchMenuClicked)
                            (image [ width (px 16), height (px 16) ]
                                { src = "/icons/search.svg", description = "header search button" }
                            )
                        )
                    , el [ Font.size 24, clashDisplay, centerX, paddings 2 0 2 0 ] (baseLink "" (text "Aguna"))
                    , row [ spacing 16 ]
                        [ baseIconButton
                            Nothing
                            (image
                                [ width (px 16), height (px 16) ]
                                { src = "/icons/cart.svg", description = "header cart button" }
                            )
                        , baseIconButton
                            Nothing
                            (image [ width (px 16), height (px 16) ]
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
    case device.class of
        Phone ->
            column []
                [ column [ spacing 32, centerX, width fill, paddings 47 25 32 24, Font.color darkPrimary ]
                    [ -- Hero Content
                      column [ spacing 12 ]
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
                        [ paddings 20 32 20 32
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
                                , bodyMedium
                                , satoshi
                                , width fill
                                , Font.color darkPrimary
                                ]
                                (text "View Collection")
                        }
                    ]
                , image [ width fill ] { description = "hero image", src = "/images/hero.jpeg" }
                ]

        Tablet ->
            el
                [ width fill
                , height (px 504)
                , Background.image "/images/hero.jpeg"
                , inFront
                    (column
                        [ spacing 50
                        , centerX
                        , width (fill |> maximum 440)
                        , paddings 38 51 36 46
                        , Font.color darkPrimary
                        , Background.color white
                        , alignRight
                        , moveDown 60
                        , moveLeft 60
                        ]
                        [ -- Hero Content
                          column [ spacing 20 ]
                            [ paragraph [ clashDisplay, headlineTwo ]
                                [ text "Secondhand finds for people who love good stuff at great prices"
                                ]
                            , paragraph [ satoshi, bodyLarge ]
                                [ text
                                    "With dozens of unique pieces and new finds arriving often, explore books, tools, furniture, electronics, and more"
                                ]
                            ]

                        -- Hero Button
                        , Input.button
                            [ paddings 20 32 20 32
                            , Background.color lightGrey
                            , mouseOver [ Background.color borderGrey ]
                            , Border.color white
                            , Border.width 1
                            , Element.focused [ Border.color darkPrimary ]
                            , width shrink
                            ]
                            { onPress = Nothing
                            , label =
                                el
                                    [ Font.center
                                    , bodyMedium
                                    , satoshi
                                    , width fill
                                    , Font.color darkPrimary
                                    ]
                                    (text "View Collection")
                            }
                        ]
                    )
                ]
                none

        _ ->
            el
                [ width fill
                , height (px 704)
                , Background.image "/images/hero.jpeg"
                , inFront
                    (column
                        [ spacing 157
                        , centerX
                        , width (fill |> maximum 640)
                        , paddings 48 61 46 56
                        , Font.color darkPrimary
                        , Background.color white
                        , alignRight
                        , moveDown 130
                        , moveLeft 80
                        ]
                        [ -- Hero Content
                          column [ spacing 20 ]
                            [ paragraph [ clashDisplay, headlineTwo ]
                                [ text "Secondhand finds for people who love good stuff at great prices"
                                ]
                            , paragraph [ satoshi, bodyLarge ]
                                [ text
                                    "With dozens of unique pieces and new finds arriving often, explore books, tools, furniture, electronics, and more"
                                ]
                            ]

                        -- Hero Button
                        , Input.button
                            [ paddings 20 32 20 32
                            , Background.color lightGrey
                            , mouseOver [ Background.color borderGrey ]
                            , Border.color white
                            , Border.width 1
                            , Element.focused [ Border.color darkPrimary ]
                            , width shrink
                            ]
                            { onPress = Nothing
                            , label =
                                el
                                    [ Font.center
                                    , bodyMedium
                                    , satoshi
                                    , width fill
                                    , Font.color darkPrimary
                                    ]
                                    (text "View Collection")
                            }
                        ]
                    )
                ]
                -- { description = "hero image", src = "/images/hero.jpeg" }
                none


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


view : Device -> Model -> Html Msg
view device model =
    Element.layout []
        (column
            [ width (fill |> maximum 1920)
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
