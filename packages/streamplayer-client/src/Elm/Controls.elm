module Elm.Controls exposing (Model, Msg(..), init, update, view)

import Debug exposing (log, toString)
import Elm.Ports exposing (setPlayPauseStatusPort)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)

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
        [ Html.Attributes.class "controls" ]
        [ button
            [ Html.Attributes.classList 
                [ ("play", True)
                , ("active", model.currentStatus == "Play")
                ]
            , onClick (SetPlayPauseStatus Play) ]
            [ svg
                [ width "100"
                , height "100"
                , viewBox "10 9 30 30"
                ]
                [ Svg.path
                    [ d "M-838-2232H562v3600H-838z"
                    , fill "none"
                    ]
                    []
                , Svg.path
                    [ d "M16 10v28l22-14z"
                    ]
                    []
                , Svg.path
                    [ d "M0 0h48v48H0z"
                    , fill "none"
                    ]
                    []
                ]
            ]
        , button
            [ Html.Attributes.class "pause"
            , onClick (SetPlayPauseStatus Pause) ]
            []
        ]
