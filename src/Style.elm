module Style exposing (..)

import Element
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes as Attr



-- TYPOGRAPHY


customFontStyles : Html msg
customFontStyles =
    Html.node "style"
        [ Attr.type_ "text/css" ]
        [ Html.text """
            @font-face { font-family: 'Clash Display'; src: url('/fonts/ClashDisplay-Extralight.woff2') format('woff2'); font-weight: 200; font-style: normal; font-display: swap; }
            @font-face { font-family: 'Clash Display'; src: url('/fonts/ClashDisplay-Light.woff2')      format('woff2'); font-weight: 300; font-style: normal; font-display: swap; }
            @font-face { font-family: 'Clash Display'; src: url('/fonts/ClashDisplay-Regular.woff2')    format('woff2'); font-weight: 400; font-style: normal; font-display: swap; }
            @font-face { font-family: 'Clash Display'; src: url('/fonts/ClashDisplay-Medium.woff2')     format('woff2'); font-weight: 500; font-style: normal; font-display: swap; }
            @font-face { font-family: 'Clash Display'; src: url('/fonts/ClashDisplay-Semibold.woff2')   format('woff2'); font-weight: 600; font-style: normal; font-display: swap; }
            @font-face { font-family: 'Clash Display'; src: url('/fonts/ClashDisplay-Bold.woff2')       format('woff2'); font-weight: 700; font-style: normal; font-display: swap; }


            @font-face { font-family: 'Satoshi'; src: url('/fonts/Satoshi-Regular.woff2')    format('woff2'); font-weight: 400; font-style: normal; font-display: swap; }
        """ ]


clashDisplay : Element.Attribute msg
clashDisplay =
    Font.family
        [ Font.typeface "Clash Display"
        , Font.sansSerif
        ]


lineHeight : Float -> Element.Attribute msg
lineHeight mult =
    Element.htmlAttribute (Attr.style "line-height" (String.fromFloat mult))


lineHeight150 : Element.Attribute msg
lineHeight150 =
    lineHeight 1.5


headlineOne : Element.Attribute msg
headlineOne =
    Font.size 36


headlineTwo : Element.Attribute msg
headlineTwo =
    Font.size 32


headlineThree : Element.Attribute msg
headlineThree =
    Font.size 24


headlineFour : Element.Attribute msg
headlineFour =
    Font.size 20


headlineFive : Element.Attribute msg
headlineFive =
    Font.size 16


headlineSix : Element.Attribute msg
headlineSix =
    Font.size 14


bodySmall : Element.Attribute msg
bodySmall =
    Font.size 14


bodyMedium : Element.Attribute msg
bodyMedium =
    Font.size 16


bodyLarge : Element.Attribute msg
bodyLarge =
    Font.size 18



-- COLORS


darkPrimary : Element.Color
darkPrimary =
    Element.rgb255 0x2A 0x25 0x4B


primary : Element.Color
primary =
    Element.rgb255 0x4E 0x4D 0x93


lightGrey : Element.Color
lightGrey =
    Element.rgb255 0xF9 0xF9 0xF9


borderGrey : Element.Color
borderGrey =
    Element.rgb255 0xEB 0xE8 0xF4


white : Element.Color
white =
    Element.rgb255 0xFF 0xFF 0xFF


borderDark : Element.Color
borderDark =
    Element.rgb255 0xCA 0xC6 0xDA



-- SPACING


paddings : Int -> Int -> Int -> Int -> Element.Attribute msg
paddings t r b l =
    Element.paddingEach { left = l, top = t, right = r, bottom = b }
