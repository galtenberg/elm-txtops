--module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)

-------------------------------------------------------
-- TxtList

-- MODEL
type alias TxtList = List String

type alias TxtModel =
  { tempField : String
  , tempArea : String
  , txtList : TxtList
  }

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
--type alias TxtOpsModel = String

-- MESSAGES
type MsgTxt
    = AreaUpdate String
    | AreaBlurred
    | ButtonPressed

-- UPDATE
--txtUpdate : MsgTxt -> TxtOpsModel -> ( TxtOpsModel, Cmd MsgTxt )
txtUpdate : MsgTxt -> TxtList -> ( TxtList, Cmd MsgTxt )
txtUpdate msg model = case msg of
  AreaUpdate txt ->
    ( model ++ [txt], Cmd.none )
  AreaBlurred ->
    ( model, Cmd.none )
  ButtonPressed ->
    ( [""], Cmd.none )

-- VIEW
--txtOpsView : TxtOpsModel -> Html MsgTxt
txtOpsView : TxtList -> Html MsgTxt
txtOpsView txtOpsModel = div []
    [
      input [ cols 40, placeholder "Feed me txt" ] [ ]
    , button [ onClick ButtonPressed ] [ text "Add" ]
    , listView txtOpsModel
    , textarea [cols 40, rows 10, placeholder "Feed me txtops", onInput AreaUpdate, onBlur AreaBlurred ] [ text ( joinTxtList txtOpsModel ) ]
    ]

-- SUBSCRIPTIONS
--txtSubscriptions : TxtOpsModel -> Sub MsgTxt
txtSubscriptions : TxtList -> Sub MsgTxt
txtSubscriptions model = Sub.none

-- INIT
--txtInit : ( TxtOpsModel, Cmd MsgTxt )
--txtInit = ( "abc", Cmd.none )
txtInit : ( TxtList, Cmd MsgTxt )
txtInit = ( ["Hello", "World"], Cmd.none )


-------------------------------------------------------
-- Page

--main : Program Never TxtOpsModel MsgTxt
main : Program Never TxtList MsgTxt
main =
    Html.program
        {
          init = txtInit
        , view = txtOpsView
        , update = txtUpdate
        , subscriptions = txtSubscriptions
        }
