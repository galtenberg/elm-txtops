module Txt exposing (..)

import String exposing (..)
import Tuple exposing (..)

initText = """
Fun, full day environment

Remember, the goal isn't software
It's txtops in a basic editor
Even crafting

Show 3 random notes

Show me what needs organizing

Let me use note as a prompt
""" |> dropLeft 1 |> dropRight 1

-- > String.uncons "ab" |> Maybe.Extra.maybeToList |> List.unzip |> Tuple.second |> List.head
-- Just "b" : Maybe.Maybe String
