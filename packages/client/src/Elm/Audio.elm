module Elm.Audio exposing (main)

import Browser
import Debug exposing (log)
import Html exposing (Html, button, div, text, audio, select, option, img)
import Html.Attributes exposing (class, controls, type_, src, title, value)
import Html.Events exposing (onClick, on, targetValue)
import Json.Decode as Json
import Http
import List exposing (head, filter)
import Maybe exposing (withDefault)

--TODO cache busting, switch stations (also endpoint url), remove count/+1/-1 examples, styling

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type alias Channel =
    { name: String
    , streamUrl: String
    , nowPlayingUrl: String
    }

type alias Model =
    { count: Int
    , channel: Channel
    , nowplaying: String
    , imageUrl: String
    , name: String
    }

--  (withDefault defaultChannel (head channels)) bit overengineerd, could do defaultChannel directly but good example of Maybe

init : () -> (Model, Cmd Msg)
init _ =
  (
    { count = 0
    , channel = (withDefault defaultChannel (head channels))
    , nowplaying = ""
    , imageUrl = ""
    , name = "" }
    , getNowPlaying defaultChannel.nowPlayingUrl
  )

defaultChannel: Channel
defaultChannel = { name = "NPO Radio 2"
                         , streamUrl = "https://icecast.omroep.nl/radio2-bb-mp3"
                         , nowPlayingUrl = "http://localhost:3100/api/nowplaying/radio2"}

channels : List Channel
channels =
    [ defaultChannel
    , { name = "Sky Radio"
        , streamUrl = "https://19993.live.streamtheworld.com/SKYRADIO.mp3"
        , nowPlayingUrl = ""
    }]

channelOption : Channel -> Html msg
channelOption channel =
    option [ value channel.name] [text channel.name]

-- equivalent to: pickChannel channelName channelList = withDefault defaultChannel (head (filter (\x -> x.name == channelName) channelList))
pickChannel : String -> List Channel -> Channel
pickChannel channelName channelList =
    channelList
        |> filter (\x -> x.name == channelName)
        |> head
        |> withDefault defaultChannel

-- HTTP

getNowPlaying : String -> Cmd Msg
getNowPlaying nowPlayingUrl =
    Http.get
        { url = nowPlayingUrl
        , expect = Http.expectJson GotNowPlaying nowPlayingDecoder
        }

type alias NowPlaying =
    { artist : String
    , title: String
    , songImageUrl: String
    , imageUrl: String
    , name: String
    }

nowPlayingDecoder : Json.Decoder NowPlaying
nowPlayingDecoder =
    Json.map5 NowPlaying
        (Json.field "artist" Json.string)
        (Json.field "title" Json.string)
        (Json.field "songImageUrl" Json.string)
        (Json.field "imageUrl" Json.string)
        (Json.field "name" Json.string)

getImageUrl : NowPlaying -> String
getImageUrl data =
    if data.songImageUrl /= "" then
        data.songImageUrl
    else
        data.imageUrl


-- UPDATE

type Msg = Increment | Decrement | GetNowPlaying | SetChannel String | GotNowPlaying (Result Http.Error NowPlaying)

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
      (model, getNowPlaying model.channel.nowPlayingUrl)
    SetChannel val ->
      let
          targetChannel = pickChannel val channels
      in
      ({ model | channel = targetChannel }, getNowPlaying targetChannel.nowPlayingUrl)
    GotNowPlaying result ->
        case result of
            Ok data ->
                ({ model
                    | nowplaying = (data.artist ++ " - " ++ data.title)
                    , name = data.name
                    , imageUrl = (getImageUrl data) }, Cmd.none)
            Err _ ->
                ({ model | nowplaying = "FAILED", name = "FAILED" }, Cmd.none)



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
        [ select [ on "change" (Json.map SetChannel targetValue)] (List.map channelOption channels)
        , div [] [ text (model.nowplaying) ]
        --, div [] [ text (model.name ++ " on " ++ model.channel) ]
        , div [] [ text ( log "my debug statement:" (model.name ++ " on " ++ model.channel.name) ) ]
        , button
            [ onClick GetNowPlaying
            , title "Get Now Playing"
            , class "get-now-playing" ]
            [ img [ src model.imageUrl ] [] ]
        , audio
            [ src model.channel.streamUrl
            , type_ "audio/mpeg"
            , controls True]
            [ text "Your browser does not support the audio element."
            ]
        ]
    ]
