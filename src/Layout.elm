-- shows how to mock a layout in elm


module Layout exposing (main)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (class, src, width, height)


layout : Html msg
layout =
    div []
        [ div [ class "info" ] [ text "Rock Paper Scissors" ]
        , div [ class "flex-container" ]
            [ div [ class "flex-item rock-item" ] []
            , div [ class "flex-item paper-item" ] []
            , div [ class "flex-item scissors-item" ] []
            ]
        , div [ class "info small" ]
            [ text "Opponent chooses: "
            , img [ src "dist/images/scissors.svg", width 32, height 32 ] []
            ]
        , div [ class "info small" ]
            [ text "You win." ]
        ]


main : Html msg
main =
    layout
