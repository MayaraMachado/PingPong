module Main where

import Graphics.Gloss
import Graphics.Gloss.Data.ViewPort
import Graphics.Gloss.Interface.Pure.Game

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
        { posicaoEspaco = (9, 30)
        , velocidade = (196, 120)
        , player1 = 40
        , player2 = 40
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
             , paleta green 290  $ player1 game
             , paleta blue (-290) $ player2 game
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

moverBola :: Float -> PongGame -> PongGame
moverBola seconds game = game { posicaoEspaco = (x', y'), player2 = py2' }
    where
        (x,y) = posicaoEspaco game
        (vx, vy) = velocidade game
        py2 = player2 game

        x' = x + vx * seconds
        y' = y + vy * seconds

        -- py2' = if (py2 < 80 && py2 > -80) then  y else py2
        py2' = y



bateuParede :: (Float, Float) -> Float -> Bool
bateuParede (_, y) raio = topoColisao || baixoColisao 
    where
        topoColisao = (y - raio <= -fromIntegral 590 / 2) 
        baixoColisao = (y + raio >= fromIntegral 590  / 2)


bateuTrave :: (Float, Float) -> Float -> Bool
bateuTrave (x, y) raio = lateral1 || lateral2
    where
        lateral1 = ((x - raio <= -fromIntegral 569 / 2) && ( y > 100 || y <= -100 ))
        lateral2 =  (( x - raio >= fromIntegral 550 / 2) && ( y >= 100 || y < -100 ))

bateuPaleta :: (Float, Float) -> Float -> PongGame  -> Bool
bateuPaleta (x, y) raio game  = paletaPlayer1 || paletaPlayer2
        where
            py1 = player1 game
            py2 = player2 game 

            paletaPlayer1 = ((x - raio < -fromIntegral 285) && ((y < py1+35) && (y > py1 - 35)))
            paletaPlayer2 = (( x - raio > fromIntegral 260) && ((y < py1+35) && (y > py1 - 35)))

gol ::  PongGame -> Bool
gol game = vitoriaPlayer1 || vitoriaPlayer2
            where
                (x,_) = posicaoEspaco game

                vitoriaPlayer1 = (x - 10 < -fromIntegral 300) 
                vitoriaPlayer2 = (x - 10 > fromIntegral 290) 

foiGol :: PongGame -> PongGame
foiGol game = game {velocidade = (vx', vy')} 
        where
            (vx, vy) = velocidade game
            vx' = if (gol game)
                then 
                    0
                else
                    vx
            
            vy' = if (gol game)
                then
                    0
                else
                    vy
        
mudarDirecao :: PongGame -> PongGame
mudarDirecao game = game {velocidade = (vx', vy')}
        where
            raio = 10

            (vx, vy) = velocidade game

            vx' = if ((bateuTrave (posicaoEspaco game) raio) || (bateuPaleta (posicaoEspaco game) raio game ))
                then 
                    -vx
                else
                    vx
            
            vy' = if ((bateuParede (posicaoEspaco game) raio)  || (bateuPaleta (posicaoEspaco game) raio game  ) )
                then
                    -vy
                else
                    vy
     
                                             
update :: Float -> PongGame -> PongGame
update seconds = mudarDirecao . moverBola seconds . foiGol

eventosTeclado :: Event -> PongGame -> PongGame
eventosTeclado (EventKey (Char 'r') _ _ _) game = game {posicaoEspaco = (0,0), velocidade = (196, 120), player1 = 0, player2 = 0}
eventosTeclado (EventKey (Char 'w') _ _ _) game = game {player1 = x'}
                    where
                        x = player1 game
                        x' = if (x < 80)
                            then
                                 x + 20
                            else
                                 x
eventosTeclado (EventKey (Char 's') _ _ _) game = game {player1 = x'}
                    where
                        x = player1 game
                        x' = if (x > -80)
                            then
                                 x - 20
                            else
                                 x
eventosTeclado _ game = game

main :: IO ()
main = play  window background 60 initialState drawGame eventosTeclado update