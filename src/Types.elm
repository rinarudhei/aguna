module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Dom as Dom
import Browser.Navigation exposing (Key)
import Element exposing (Device)
import Url exposing (Url)


type Page
    = Home
    | Login
    | NotFound


type alias FrontendModel =
    { key : Key
    , device : Device
    , page : Page
    }


type alias BackendModel =
    {}


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | WindowResized Int Int
    | GotWindowSize Dom.Viewport
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
