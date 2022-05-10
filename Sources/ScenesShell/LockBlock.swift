import Igis
import Scenes

class LockBlock: RenderableEntity,KeyDownHandler
{
    var canvasWidth = 1916
    var canvasHeight = 973
    var fillStyles: [FillStyle] = []
    var strokeStyles: [StrokeStyle] = []
    var rectangles: [Rectangle] = []
    var drawMainScreen = true
    init()
    {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"LockBlock")
    }
    override func render(canvas:Canvas)
    {
        if !rectangles.isEmpty
        {
            for index in 0 ..< rectangles.count
            {
                canvas.render(fillStyles[index],strokeStyles[index],rectangles[index])
            }
        }
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
    func addRectangle(fillStyle:FillStyle,strokeStyle:StrokeStyle,rectangle:Rectangle)
    {
        fillStyles.append(fillStyle)
        strokeStyles.append(strokeStyle)
        rectangles.append(rectangle)
    }
    func isBottom(y:Int) -> Bool
    {
        for rectangle in rectangles
        {
            if y >= rectangle.rect.topLeft.y
            {
                return true
            }
        }
        if y >= 700
        {
            return true
        }
        return false
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        if drawMainScreen
        {
            drawMainScreen = false
        }
    }
}
