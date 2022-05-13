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
            let textList1 = ["SCORE: \(score)","FULL LINES: \(fullLines)","NEXT BLOCKS: ","","RULE: "]
            var y = 200
            for message in textList1
            {
                let text = Text(location:Point(x:0,y:y),text:message)
                text.font = "35pt Arial Bold"
                canvas.render(text)
                y += 50
            }
            y -= 10
            let textList2 = ["ArrowLeft -> Move the block to the left.","ArrowRight -> Move the block to the right.","Space -> Drop the block","Control-Space -> Restart the game"]
            for message in textList2
            {
                let text = Text(location:Point(x:0,y:y),text:message)
                text.font = "25pt Arial Bold"
                canvas.render(text)
                y += 40
            }
        }
        if !rectangles.isEmpty
        {
            //Render the all lock blocks.
            for index in 0 ..< rectangles.count
            {
                canvas.render(fillStyles[index],strokeStyles[index],rectangles[index])
            }
        }
        if theEnd
        {
            //Write the GAME OVER when the game is over.
            canvas.render(FillStyle(color:Color(red:28,green:26,blue:14)),Rectangle(rect:Rect(topLeft:Point(x:0,y:0),size:Size(width:canvasWidth,height:canvasHeight)),fillMode:.fill))
            let theEndText = Text(location:Point(x:0,y:canvasHeight / 2),text:"GAME")
            theEndText.font = "\(canvasHeight / 3)pt Arial Bold"
            canvas.render(FillStyle(color:Color(.white)),theEndText)
            theEndText.location = Point(x:0,y:canvasHeight / 2 + canvasHeight / 3)
            theEndText.text = "OVER"
            canvas.render(theEndText)
            let descriptionText = Text(location:Point(x:canvasWidth / 5 * 3 + 50,y:canvasHeight / 2 - canvasHeight / 6),text:"Score: \(score), FullLines: \(fullLines)")
            descriptionText.font = "\(canvasHeight / 18)pt Arial Bold"
            canvas.render(descriptionText)
            descriptionText.font = "\(canvasHeight / 12)pt Arial Bold"
            descriptionText.location = Point(x:canvasWidth / 5 * 3 + 50,y:canvasHeight / 2 - canvasHeight / 12)
            descriptionText.text = "To start the"
            canvas.render(descriptionText)
            descriptionText.location = Point(x:canvasWidth / 5 * 3 + 50,y:canvasHeight / 2)
            descriptionText.text = "Game again,"
            canvas.render(descriptionText)
            descriptionText.location = Point(x:canvasWidth / 5 * 3 + 50,y:canvasHeight / 2 + canvasHeight / 12)
            descriptionText.text = "Press the"
            canvas.render(descriptionText)
            descriptionText.location = Point(x:canvasWidth / 5 * 3 + 50,y:canvasHeight / 2 + canvasHeight / 6)
            descriptionText.text = "Control-Space"
            canvas.render(descriptionText)
        }
    }
    override func calculate(canvasSize:Size)
    {
        //We can use canvasSize in this file.
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
        var list: [Int] = []
        for y in 0 ..< 20
        {
            list.insert(0,at:y)
        }
        for rectangle in rectangles
        {
            //When the rectangle is on the top, the game is over.
            if rectangle.rect.topLeft.y == 50
            {
                drawMainScreen = true
                theEnd = true
            }
            else
            {
                let y = (rectangle.rect.topLeft.y - 50) / 30 - 1
                list[y] += 1
            }
        }
        var count = -1
        for y in 0 ..< 20
        {
            //When there are 10 of blocks on the same line, plus the fullLines.
            if list[y] == 10
            {
                fullLines += 1
                list[y] = 0
                count = y
            }
        }
        if count != -1
        {
            var index = 0
            for rectangle in rectangles
            {
                if rectangle.rect.topLeft.y == (count + 1) * 30 + 50
                {
                    //When there are 10 of blocks on the same line, remove the line.
                    fillStyles.remove(at:index)
                    strokeStyles.remove(at:index)
                    rectangles.remove(at:index)
                    index -= 1
                }
                index += 1
            }
            for rectangle in rectangles
            {
                //Drop all blocks above the removed line.
                if rectangle.rect.topLeft.y < (count + 1) * 30 + 50
                {
                    rectangle.rect.topLeft.y += 30
                }
            }
        }
    }
    override func setup(canvasSize:Size,canvas:Canvas)
    {
        //Register KeyDownhandler
        dispatcher.registerKeyDownHandler(handler:self)
    }
    override func teardown()
    {
        //Unregister KeyDownhandler
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
    func addRectangle(fillStyle:FillStyle,strokeStyle:StrokeStyle,rectangle:Rectangle)
    {
        //Add rectangle in the lockBlock list
        fillStyles.append(fillStyle)
        strokeStyles.append(strokeStyle)
        rectangles.append(rectangle)
        if !theEnd
        {
            score += 1
        }
    }
    func isBottom(x:Int,y:Int) -> Bool
    {
        //Check whether there are any wall or blocks at the bottom.
        for rectangle in rectangles
        {
            if rectangle.rect.topLeft == Point(x:x,y:y)
            {
                return true
            }
        }
        return y >= 650
    }
    func isLeft(x:Int,y:Int) -> Bool
    {
        //Check whether there are any wall or blocks on the left.
        for rectangle in rectangles
        {
            if rectangle.rect.topLeft == Point(x:x - 30,y:y)
            {
                return true
            }
        }
        return x <= canvasWidth / 2 + 30
    }
    func isRight(x:Int,y:Int) -> Bool
    {
        //Check whether there are any wall or blocks on the right.
        for rectangle in rectangles
        {
            if rectangle.rect.topLeft == Point(x:x + 30,y:y)
            {
                return true
            }
        }
        return x >= canvasWidth / 2 + 330
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        //When we press any key during main screen, stop drawing the main screen and start drawing the game screen.
        if drawMainScreen
        {
            drawMainScreen = false
        }
        //When we press control-space during the game, restart the game with drawing the main screen.
        if !drawMainScreen && code == "Space" && ctrlKey
        {
            drawMainScreen = true
            fillStyles = []
            strokeStyles = []
            rectangles = []
            score = 0
            fullLines = 0
            theEnd = false
        }
    }
}
