module Txt exposing (..)

import String exposing (..)
import Tuple exposing (..)

initTxt = """
Your control panel

- Color: Blue
- When: need Energy
- Tag: Resonance

Fun, full day environment

Remember, the goal isn't software
It's txtops in a basic editor
Even crafting

Show 3 random notes
[#1001]

Show me what needs organizing

Let me use note as a prompt
[#1002]

Zoomability of workflowy, mindscope
With breadcrumbs
""" |> dropLeft 1 |> dropRight 1

-- > String.uncons "ab" |> Maybe.Extra.maybeToList |> List.unzip |> Tuple.second |> List.head
-- Just "b" : Maybe.Maybe String
