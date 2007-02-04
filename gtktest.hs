import Graphics.UI.Gtk
import Graphics.UI.Gtk.Glade

gladeFile = "gtktest.glade"

main :: IO ()
main = do
  initGUI
  Just xml <- xmlNew gladeFile
  w <- xmlGetWidget xml castToWindow "window1"
  onDestroy w mainQuit
  clBtn <- xmlGetWidget xml castToButton "closeButton"
  onClicked clBtn $ do
         widgetDestroy w
  mainGUI

{- TODO:
 - check why initGUI fails in ghci on mac
 - check "insanity" of glade
-}
