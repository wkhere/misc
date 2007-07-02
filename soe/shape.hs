module Shape where
          
data Shape = Rectangle Side Side
           | Ellipse Radius Radius
           | RtTriangle Side Side
           | Polygon [Vertex]
  deriving Show

type Radius = Float
type Side = Float
type Vertex = (Float, Float)

square s = Rectangle s s
circle r = Ellipse r r

area :: Shape -> Float

area (Rectangle s1 s2) = s1*s2
area (RtTriangle s1 s2) = s1*s2/2
area (Ellipse r1 r2) = pi*r1*r2

