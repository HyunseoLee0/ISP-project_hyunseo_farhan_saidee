import Igis
import Scenes

class Block: RenderableEntity,KeyDownHandler
{
    var canvasWidth = 1916
    var canvasHeight = 973
    var blocks = ["I","J","L","O","S","T","Z","."]
    //first, blockKind is "First" to show the process of making the board like curtain call.
    var blockKind = "First"
    var nextBlock: String
    var x: Int
    var y: Int
    var nextX: Int
    var nextY: Int
    let aquaColor = Color(red:0,green:255,blue:255)
    var drawMainScreen = true
    var count = 1
    var down = false
    var endBlock = false
    let lockBlock = LockBlock()
    var side = 30
    init()
    {
        self.nextBlock = blocks.randomElement()!
        self.x = canvasWidth / 2 + side
        self.y = 50
        self.nextX = 310
        self.nextY = 270
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Button")
    }
    override func render(canvas:Canvas)
    {
        //Draw the blocks.
        drawBlock(canvas:canvas)
        //Draw the next block.
        drawNextBlock(canvas:canvas)
    }
    override func calculate(canvasSize:Size)
    {
        //We can use canvasSize in this file.
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
        //During playing the game,
        if !drawMainScreen
        {
            //Check whether the process of the making board like curtain call is done.
            if blockKind == "First" && y + side >= 650
            {
                endBlock = true
            }
            //Check the block is at the bottom.
            if isBottom()
            {
                endBlock = true
            }
            //Curtain call is going to up
            if blockKind == "First" && endBlock && y - side > 0
            {
                y -= side
            }
            else if count > 0
            {
                //Put the delay with count.
                count -= 1
                if count == 0 && !isBottom()
                {
                    y += side
                    count = 20
                    if down
                    {
                        count = 1
                    }
                }
            }
        }
    }
    override func setup(canvasSize:Size,canvas:Canvas)
    {
        //Register KeyDownhandler.
        dispatcher.registerKeyDownHandler(handler:self)
    }
    override func teardown()
    {
        //Unregister KeyDownhandler.
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
    func drawBlock(canvas:Canvas)
    {
        let strokeStyle = StrokeStyle(color:Color(.black))
        let lineWidth = LineWidth(width:3)
        if !drawMainScreen
        {
            let xInfo = getInfo(kind:"X")
            let yInfo = getInfo(kind:"Y")
            if blockKind == "First"
            {
                canvas.render(FillStyle(color:Color(red:28,green:26,blue:14)))
                canvas.render(Rectangle(rect:Rect(topLeft:Point(x:canvasWidth / 2 - 10,y:y - 580),size:Size(width:400,height:580)),fillMode:.fill))
                if y < side
                {
                    //Check the end of this block, and export the next block.
                    endBlocks()
                }
            }
            //Draw the I block when the current block is this.
            if blockKind == "I"
            {
                let fillStyle = FillStyle(color:aquaColor)
                for _ in 0 ..< xInfo
                {
                    let rectangle = getRectangle()
                    canvas.render(fillStyle,strokeStyle,lineWidth,rectangle)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle)
                    }
                    x += side
                }
                x -= side * xInfo
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the J block when the current block is this.
            if blockKind == "J"
            {
                let fillStyle = FillStyle(color:Color(.blue))
                let rectangle1 = getRectangle()
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                if endBlock
                {
                    //When the block is at bottom, lock the block at that place.
                    lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle1)
                }
                y += side
                for _ in 0 ..< xInfo
                {
                    let rectangle2 = getRectangle()
                    canvas.render(rectangle2)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle2)
                    }
                    x += side
                }
                x -= side * xInfo
                y -= side
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the L block when the current block is this.
            if blockKind == "L"
            {
                let fillStyle = FillStyle(color:Color(.orange))
                x += side * 2
                let rectangle1 = getRectangle()
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                if endBlock
                {
                    //When the block is at bottom, lock the block at that place.
                    lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle1)
                }
                x -= side * 2
                y += side
                for _ in 0 ..< xInfo
                {
                    let rectangle2 = getRectangle()
                    canvas.render(rectangle2)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle2)
                    }
                    x += side
                }
                x -= side * xInfo
                y -= side
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the O block when the current block is this.
            if blockKind == "O"
            {
                let fillStyle = FillStyle(color:Color(.yellow))
                for _ in 0 ..< yInfo
                {
                    for _ in 0 ..< xInfo
                    {
                        let rectangle = getRectangle()
                        canvas.render(fillStyle,strokeStyle,lineWidth,rectangle)
                        if endBlock
                        {
                            //When the block is at bottom, lock the block at that place.
                            lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle)
                        }
                        x += side
                    }
                    x -= side * xInfo
                    y += side
                }
                y -= side * yInfo
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the S block when the current block is this.
            if blockKind == "S"
            {
                let fillStyle = FillStyle(color:Color(.green))
                x += side
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle1 = getRectangle()
                    canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle1)
                    }
                    x += side
                }
                x -= side * xInfo
                y += side
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle2 = getRectangle()
                    canvas.render(rectangle2)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle2)
                    }
                    x += side
                }
                x -= side * (xInfo - 1)
                y -= side
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the T block when the current block is this.
            if blockKind == "T"
            {
                let fillStyle = FillStyle(color:Color(.purple))
                x += side
                let rectangle1 = getRectangle()
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                if endBlock
                {
                    //When the block is at bottom, lock the block at that place.
                    lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle1)
                }
                x -= side
                y += side
                for _ in 0 ..< xInfo
                {
                    let rectangle2 = getRectangle()
                    canvas.render(rectangle2)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle2)
                    }
                    x += side
                }
                x -= side * xInfo
                y -= side
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the Z block when the current block is this.
            if blockKind == "Z"
            {
                let fillStyle = FillStyle(color:Color(.red))
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle1 = getRectangle()
                    canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle1)
                    }
                    x += side
                }
                x -= side * (xInfo - 1)
                y += side
                x += side
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle2 = getRectangle()
                    canvas.render(rectangle2)
                    if endBlock
                    {
                        //When the block is at bottom, lock the block at that place.
                        lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle2)
                    }
                    x += side
                }
                x -= side * xInfo
                y -= side
                //Check the end of this block, and export the next block.
                endBlocks()
            }
            //Draw the . block when the current block is this.
            if blockKind == "."
            {
                let fillStyle = FillStyle(color:Color(.pink))
                let rectangle = getRectangle()
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle)
                if endBlock
                {
                    //When the block is at bottom, lock the block at that place.
                    lockBlock.addRectangle(fillStyle:fillStyle,strokeStyle:strokeStyle,rectangle:rectangle)
                }
                //Check the end of this block, and export the next block.
                endBlocks()
            }
        }
    }
    func drawNextBlock(canvas:Canvas)
    {
        let strokeStyle = StrokeStyle(color:Color(.black))
        let lineWidth = LineWidth(width:3)
        if !drawMainScreen
        {
            let xInfo = getInfo(kind:"X",next:true)
            let yInfo = getInfo(kind:"Y",next:true)
            //Draw the I block when the next block is this.
            if nextBlock == "I"
            {
                let fillStyle = FillStyle(color:aquaColor)
                for _ in 0 ..< xInfo
                {
                    let rectangle = getRectangle(next:true)
                    canvas.render(fillStyle,strokeStyle,lineWidth,rectangle)
                    nextX += side
                }
                nextX -= side * xInfo
            }
            //Draw the J block when the next block is this.
            if nextBlock == "J"
            {
                let fillStyle = FillStyle(color:Color(.blue))
                let rectangle1 = getRectangle(next:true)
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                nextY += side
                for _ in 0 ..< xInfo
                {
                    let rectangle2 = getRectangle(next:true)
                    canvas.render(rectangle2)
                    nextX += side
                }
                nextX -= side * xInfo
                nextY -= side
            }
            //Draw the L block when the next block is this.
            if nextBlock == "L"
            {
                let fillStyle = FillStyle(color:Color(.orange))
                nextX += side * 2
                let rectangle1 = getRectangle(next:true)
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                nextX -= side * 2
                nextY += side
                for _ in 0 ..< xInfo
                {
                    let rectangle2 = getRectangle(next:true)
                    canvas.render(rectangle2)
                    nextX += side
                }
                nextX -= side * xInfo
                nextY -= side
            }
            //Draw the O block when the next block is this.
            if nextBlock == "O"
            {
                let fillStyle = FillStyle(color:Color(.yellow))
                for _ in 0 ..< yInfo
                {
                    for _ in 0 ..< xInfo
                    {
                        let rectangle = getRectangle(next:true)
                        canvas.render(fillStyle,strokeStyle,lineWidth,rectangle)
                        nextX += side
                    }
                    nextX -= side * xInfo
                    nextY += side
                }
                nextY -= side * yInfo
            }
            //Draw the S block when the next block is this.
            if nextBlock == "S"
            {
                let fillStyle = FillStyle(color:Color(.green))
                nextX += side
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle1 = getRectangle(next:true)
                    canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                    nextX += side
                }
                nextX -= side * xInfo
                nextY += side
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle2 = getRectangle(next:true)
                    canvas.render(rectangle2)
                    nextX += side
                }
                nextX -= side * (xInfo - 1)
                nextY -= side
            }
            //Draw the T block when the next block is this.
            if nextBlock == "T"
            {
                let fillStyle = FillStyle(color:Color(.purple))
                nextX += side
                let rectangle1 = getRectangle(next:true)
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                nextX -= side
                nextY += side
                for _ in 0 ..< xInfo
                {
                    let rectangle2 = getRectangle(next:true)
                    canvas.render(rectangle2)
                    nextX += side
                }
                nextX -= side * xInfo
                nextY -= side
            }
            //Draw the Z block when the next block is this.
            if nextBlock == "Z"
            {
                let fillStyle = FillStyle(color:Color(.red))
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle1 = getRectangle(next:true)
                    canvas.render(fillStyle,strokeStyle,lineWidth,rectangle1)
                    nextX += side
                }
                nextX -= side * (xInfo - 1)
                nextY += side
                nextX += side
                for _ in 0 ..< xInfo - 1
                {
                    let rectangle2 = getRectangle(next:true)
                    canvas.render(rectangle2)
                    nextX += side
                }
                nextX -= side * xInfo
                nextY -= side
            }
            //Draw the . block when the next block is this.
            if nextBlock == "."
            {
                let fillStyle = FillStyle(color:Color(.pink))
                let rectangle = getRectangle(next:true)
                canvas.render(fillStyle,strokeStyle,lineWidth,rectangle)
            }
        }
    }
    func endBlocks()
    {
        //The process for exporting the next block when the current block reaches at the bottom.
        if endBlock
        {
            down = false
            count = 20
            x = canvasWidth / 2 + side
            y = 50
            endBlock = false
            blockKind = nextBlock
            nextBlock = blocks.randomElement()!
        }
    }
    func isBottom() -> Bool
    {
        //Check whether there are any wall or blocks at the bottom.
        let xInfo = getInfo(kind:"X")
        let yInfo = getInfo(kind:"Y")
        var checkX = x
        if blockKind != "S" && blockKind != "Z"
        {
            for _ in 0 ..< xInfo
            {
                if lockBlock.isBottom(x:checkX,y:y + side * yInfo)
                {
                    return true
                }
                checkX += 30
            }
        }
        if blockKind == "S"
        {
            for _ in 0 ..< xInfo - 1
            {
                if lockBlock.isBottom(x:checkX,y:y + side * yInfo)
                {
                    return true
                }
                checkX += 30
            }
            if lockBlock.isBottom(x:checkX,y:y + side * (yInfo - 1))
            {
                return true
            }
        }
        if blockKind == "Z"
        {
            if lockBlock.isBottom(x:checkX,y:y + side * (yInfo - 1))
            {
                return true
            }
            checkX += 30
            for _ in 0 ..< xInfo - 1
            {
                if lockBlock.isBottom(x:checkX,y:y + side * yInfo)
                {
                    return true
                }
                checkX += 30
            }
        }
        return false
    }
    func isLeft() -> Bool
    {
        //Check whether there are any wall or blocks on the left.
        let xInfo = getInfo(kind:"X")
        if blockKind == "I" || blockKind == "."
        {
            return lockBlock.isLeft(x:x,y:y)
        }
        if blockKind == "J" || blockKind == "O"
        {
            return lockBlock.isLeft(x:x,y:y) || lockBlock.isLeft(x:x,y:y + side)
        }
        if blockKind == "L"
        {
            return lockBlock.isLeft(x:x + side * (xInfo - 1),y:y) || lockBlock.isLeft(x:x,y:y + side)
        }
        if blockKind == "S" || blockKind == "T"
        {
            return lockBlock.isLeft(x:x + side,y:y) || lockBlock.isLeft(x:x,y:y + side)
        }
        if blockKind == "Z"
        {
            return lockBlock.isLeft(x:x,y:y) || lockBlock.isLeft(x:x + side,y:y + side)
        }
        return false
    }
    func isRight() -> Bool
    {
        //Check whether there are any wall or blocks on the right.
        let xInfo = getInfo(kind:"X")
        if blockKind == "I" || blockKind == "."
        {
            return lockBlock.isRight(x:x + side * xInfo,y:y)
        }
        if blockKind == "J"
        {
             return lockBlock.isRight(x:x,y:y) || lockBlock.isRight(x:x + side * xInfo,y:y + side)
        }
        if blockKind == "L" || blockKind == "O"
        {
            return lockBlock.isRight(x:x + side * xInfo,y:y) || lockBlock.isRight(x:x + side * xInfo,y:y + side)
        }
        if blockKind == "S"
        {
            return lockBlock.isRight(x:x + side * xInfo,y:y) || lockBlock.isRight(x:x + side * (xInfo - 1),y:y + side)
        }
        if blockKind == "T" || blockKind == "Z"
        {
            return lockBlock.isRight(x:x + side * (xInfo - 1),y:y) || lockBlock.isRight(x:x + side * xInfo,y:y + side)
        }
        return false
    }
    func getInfo(kind:String,next:Bool = false) -> Int
    {
        //Get the information of the blockKind like how many columns and rows.
        var currentKind = blockKind
        if next
        {
            currentKind = nextBlock
        }
        if kind == "X"
        {
            if currentKind == "I" || currentKind == "First"
            {
                return 4
            }
            if currentKind == "J" || currentKind == "L" || currentKind == "S" || currentKind == "T" || currentKind == "Z"
            {
                return 3
            }
            if currentKind == "O"
            {
                return 2
            }
            if currentKind == "."
            {
                return 1
            }
        }
        if kind == "Y"
        {
            if currentKind == "First" || currentKind == "I" || currentKind == "."
            {
                return 1
            }
            if currentKind == "J" || currentKind == "L" || currentKind == "O" || currentKind == "S" || currentKind == "T" || currentKind == "Z"
            {
                return 2
            }
        }
        return -1
    }
    //GET THE RECTANGLE
    func getRectangle(next:Bool = false) -> Rectangle
    {
        if next
        {
            return Rectangle(rect:Rect(topLeft:Point(x:nextX,y:nextY),size:Size(width:side,height:side)),fillMode:.fillAndStroke)
        }
        return Rectangle(rect:Rect(topLeft:Point(x:x,y:y),size:Size(width:side,height:side)),fillMode:.fillAndStroke)
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        //When we press any key during main screen, stop drawing the main screen and start drawing the game screen.
        if drawMainScreen
        {
            drawMainScreen = false
            down = true
        }
        //When we press control-space during the game, restart the game with drawing the main screen.
        if !drawMainScreen && code == "Space" && ctrlKey
        {
            //The process of the RESET THE GAME.
            drawMainScreen = true
            blockKind = "First"
            nextBlock = blocks.randomElement()!
            x = canvasWidth / 2 + side
            y = 50
            count = 1
            down = false
            endBlock = false
        }
        //When the blockKind is not "First" and down is false, we can control the block by pressing the key.
        if blockKind != "First" && !down
        {
            //block is dropping
            if y < 620
            {
                //When we press the key SpaceBar, drop the block quickly.
                if code == "Space" && y < 590
                {
                    down = true
                }
                //When we press the key ArrowLeft, move the block to the left if it is possible.
                if key == "ArrowLeft" && !isLeft()
                {
                    x -= side
                }
                //When we press the key ArrowRight, move the block to the right if it is possible.
                if key == "ArrowRight" && !isRight()
                {
                    x += side
                }
            }
        }
    }
}
