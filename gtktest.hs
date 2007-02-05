import Graphics.UI.Gtk
import Graphics.UI.Gtk.Glade

gladeFile = "gtktest.glade"

main :: IO ()
main = do
  initGUI
  Just xml <- xmlNew gladeFile
  let getw = xmlGetWidget xml castToWindow
  let getb = xmlGetWidget xml castToButton
  w <- getw "window1"
  onDestroy w mainQuit
  clBtn <- getb "closeButton"
  onClicked clBtn $ do
         widgetDestroy w
  mainGUI

{- TODO:
 - check why initGUI fails in ghci on mac (it doesn't on debian x86)
 - check "insanity" of glade
-}
