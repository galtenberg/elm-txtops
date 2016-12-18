--module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Json.Decode as Json

-------------------------------------------------------
-- StringList

-- MODEL
type alias StringList = List String


-- FUNCTIONS
splitStrings : String -> StringList
splitStrings str = split "\n\n" str

joinStringList : StringList -> String
joinStringList list = join "\n\n" list

liText l = li [] [text l]

renderList : StringList -> Html Msg
renderList list =
    list
    |> List.map liText
    |> ul []


-- VIEW
listView : StringList -> Html Msg
listView listModel = renderList listModel


-------------------------------------------------------
-- Model

-- MODEL
type alias Model =
    { tempField : String
    , tempArea : String
    , strList : StringList
    , strAreaList : StringList
    }

-- MESSAGES
type Msg
    = AreaUpdate String
    | FieldUpdate String
    | AreaBlurred
    | ButtonPressed

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = ((case msg of
        FieldUpdate str ->
            { model | tempField = str }
        ButtonPressed ->
            { model
            | strList = model.strList ++ [model.tempField]
            , strAreaList = model.strList ++ [model.tempField]
            }
        AreaUpdate str ->
            { model
            | tempArea = str
            , strAreaList = splitStrings str
            }
        AreaBlurred ->
            { model | strList = splitStrings model.tempArea }
    ), Cmd.none)

-- VIEW
view : Model -> Html Msg
view strOpsModel = table [] [ tr [style[("vertical-align", "top")] ]
    [ td []
      [ textarea [ cols 60, rows 4, onInput FieldUpdate ] [ ]
      , br [] []
      , button [ style[("width", "100%")], onClick ButtonPressed ] [ text "🔽" ]
      , listView strOpsModel.strList
      ],
      td []
      [
        textarea
          [ cols 60, rows 40, onBlur AreaBlurred, onInput AreaUpdate, value ( joinStringList strOpsModel.strAreaList ) ]
          [ ]
      ]
    ]]

onChange f = on "change" (Json.map f Json.string)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT
init : ( Model, Cmd Msg )
init =
    ( { tempField = "", tempArea = "Hello\n\nWorld", strList = ["Hello", "World"], strAreaList = ["Hello", "World"] }
    , Cmd.none
    )


-------------------------------------------------------
-- Page

main : Program Never Model Msg
main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
