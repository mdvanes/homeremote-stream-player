module Elm.Audio exposing (main)

import Browser
import Debug exposing (log, toString)
import Elm.Controls
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
import Elm.SelectedChannel exposing (defaultChannel)
import Elm.ChannelSelector


-- TODO split into multiple files, Elm architecture
-- TODO emit an event to a port each time GetNowPlaying is called and the values are different
-- Audio events based on https://vincent.jousse.org/en/tech/interacting-with-dom-element-using-elm-audio-video/


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


--type alias Channel =
--    { name : String
--    , streamUrl : String
--    , nowPlayingUrl : String
--    }


type alias Model =
    --title : String
    --, artist : String
    --, imageUrl : String
    --, name : String
    --, serviceUrlRoot : String
    { controls : Elm.Controls.Model
    , channelSelector : Elm.ChannelSelector.Model
    , nowPlaying : Elm.NowPlaying.Model
    }


type alias FlagModel =
    { serviceUrlRoot : String }


flagDecoder : Json.Decoder FlagModel
flagDecoder =
    Json.map FlagModel
        (Json.field "serviceUrlRoot" Json.string)


createModelInit : String -> Elm.Controls.Model -> Elm.ChannelSelector.Model -> Elm.NowPlaying.Model -> Model
createModelInit serviceUrlRoot controlsInit channelSelectorInit nowPlayingInit =
    { controls = controlsInit
    , channelSelector = channelSelectorInit
    , nowPlaying = nowPlayingInit
    }

createCmdInit : String -> Cmd Elm.Controls.Msg -> Cmd Elm.ChannelSelector.Msg -> Cmd Elm.NowPlaying.Msg -> Cmd Msg
createCmdInit serviceUrlRoot controlsCmds channelSelectorCmds nowPlayingCmds =
    Cmd.batch
        [ Cmd.map MsgControls controlsCmds
        , Cmd.map MsgChannelSelector channelSelectorCmds
        -- , getNowPlaying (serviceUrlRoot ++ defaultChannel.nowPlayingUrl)
        , Cmd.map MsgNowPlaying nowPlayingCmds
        ]

init : Json.Encode.Value -> ( Model, Cmd Msg )
init flags =
    let
        ( controlsInit, controlsCmds ) =
            Elm.Controls.init
        ( channelSelectorInit, channelSelectorCmds ) =
            Elm.ChannelSelector.init
    in
    case Json.decodeValue flagDecoder flags of
        Ok flagModel ->
            let
                ( nowPlayingInit, nowPlayingCmds ) =
                    Elm.NowPlaying.init flagModel.serviceUrlRoot
            in
            ( createModelInit flagModel.serviceUrlRoot controlsInit channelSelectorInit nowPlayingInit
            , createCmdInit flagModel.serviceUrlRoot controlsCmds channelSelectorCmds nowPlayingCmds
            )
        Err _ ->
            let
                ( nowPlayingInit, nowPlayingCmds ) =
                    Elm.NowPlaying.init ""
            in
            ( createModelInit "" controlsInit channelSelectorInit nowPlayingInit
            , createCmdInit "" controlsCmds channelSelectorCmds nowPlayingCmds
            )






--getNowPlaying : String -> Cmd Msg
--getNowPlaying nowPlayingUrl =
--    Http.get
--        { url = nowPlayingUrl
--        , expect = Http.expectJson GotNowPlaying nowPlayingDecoder
--        }


--type alias NowPlaying =
--    { artist : String
--    , title : String
--    , songImageUrl : String
--    , imageUrl : String
--    , name : String
--    }
--
--
--nowPlayingDecoder : Json.Decoder NowPlaying
--nowPlayingDecoder =
--    Json.map5 NowPlaying
--        (Json.field "artist" Json.string)
--        (Json.field "title" Json.string)
--        (Json.field "songImageUrl" Json.string)
--        (Json.field "imageUrl" Json.string)
--        (Json.field "name" Json.string)


--getImageUrl : NowPlaying -> String
--getImageUrl data =
--    if data.songImageUrl /= "" then
--        data.songImageUrl
--
--    else
--        data.imageUrl



-- UPDATE


type Msg
    = MsgControls Elm.Controls.Msg
    | MsgChannelSelector Elm.ChannelSelector.Msg
    | MsgNowPlaying Elm.NowPlaying.Msg



-- TODO instead of map4 use https://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest/
--  also see https://stackoverflow.com/questions/46993855/elm-decoding-a-nested-array-of-objects-with-elm-decode-pipeline
--  can't use elm-decode-pipeline, because it does not yet support Elm 0.19
--  install with: elm install NoRedInk/elm-decode-pipeline


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        MsgControls msg_ ->
            let
                ( controlsModel, controlsCmds ) =
                    Elm.Controls.update msg_ model.controls
            in
            ( { model | controls = controlsModel }
            , Cmd.map MsgControls controlsCmds
            )

        MsgChannelSelector msg_ ->
            let
                ( channelSelectorModel, channelSelectorCmds ) =
                    Elm.ChannelSelector.update msg_ model.channelSelector
            in
            ( { model | channelSelector = channelSelectorModel }
            , Cmd.map MsgChannelSelector channelSelectorCmds
            )

        MsgNowPlaying msg_ ->
            let
                ( nowPlayingModel, nowPlayingCmds ) =
                    Elm.NowPlaying.update msg_ model.nowPlaying
            in
            ( { model | nowPlaying = nowPlayingModel }
            , Cmd.map MsgNowPlaying nowPlayingCmds
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ div
            [ class "card" ]
            [ div
                [ class "music-info" ]
                [ div
                    [ class "channel" ]
                    [ Html.map MsgChannelSelector (Elm.ChannelSelector.view model.channelSelector)
                    , p [ class "channel-info" ] [ text (log "my debug statement:" model.nowPlaying.name) ]
                    ]
                , Html.map MsgNowPlaying (Elm.NowPlaying.viewTitleArtist model.nowPlaying)

                --, div [] [ text (model.name ++ " on " ++ model.channel) ]
                , div [] [ text (model.channelSelector.selectedChannel.channel.streamUrl ++ "?" ++ model.channelSelector.timestamp) ]
                , audio
                    [ id "homeremote-stream-player-audio-elem"
                    , src (model.channelSelector.selectedChannel.channel.streamUrl ++ "?" ++ model.channelSelector.timestamp)
                    , type_ "audio/mpeg"
                    , controls True

                    --`, on "play" (Json.map TimeUpdate timeDecoder)` can also be written as `onPlay TimeUpdate` with functions defined elsewhere:
                    -- onPlay : (Float -> msg) -> Html.Attribute msg
                    -- onPlay msg =
                    --     on "play" (Json.map msg timeDecoder)
                    --
                    -- timeDecoder : Json.Decoder Float
                    -- timeDecoder =
                    --     Json.at [ "target", "currentTime" ] Json.float
                    , Html.Attributes.map MsgNowPlaying (Elm.NowPlaying.onPlay model.nowPlaying)
                    ]
                    [ text "Your browser does not support the audio element."
                    ]
                , Html.map MsgControls (Elm.Controls.view model.controls)
                ]
            , Html.map MsgNowPlaying (Elm.NowPlaying.viewImage model.nowPlaying)
            --, button
            --    [ onClick Elm.NowPlaying.GetNowPlaying
            --    , title "Get Now Playing"
            --    , class "get-now-playing"
            --    ]
            --    [ img [ src model.imageUrl ] [] ]
            ]
        ]
