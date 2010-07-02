module T1 where
import Graphics.SOE.Gtk
import System

spaceClose :: Window -> IO ()
spaceClose w = 
    do k <- getKey w
       if k==' ' then closeWindow w
                 else spaceClose w
                      
runHello = runGraphics $ do
             host <- catch (System.getEnv "HOSTNAME") 
                         (\e -> return "unknown")
             w <- openWindow ("SOE t1 @" ++ host) (400, 300)
             drawInWindow w (text (20, 100) 
                               $ "Hello! It works at the host: " ++ host)
             k <- getKey w
             spaceClose w

fillTri :: Window -> Int -> Int -> Int -> IO ()
fillTri w x y size =
    drawInWindow w (withColor Blue
                    (polygon [(x,y), (x+size,y), (x,y-size), (x,y)]))

sierpTri :: Window -> Int -> Int -> Int -> Int -> IO ()
sierpTri w minSize size x y =
    let sierpTri' size x y =
            if size <= minSize
            then fillTri w x y size
            else let size2 = size `div` 2
                 in do sierpTri' size2 x y
                       sierpTri' size2 x (y-size2)
                       sierpTri' size2 (x+size2) y
    in sierpTri' size x y

runSierp = runGraphics $ do
             w <- openWindow "SOE SierpTri" (500, 500)
             sierpTri w 8 256 50 300 
             spaceClose w
