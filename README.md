# PingPong

Elaborar um jogo em Haskell/Gloss que atenda aos requisitos especificados na
seção Requisistos.

## 1. Requisitos
O jogo deve ser disputado entre dois oponentes: um jogador humano e um jogador artificial. Os
jogadores disputam pela realização de um gol no cenário ilustrado na Figura 1.

![alt tag](https://user-images.githubusercontent.com/16944803/34362168-77027cb0-ea58-11e7-9eab-18fca42d6707.png)

Cada jogador pode movimentar um bastão no sentido vertical para defender seu gol ou
direcionar o movimento da bola.

### Movimento da bola. 
- A bola se movimenta sempre com velocidade horizontal constante. O sentido da
velocidade horizontal muda sempre que ocorre a colisão com as bordas verticais do campo, ou quando
colide com um bastão. 

- A velocidade vertical muda sempre que ocorre colisão com uma das bordas
horizontais. 

- A velocidade vertical da bola pode mudar ou permanecer igual quando ocorre colisão com
um bastão. 

- A velocidade vertical do bastão deve ser somada à da bola, portanto, ela pode subir, descer
mais rapidamente ou mais lentamente, a depender da velocidade do bastão.Inicialização. O jogo começa com a bola posicionada no centro do campo, se deslocando numa direção
aleatória.

### Finalização. 

- O jogo termina quando um dos jogadores consegue fazer um gol.

### Dimensões. 
- O campo tem dimensões 600x600 pixels. 
- As traves possuem altura igual a 180 pixels centralizadas verticalmente em cada extremidade vertical do campo. 
- A bola possui raio igual 15 pixels.
- Os bastões possuem dimensões 70 pixels na vertical e 10 pixels na horizontal.

### Velocidades. 
- As velocidades, tanto da bola quanto dos bastões, devem ser escolhidas pelos projetistas
do jogo.

### Jogador artificial. 
- A estratégia do jogador artificial deve ser escolhida pelos projetistas.
