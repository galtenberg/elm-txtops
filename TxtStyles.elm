module TxtStyles exposing (..)

(=>) = (,) --http://faq.elm-community.org/#what-does--mean

radius = "15px"

lightBorderStyle = [ "border" => "1px lightgrey solid" ]
fullWidthStyle = [ "width" => "100%" ]
topAlignStyle = [ "vertical-align" => "top" ]
centerAlignStyle = [ "text-align" => "center" ]
rounded = [ "border-radius" => radius ]
cursorPointer = [ "cursor" => "pointer" ]

defaultFont =
  [ "font-family" => "-apple-system, BlinkMacSystemFont, sans-serif"
  , "font-size" => "18px"
  ]

tableStyle =
  [ "padding" => "15px"
  , "table-layout" => "fixed"
  , "width" => "100%"
  , "background-color" => "rgb(252, 255, 255)"
  ] ++ defaultFont
tableCellStyle =
  [ "padding" => "30px"
  ]
tableCellStyle25 =
  [ "width" => "25%" ] ++ tableCellStyle
tableCellStyle35 =
  [ "width" => "35%" ] ++ tableCellStyle
tableCellStyle40 =
  [ "width" => "40%" ] ++ tableCellStyle

magicBox = rounded
magicBoxTextStyle =
  [ "border-top-left-radius" => radius
  , "border-top-right-radius" => radius
  , "padding" => "10px"
  , "margin" => "0"
  , "width" => "100%"
  , "box-sizing" => "border-box"
  , "outline" => "none"
  ] ++ lightBorderStyle ++ defaultFont
magicBoxButtonWrapperStyle = [ "margin-top" => "-6px" ]
magicBoxButtonStyle =
  [ "border-bottom-left-radius" => radius
  , "border-bottom-right-radius" => radius
  , "background-color" => "white"
  , "color" => "rgb(169, 186, 188)"
  , "font-size" => "18px"
  , "margin-bottom" => "30px"
  , "width" => "100%"
  , "height" => "30px"
  , "padding-top" => "4px"
  ] ++ lightBorderStyle ++ cursorPointer

magicButtonStyle =
  [ "white-space" => "pre"
  , "width" => "93%"
  , "padding" => "15px"
  , "margin-bottom" => "30px"
  , "background-color" => "white"
  ] ++ lightBorderStyle ++ rounded ++ defaultFont ++ cursorPointer
magicButtonStyle2 =
  magicButtonStyle ++
  [ "background-color" => "rgb(206, 227, 229)"
  , "font-variant" => "small-caps"
  , "font-weight" => "bold"
  , "border" => "0"
  ]

txtAreaStyle =
  [ "background-color" => "rgb(233, 237, 237)"
  , "padding" => "10px"
  , "width" => "100%"
  ] ++ lightBorderStyle ++ defaultFont
