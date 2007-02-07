import Graphics.UI.Gtk
import Graphics.UI.Gtk.Glade

gladeFile = "gtktest.glade"

main :: IO ()
main = do
  initGUI
  Just xml <- xmlNew gladeFile
  let getw = xmlGetWidget xml castToWindow
  let getb = xmlGetWidget xml castToButton
  let getmi = xmlGetWidget xml castToMenuItem
  w <- getw "window1"
  onDestroy w mainQuit
  clBtn <- getb "closeButton"
  onClicked clBtn $ do
         widgetDestroy w
  q <- getmi "quit1"
  onActivateLeaf q $ do
         widgetDestroy w
  mainGUI

{- TODO:
 - find a way of multiple load/run cycle within ghci
-}
