module Elm.Audio exposing (main)

import Browser
import Html exposing (Html, button, div, text, audio, source, controls)
import Html.Events exposing (onClick)


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = Int

init : Model
init =
  0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    , audio [ controls ]
        [ source
            [ src "https://icecast.omroep.nl/radio2-bb-mp3"
            ]
            []
        , text "Your browser does not support the audio element."
        ]
    ]
