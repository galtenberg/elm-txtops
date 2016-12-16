--module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)

-------------------------------------------------------
-- ListModel

-- MODEL
type alias ListModel = List String

-- FUNCTIONS
splitStrings : String -> ListModel
splitStrings str = split "\n\n" str

liText l = li [] [text l]

renderList : ListModel -> Html MsgTxt
renderList list =
    list
    |> List.map liText
    |> ul []

-- VIEW
listView : ListModel -> Html MsgTxt
listView listModel = renderList listModel


-------------------------------------------------------
-- TxtBoxModel

-- MODEL
type alias TxtOpsModel = String

-- MESSAGES
type MsgTxt
    = AreaUpdate String
    | ButtonPressed

-- UPDATE
txtUpdate : MsgTxt -> TxtOpsModel -> ( TxtOpsModel, Cmd MsgTxt )
txtUpdate msg model = case msg of
  AreaUpdate txt ->
    ( txt, Cmd.none )
  ButtonPressed ->
    ( "", Cmd.none )

-- VIEW
txtOpsView : TxtOpsModel -> Html MsgTxt
txtOpsView txtOpsModel = div []
    [
      input [ cols 40, placeholder "Magic box" ] [ ]
    , button [ onClick ButtonPressed ] [ text "hi" ]
    , listView (splitStrings "Hello\n\nxorld")
    , textarea [cols 40, rows 10, placeholder "Feed me txtops", onInput (AreaUpdate), onBlur (AreaUpdate "blur") ] [ text txtOpsModel ]
    ]

-- SUBSCRIPTIONS
txtSubscriptions : TxtOpsModel -> Sub MsgTxt
txtSubscriptions model = Sub.none

-- INIT
txtInit : ( TxtOpsModel, Cmd MsgTxt )
txtInit = ( "abc", Cmd.none )


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
