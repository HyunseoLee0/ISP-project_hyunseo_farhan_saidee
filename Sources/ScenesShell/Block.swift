import Igis
import Scenes

class Block: RenderableEntity,KeyDownHandler
{
    var canvasWidth = 1916
    var canvasHeight = 973
    var blockKind = "First"
    var blocks = ["I","J"]
    var x: Int
    var y: Int
    let aquaColor = Color(red:0,green:255,blue:255)
    var drawMainScreen = true
    var count = 1
    var down = false
    var endBlock = false
    let lockBlock = LockBlock()
    init()
    {
        self.x = canvasWidth / 2 + 30
        self.y = 100
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Button")
    }
    override func render(canvas:Canvas)
    {
        drawBlock(canvas:canvas)
    }
    override func calculate(canvasSize:Size)
    {
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
        if !drawMainScreen
        {
            if ((blockKind == "I" || blockKind == "First") && y + 30 >= 700) || (blockKind != "I" && blockKind != "First" && y + 60 >= 700)
            {
                endBlock = true
            }
            
            if blockKind == "First" && endBlock && y - 30 > 0
            {
                y -= 30
            }
            else if count > 0
            {
                count -= 1
                if count == 0 && (((blockKind == "I" || blockKind == "First") && y + 30 < 700) || (blockKind != "I" && blockKind != "First" && y + 60 < 700))
                {
                    y += 30
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
        dispatcher.registerKeyDownHandler(handler:self)
    }
    override func teardown()
    {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
    func drawBlock(canvas:Canvas)
    {
        if !drawMainScreen
        {
            let side = 30
            if blockKind == "First"
            {
                canvas.render(FillStyle(color:Color(red:28,green:26,blue:14)))
                canvas.render(Rectangle(rect:Rect(topLeft:Point(x:canvasWidth / 2 - 10,y:y - 630),size:Size(width:400,height:630)),fillMode:.fill))
                if y < 30
                {
                    down = false
                    count = 20
                    x = canvasWidth / 2 + 30
                    y = 100
                    endBlock = false
                    blockKind = blocks.randomElement()!
                }
            }
            if blockKind == "I"
            {
                for _ in 0 ..< 4
                {
                    let fillStyle = FillStyle(color:aquaColor)
                    canvas.render(fillStyle,StrokeStyle(color:Color(.black)),LineWidth(width:3))
                    let rectangle = Rectangle(rect:Rect(topLeft:Point(x:x,y:y),size:Size(width:side,height:side)),fillMode:.fillAndStroke)
                    canvas.render(rectangle)
                    if endBlock
                    {
                        lockBlock.addRectangle(fillStyle:FillStyle(color:aquaColor),strokeStyle:StrokeStyle(color:Color(.black)),rectangle:rectangle)
                    }
                    x += side
                }
                x -= side * 4
                if endBlock
                {
                    down = false
                    count = 20
                    x = canvasWidth / 2 + 30
                    y = 100
                    endBlock = false
                    blockKind = blocks.randomElement()!
                }
            }
            if blockKind == "J"
            {
                canvas.render(FillStyle(color:Color(.blue)),StrokeStyle(color:Color(.black)),LineWidth(width:3))
                let rectangle1 = Rectangle(rect:Rect(topLeft:Point(x:x,y:y),size:Size(width:side,height:side)),fillMode:.fillAndStroke)
                canvas.render(rectangle1)
                if endBlock
                {
                    let lockBlock = LockBlock()
//                    lockBlock.setRectangle(rectangle:rectangle1)
                }
                y += 30
                for _ in 0 ..< 3
                {
                    let rectangle2 = Rectangle(rect:Rect(topLeft:Point(x:x,y:y),size:Size(width:side,height:side)),fillMode:.fillAndStroke)
                    canvas.render(rectangle2)
                    if endBlock
                    {
                        let lockBlock = LockBlock()
//                        lockBlock.setRectangle(rectangle:rectangle2)
                    }
                    x += side
                }
                x -= side * 3
                y -= 30
                if endBlock
                {
                    down = false
                    count = 20
                    x = canvasWidth / 2 + 30
                    y = 100
                    endBlock = false
                    blockKind = blocks.randomElement()!
                }
            }
        }
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        if drawMainScreen
        {
            drawMainScreen = false
            down = true
        }
        if key == "ArrowDown" && y + 60 < 700
        {
            y += 30
        }
        if y + 30 < 700
        {
            if code == "Space" && y + 60 < 700
            {
                down = true
            }
            if key == "ArrowLeft" && x - 30 > canvasWidth / 2
            {
                x -= 30
            }
            if key == "ArrowRight"
            {
                if (blockKind == "I" && x + 30 < canvasWidth / 2 + 240) || (blockKind != "I" && x + 30 < canvasWidth / 2 + 270)
                {
                    x += 30
                }
            }
        }
    }
}
