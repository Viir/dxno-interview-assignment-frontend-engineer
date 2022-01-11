module Main exposing (..)

import Browser
import Html
import Html.Events


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    Int


init : Model
init =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.button [ Html.Events.onClick Decrement ] [ Html.text "-" ]
        , Html.div [] [ Html.text (String.fromInt model) ]
        , Html.button [ Html.Events.onClick Increment ] [ Html.text "+" ]
        ]
