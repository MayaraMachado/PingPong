module Main where

import Graphics.Gloss

window :: Display
window = InWindow "Ping Pong" (600, 600) (10, 10)

background :: Color
background = black

drawing :: Picture
drawing = pictures 
    [ color bola $ circleSolid 15
    , translate (-280) (-100) $ color paletaPlayer1 $ rectangleSolid 10 70
    , translate (280) 0 $ color paletaPlayer2 $ rectangleSolid 10 70
    , translate 0 (-300) $ color parede $ rectangleSolid 600 20
    , translate 0 (300) $ color parede $ rectangleSolid 600 20
    , translate (-300) (-300) $ color parede $ rectangleSolid 20 410
    , translate (-300) (300) $ color parede $ rectangleSolid 20 410
    , translate (300) (300) $ color parede $ rectangleSolid 20 410
    , translate (300) (-300) $ color parede $ rectangleSolid 20 410
    ]
    where  
        bola = white
        paletaPlayer1 = green 
        paletaPlayer2 = red
        parede = light (light (light black))

main :: IO ()
main = display window background drawing
