module Elm.SelectedChannel exposing (Model, Msg(..), init, update, defaultChannel, channels, Channel)

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
    { channel: Channel
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
    }, Cmd.none )

-- UPDATE


type Msg
    = SetChannel Channel

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetChannel val ->
            --let
            --    targetChannel =
            --        pickChannel val channels
            --in
            -- TODO fix getNowPlaying ***
            --( { model | channel = targetChannel }, Cmd.batch [ Task.perform UpdateTimestamp Time.now, getNowPlaying (model.url ++ targetChannel.nowPlayingUrl) ] )
            ( { model | channel = log "SetChannel" val }, Cmd.none )



-- VIEW


--view : Model -> Html Msg
--view model =
-- select [ on "change" (Json.map SetChannel targetValue) ] (List.map channelOption channels)
--
--channelOption : Channel -> Html msg
--channelOption channel =
--    option [ value channel.name ] [ text channel.name ]



-- equivalent to: pickChannel channelName channelList = withDefault defaultChannel (head (filter (\x -> x.name == channelName) channelList))


--pickChannel : String -> List Channel -> Channel
--pickChannel channelName channelList =
--    channelList
--        |> filter (\x -> x.name == channelName)
--        |> head
--        |> withDefault defaultChannel
