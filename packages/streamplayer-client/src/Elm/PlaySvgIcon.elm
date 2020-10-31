module Elm.PlaySvgIcon exposing (view)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)

view : Html msg
view =
    svg
        [ width "100"
        , height "100"
        , viewBox "10 9 30 30"
        ]
        [ Svg.path
            [ d "M-838-2232H562v3600H-838z"
            , fill "none"
            ]
            []
        , Svg.path
            [ d "M16 10v28l22-14z"
            ]
            []
        , Svg.path
            [ d "M0 0h48v48H0z"
            , fill "none"
            ]
            []
        ]
