module Elm.PauseSvgIcon exposing (view)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)

view : Html msg
view =
    svg
        [ width "50"
        , height "50"
        , viewBox "0 0 357 357"
        ]
        [ Svg.path
            [ d "M25.5,357h102V0h-102V357z M229.5,0v357h102V0H229.5z"
            ]
            []
        ]
