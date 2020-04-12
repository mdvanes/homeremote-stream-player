module Elm.Audio exposing (main)

import Browser
import Html exposing (Html, button, div, text, audio, select, option)
import Html.Attributes exposing (class, controls, type_, src, title, value)
import Html.Events exposing (onClick, on, targetValue)
import Json.Decode as Json
import Http

--TODO cache busting, switch stations (also endpoint url), get now playing, remove count/+1/-1 examples

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type alias Model = { count: Int, channel: String, nowplaying: String }

init : () -> (Model, Cmd Msg)
init _ =
  (
    { count = 0
    , channel = "NPO Radio 2"
    , nowplaying = "" }
    , getNowPlaying
  )

channelOptions = ["NPO Radio 2", "Sky Radio"]

channelOption channel =
    option [ value channel] [text channel]

-- HTTP

getNowPlaying : Cmd Msg
getNowPlaying =
    Http.get
        { url = "http://localhost:3100/api/nowplaying/radio2"
        , expect = Http.expectJson GotNowPlaying nowPlayingDecoder
        }

type alias NowPlaying =
    { artist : String
    , title: String
    , imageUrl: String
    }

nowPlayingDecoder : Json.Decoder String
nowPlayingDecoder =
    Json.field "title" Json.string


-- UPDATE

type Msg = Increment | Decrement | GetNowPlaying | SetChannel String | GotNowPlaying (Result Http.Error String)

-- TODO instead of map4 use https://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest/
--  also see https://stackoverflow.com/questions/46993855/elm-decoding-a-nested-array-of-objects-with-elm-decode-pipeline
--  can't use elm-decode-pipeline, because it does not yet support Elm 0.19
--  install with: elm install NoRedInk/elm-decode-pipeline

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ({ model | count = model.count + 1 }, Cmd.none)
    Decrement ->
      ({ model | count = model.count - 1 }, Cmd.none)
    GetNowPlaying ->
      ({ model | count = model.count - 1 }, Cmd.none)
    SetChannel val ->
      ({ model | channel = val }, Cmd.none)
    GotNowPlaying result ->
        case result of
            Ok fullText ->
                ({ model | nowplaying = fullText }, Cmd.none)
            Err _ ->
                ({ model | nowplaying = "FAILED" }, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

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
        , div [] [ text ("Now Playing:" ++ model.nowplaying) ]
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
