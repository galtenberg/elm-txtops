module TxtStyles exposing (..)

(=>) = (,) --http://faq.elm-community.org/#what-does--mean

radius = "15px"

lightBorderStyle = [ "border" => "1px lightgrey solid" ]
fullWidthStyle = [ "width" => "100%" ]
topAlignStyle = [ "vertical-align" => "top" ]
rounded = [ "border-radius" => radius ]

defaultFont =
  [ "font-family" => "-apple-system, BlinkMacSystemFont, sans-serif"
  , "font-size" => "18px"
  ]

tableStyle =
  [ "padding" => "15px"
  ] ++ defaultFont
tableCellStyle = [ "padding" => "30px" ]

magicBox = rounded
magicBoxTextStyle =
  [ "border-top-left-radius" => radius
  , "border-top-right-radius" => radius
  , "padding" => "10px"
  , "margin" => "0"
  ] ++ lightBorderStyle ++ defaultFont
magicBoxButtonWrapperStyle = [ "margin-top" => "-8px" ]
magicBoxButtonStyle =
  [ "border-bottom-left-radius" => radius
  , "border-bottom-right-radius" => radius
  , "background-color" => "white"
  , "font-size" => "18px"
  ] ++ fullWidthStyle ++ lightBorderStyle
magicButtonStyle =
  [ "white-space" => "pre"
  , "width" => "95%"
  , "padding" => "15px"
  , "margin-top" => "30px"
  ] ++ lightBorderStyle ++ rounded ++ defaultFont

readTextAreaStyle =
  [ "background-color" => "rgb(236,236,236)"
  ] ++ lightBorderStyle ++ defaultFont
