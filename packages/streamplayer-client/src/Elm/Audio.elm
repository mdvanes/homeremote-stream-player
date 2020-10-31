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



-- TODO split into multiple files, Elm architecture, see branch
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
    { channel : Channel
    , title : String
    , artist : String
    , imageUrl : String
    , name : String
    , timestamp : String
    , url : String
    , controls : Elm.Controls.Model
    }


type alias FlagModel =
    { url : String }


flagDecoder : Json.Decoder FlagModel
flagDecoder =
    Json.map FlagModel
        (Json.field "url" Json.string)


init : Json.Encode.Value -> ( Model, Cmd Msg )
init flags =
    let
        ( controlsInit, controlsCmds ) =
            Elm.Controls.init
    in
    case Json.decodeValue flagDecoder flags of
        Ok flagModel ->
            ( { channel = defaultChannel
              , title = ""
              , artist = ""
              , imageUrl = ""
              , name = ""
              , timestamp = ""
              , url = flagModel.url
              , controls = controlsInit
              }
            , Cmd.batch
                [ Task.perform UpdateTimestamp Time.now
                , getNowPlaying (flagModel.url ++ defaultChannel.nowPlayingUrl)
                , Cmd.map MsgControls controlsCmds
                ]
            )

        Err _ ->
            ( { channel = defaultChannel
              , title = ""
              , artist = ""
              , imageUrl = ""
              , name = ""
              , timestamp = ""
              , url = ""
              , controls = controlsInit
              }
            , Cmd.batch
                [ Task.perform UpdateTimestamp Time.now
                , getNowPlaying defaultChannel.nowPlayingUrl
                , Cmd.map MsgControls controlsCmds
                ]
            )


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
      , nowPlayingUrl = "/api/nowplaying/radio3"
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



-- HTTP
-- TODO nowPlayingUrl could be prefixed with url from flag, but the suffix can be "". Split into 2 arguments and test if the suffix is "" before calling Http.get


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
    = SetChannel String
    | UpdateTimestamp Time.Posix
    | GetNowPlaying
    | GotNowPlaying (Result Http.Error NowPlaying)
    | MsgControls Elm.Controls.Msg



-- TODO instead of map4 use https://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest/
--  also see https://stackoverflow.com/questions/46993855/elm-decoding-a-nested-array-of-objects-with-elm-decode-pipeline
--  can't use elm-decode-pipeline, because it does not yet support Elm 0.19
--  install with: elm install NoRedInk/elm-decode-pipeline


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

        GetNowPlaying ->
            ( model, getNowPlaying (model.url ++ model.channel.nowPlayingUrl) )

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
                        , name = model.channel.name
                      }
                    , Cmd.none
                    )

        MsgControls msg_ ->
            let
                ( controlsModel, controlsCmds ) =
                    Elm.Controls.update msg_ model.controls
            in
            ( { model | controls = controlsModel }
            -- Regardless of the type of Command from Controls, always update the timestamp too
            , Cmd.batch [ Task.perform UpdateTimestamp Time.now, Cmd.map MsgControls controlsCmds ]
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "card-wrapper aspect-ratio-outer" ]
        [ div
            [ class "card aspect-ratio-inner" ]
            [ div
                [ class "music-info" ]
                [ div
                    [ class "music-info-content" ]
                    [ div
                        [ class "channel" ]
                        [ select [ on "change" (Json.map SetChannel targetValue) ] (List.map channelOption channels)
                        , p [ class "channel-info" ] [ text (log "programme name" model.name) ]
                        ]
                        , p [ class "title" ] [ text model.title ]
                        , p [ class "artist" ] [ text model.artist ]

                        --, div [] [ text (model.name ++ " on " ++ model.channel) ]
                        , audio
                        [ id "homeremote-stream-player-audio-elem"
                        , src (model.channel.streamUrl ++ "?" ++ (log "timestamp" model.timestamp))
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
                ]
            , button
                [ onClick GetNowPlaying
                , title "Get Now Playing"
                , class "get-now-playing"
                ]
                [ img [ src model.imageUrl ] [] ]
            ]
        ]
