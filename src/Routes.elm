module Routes exposing (Route(..), match, routeToUrl)

import Lamdera exposing (Url)
import Url.Parser as Parser exposing (Parser, map, oneOf, top)


type Route
    = Home
    | Login


routes : Parser (Route -> a) a
routes =
    oneOf
        [ map Home top
        , map Login (Parser.s "login")
        ]


routeToUrl : Route -> String
routeToUrl route =
    case route of
        Home ->
            "/"

        Login ->
            "/login"


match : Url -> Maybe Route
match url =
    Parser.parse routes url
