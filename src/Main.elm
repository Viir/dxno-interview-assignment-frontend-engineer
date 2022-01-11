module Main exposing (..)

import Browser
import Html
import Html.Attributes
import Html.Events.Extra.Mouse
import Svg
import Svg.Attributes


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { timelineMouseOffset : Maybe Float
    }


init : Model
init =
    { timelineMouseOffset = Nothing
    }


type Msg
    = MouseMoveOnTimeline Html.Events.Extra.Mouse.Event


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseMoveOnTimeline event ->
            { model | timelineMouseOffset = Just (Tuple.first event.offsetPos) }


viewTimeline : Model -> Html.Html Msg
viewTimeline model =
    Svg.svg
        [ Html.Attributes.style "width" "100%"
        , Svg.Attributes.viewBox "0 0 100 10"
        ]
        [ Svg.rect
            [ Html.Events.Extra.Mouse.onMove MouseMoveOnTimeline
            , Html.Attributes.style "width" "100%"
            , Html.Attributes.style "height" "100"
            , Svg.Attributes.fill "lightblue"
            ]
            []
        ]


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ viewTimeline model
        , Html.div []
            [ Html.text ("offset: " ++ (model.timelineMouseOffset |> Maybe.map String.fromFloat |> Maybe.withDefault "Nothing"))
            ]
        ]
