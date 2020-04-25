module Elm.NowPlaying exposing (..)
import Elm.SelectedChannel exposing (defaultChannel)
import Http
import Json.Decode as Json
import Html exposing (Html, audio, button, div, img, option, p, select, text)
import Html.Attributes exposing (class, controls, id, src, title, type_, value)
import Html.Events exposing (on, onClick, targetValue)
import Debug exposing (log, toString)

-- MODEL

type alias Model =
    { title : String
    , artist : String
    , imageUrl : String
    , name : String
    , serviceUrlRoot: String
    , selectedChannel: Elm.SelectedChannel.Model
    }

type alias NowPlaying =
    { artist : String
    , title : String
    , songImageUrl : String
    , imageUrl : String
    , name : String
    }

-- INIT

init : String -> ( Model, Cmd Msg )
init initialServiceRootUrl =
    let
        ( selectedChannelInit, selectedChannelCmds ) =
            Elm.SelectedChannel.init
    in    (
    { title = ""
    , artist = ""
    , imageUrl = ""
    , name = ""
    , serviceUrlRoot = log "NowPlaying.init initialServiceRootUrl" initialServiceRootUrl
    , selectedChannel = selectedChannelInit
    }, getNowPlaying (initialServiceRootUrl ++ defaultChannel.nowPlayingUrl) )

-- HTTP
-- TODO nowPlayingUrl could be prefixed with url from flag, but the suffix can be "". Split into 2 arguments and test if the suffix is "" before calling Http.get


getNowPlaying : String -> Cmd Msg
getNowPlaying nowPlayingUrl =
    Http.get
        { url = nowPlayingUrl
        , expect = Http.expectJson GotNowPlaying nowPlayingDecoder
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
    | GetNowPlaying2 String
    | GotNowPlaying (Result Http.Error NowPlaying)


-- TODO instead of map4 use https://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest/
--  also see https://stackoverflow.com/questions/46993855/elm-decoding-a-nested-array-of-objects-with-elm-decode-pipeline
--  can't use elm-decode-pipeline, because it does not yet support Elm 0.19
--  install with: elm install NoRedInk/elm-decode-pipeline


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNowPlaying ->
            ( model, getNowPlaying (model.serviceUrlRoot ++ model.selectedChannel.channel.nowPlayingUrl) )

        GetNowPlaying2 nowPlayingUrl ->
            ( model, getNowPlaying (model.serviceUrlRoot ++ nowPlayingUrl) )

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
                        , name = model.selectedChannel.channel.name
                      }
                    , Cmd.none
                    )

-- VIEW

onPlay : Model -> Html.Attribute Msg
onPlay model =
    on "play" (Json.succeed GetNowPlaying)

viewImage : Model -> Html Msg
viewImage model =
    button
        [ onClick GetNowPlaying
        , title "Get Now Playing"
        , class "get-now-playing"
        ]
        [ img [ src model.imageUrl ] [] ]

viewTitleArtist : Model -> Html Msg
viewTitleArtist model =
    div
        []
        [ p [ class "title" ] [ text model.title ]
        , p [ class "artist" ] [ text model.artist ]
        ]

