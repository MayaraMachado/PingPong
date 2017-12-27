module Main where

import Graphics.Gloss

data PongGame = Game { posicaoEspaco :: (Float, Float) 
                      , velocidade :: (Float, Float)
                      , player1 :: Float
                      , player2 :: Float
                      } 
              | GameOver        
              deriving Show

-- data PongGame = Play  Bola Player1 Player2
--               | GameOver 
--               deriving (Eq, Show)

-- type velocidade = (Float, Float)
-- type posicaoEspaco = (Float, Float)
-- type paletaPlayer = Float

-- data Bola = Bola posicaoEspaco velocidade
--     deriving (Eq, Show)
-- data Player1 = Player1 paletaPlayer
--     deriving (Eq, Show)
-- data Player2 = Player2 paletaPlayer

initialState :: PongGame
initialState = Game
        { posicaoEspaco = (-10, 30)
        , velocidade = (1, -3)
        , player1 = 40
        , player2 = -40
        }

drawGame :: PongGame -> Picture

drawGame GameOver 
    = scale 0.3 0.3
        . translate (-400) 0
        . color red
        . text
        $ "Game Over!"

drawGame game =
    pictures [ bola
             , paleta green 280  $ player1 game
             , paleta blue (-280) $ player2 game
             , translate 0 (-300) $ color parede $ rectangleSolid 600 20
             , translate 0 (300) $ color parede $ rectangleSolid 600 20
             , translate (-300) (-300) $ color parede $ rectangleSolid 20 410
             , translate (-300) (300) $ color parede $ rectangleSolid 20 410
             , translate (300) (300) $ color parede $ rectangleSolid 20 410
             , translate (300) (-300) $ color parede $ rectangleSolid 20 410
             ]
    where
        -- Bola
        bola = uncurry translate (posicaoEspaco game) $ color corBola $ circleSolid 10
        corBola = white

        --Cor parede
        parede = light (light (light black))

        --Paletas
        paleta :: Color -> Float -> Float -> Picture
        paleta cor x y = pictures
            [ translate x y $ color cor $ rectangleSolid 10 70
            , translate x y $ color cor $ rectangleSolid 10 70
            ]



window :: Display
window = InWindow "Ping Pong" (600, 600) (10, 10)

background :: Color
background = black

-- drawing :: Picture
-- drawing = pictures 
--     [ color bola $ circleSolid 15
--     , translate (-280) (-100) $ color paletaPlayer $ rectangleSolid 10 70
--     , translate (280) 0 $ color paletaPlayer2 $ rectangleSolid 10 70
--     , translate 0 (-300) $ color parede $ rectangleSolid 600 20
--     , translate 0 (300) $ color parede $ rectangleSolid 600 20
--     , translate (-300) (-300) $ color parede $ rectangleSolid 20 410
--     , translate (-300) (300) $ color parede $ rectangleSolid 20 410
--     , translate (300) (300) $ color parede $ rectangleSolid 20 410
--     , translate (300) (-300) $ color parede $ rectangleSolid 20 410
--     ]
--     where  
--         bola = white
--         paletaPlayer = green 
--         paletaPlayer2 = red
--         parede = light (light (light black))



main :: IO ()
main = display window background (drawGame initialState )
