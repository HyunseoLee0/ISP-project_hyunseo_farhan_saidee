import Igis
import Scenes

class Button: RenderableEntity,EntityMouseClickHandler
{
    var button: Rectangle
    var text: Text
    var point: Point
    var canvasWidth = 1916
    var canvasHeight = 973
    var clicking = false
    let width = 200
    let height = 60
    init(message:String,point:Point)
    {
        button = Rectangle(rect:Rect(topLeft:point,size:Size(width:width,height:height)),fillMode:.fillAndStroke)
        text = Text(location:point,text:message)
        text.font = "\(height / 2)pt Arial"
        self.point = point
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Button")
    }
    override func render(canvas:Canvas)
    {
        let strokeStyle = StrokeStyle(color:Color(.black))
        let fillStyle1 = FillStyle(color:Color(.gray))
        var lineWidth = LineWidth(width:3)
        if clicking
        {
            lineWidth = LineWidth(width:7)
        }
        button.rect.topLeft = point
        canvas.render(strokeStyle,fillStyle1,lineWidth,button)
        let fillStyle2 = FillStyle(color:Color(.black))
        text.location = Point(x:point.x + width / text.text.count,y:point.y + height - height / 4)
        canvas.render(fillStyle2,text)
    }
    override func calculate(canvasSize:Size)
    {
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
    }
    override func setup(canvasSize:Size,canvas:Canvas)
    {
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }
    override func teardown()
    {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }
    func onEntityMouseClick(globalLocation:Point)
    {
        if isInButton(mousePoint:globalLocation)
        {
            
        }
    }
    func move(to point:Point)
    {
        if point.x >= 0 && point.x + button.rect.width <= canvasWidth && point.y >= 0 && point.y + button.rect.height <= canvasHeight
        {
            self.point = point
        }
    }
    func isInButton(mousePoint:Point) -> Bool
    {
        return mousePoint.x >= point.x && mousePoint.x <= point.x + width && mousePoint.y >= point.y && mousePoint.y <= point.y + height
    } 
}
