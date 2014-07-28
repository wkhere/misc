{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.HTTP.Types (status200)
import Network.Wai.Handler.Warp (run)

app :: Application
app req res  = res $
  responseLBS status200 [("Content-Type", "text/plain")] "Hello World"

main = run 3000 app
