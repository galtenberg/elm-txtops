--module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Maybe exposing (Maybe)
import Set exposing (..)
import Regex exposing (..)
import Json.Decode as Json
import Txt exposing (..)
import TxtStyles exposing (..)


type alias Txt = String
type alias Note = String
type alias NoteList = List Note
type alias NoteSet = Set Note
type alias Craft = String
type alias CraftList = List Craft

-------------------------------------------------------
-- StringList

-- MODEL
type alias StringList = List String

-- VIEW
listView : StringList -> Html Msg
listView listModel = renderList listModel

liText1 l = div [ style magicButtonStyle ] [ text l ]
liText2 l = div [ style magicButtonStyle2 ] [ text l ]

renderList : StringList -> Html Msg
renderList list = list |> List.map liText1 |> div []
renderList2 : StringList -> Html Msg
renderList2 list = list |> List.map liText2 |> div []

-- FUNCTIONS UTIL
splitTxt : Txt -> NoteList
splitTxt txt = String.split "\n\n" txt

joinStringList : StringList -> String
joinStringList list = join "\n\n" list

uniqueList : List comparable -> List comparable
uniqueList list = list |> Set.fromList |> Set.toList

-- FUNCTIONS CRAFTS
regexCrafts : Txt -> List Regex.Match
regexCrafts txt = find All (regex ".*\\s+(\\w+:\\s*\\w+)") txt

extractSubmatches : Regex.Match -> List String
extractSubmatches match =
    match.submatches
    |> List.map (Maybe.withDefault "")

matchCrafts : String -> StringList
matchCrafts str =
    regexCrafts str
    |> List.map extractSubmatches
    |> List.foldr (++) []

-- FUNCTIONS ID
regexIDs : String -> List Regex.Match
regexIDs str = find All (regex "\\[#(\\d+)") str

maxID : String -> Int
maxID str =
    regexIDs str
    |> List.map extractSubmatches
    |> List.foldr (++) []
    |> List.map String.toInt
    |> List.map (Result.withDefault 0)
    |> List.maximum
    |> Maybe.withDefault 1001

newID : String -> String
newID str =
    (maxID str) + 1 |> toString

-------------------------------------------------------
-- Model

-- MODEL
type alias Model =
    { strCraftsList : StringList
    , strMagicField : String
    , strList : StringList
    , txt : Txt
    }


-- MESSAGES
type Msg
    = FieldUpdate String
    | ButtonPressed
    | AreaUpdate String
    | AreaBlurred


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    FieldUpdate str -> { model | strMagicField = str } ! []
    ButtonPressed ->
        let
            trimmedField = String.trim model.strMagicField
            emptyField = String.isEmpty trimmedField
            fieldWithID = trimmedField ++ "\n[#" ++ (newID model.txt) ++ "]"
            appendedTxt = if emptyField then model.txt else model.txt ++ "\n\n" ++ fieldWithID
            combinedList = if emptyField then model.strList else model.strList ++ [ trimmedField ]
        in
            { model
            | strCraftsList = matchCrafts appendedTxt
            , strMagicField = ""
            , strList = combinedList
            , txt = appendedTxt
            } ! []
    AreaUpdate str -> { model | txt = str } ! []
    AreaBlurred ->
        let trimmedTxt = String.trim model.txt
        in { model
        | strCraftsList = matchCrafts trimmedTxt
        , strList = splitTxt trimmedTxt
        , txt = trimmedTxt
        } ! []


-- VIEW
view : Model -> Html Msg
view strOpsModel =
    table [ style tableStyle ]
    [ tr [ style topAlignStyle ]
      [ viewCraftColumn strOpsModel
      , viewNoteColumn strOpsModel
      , viewTxtColumn strOpsModel
      ]
    ]

viewCraftColumn strOpsModel =
    td [ style tableCellStyle25 ]
    [ renderList2 ( "NoteCraft" :: ( uniqueList strOpsModel.strCraftsList ) ) ]

viewNoteColumn strOpsModel =
    td [ style tableCellStyle40 ]
    [ div [ style magicBox ]
        [ div [] [ textarea [ rows 4, onInput FieldUpdate, style magicBoxTextStyle, value strOpsModel.strMagicField ] [ ] ]
        , div [ style magicBoxButtonWrapperStyle ] [ button [ style magicBoxButtonStyle, onClick ButtonPressed ] [ text "▼" ] ] --▼ 🔽
        ]
    , listView strOpsModel.strList
    ]

viewTxtColumn strOpsModel =
    td [ style tableCellStyle35 ]
    [ textarea
      [ rows 40, onBlur AreaBlurred, onInput AreaUpdate, value strOpsModel.txt, style txtAreaStyle ]
      [ ]
    ]


-- INIT
init : ( Model, Cmd Msg )
init =
    { strCraftsList = matchCrafts initTxt
    , strMagicField = ""
    , strList = splitTxt initTxt
    , txt = initTxt
    } ! []


-------------------------------------------------------
-- Page

main : Program Never Model Msg
main = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
