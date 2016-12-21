module TxtStyles exposing (..)

(=>) = (,) --http://faq.elm-community.org/#what-does--mean

lightBorderStyle = ["border" => "1px lightgrey solid"]
fullWidthStyle = ["width" => "100%"]
topAlignStyle = ["vertical-align" => "top"]

magicBoxButtonHacksStyle = ["margin-top" => "-8px"]
magicTextBoxStyle =
  [ "white-space" => "pre"
  , "width" => "92%"
  , "padding" => "15px"
  , "margin-top" => "30px"
  ] ++ lightBorderStyle
