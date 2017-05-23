require "CiderDebugger"; --Variables--
widget = require "widget"
ccx = display.contentCenterX
ccy = display.contentCenterY
cw = display.contentWidth
ch = display.contentHeight
f = native.systemFont
math.randomseed(os.time())

local buttonLPressed = false
local buttonRPressed = false

--Title Screen--
function titleScreen ( )
    gameTitle = display.newText(" STAR ", ccx, ccy-110, "prometheus", 50)
    gameTitle2 = display.newText(" BATTLES ", ccx, ccy-50, "prometheus", 50)


    function shipMove( )
        if math.random() > .8 then
            --audio.play(jump)
            newX = math.random(shipintro.width/2, cw-shipintro.width/2)
            transition.to(shipintro, {time = 500, x = newX, y = shipintro.y})
        end
    end

    function shipShoot( )
        laser = display.newImage("images/laser1.png", shipintro.x, shipintro.y-shipintro.height/2)
        transition.to(laser, {time = 750, x = laser.x, y = -ch})
    end

    --ship image--
    shipintro = display.newImage("images/ship1.png", ccx, ch-40)
    shipintro:scale(1.5, 1.5)

    function startEvent( event )
        if event.phase == "began" then

        elseif event.phase == "ended" then
            timer.cancel(loopMove)
            timer.cancel(loopShoot)
            display.remove( shipintro )
            display.remove( gameTitle )
            display.remove( gameTitle2 )
            display.remove( Sbutton )
            display.remove( StartGamebutton )
            toSelectScreen = timer.performWithDelay(500, selectScreen, 1)
        end
    end

    --start button--
    Sbutton  = display.newRect(ccx, ccy+30, 175, 50, 4)
    Sbutton:setFillColor(0,0,0)
    Sbutton.strokeWidth = 4
    StartGamebutton = widget.newButton
    {
        id = "startbtn",
        label = "START GAME",
        font = "prometheus",
        labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
        fontSize = 16, -- a bit smaller
        x = Sbutton.x, -- size and location based
        y = Sbutton.y, -- on the button display object
        width = Sbutton.width,
        height = Sbutton.height,
        onEvent = startEvent
    }

    Sbutton.alpha = 0
    StartGamebutton.alpha = 0

    --fade in button--
    transition.to(Sbutton, {time = 3000, delay = 2000, alpha = 1.0 })
    transition.to(StartGamebutton, {time = 3000, delay = 2000, alpha = 1.0 })

    --loop/timer for random ship moving and ship shooting--
    loopMove = timer.performWithDelay(100, shipMove, 0)
    loopShoot = timer.performWithDelay(500, shipShoot, 0)
end

--Selection Screen--
function selectScreen()
    chooseTxt = display.newText(" SELECT YOUR ", ccx, ccy-180, "prometheus", 30)
    shipChooseTxt = display.newText(" SHIP ", ccx, ccy-120, "prometheus", 45)

    --rectangles to highlight ship selections--
    rect1  = display.newRect(ccx, ccy-50, cw-20, 75)
    rect1:setFillColor(0,0,0)
    rect1.strokeWidth = 4

    rect2  = display.newRect(ccx, ccy+40, cw-20, 75)
    rect2:setFillColor(0,0,0)
    rect2.strokeWidth = 4

    rect3  = display.newRect(ccx, ccy+130, cw-20, 75)
    rect3:setFillColor(0,0,0)
    rect3.strokeWidth = 4

    --ship img displays--
    ship1 = display.newImage("images/ship1.png", ccx-110, ccy-50)
    ship2 = display.newImage("images/ship2.png", ccx-110, ccy+40)
    ship3 = display.newImage("images/ship3.png", ccx-110, ccy+130)

    ship1:scale( 2.5, 2.5)
    ship2:scale( 2.5, 2.5)
    ship3:scale( 2.5, 2.5)

    ship1Txt = display.newText(" Archon ", ccx-75, ccy-50, "space age", 25)
    ship2Txt = display.newText(" Firebird ", ccx-75, ccy+40, "space age", 25)
    ship3Txt = display.newText(" Destroyer ", ccx-75, ccy+130, "space age", 25)
    ship3Txt.anchorX = 0
    ship2Txt.anchorX = 0
    ship1Txt.anchorX = 0

    rect1.alpha = 1
    rect2.alpha = 0
    rect3.alpha = 0
    shipSelect = 1

    rect1.isHitTestable = true
    rect2.isHitTestable = true
    rect3.isHitTestable = true

    rect1:addEventListener("tap", rect1)
    rect2:addEventListener("tap", rect2)
    rect3:addEventListener("tap", rect3)

--function to transition to start game--
function selectEvent( event )
        if event.phase == "began" then

        elseif event.phase == "ended" then
            display.remove( ship1 )
            display.remove( ship2 )
            display.remove( ship3 )
            display.remove( ship1Txt )
            display.remove( ship2Txt )
            display.remove( ship3Txt )
            display.remove( rect1 )
            display.remove( rect2 )
            display.remove( rect3 )
            display.remove( selectButton )
            display.remove( selectRect )
            display.remove( shipChooseTxt )
            display.remove( chooseTxt )
            toStartScreen = timer.performWithDelay(1000, startGame, 1)
        end
    end

    --select button--
    selectRect = display.newRect(ccx, ch-35, 175, 50, 4)
    selectRect:setFillColor(0,0,0)
    selectRect.strokeWidth = 4
    selectButton = widget.newButton
    {
        id = "selectbtn",
        label = "START",
        font = "prometheus",
        labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
        fontSize = 16,
        x = selectRect.x,
        y = selectRect.y,
        width = selectRect.width,
        height = selectRect.height,
        onEvent = selectEvent
    }

    --changes selected ship--
function rect1:tap( event )
 rect1.alpha = 1
 rect2.alpha = 0
 rect3.alpha = 0
 shipSelect = 1
end

function rect2:tap( event )
 rect1.alpha = 0
 rect2.alpha = 1
 rect3.alpha = 0
 shipSelect = 2
end

function rect3:tap( event )
 rect1.alpha = 0
 rect2.alpha = 0
 rect3.alpha = 1
 shipSelect = 3
end

end

--Start Game--
function startGame ( event )
    function getDrawnButton( buttonID, xPos, yPos, w, h, text )

        button = display.newRoundedRect(xPos, yPos, w, h, 30)
        button.strokeWidth = 1
        button:setStrokeColor(.5,.5,.5)
        button.alpha = .2
        b = widget.newButton
        {
            id = buttonID,
            label = text,
            font = "HelveticaNeue-Light",
            fontSize = 16,
            embossed = true,
            x = xPos,
            y = yPos,
            width = w,
            height = h,
            onEvent = onButtonEvent
        }
        b.button = button
        b.pressed = pressed

        return b

    end

    --changes which ship image appears based on movement, and determines movement--
    function onButtonEvent( event )
        if event.phase == "began" then
            if event.target.id == "btnLeft" then
                buttonLPressed = true
                shipimg.alpha = 0
                shipimgleft.alpha = 1
                shipimgright.alpha = 0
            end
            if event.target.id == "btnRight" then
                buttonRPressed = true
                shipimg.alpha = 0
                shipimgleft.alpha = 0
                shipimgright.alpha = 1
            end
        elseif event.phase == "ended" then
            if event.target.id == "btnLeft" then
                buttonLPressed = false
                shipimg.alpha = 1
                shipimgleft.alpha = 0
                shipimgright.alpha = 0
            end
            if event.target.id == "btnRight" then
                buttonRPressed = false
                shipimg.alpha = 1
                shipimgleft.alpha = 0
                shipimgright.alpha = 0
            end
        end
    end

    --Create Button Text--
    btnLeft = getDrawnButton("btnLeft", ccx/2, ccy, cw/2, ch, "Left")
    btnRight = getDrawnButton("btnRight", ccx/2+cw/2, ccy, cw/2, ch, "Right")

    --changes ship based on selection screen--
    if shipSelect == 1 then

        shipimgleft = display.newImage("images/ship1left.png", ccx, ch-40)
        shipimgright = display.newImage("images/ship1right.png", ccx, ch-40)
        shipimg = display.newImage("images/ship1.png", ccx, ch-40, 40, 40)

    elseif shipSelect == 2 then

        shipimgleft = display.newImage("images/ship2left.png", ccx, ch-40)
        shipimgright = display.newImage("images/ship2right.png", ccx, ch-40)
        shipimg = display.newImage("images/ship2.png", ccx, ch-40)

    elseif shipSelect == 3 then
        shipimgleft = display.newImage("images/ship3left.png", ccx, ch-40)
        shipimgright = display.newImage("images/ship3right.png", ccx, ch-40)
        shipimg = display.newImage("images/ship3.png", ccx, ch-40)
    end
    shipimg:scale(1.5, 1.5)
    shipimgleft:scale(1.5, 1.5)
    shipimgright:scale(1.5, 1.5)

    shipimg.alpha = 1
    shipimgleft.alpha = 0
    shipimgright.alpha = 0

    --creates display group for left, right, and normal image--
    local ship = display.newGroup()
    ship:insert(shipimg)
    ship:insert(shipimgleft)
    ship:insert(shipimgright)

    --moves the whole display group of ships. normal ship, left, and right ship move together--
    local function moveCharacter(event)
        --display groups work wierd, so this gets the actual location of the images--
        --"Ship" is the display group of the three images--
        actualShipX, actualShipY = ship:localToContent( cw/2,0 )
        if buttonLPressed then

            if actualShipX > ship.width/2 then
                ship.x = ship.x - 5
            end
        end
        if buttonRPressed then

            if actualShipX < cw-ship.width/2 then
                ship.x = ship.x + 5
            end
        end

    end
    Runtime:addEventListener("enterFrame", moveCharacter)
    function shipShoot( )
        laser = display.newImage("images/laser1.png", actualShipX, shipimg.y-shipimg.height/2)
        --change the time to determine how fast laser moves upscreen--
        transition.to(laser, {time = 500, x = laser.x, y = -ch})
    end
    --calls the laser. Change this to determine how much time between shots.--
    loopShoot = timer.performWithDelay(500, shipShoot, 0)
end

--this starts the game by calling the title screen--
titleScreen()