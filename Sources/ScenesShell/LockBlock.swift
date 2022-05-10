import Igis
import Scenes

class LockBlock: RenderableEntity
{
    var canvasWidth = 1916
    var canvasHeight = 973
    var fillStyles: [FillStyle] = []
    var strokeStyles: [StrokeStyle] = []
    var rectangles: [Rectangle] = []
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
    func addRectangle(fillStyle:FillStyle,strokeStyle:StrokeStyle,rectangle:Rectangle)
    {
        fillStyles.append(fillStyle)
        strokeStyles.append(strokeStyle)
        rectangles.append(rectangle)
    }
}
