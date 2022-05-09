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
    init(blockKind:String)
    {
        self.blockKind = blockKind
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
        if blockKind == "L"
        {
            let side = 30
            for _ in 0 ..< 10
            {
                canvas.render(FillStyle(color:aquaColor),StrokeStyle(color:Color(.black)),LineWidth(width:3))
                canvas.render(Rectangle(rect:Rect(topLeft:Point(x:x,y:y),size:Size(width:side,height:side)),fillMode:.fillAndStroke))
                x += side
            }
            x -= side * 11
        }
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        if key == "ArrowUp"
        {
            y -= 30
        }
        if key == "ArrowDown"
        {
            y += 30
        }
        if key == "ArrowLeft"
        {
            x -= 1
        }
        if key == "ArrowRight"
        {
            x += 1
        }
    }
}
