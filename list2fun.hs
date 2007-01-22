module Foo where

appf f [] = error "too less args"
appf f (x:xs) = (f x, xs)
