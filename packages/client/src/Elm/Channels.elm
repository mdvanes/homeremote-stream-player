module Elm.Channels exposing (..)

import Html exposing (Html, audio, button, div, img, option, p, select, text)
import Html.Attributes exposing (class, controls, id, src, title, type_, value)
import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as Json
import Json.Encode
import List exposing (filter, head)
import Maybe exposing (withDefault)
import Task
import Time
import Debug exposing (log, toString)

-- MODEL

type alias Channel =
    { name : String
    , streamUrl : String
    , nowPlayingUrl : String
    }

type alias Model =
    {
        channel: Channel
        , timestamp : String
    }

defaultChannel : Channel
defaultChannel =
    { name = "NPO Radio 2"
    , streamUrl = "https://icecast.omroep.nl/radio2-bb-mp3"
    , nowPlayingUrl = "/api/nowplaying/radio2"
    }

channels : List Channel
channels =
    [ defaultChannel
    , { name = "3FM"
      , streamUrl = "https://icecast.omroep.nl/3fm-bb-mp3"
      , nowPlayingUrl = ""
      }
    , { name = "Sky Radio"
      , streamUrl = "https://19993.live.streamtheworld.com/SKYRADIO.mp3"
      , nowPlayingUrl = ""
      }
    , { name = "Pinguin Radio"
      , streamUrl = "http://streams.pinguinradio.com/PinguinRadio320.mp3"
      , nowPlayingUrl = ""
      }
    ]

-- INIT

init : ( Model, Cmd Msg )
init =
    ( {
    channel = defaultChannel
    , timestamp = ""
    }, Task.perform UpdateTimestamp Time.now )

-- UPDATE


type Msg
    = SetChannel String
    | UpdateTimestamp Time.Posix

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetChannel val ->
            let
                targetChannel =
                    pickChannel val channels
            in
            ( { model | channel = targetChannel }, Cmd.batch [ Task.perform UpdateTimestamp Time.now, getNowPlaying (model.url ++ targetChannel.nowPlayingUrl) ] )

        UpdateTimestamp time ->
            ( { model | timestamp = toString (Time.posixToMillis time) }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
 select [ on "change" (Json.map SetChannel targetValue) ] (List.map channelOption channels)

channelOption : Channel -> Html msg
channelOption channel =
    option [ value channel.name ] [ text channel.name ]



-- equivalent to: pickChannel channelName channelList = withDefault defaultChannel (head (filter (\x -> x.name == channelName) channelList))


pickChannel : String -> List Channel -> Channel
pickChannel channelName channelList =
    channelList
        |> filter (\x -> x.name == channelName)
        |> head
        |> withDefault defaultChannel
