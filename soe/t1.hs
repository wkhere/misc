module SOETest1 where
import Graphics.SOE 
import System

spaceClose :: Window -> IO ()
spaceClose w = 
    do k <- getKey w
       if k==' ' then closeWindow w
                 else spaceClose w
                      
main0 = runGraphics 
        (do 
          host <- catch (System.getEnv "HOSTNAME") (\e -> return "unknown")
          w <- openWindow ("SOE t1 @" ++ host) (400, 300)
          drawInWindow w (text (20, 100) 
                         $ "Hello! It works at the host: " ++ host)
          k <- getKey w
          spaceClose w
        )
