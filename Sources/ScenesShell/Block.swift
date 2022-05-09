import Igis
import Scenes

class Block: RenderableEntity,KeyDownHandler
{
    var canvasWidth = 1916
    var canvasHeight = 973
    var blockKind = "L"
    var x: Int
    var y: Int
    let aquaColor = Color(red:0,green:255,blue:255)
    var drawMainScreen = true
    var count = 20
    init(blockKind:String)
    {
        self.blockKind = blockKind
        self.x = canvasWidth / 2 + 21
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
            if count > 0
            {
                count -= 1
                if count == 0 && y + 60 <= 700
                {
                    y += 30
                    count = 20
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
            if blockKind == "L"
            {
                let side = 30
                for _ in 0 ..< 4
                {
                    canvas.render(FillStyle(color:aquaColor),StrokeStyle(color:Color(.black)),LineWidth(width:3))
                    canvas.render(Rectangle(rect:Rect(topLeft:Point(x:x,y:y),size:Size(width:side,height:side)),fillMode:.fillAndStroke))
                    x += side
                }
                x -= side * 4
            }
        }
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        if drawMainScreen
        {
            drawMainScreen = false
        }
        if key == "ArrowDown" && y + 60 < 700
        {
            y += 30
        }
        if y + 30 < 700
        {
            print(key)
            if key == "ArrowLeft" && x - 30 > canvasWidth / 2
            {
                x -= 30
            }
            if key == "ArrowRight" && x + 30 < canvasWidth / 2 + 240
            {
                x += 30
            }
        }
    }
}
