--module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Json.Decode as Json
import Regex exposing (..)
import Maybe exposing (Maybe)
import Txt exposing (..)
import TxtStyles exposing (..)


-------------------------------------------------------
-- StringList

-- MODEL
type alias StringList = List String


-- FUNCTIONS
splitStrings : String -> StringList
splitStrings str = String.split "\n\n" str

joinStringList : StringList -> String
joinStringList list = join "\n\n" list

regexCrafts : String -> List Regex.Match
regexCrafts str = find All (regex ".*\\s+(\\w+:\\s*\\w+)") str

matchCrafts : String -> StringList
matchCrafts str =
    List.foldr (++) []
    ( List.map
      (\m -> (List.map (Maybe.withDefault "") m.submatches))
      (regexCrafts str)
    )

liText l = div [ style magicButtonStyle ] [ text l ]
liText2 l = div [ style magicButtonStyle2 ] [ text l ]

renderList : StringList -> Html Msg
renderList list =
    list
    |> List.map liText
    |> div []


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
update msg model = case msg of
    FieldUpdate str ->
        { model | tempField = str } ! []
    ButtonPressed ->
        { model
        | strList = model.strList ++ [ model.tempField ]
        , strAreaList = model.strList ++ [ model.tempField ]
        , tempField = ""
        } ! []
    AreaUpdate str ->
        { model
        | tempArea = str
        , strAreaList = splitStrings str
        } ! []
    AreaBlurred ->
        { model | strList = splitStrings model.tempArea } ! []


-- VIEW
view : Model -> Html Msg
view strOpsModel = table [ style tableStyle ] [ tr [ style topAlignStyle ]
    [ viewCraftColumn strOpsModel
    , viewNoteColumn strOpsModel
    , viewTxtColumn strOpsModel
    ] ]

viewCraftColumn strOpsModel =
    td [ style tableCellStyle25 ]
    [ div [] (List.map liText2 ([ "NoteCraft" ] ++ (matchCrafts initText)) ) ]

viewNoteColumn strOpsModel =
    td [ style tableCellStyle40 ]
    [ div [ style magicBox ]
        [ div [] [ textarea [ rows 4, onInput FieldUpdate, style magicBoxTextStyle, value strOpsModel.tempField ] [ ] ]
        , div [ style magicBoxButtonWrapperStyle ] [ button [ style magicBoxButtonStyle, onClick ButtonPressed ] [ text "🔽" ] ]
        ]
    , listView strOpsModel.strList
    ]

viewTxtColumn strOpsModel =
    td [ style tableCellStyle35 ]
    [
        textarea
        [ rows 40, onBlur AreaBlurred, onInput AreaUpdate, value ( joinStringList strOpsModel.strAreaList ), style readTextAreaStyle ]
        [ ]
    ]


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT
init : ( Model, Cmd Msg )
init =
    ( { tempField = "", tempArea = initText, strList = splitStrings initText, strAreaList = splitStrings initText }
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
