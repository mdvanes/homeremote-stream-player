module Elm.Controls exposing (Model, Msg(..), init, update, view)

import Debug exposing (toString)
import Elm.Ports exposing (setPlayPauseStatusPort)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    {}


type Msg
    = SetPlayPauseStatus PlayPauseStatus


type PlayPauseStatus
    = Play
    | Pause


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPlayPauseStatus status ->
            ( model, setPlayPauseStatusPort (toString status) )


view : Model -> Html Msg
view model =
    div
        []
        [ button
            [ onClick (SetPlayPauseStatus Play) ]
            [ text "play" ]
        , button
            [ onClick (SetPlayPauseStatus Pause) ]
            [ text "pause" ]
        ]
