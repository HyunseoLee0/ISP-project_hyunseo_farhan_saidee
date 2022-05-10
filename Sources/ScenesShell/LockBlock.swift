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
    var score = 0
    var fullLines = 0
    var theEnd = false
    init()
    {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"LockBlock")
    }
    override func render(canvas:Canvas)
    {
        if !drawMainScreen
        {
            let tetrisText = Text(location:Point(x:0,y:150),text:"TETRIS")
            tetrisText.font = "150pt Arial Bold"
            canvas.render(FillStyle(color:Color(red:100,green:92,blue:103)),tetrisText)
            let textList = ["SCORE: \(score)","FULL LINES: \(fullLines)"]
            var y = 200
            for message in textList
            {
                let text = Text(location:Point(x:0,y:y),text:message)
                text.font = "35pt Arial Bold"
                canvas.render(text)
                y += 50
            }
        }
        if !rectangles.isEmpty
        {
            for index in 0 ..< rectangles.count
            {
                canvas.render(fillStyles[index],strokeStyles[index],rectangles[index])
            }
        }
        if theEnd
        {
            canvas.render(FillStyle(color:Color(red:28,green:26,blue:14)),Rectangle(rect:Rect(topLeft:Point(x:0,y:0),size:Size(width:canvasWidth,height:canvasHeight)),fillMode:.fill))
            let theEndText = Text(location:Point(x:0,y:canvasHeight / 2),text:"GAME")
            theEndText.font = "\(canvasHeight / 3)pt Arial Bold"
            canvas.render(FillStyle(color:Color(.white)),theEndText)
            theEndText.location = Point(x:0,y:canvasHeight / 2 + canvasHeight / 3)
            theEndText.text = "OVER"
            canvas.render(theEndText)
        }
    }
    override func calculate(canvasSize:Size)
    {
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
        for rectangle in rectangles
        {
            if rectangle.rect.topLeft.y == 100
            {
                drawMainScreen = true
                theEnd = true
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
    func addRectangle(fillStyle:FillStyle,strokeStyle:StrokeStyle,rectangle:Rectangle)
    {
        fillStyles.append(fillStyle)
        strokeStyles.append(strokeStyle)
        rectangles.append(rectangle)
        score += 1
    }
    func isBottom(x:Int,y:Int) -> Bool
    {
        for rectangle in rectangles
        {
            if x == rectangle.rect.topLeft.x && y >= rectangle.rect.topLeft.y
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
