module Txt exposing (..)

import String exposing (..)
import Tuple exposing (..)

initText = dropLeft 1 """
Hello
hi

World
"""

-- > String.uncons "ab" |> Maybe.Extra.maybeToList |> List.unzip |> Tuple.second |> List.head
-- Just "b" : Maybe.Maybe String
