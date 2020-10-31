module Elm.Controls exposing (Model, Msg(..), init, update, view)

import Debug exposing (log, toString)
import Elm.Ports exposing (setPlayPauseStatusPort)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, classList)

type alias Model =
    { currentStatus : String }


type Msg
    = SetPlayPauseStatus PlayPauseStatus


type PlayPauseStatus
    = Play
    | Pause


init : ( Model, Cmd Msg )
init =
    ( { currentStatus = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPlayPauseStatus status ->
            let
                statusStr = (toString status)
            in
            ( { model | currentStatus = statusStr }, setPlayPauseStatusPort statusStr )


view : Model -> Html Msg
view model =
    div
        [ class "controls" ]
        [ button
            [ classList 
                [ ("play", True)
                , ("active", model.currentStatus == "Play")
                ]
            , onClick (SetPlayPauseStatus Play) ]
            []
        , button
            [ class "pause"
            , onClick (SetPlayPauseStatus Pause) ]
            []
        ]
