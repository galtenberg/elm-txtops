module App exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onBlur)
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
--renderList : ListModel -> Html MsgNoOp
--renderList : ListModel -> Html a
renderList list =
    list
    |> List.map liText
    |> ul []

-- MESSAGES
--type MsgNoOp = NoOp

-- UPDATE
--listUpdate : MsgNoOp -> ListModel -> ( ListModel, Cmd MsgNoOp )
--listUpdate msg model =
    --case msg of
        --NoOp ->
            --( model, Cmd.none )

-- VIEW
listView : ListModel -> Html MsgTxt
--listView : ListModel -> Html MsgNoOp
listView listModel = renderList listModel

-- SUBSCRIPTIONS
--listSubscriptions : ListModel -> Sub MsgNoOp
--listSubscriptions model = Sub.none

-- INIT
--listInit : ( ListModel, Cmd MsgNoOp )
--listInit = ( splitStrings "Hello\n\nxorld", Cmd.none )


-------------------------------------------------------
-- TxtBoxModel

-- MODEL
type alias TxtOpsModel = String

-- MESSAGES
type MsgTxt = NewTxt String

-- UPDATE
txtUpdate : MsgTxt -> TxtOpsModel -> ( TxtOpsModel, Cmd MsgTxt )
txtUpdate (NewTxt txt) oldTxt =
  ( txt, Cmd.none )

--blurHappens : Sub MsgTxt
--blurHappens = ("hi")

-- VIEW
txtOpsView : TxtOpsModel -> Html MsgTxt
--txtOpsView : TxtOpsModel -> Html a
txtOpsView txtOpsModel = div []
    [
      input [ cols 40, placeholder "Magic box" ] [ ]
    --, button [ ] [ "sup" ]
    --, renderList (splitStrings "Hello\n\nxorld")
    , listView (splitStrings "Hello\n\nxorld")
    , textarea [cols 40, rows 10, placeholder "Feed me txtops", onInput NewTxt ] [ text txtOpsModel ]
    ]

-- SUBSCRIPTIONS
txtSubscriptions : TxtOpsModel -> Sub MsgTxt
txtSubscriptions model = Sub.none

-- INIT
txtInit : ( TxtOpsModel, Cmd MsgTxt )
txtInit = ( "abc", Cmd.none )


-------------------------------------------------------
-- Page

--combinedView : (Html a, Html a) -> (Html a)
--combinedView (diva, divb) =
    --div [] [ [ diva, divb ] ]

-- INIT
--combinedInit : ( 

-- MAIN

--main1 : Program Never
--main1 =
    --Html.App.program
        --{
        --init = listInit
        --, view = listView
        --, update = listUpdate
        --, subscriptions = listSubscriptions
        --}

main : Program Never
main =
    Html.App.program
    --Html.App.beginnerProgram
        {
          init = txtInit
        , view = txtOpsView
        --, view = combinedView(listView, txtOpsView)
        , update = txtUpdate
        , subscriptions = txtSubscriptions
        }
