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


extractSubmatches : Regex.Match -> List String
extractSubmatches match =
    match.submatches
    |> List.map (Maybe.withDefault "")


-------------------------------------------------------
-- NoteList, NoteSet
type alias NoteList = List Note
type alias NoteSet = Set Note

-- VIEW
listView : NoteList -> Html Msg
listView noteList = renderList noteList

liText1 l = div [ style magicButtonStyle ] [ text l ]

renderList : NoteList -> Html Msg
renderList list = list |> List.map liText1 |> div []


-------------------------------------------------------
-- Craft, CraftList
type alias Craft = String
type alias CraftList = List Craft

regexCrafts : Txt -> List Regex.Match
regexCrafts txt = find All (regex ".*\\s+[-+]\\s*(\\w+:\\s*.+)") txt

matchCrafts : Txt -> NoteList
matchCrafts txt =
    regexCrafts txt
    |> List.map extractSubmatches
    |> List.foldr (++) []

uniqueCraftList : NoteList -> NoteList
uniqueCraftList list = list |> Set.fromList |> Set.toList


-------------------------------------------------------
-- Txt
type alias Txt = String

splitTxt : Txt -> NoteList
splitTxt txt = String.split "\n\n" txt

noteListToTxt : NoteList -> Txt
noteListToTxt noteList = join "\n\n" noteList


-------------------------------------------------------
-- ID
type alias ID = Int

regexIDs : Txt -> List Regex.Match
regexIDs txt = find All (regex "\\[#(\\d+)") txt

maxID : Txt -> ID
maxID txt =
    regexIDs txt
    |> List.map extractSubmatches
    |> List.foldr (++) []
    |> List.map String.toInt
    |> List.map (Result.withDefault 0)
    |> List.maximum
    |> Maybe.withDefault 1001

newID : Txt -> ID
newID txt =
    (maxID txt) + 1


-------------------------------------------------------
-- Note
type alias Note = String

buildNote : String -> Note
buildNote str = String.trim str

isEmptyNote : Note -> Bool
isEmptyNote note = String.isEmpty note

appendIDtoNote : Note -> ID -> Note
appendIDtoNote note id = note ++ "\n[#" ++ (toString id) ++ "]"


-------------------------------------------------------
-- Program

-- MODEL
type alias Model =
    { craftList : CraftList
    , magicField : Note
    , noteList : NoteList
    , txt : Txt
    }


-- MESSAGES
type Msg
    = MagicFieldUpdate String
    | MagicButtonPressed
    | CraftPressed String
    | AreaUpdate String
    | AreaBlurred


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    MagicFieldUpdate str -> { model | magicField = str } ! []
    MagicButtonPressed ->
        let
            newNote = buildNote model.magicField
            newNoteID = newID model.txt
            noteWithID = appendIDtoNote newNote newNoteID
            appendedTxt = if (isEmptyNote newNote) then model.txt else model.txt ++ "\n\n" ++ noteWithID
            appendedNoteList = if (isEmptyNote newNote) then model.noteList else model.noteList ++ [ newNote ]
        in
            { model
            | craftList = matchCrafts appendedTxt
            , magicField = ""
            , noteList = appendedNoteList
            , txt = appendedTxt
            } ! []
    CraftPressed str ->
        let
            appendedMagicField = model.magicField ++ "\n- " ++ str
        in
            { model | magicField = appendedMagicField } ! []
    AreaUpdate str -> { model | txt = str } ! []
    AreaBlurred ->
        let trimmedTxt = String.trim model.txt
        in { model
        | craftList = matchCrafts trimmedTxt
        , noteList = splitTxt trimmedTxt
        , txt = trimmedTxt
        } ! []


-- VIEW
view : Model -> Html Msg
view model =
    table [ style tableStyle ]
    [ tr [ style topAlignStyle ]
      [ viewCraftColumn model
      , viewNoteColumn model
      , viewTxtColumn model
      ]
    ]

viewCraftColumn model =
    td [ style tableCellStyle25 ]
    [ renderList2 ( "NoteCraft" :: ( uniqueCraftList model.craftList ) ) ]

liText2 l = div [ style magicButtonStyle2, onClick (CraftPressed l) ] [ text l ]
renderList2 list = list |> List.map liText2 |> div []

viewNoteColumn model =
    td [ style tableCellStyle40 ]
    [ div [ style magicBox ]
        [ div [] [ textarea [ rows 4, onInput MagicFieldUpdate, style magicBoxTextStyle, value model.magicField ] [ ] ]
        , div [ style magicBoxButtonWrapperStyle ] [ button [ style magicBoxButtonStyle, onClick MagicButtonPressed ] [ text "▼" ] ] --▼ 🔽
        ]
    , listView model.noteList
    ]

viewTxtColumn model =
    td [ style tableCellStyle35 ]
    [ textarea
      [ rows 40, onBlur AreaBlurred, onInput AreaUpdate, value model.txt, style txtAreaStyle ]
      [ ]
    ]


-- INIT
init : ( Model, Cmd Msg )
init =
    { craftList = matchCrafts initTxt
    , magicField = ""
    , noteList = splitTxt initTxt
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
