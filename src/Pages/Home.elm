module Pages.Home exposing (Model, Msg, init, update, view)

import Element
    exposing
        ( Device
        , DeviceClass(..)
        , Element
        , Length
        , alignRight
        , centerX
        , column
        , el
        , fill
        , height
        , html
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
        , wrappedRow
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, br)
import Html.Attributes as HtmlAttr
import Style exposing (bodyLarge, bodyMedium, borderGrey, clashDisplay, darkPrimary, headlineFour, headlineThree, headlineTwo, lightGrey, paddings, satoshi, white)


ariaLabel : String -> Element.Attribute msg
ariaLabel =
    HtmlAttr.attribute "aria-label" >> Element.htmlAttribute


ariaExpanded : Bool -> Element.Attribute msg
ariaExpanded isOpen =
    HtmlAttr.attribute "aria-expanded"
        (if isOpen then
            "true"

         else
            "false"
        )
        |> Element.htmlAttribute


ariaHidden : Element.Attribute msg
ariaHidden =
    HtmlAttr.attribute "aria-hidden" "true" |> Element.htmlAttribute


role : String -> Element.Attribute msg
role r =
    HtmlAttr.attribute "role" r |> Element.htmlAttribute


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
            column [ spacing 24, paddings 20 20 20 24, height fill, width fill, Background.color white, ariaLabel "Main menu", role "dialog", ariaExpanded True ]
                [ -- Panel Header
                  row [ width fill, spaceEvenly ]
                    [ el [ paddings 2 0 2 0, clashDisplay, Font.size 24 ] (baseLink "" (text "Aguna"))
                    , baseIconButton
                        { onPress = Just HeaderMenuClicked
                        , label = "Close menu"
                        , expanded = Just False
                        }
                        (image [ width (px 16), height (px 16), ariaHidden ]
                            { src = "/icons/close.svg", description = "" }
                        )
                    ]
                , column [ Font.alignLeft, spacing 44, satoshi, Font.size 16, Font.color (rgb255 114 110 141), paddings 20 0 20 0 ]
                    categories
                ]

        _ ->
            Element.none


baseIconButton :
    { onPress : Maybe msg
    , label : String
    , expanded : Maybe Bool
    }
    -> Element msg
    -> Element msg
baseIconButton config child =
    Input.button
        ([ Border.width 1
         , Border.color white
         , Element.focused [ Border.color darkPrimary ]
         , ariaLabel config.label
         ]
            ++ (case config.expanded of
                    Just isOpen ->
                        [ ariaExpanded isOpen ]

                    Nothing ->
                        []
               )
        )
        { onPress = config.onPress, label = child }


viewHeader : Device -> Model -> Element Msg
viewHeader device model =
    case device.class of
        Phone ->
            column [ width fill, role "banner" ]
                [ row [ width fill, clashDisplay, Font.size 24, paddings 20 20 20 24, spaceEvenly ]
                    [ el [ paddings 2 0 2 0 ] (baseLink "" (text "Aguna"))
                    , row [ spacing 20 ]
                        [ baseIconButton
                            { onPress = Just SearchMenuClicked, label = "Search", expanded = Just model.searchMenuOpened }
                            (image [ width (px 16), height (px 16), ariaHidden ]
                                { src = "/icons/search.svg", description = "" }
                            )
                        , baseIconButton
                            { onPress = Just HeaderMenuClicked, label = "Open Menu", expanded = Just model.headerMenuIsOpened }
                            (image [ width (px 16), height (px 16), ariaHidden ]
                                { src = "/icons/menu.svg", description = "" }
                            )
                        ]
                    ]
                ]

        _ ->
            column [ width fill, role "banner" ]
                [ -- Top Header
                  row [ width fill, paddings 20 28 20 28 ]
                    [ el []
                        (baseIconButton
                            { onPress = Just SearchMenuClicked
                            , label = "Search"
                            , expanded = Just model.searchMenuOpened
                            }
                            (image [ width (px 16), height (px 16), ariaHidden ]
                                { src = "/icons/search.svg", description = "" }
                            )
                        )
                    , el [ Font.size 24, clashDisplay, centerX, paddings 2 0 2 0 ] (baseLink "" (text "Aguna"))
                    , row [ spacing 16 ]
                        [ baseIconButton
                            { onPress = Just SearchMenuClicked
                            , label = "Cart"
                            , expanded = Just model.searchMenuOpened
                            }
                            (image
                                [ width (px 16), height (px 16), ariaHidden ]
                                { src = "/icons/cart.svg", description = "" }
                            )
                        , baseIconButton
                            { onPress = Nothing
                            , label = "Account"
                            , expanded = Nothing
                            }
                            (image [ width (px 16), height (px 16), ariaHidden ]
                                { src = "/icons/user.svg", description = "" }
                            )
                        ]
                    ]

                -- Separator
                , el [ width fill, paddings 0 28 0 28 ]
                    (el [ width fill, height (px 1), Background.color (rgba 0 0 0 0.1) ] Element.none)

                -- Categories
                , row [ centerX, spacing 44, satoshi, Font.size 16, Font.color (rgb255 114 110 141), paddings 20 0 20 0, role "navigation", ariaLabel "Categories" ]
                    categories
                ]


viewHeroButton : Device -> Element msg
viewHeroButton device =
    let
        buttonLength =
            if device.class == Phone then
                fill

            else
                shrink
    in
    Input.button
        [ paddings 20 32 20 32
        , Background.color lightGrey
        , mouseOver [ Background.color borderGrey ]
        , Border.color lightGrey
        , Border.width 1
        , Element.focused [ Border.color darkPrimary ]
        , width buttonLength
        ]
        { onPress = Nothing
        , label =
            el
                [ Font.center
                , bodyMedium
                , satoshi
                , width buttonLength
                , Font.color darkPrimary
                ]
                (text "View Collection")
        }


viewHeroContent : Device -> Element msg
viewHeroContent device =
    let
        { paragraphSpacing, titleFontSize, subtitleFontSize, dynamicSubtitle } =
            case device.class of
                Phone ->
                    { paragraphSpacing = spacing 12
                    , titleFontSize = Font.size 24
                    , subtitleFontSize = Font.size 16
                    , dynamicSubtitle = "With dozens of unique pieces and new finds arriving often, explore books, tools, furniture, electronics, and more"
                    }

                _ ->
                    { paragraphSpacing = spacing 20
                    , titleFontSize = headlineTwo
                    , subtitleFontSize = bodyLarge
                    , dynamicSubtitle = "Explore our pre-loved books and more"
                    }
    in
    column [ paragraphSpacing ]
        [ paragraph [ clashDisplay, titleFontSize ]
            [ text "Secondhand finds for people who love good stuff at great prices"
            ]
        , paragraph [ satoshi, subtitleFontSize ]
            [ text
                dynamicSubtitle
            ]
        ]


heroConfig :
    Device
    ->
        { heroImageHeight : Length
        , columnSpacing : Element.Attribute msg
        , contentPaddings : Element.Attribute msg
        , contentMoveDown : Element.Attribute msg
        , contentMoveLeft : Element.Attribute msg
        , maxWidth : Int
        }
heroConfig device =
    case device.class of
        Tablet ->
            { heroImageHeight = px 504
            , columnSpacing = spacing 50
            , contentPaddings = paddings 38 51 36 46
            , contentMoveDown = moveDown 60
            , contentMoveLeft = moveLeft 60
            , maxWidth = 440
            }

        _ ->
            { heroImageHeight = px 704
            , columnSpacing = spacing 157
            , contentMoveDown = moveDown 130
            , contentPaddings = paddings 48 61 46 56
            , contentMoveLeft = moveLeft 80
            , maxWidth = 640
            }


viewBigHero : Device -> Element msg
viewBigHero device =
    case device.class of
        Phone ->
            none

        _ ->
            let
                { heroImageHeight, columnSpacing, contentPaddings, contentMoveDown, contentMoveLeft, maxWidth } =
                    heroConfig device
            in
            el
                [ width fill
                , height heroImageHeight
                , Background.image "/images/hero.jpeg"
                , inFront
                    (column
                        [ columnSpacing
                        , centerX
                        , width (fill |> maximum maxWidth)
                        , contentPaddings
                        , Font.color darkPrimary
                        , Background.color white
                        , alignRight
                        , contentMoveDown
                        , contentMoveLeft
                        ]
                        [ viewHeroContent device
                        , viewHeroButton device
                        ]
                    )
                ]
                none


viewHero : Device -> Element msg
viewHero device =
    case device.class of
        Phone ->
            column []
                [ column [ spacing 32, centerX, width fill, paddings 47 25 32 24, Font.color darkPrimary ]
                    [ viewHeroContent device
                    , viewHeroButton device
                    ]
                , image [ width fill, ariaHidden ] { description = "hero image", src = "/images/hero.jpeg" }
                ]

        _ ->
            viewBigHero device


valueProposition :
    Device
    -> { icon : String, title : String, description : String }
    -> Element msg
valueProposition device cardConfig =
    let
        ( cardWidth, cardPaddings ) =
            case device.class of
                Phone ->
                    ( width (px 342), paddings 36 24 36 24 )

                Tablet ->
                    ( width (px 265), paddings 36 24 36 24 )

                _ ->
                    ( width (px 305), paddings 48 48 48 48 )
    in
    el [ Background.color lightGrey, cardWidth, cardPaddings ]
        (column [ spacing 12 ]
            [ image [ width (px 24), height (px 24), ariaHidden ]
                { src = cardConfig.icon, description = "" }
            , paragraph
                [ headlineFour, Font.color darkPrimary, clashDisplay ]
                [ text cardConfig.title ]
            , paragraph
                [ bodyMedium, Font.color darkPrimary, satoshi ]
                [ text cardConfig.description ]
            ]
        )


valuePropositions : Device -> Element msg
valuePropositions device =
    let
        layoutStyles =
            case device.class of
                Phone ->
                    [ paddings 48 24 50 25, spacing 36, centerX ]

                Tablet ->
                    [ paddings 48 24 50 24, spacing 36, centerX, width (fill |> maximum 600) ]

                _ ->
                    [ paddings 80 80 82 80, spacing 36, centerX, width shrink ]

        layoutContainerStyles =
            case device.class of
                Phone ->
                    [ spacing 26 ]

                Tablet ->
                    [ spacing 22, spaceEvenly ]

                _ ->
                    [ spacing 22 ]

        title =
            case device.class of
                Phone ->
                    paragraph [ headlineFour, Font.color darkPrimary, clashDisplay ]
                        [ text "What makes our brand"
                        , html <| br [] []
                        , text "different"
                        ]

                _ ->
                    paragraph [ headlineThree, Font.color darkPrimary, clashDisplay, Font.center ]
                        [ text "What makes our brand different"
                        ]

        layoutContainer attrs children =
            case device.class of
                Phone ->
                    column attrs children

                _ ->
                    wrappedRow attrs children
    in
    column
        layoutStyles
        [ title
        , layoutContainer layoutContainerStyles
            [ valueProposition
                device
                { icon = "icons/delivery.svg", title = "Next day as standard", description = "Order before 3pm and get your order the next day" }
            , valueProposition
                device
                { icon = "icons/checkmark.svg", title = "High quality stuff", description = "We only sell sorted high-quality pre-loved products" }
            , valueProposition
                device
                { icon = "icons/purchase.svg", title = "Unbeatable prices", description = "You won't find better prices anywhere" }
            , valueProposition
                device
                { icon = "icons/sprout.svg", title = "Recycled packaging", description = "We use 100% recycled packaging" }
            ]
        ]


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
            , role "main"
            ]
            [ viewHeader device model
            , viewHero device
            , valuePropositions device
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
