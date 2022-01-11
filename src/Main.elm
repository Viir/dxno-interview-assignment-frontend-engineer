module Main exposing (..)

import Browser
import Browser.Dom
import Clock
import DateTime
import Html
import Html.Attributes
import Html.Events.Extra.Mouse
import Svg
import Svg.Attributes
import Task
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


type alias Model =
    { mouseHoverTime : Maybe (Result String ( Time.Posix, Time.Zone ))
    }


init : ( Model, Cmd Msg )
init =
    ( { mouseHoverTime = Nothing }
    , Cmd.none
    )


type alias EventWithContext =
    { mouseMove : Html.Events.Extra.Mouse.Event
    , element : Browser.Dom.Element
    , timeZone : Time.Zone
    , timeNow : Time.Posix
    }


type Msg
    = MouseMoveOnTimeline Html.Events.Extra.Mouse.Event
    | MouseMoveOnTimelineGotContext (Result String EventWithContext)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMoveOnTimeline mouseMove ->
            ( model
            , Browser.Dom.getElement "timeline-container"
                |> Task.mapError (always "Get Element")
                |> Task.andThen
                    (\element ->
                        Time.here
                            |> Task.mapError (always "Get Time Zone")
                            |> Task.andThen
                                (\timeZone ->
                                    Time.now
                                        |> Task.mapError (always "Get Time now")
                                        |> Task.map
                                            (\timeNow ->
                                                { mouseMove = mouseMove
                                                , element = element
                                                , timeZone = timeZone
                                                , timeNow = timeNow
                                                }
                                            )
                                )
                    )
                |> Task.attempt MouseMoveOnTimelineGotContext
            )

        MouseMoveOnTimelineGotContext result ->
            ( { model
                | mouseHoverTime =
                    Just
                        (result
                            |> Result.andThen
                                (\eventWithContext ->
                                    let
                                        totalMinutes =
                                            round
                                                ((Tuple.first eventWithContext.mouseMove.offsetPos * 1440)
                                                    / eventWithContext.element.element.width
                                                )

                                        hours =
                                            totalMinutes // 60

                                        minutes =
                                            totalMinutes - hours * 60
                                    in
                                    case
                                        eventWithContext.timeNow
                                            |> DateTime.fromPosix
                                            |> DateTime.setHours hours
                                            |> Maybe.andThen (DateTime.setMinutes minutes)
                                    of
                                        Nothing ->
                                            Err "Failed to map time using DateTime"

                                        Just dateTime ->
                                            Ok
                                                ( dateTime
                                                    |> DateTime.toPosix
                                                , eventWithContext.timeZone
                                                )
                                )
                        )
              }
            , Cmd.none
            )


viewTimeline : Model -> Html.Html Msg
viewTimeline model =
    Svg.svg
        [ Html.Attributes.id "timeline-container"
        , Html.Attributes.style "width" "100%"
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
            [ Html.text
                ("hovered time: "
                    ++ (model.mouseHoverTime
                            |> Maybe.map hoverResultDisplayText
                            |> Maybe.withDefault "No hover event yet"
                       )
                )
            ]
        ]


hoverResultDisplayText : Result String ( Time.Posix, Time.Zone ) -> String
hoverResultDisplayText result =
    case result of
        Err error ->
            "Error: " ++ error

        Ok ( time, zone ) ->
            [ Time.toHour zone time
            , Time.toMinute zone time
            ]
                |> List.map (String.fromInt >> String.padLeft 2 '0')
                |> String.join ":"
