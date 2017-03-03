module RPS exposing (main)

import Html exposing (Html, div, text, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, src, width, height)
import Random


-- MODEL


type Move
    = Rock
    | Paper
    | Scissors


type alias Model =
    { playerMove : Maybe Move
    , randMove : Maybe Move
    }


model : Model
model =
    { playerMove = Nothing, randMove = Nothing }


type Msg
    = Choose Move
    | GenerateMove
    | NewMove Move


type Outcome
    = Win
    | Lose
    | Tie



-- UPDATE


outcome : Move -> Move -> Outcome
outcome move1 move2 =
    case ( move1, move2 ) of
        ( Rock, Rock ) ->
            Tie

        ( Rock, Paper ) ->
            Lose

        ( Rock, Scissors ) ->
            Win

        ( Paper, Rock ) ->
            Win

        ( Paper, Paper ) ->
            Tie

        ( Paper, Scissors ) ->
            Lose

        ( Scissors, Rock ) ->
            Lose

        ( Scissors, Paper ) ->
            Win

        ( Scissors, Scissors ) ->
            Tie


idxToMove : Int -> Move
idxToMove idx =
    case idx of
        1 ->
            Rock

        2 ->
            Paper

        3 ->
            Scissors

        _ ->
            Rock


genMove : Random.Generator Move
genMove =
    Random.map idxToMove (Random.int 1 3)


outcomeToString : Maybe Move -> Maybe Move -> String
outcomeToString possibleMove1 possibleMove2 =
    case ( possibleMove1, possibleMove2 ) of
        ( Nothing, _ ) ->
            ""

        ( _, Nothing ) ->
            ""

        ( Just move1, Just move2 ) ->
            "You " ++ (outcome move1 move2 |> toString |> String.toLower) ++ "."


moveToString : Maybe Move -> String
moveToString possibleMove =
    case possibleMove of
        Nothing ->
            ""

        Just move ->
            case move of
                Rock ->
                    "rock"

                Paper ->
                    "paper"

                Scissors ->
                    "scissors"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Choose move ->
            ({ model | playerMove = Just move }
                |> update GenerateMove
            )

        GenerateMove ->
            ( model, Random.generate NewMove genMove )

        NewMove move ->
            ( { model | randMove = Just move }, Cmd.none )



-- VIEW


displayPlayerChoice : Model -> Html Msg
displayPlayerChoice model =
    if model.playerMove == Nothing then
        text ""
    else
        div [ class "info small" ]
            [ text "You choose: "
            , img [ src ("dist/images/" ++ moveToString model.playerMove ++ ".svg"), width 32, height 32 ] []
            ]


displayOpponentChoice : Model -> Html Msg
displayOpponentChoice model =
    if model.randMove == Nothing then
        text ""
    else
        div [ class "info small" ]
            [ text "Opponent chooses: "
            , img [ src ("dist/images/" ++ moveToString model.randMove ++ ".svg"), width 32, height 32 ] []
            ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "info" ] [ text "Rock Paper Scissors" ]
        , div [ class "flex-container" ]
            [ div
                [ class "flex-item rock-item"
                , onClick (Choose Rock)
                ]
                []
            , div
                [ class "flex-item paper-item"
                , onClick (Choose Paper)
                ]
                []
            , div
                [ class "flex-item scissors-item"
                , onClick (Choose Scissors)
                ]
                []
            ]
        , displayPlayerChoice model
        , displayOpponentChoice model
        , div [ class "info small" ]
            [ text <| outcomeToString model.playerMove model.randMove ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , init = ( model, Cmd.none )
        }
