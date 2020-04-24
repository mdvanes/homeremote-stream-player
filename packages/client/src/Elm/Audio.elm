module Elm.Audio exposing (main)

import Browser
import Debug exposing (log, toString)
import Elm.Controls
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
import Elm.Channels exposing (defaultChannel)



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


type alias Channel =
    { name : String
    , streamUrl : String
    , nowPlayingUrl : String
    }


type alias Model =
    { title : String
    , artist : String
    , imageUrl : String
    , name : String
    , serviceUrlRoot : String
    , controls : Elm.Controls.Model
    , channels : Elm.Channels.Model
    }


type alias FlagModel =
    { serviceUrlRoot : String }


flagDecoder : Json.Decoder FlagModel
flagDecoder =
    Json.map FlagModel
        (Json.field "serviceUrlRoot" Json.string)


createModelInit : String -> Elm.Controls.Model -> Elm.Channels.Model -> Model
createModelInit serviceUrlRoot controlsInit channelsInit =
    { title = ""
    , artist = ""
    , imageUrl = ""
    , name = ""
    , serviceUrlRoot = serviceUrlRoot
    , controls = controlsInit
    , channels = channelsInit
    }

createCmdInit : String -> Cmd Elm.Controls.Msg -> Cmd Elm.Channels.Msg -> Cmd Msg
createCmdInit serviceUrlRoot controlsCmds channelsCmds =
    Cmd.batch
        [ Cmd.map MsgControls controlsCmds
        , Cmd.map MsgChannels channelsCmds
        , getNowPlaying (serviceUrlRoot ++ defaultChannel.nowPlayingUrl)
        ]

init : Json.Encode.Value -> ( Model, Cmd Msg )
init flags =
    let
        ( controlsInit, controlsCmds ) =
            Elm.Controls.init
        ( channelsInit, channelsCmds ) =
            Elm.Channels.init
    in
    case Json.decodeValue flagDecoder flags of
        Ok flagModel ->
            ( createModelInit flagModel.serviceUrlRoot controlsInit channelsInit
            , createCmdInit flagModel.serviceUrlRoot controlsCmds channelsCmds
            )
        Err _ ->
            ( createModelInit "" controlsInit channelsInit
            , createCmdInit "" controlsCmds channelsCmds
            )





-- HTTP
-- TODO nowPlayingUrl could be prefixed with serviceUrlRoot from flag, but the suffix can be "". Split into 2 arguments and test if the suffix is "" before calling Http.get


getNowPlaying : String -> Cmd Msg
getNowPlaying nowPlayingUrl =
    Http.get
        { url = nowPlayingUrl
        , expect = Http.expectJson GotNowPlaying nowPlayingDecoder
        }


type alias NowPlaying =
    { artist : String
    , title : String
    , songImageUrl : String
    , imageUrl : String
    , name : String
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


type Msg
    = GetNowPlaying
    | GotNowPlaying (Result Http.Error NowPlaying)
    | MsgControls Elm.Controls.Msg
    | MsgChannels Elm.Channels.Msg



-- TODO instead of map4 use https://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest/
--  also see https://stackoverflow.com/questions/46993855/elm-decoding-a-nested-array-of-objects-with-elm-decode-pipeline
--  can't use elm-decode-pipeline, because it does not yet support Elm 0.19
--  install with: elm install NoRedInk/elm-decode-pipeline


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNowPlaying ->
            ( model, getNowPlaying (model.serviceUrlRoot ++ model.channels.channel.nowPlayingUrl) )

        GotNowPlaying result ->
            case result of
                Ok data ->
                    ( { model
                        | title = data.title
                        , artist = data.artist
                        , name = data.name
                        , imageUrl = getImageUrl data
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | title = "UNKNOWN"
                        , artist = "UNKNOWN"
                        , name = model.channels.channel.name
                      }
                    , Cmd.none
                    )

        MsgControls msg_ ->
            let
                ( controlsModel, controlsCmds ) =
                    Elm.Controls.update msg_ model.controls
            in
            ( { model | controls = controlsModel }
            , Cmd.map MsgControls controlsCmds
            )

        MsgChannels msg_ ->
            let
                ( channelsModel, channelsCmds ) =
                    Elm.Channels.update msg_ model.channels
            in
            ( { model | channels = channelsModel }
            , Cmd.map MsgChannels channelsCmds
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
                    [ Html.map MsgChannels (Elm.Channels.view model.channels)
                    , p [ class "channel-info" ] [ text (log "my debug statement:" model.name) ]
                    ]
                , p [ class "title" ] [ text model.title ]
                , p [ class "artist" ] [ text model.artist ]

                --, div [] [ text (model.name ++ " on " ++ model.channel) ]
                , audio
                    [ id "homeremote-stream-player-audio-elem"
                    , src (model.channels.channel.streamUrl ++ "?" ++ model.channels.timestamp)
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
                    , on "play" (Json.succeed GetNowPlaying)
                    ]
                    [ text "Your browser does not support the audio element."
                    ]
                , Html.map MsgControls (Elm.Controls.view model.controls)
                ]
            , button
                [ onClick GetNowPlaying
                , title "Get Now Playing"
                , class "get-now-playing"
                ]
                [ img [ src model.imageUrl ] [] ]
            ]
        ]
