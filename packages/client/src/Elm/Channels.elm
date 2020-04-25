module Elm.Channels exposing (Model, Msg(..), init, update, view)

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
import Elm.SelectedChannel exposing (Channel, Msg(..), channels, defaultChannel)

-- MODEL

-- TODO rename file to ChannelSelector

--type alias Channel =
--    { name : String
--    , streamUrl : String
--    , nowPlayingUrl : String
--    }

type alias Model =
    { selectedChannel: Elm.SelectedChannel.Model
    , timestamp : String
    }

--defaultChannel : Channel
--defaultChannel =
--    { name = "NPO Radio 2"
--    , streamUrl = "https://icecast.omroep.nl/radio2-bb-mp3"
--    , nowPlayingUrl = "/api/nowplaying/radio2"
--    }
--
--channels : List Channel
--channels =
--    [ defaultChannel
--    , { name = "3FM"
--      , streamUrl = "https://icecast.omroep.nl/3fm-bb-mp3"
--      , nowPlayingUrl = ""
--      }
--    , { name = "Sky Radio"
--      , streamUrl = "https://19993.live.streamtheworld.com/SKYRADIO.mp3"
--      , nowPlayingUrl = ""
--      }
--    , { name = "Pinguin Radio"
--      , streamUrl = "http://streams.pinguinradio.com/PinguinRadio320.mp3"
--      , nowPlayingUrl = ""
--      }
--    ]

-- INIT

init : ( Model, Cmd Msg )
init =
    let
        ( selectedChannelInit, selectedChannelCmds ) =
            Elm.SelectedChannel.init
    in
    ( {
    selectedChannel = selectedChannelInit
    , timestamp = ""
    }, Task.perform UpdateTimestamp Time.now )

-- UPDATE


type Msg
    = SelectChannel String
    | UpdateTimestamp Time.Posix
    -- | SetChannel Elm.SelectedChannel.Channel
    | MsgSelectedChannel Elm.SelectedChannel.Msg

send : msg -> Cmd msg
send msg =
  Task.succeed msg
  |> Task.perform identity

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectChannel val ->
            let
                targetChannel =
                    pickChannel val channels
                --( channelsModel, channelsCmds ) =
                --    Elm.SelectedChannel.update msg_ model.selectedChannel
            in
            -- TODO fix getNowPlaying ***
            --( { model | channel = targetChannel }, Cmd.batch [ Task.perform UpdateTimestamp Time.now, getNowPlaying (model.url ++ targetChannel.nowPlayingUrl) ] )
            -- ( model, Cmd.batch [ send (SetChannel targetChannel), Task.perform UpdateTimestamp Time.now ] )
            ( model, Cmd.batch [ send (MsgSelectedChannel (Elm.SelectedChannel.SetChannel targetChannel)), Task.perform UpdateTimestamp Time.now ] )

        UpdateTimestamp time ->
            ( { model | timestamp = toString (Time.posixToMillis time) }, Cmd.none )

        -- WARNING INFINITE RECURSION
        --SetChannel msg_ ->
        --    ( model, send (SetChannel msg_)) -- magic? How does this end up in SelectedChannel?
        --SetChannel msg_ ->
        --    (model, log "dead end" Cmd.none) -- TODO how to run Elm.SelectedChannel.update ?

        --MsgSelectedChannel msg_ ->
        --    let
        --        ( channelsModel, channelsCmds ) =
        --            Elm.SelectedChannel.update msg_ model.selectedChannel
        --    in
        --    ( { model | selectedChannel = channelsModel }
        --    , Cmd.map MsgSelectedChannel channelsCmds
        --    )
        MsgSelectedChannel msg_ ->
            let
                ( channelsModel, channelsCmds ) =
                    Elm.SelectedChannel.update msg_ model.selectedChannel
            in
            ( { model | selectedChannel = channelsModel }
            , Cmd.map MsgSelectedChannel channelsCmds
            )

-- VIEW


view : Model -> Html Msg
view model =
 select [ on "change" (Json.map SelectChannel targetValue) ] (List.map channelOption Elm.SelectedChannel.channels)

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
