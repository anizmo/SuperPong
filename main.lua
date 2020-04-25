-- Library --

require 'Ball'

require 'Paddle'

require 'Border'

push = require 'push'

-- Constants --

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 800

VIRTUAL_SCREEN_WIDTH = 640
VIRTUAL_SCREEN_HEIGHT = 400

PADDLE_SPEED = 250

-- Variables --

scoreLeft = 0

scoreRight = 0

gameStateLabel = [[Press Enter to Start 2 Player Game!

or

Press Space to Start Single Player Game]]

ball = Ball(VIRTUAL_SCREEN_WIDTH/2,VIRTUAL_SCREEN_HEIGHT/2,10,10)

player1Paddle = Paddle(10, VIRTUAL_SCREEN_HEIGHT/2 -30, 16, 60)

player2Paddle = Paddle(VIRTUAL_SCREEN_WIDTH - 25, VIRTUAL_SCREEN_HEIGHT/2 -30, 16, 60)

borderTop = Border( 0 ,  54, VIRTUAL_SCREEN_WIDTH, 1)
borderBottom = Border( 0 ,  VIRTUAL_SCREEN_HEIGHT - 10, VIRTUAL_SCREEN_WIDTH, 1)

borderPlayer1 = Border( -2 ,  54, 1, VIRTUAL_SCREEN_HEIGHT - 65)
borderPlayer2 = Border( VIRTUAL_SCREEN_WIDTH + 1 ,  54, 1, VIRTUAL_SCREEN_HEIGHT - 65)

servingPlayer = 'Player 1'

isAIEnabled = false

gameMode = ''

player2Name = ''

-- State--

gamestate = 'start'


function love.load()
    gameFont = love.graphics.newFont('minotaur.ttf',24)

    smallerFont = love.graphics.newFont('minotaur.ttf',16)

    love.graphics.setFont(gameFont)

    push:setupScreen(VIRTUAL_SCREEN_WIDTH, VIRTUAL_SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT,  {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    music = love.audio.newSource("background.ogg","stream")
    music:setVolume(0.1)
    music:setLooping(true)
    music:play()

    love.graphics.setColor(0,255,0)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_SCREEN_WIDTH, VIRTUAL_SCREEN_HEIGHT)

end

function love.resize(w,h)
    push:resize(w,h)
end


function love.draw()
    push:apply('start')

    love.graphics.setFont(gameFont)

    love.graphics.setColor(237, 236, 194)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_SCREEN_WIDTH, VIRTUAL_SCREEN_HEIGHT)

    love.graphics.setColor(255,0,0)
    love.graphics.printf("Super Pong!",0, 10, VIRTUAL_SCREEN_WIDTH, 'center')

    love.graphics.printf(scoreLeft,20, 30, VIRTUAL_SCREEN_WIDTH - 20, 'left')

    love.graphics.printf(scoreRight,0, 30, VIRTUAL_SCREEN_WIDTH - 20, 'right')

    player1Paddle:render()

    player2Paddle:render()

    if(gamestate == 'play') then
        ball:render()
    end

    borderTop:render()
    borderBottom:render()
    borderPlayer1:render()
    borderPlayer2:render()

    love.graphics.setColor(255,0,0)
    love.graphics.printf(gameStateLabel,0, VIRTUAL_SCREEN_HEIGHT/2, VIRTUAL_SCREEN_WIDTH, 'center')

    love.graphics.setFont(smallerFont)
    love.graphics.printf(gameMode,0, 34, VIRTUAL_SCREEN_WIDTH, 'center')

    love.graphics.printf("Player 1",20, 15, VIRTUAL_SCREEN_WIDTH - 20, 'left')

    love.graphics.printf(player2Name,0, 15, VIRTUAL_SCREEN_WIDTH - 20, 'right')

    push:apply('end')

end

function love.keypressed(key)

    if key == 'enter' or key == 'return' then

        if gamestate == 'start' then

            gamestate = 'play'

            gameStateLabel = ''

            isAIEnabled = false

            player2Name = 'Player 2'

            gameMode = 'Multiplayer'

        elseif(gamestate == 'play') then

            gamestate = 'start'

            gameStateLabel = [[Press Enter to Start 2 Player Game!

or

Press Space to Start Single Player Game]]

            ball:reset()

            player1Paddle:reset()

            player2Paddle:reset()

            scoreLeft = 0

            scoreRight = 0

        elseif(gamestate == 'gameover') then

            gamestate = 'start'
    
            gameStateLabel = [[Press Enter to Start 2 Player Game!

or

Press Space to Start Single Player Game]]
    
            ball:reset()
    
            player1Paddle:reset()
    
            player2Paddle:reset()
    
            scoreLeft = 0
    
            scoreRight = 0
        end
    end

    if key == 'space' then

        if(gamestate == 'serve') then

            gamestate = 'play'

            if(servingPlayer == "Player 1") then
               ball.ballDX = math.random(2) == 1 and 100 or 100
            else
               ball.ballDX = math.random(2) == 1 and -100 or -100
            end

            gameStateLabel = ''

        elseif (gamestate == 'start') then

            isAIEnabled = true

            gamestate = 'play'

            gameStateLabel = ''

            player2Name = 'CPU'

            gameMode = 'Single-Player'
        end
    
end


  if key == 'escape' then
    love.event.quit()
  end
end


function love.update(dt)
    love.window.setTitle('Pong   FPS '.. tostring(love.timer.getFPS()))

    if love.keyboard.isDown('w') then

        player1Paddle.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then

        player1Paddle.dy = PADDLE_SPEED

    else

        player1Paddle.dy = 0

    end

    if(isAIEnabled == true) then
        player2Paddle.dy = ball.ballDY + math.random(-10,10) * ball.ballSpeedMultiplicationFactor
    else
        if love.keyboard.isDown('up') then

            player2Paddle.dy = -PADDLE_SPEED
    
        elseif love.keyboard.isDown('down') then
    
            player2Paddle.dy = PADDLE_SPEED
    
        else 
            
            player2Paddle.dy = 0
    
        end
    end

    if(gamestate == 'play') then
        ball:update(dt)
        player1Paddle:update(dt)
        player2Paddle:update(dt)

        if(ball:collides(player1Paddle)) then
            ball.ballDX = -ball.ballDX * 1.1
            ball.x = player1Paddle.x + 16

            if(ball.ballDY < 0) then
                ball.ballDY = - math.random(10,150)
            else
                ball.ballDY = math.random(10,150)
            end
        end

        if(ball:collides(player2Paddle)) then
            ball.ballSpeedMultiplicationFactor = (ball.ballSpeedMultiplicationFactor * 1.03)
            ball.ballDX = -ball.ballDX * ball.ballSpeedMultiplicationFactor
            ball.x = player2Paddle.x - 16

            if(ball.ballDY < 0) then
                ball.ballDY = - math.random(10,150)
            else
                ball.ballDY = math.random(10,150)
            end
        end

        if(ball:collides(borderTop)) then
            ball.ballSpeedMultiplicationFactor = (ball.ballSpeedMultiplicationFactor * 1.03)
            ball.ballDY = -ball.ballDY * ball.ballSpeedMultiplicationFactor
            ball.y = borderTop.y + 1
        end

        if(ball:collides(borderBottom)) then
            ball.ballDY = -ball.ballDY * 1.1
            ball.y = borderBottom.y - 10
        end

        if(ball:collides(borderPlayer1)) then
            scoreRight = scoreRight + 1
            if(scoreRight==5) then 
                gameStateLabel = player2Name.. ' Won!'
                gamestate = 'gameover'
            else
                servingPlayer = 'Player 1'
                gamestate = 'serve'
                player1Paddle:reset()
                player2Paddle:reset()
                ball:reset()
                gameStateLabel = 'Serve : '.. servingPlayer
            end
            
        end

        if(ball:collides(borderPlayer2)) then
            scoreLeft = scoreLeft + 1
            if(scoreLeft==5) then 
                gameStateLabel = 'Player 1 Won!'
                gamestate = 'gameover'
            else
                servingPlayer = 'Player 2'
                gamestate = 'serve'
                player1Paddle:reset()
                player2Paddle:reset()
                ball:reset()
                gameStateLabel = 'Serve : '.. servingPlayer
            end
        end

    end 

end