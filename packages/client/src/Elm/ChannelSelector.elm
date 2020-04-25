module Elm.ChannelSelector exposing (Model, Msg(..), init, update, view)

import Elm.NowPlaying
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

type alias Model =
    { selectedChannel: Elm.SelectedChannel.Model
    , nowPlaying: Elm.NowPlaying.Model
    , timestamp : String
    }


-- INIT

init : ( Model, Cmd Msg )
init =
    let
        ( selectedChannelInit, selectedChannelCmds ) =
            Elm.SelectedChannel.init
        ( nowPlayingInit, nowPlayingCmds ) =
            Elm.NowPlaying.init "TODO_initialServiceRootUrl" -- TODO
    in
    ( {
    selectedChannel = selectedChannelInit
    , nowPlaying = nowPlayingInit
    , timestamp = ""
    }, Cmd.batch [Cmd.map MsgNowPlaying nowPlayingCmds, Task.perform UpdateTimestamp Time.now ] )

-- UPDATE


type Msg
    = SelectChannel String
    | UpdateTimestamp Time.Posix
    | MsgSelectedChannel Elm.SelectedChannel.Msg
    | MsgNowPlaying Elm.NowPlaying.Msg

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

        MsgSelectedChannel msg_ ->
            let
                ( selectedChannelModel, selectedChannelCmds ) =
                    Elm.SelectedChannel.update msg_ model.selectedChannel
            in
            ( { model | selectedChannel = selectedChannelModel }
            , Cmd.map MsgSelectedChannel selectedChannelCmds
            )

        MsgNowPlaying msg_ ->
            let
                ( nowPlayingModel, nowPlayingCmds ) =
                    Elm.NowPlaying.update msg_ model.nowPlaying
            in
            ( { model | nowPlaying = nowPlayingModel }
            , Cmd.map MsgNowPlaying nowPlayingCmds)

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
