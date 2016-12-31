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


-------------------------------------------------------
-- StringList

-- MODEL
type alias StringList = List String

-- VIEW
listView : StringList -> Html Msg
listView listModel = renderList listModel

-- FUNCTIONS
splitStrings : String -> StringList
splitStrings str = String.split "\n\n" str

joinStringList : StringList -> String
joinStringList list = join "\n\n" list

regexCrafts : String -> List Regex.Match
regexCrafts str = find All (regex ".*\\s+(\\w+:\\s*\\w+)") str

extractSubmatches : Regex.Match -> List String
extractSubmatches match =
    match.submatches
    |> List.map (Maybe.withDefault "")

matchCrafts : String -> StringList
matchCrafts str =
    regexCrafts str
    |> List.map extractSubmatches
    |> List.foldr (++) []

liText1 l = div [ style magicButtonStyle ] [ text l ]
liText2 l = div [ style magicButtonStyle2 ] [ text l ]

renderList : StringList -> Html Msg
renderList list = list |> List.map liText1 |> div []
renderList2 : StringList -> Html Msg
renderList2 list = list |> List.map liText2 |> div []

uniqueList list = list |> Set.fromList |> Set.toList


-------------------------------------------------------
-- Model

-- MODEL
type alias Model =
    { strCraftsList : StringList
    , strMagicField : String
    , strList : StringList
    , strArea : String
    }


-- MESSAGES
type Msg
    = AreaUpdate String
    | FieldUpdate String
    | AreaBlurred
    | ButtonPressed


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    FieldUpdate str ->
        { model
        | strMagicField = str
        } ! []
    ButtonPressed ->
        let
            trimmedField = String.trim model.strMagicField
            emptyField = String.isEmpty trimmedField
            combinedArea = if emptyField then model.strArea else model.strArea ++ "\n\n" ++ model.strMagicField
            combinedList = if emptyField then model.strList else model.strList ++ [ model.strMagicField ]
        in
            { model
            | strCraftsList = matchCrafts combinedArea
            , strMagicField = ""
            , strList = combinedList
            , strArea = combinedArea
            } ! []
    AreaUpdate str ->
        { model
        | strArea = str
        } ! []
    AreaBlurred ->
        let trimmedArea = String.trim model.strArea
        in { model
        | strCraftsList = matchCrafts trimmedArea
        , strList = splitStrings trimmedArea
        , strArea = trimmedArea
        } ! []


-- VIEW
view : Model -> Html Msg
view strOpsModel = table [ style tableStyle ] [ tr [ style topAlignStyle ]
    [ viewCraftColumn strOpsModel
    , viewNoteColumn strOpsModel
    , viewTxtColumn strOpsModel
    ] ]

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
    [
        textarea
        [ rows 40, onBlur AreaBlurred, onInput AreaUpdate, value strOpsModel.strArea, style readTextAreaStyle ]
        [ ]
    ]


-- INIT
init : ( Model, Cmd Msg )
init =
    { strCraftsList = matchCrafts initText
    , strMagicField = ""
    , strList = splitStrings initText
    , strArea = initText
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
