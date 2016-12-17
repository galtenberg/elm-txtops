--module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)

-------------------------------------------------------
-- TxtList

-- MODEL
type alias TxtList = List String


-- FUNCTIONS
splitStrings : String -> TxtList
splitStrings str = split "\n\n" str

joinTxtList : TxtList -> String
joinTxtList list = join "\n\n" list

liText l = li [] [text l]

renderList : TxtList -> Html MsgTxt
renderList list =
    list
    |> List.map liText
    |> ul []

-- VIEW
listView : TxtList -> Html MsgTxt
listView listModel = renderList listModel


-------------------------------------------------------
-- TxtBoxModel

-- MODEL
type alias TxtOpsModel =
  { tempField : String
  , tempArea : String
  , txtList : TxtList
  }

-- MESSAGES
type MsgTxt
    = AreaUpdate String
    | FieldUpdate String
    | AreaBlurred
    | ButtonPressed

-- UPDATE
txtUpdate : MsgTxt -> TxtOpsModel -> ( TxtOpsModel, Cmd MsgTxt )
txtUpdate msg model = case msg of
  FieldUpdate txt ->
    ( { model | tempField = txt }, Cmd.none )
  ButtonPressed ->
    ( { model | txtList = model.txtList ++ [model.tempField] }, Cmd.none )
  AreaUpdate txt ->
    ( { model | tempArea = txt }, Cmd.none )
  AreaBlurred ->
    ( { model | txtList = splitStrings model.tempArea }, Cmd.none )

-- VIEW
txtOpsView : TxtOpsModel -> Html MsgTxt
txtOpsView txtOpsModel = div []
    [
      input [ cols 40, placeholder "Feed me txt", onInput FieldUpdate ] [ ]
    , button [ onClick ButtonPressed ] [ text "Add" ]
    , listView txtOpsModel.txtList
    , textarea [cols 40, rows 10, placeholder "Feed me txtops", onInput AreaUpdate, onBlur AreaBlurred ] [ text ( joinTxtList txtOpsModel.txtList ) ]
    ]

-- SUBSCRIPTIONS
txtSubscriptions : TxtOpsModel -> Sub MsgTxt
txtSubscriptions model = Sub.none

-- INIT
txtInit : ( TxtOpsModel, Cmd MsgTxt )
txtInit = (
  ( { tempField = "", tempArea = "", txtList = ["Hello", "World"] } )
  , Cmd.none
  )


-------------------------------------------------------
-- Page

main : Program Never TxtOpsModel MsgTxt
main =
    Html.program
        {
          init = txtInit
        , view = txtOpsView
        , update = txtUpdate
        , subscriptions = txtSubscriptions
        }
