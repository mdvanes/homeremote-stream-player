module Elm.Audio exposing (main)

import Browser
import Html exposing (Html, button, div, text, audio, select, option)
import Html.Attributes exposing (class, controls, type_, src, title, value)
import Html.Events exposing (onClick, on, targetValue)
import Json.Decode as Json

--TODO cache busting, switch stations, get now playing, remove count/+1/-1 examples

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = { count: Int, channel: String }

init : Model
init =
  { count = 0
  , channel = "NPO Radio 2" }

channelOptions = ["NPO Radio 2", "Sky Radio"]

channelOption channel =
    option [ value channel] [text channel]

-- UPDATE

type Msg = Increment | Decrement | GetNowPlaying | SetChannel String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | count = model.count + 1 }
    Decrement ->
      { model | count = model.count - 1 }
    GetNowPlaying ->
      { model | count = model.count - 1 }
    SetChannel val ->
      { model | channel = val }


-- VIEW

view : Model -> Html Msg
view model =
  div
    []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.count) ]
    , button [ onClick Increment ] [ text "+" ]
    , div
        [ class "card" ]
        [ select [ on "change" (Json.map SetChannel targetValue)] (List.map channelOption channelOptions)
        , div [] [ text "NYI Now Playing" ]
        , div [] [ text "NYI Programme" ]
        , div [] [ text model.channel ]
        , button [ onClick GetNowPlaying , title "Refresh ~ do this onclick on logo" ] [ text "R" ]
        , audio
            [ src "https://icecast.omroep.nl/radio2-bb-mp3"
            , type_ "audio/mpeg"
            , controls True]
            [ text "Your browser does not support the audio element."
            ]
        ]
    ]
