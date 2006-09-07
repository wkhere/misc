module SOETest1 where
import Graphics.SOE

spaceClose :: Window -> IO ()
spaceClose w = 
    do k <- getKey w
       if k==' ' then closeWindow w
                 else spaceClose w
                      
main0 = 
    runGraphics (
                 do w <- openWindow 
                         "SOE test1" (300, 300)
                    drawInWindow w (text (100, 200) "Hello! It works!")
                    k <- getKey w
                    spaceClose w
                )
