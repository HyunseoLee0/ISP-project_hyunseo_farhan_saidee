import Igis
import Scenes
import Foundation

/*
 This class is responsible for rendering the background.
 */


class Background: RenderableEntity,KeyDownHandler
{
    let mainImage: Image
    var canvasWidth = 1916
    var canvasHeight = 973
    var drawMainScreen = true
    var score = 0
    var fullLines = 0
    init()
    {
        guard let mainImageURL = URL(string:"https://media-cldnry.s-nbcnews.com/image/upload/t_fit-560w,f_auto,q_auto:best/newscms/2014_23/493331/tetris2.jpg")
        else
        {
            fatalError("Failed to create URL for MainImage")
        }
        mainImage = Image(sourceURL:mainImageURL)
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }
    override func setup(canvasSize:Size,canvas:Canvas)
    {
        dispatcher.registerKeyDownHandler(handler:self)
        canvas.setup(mainImage)
    }
    override func teardown()
    {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        if drawMainScreen
        {
            drawMainScreen = false
        }
    }
    override func render(canvas:Canvas)
    {
        if drawMainScreen && mainImage.isReady
        {
            mainImage.renderMode = .destinationRect(Rect(topLeft:Point(x:0,y:0),size:Size(width:canvasWidth,height:canvasHeight)))
            canvas.render(mainImage)
        }
        else
        {
            canvas.render(FillStyle(color:Color(red:28,green:26,blue:14)),Rectangle(rect:Rect(topLeft:Point(x:0,y:0),size:Size(width:canvasWidth,height:canvasHeight)),fillMode:.fill))
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
            drawBoard(canvas:canvas)
        }
    }
    override func calculate(canvasSize:Size)
    {
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
    }
    func drawBoard(canvas:Canvas)
    {
        canvas.render(FillStyle(color:Color(red:100,green:92,blue:103)))
        var y = 100
        for _ in 0 ..< 20
        {
            var x = canvasWidth / 2
            let text = Text(location:Point(x:x,y:y),text:"<!")
            text.font = "25pt Arial bold"
            canvas.render(text)
            x += 10
            for _ in 0 ..< 10
            {
                text.location = Point(x:x,y:y)
                text.text = "o"
                canvas.render(text)
                x += 15
            }
            text.location = Point(x:x,y:y)
            text.text = "!>"
            canvas.render(text)
            y += 25
        }
//        x += 5
        for _ in 0 ..< 10
        {
//            let text = Text(location:Point(x:x,y:y),text:"o")
//            text.font = "25pt Arial bold"
//            canvas.render(text)
//            x += 5
        }
        let lastText = Text(location:Point(x:canvasWidth / 2,y:y),text:"- - - - - - - - - - - - - - - -")
        canvas.render(lastText)
    }
}
