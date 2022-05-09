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
        //Call the image through the URL of Tetris Main Screen
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
        //Register KeyDownhandler
        dispatcher.registerKeyDownHandler(handler:self)
        //Setup MainImage
        canvas.setup(mainImage)
    }
    override func teardown()
    {
        //Unregister KeyDownhandler
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
    func onKeyDown(key:String,code:String,ctrlKey:Bool,shiftKey:Bool,altKey:Bool,metaKey:Bool)
    {
        //When we press any key during main screen, stop drawing the main screen and start drawing the game screen.
        if drawMainScreen
        {
            drawMainScreen = false
        }
    }
    override func render(canvas:Canvas)
    {
        //Before we press any key to start.
        if drawMainScreen && mainImage.isReady
        {
            //Change the size of the image
            mainImage.renderMode = .destinationRect(Rect(topLeft:Point(x:0,y:0),size:Size(width:canvasWidth,height:canvasHeight)))
            //Render the Image
            canvas.render(mainImage)
        }
        //After we press any key to start.
        else
        {
            //Render Background.
            canvas.render(FillStyle(color:Color(red:28,green:26,blue:14)),Rectangle(rect:Rect(topLeft:Point(x:0,y:0),size:Size(width:canvasWidth,height:canvasHeight)),fillMode:.fill))
            //Render Texts of "tetris", Score, and Full lines.
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
            //Draw the tetris board.
            drawBoard(canvas:canvas)
        }
    }
    override func calculate(canvasSize:Size)
    {
        //We can use canvasSize in this file.
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
    }
    func drawBoard(canvas:Canvas)
    {
        //Render the color filling the text.
        let grayFillStyle = FillStyle(color:Color(red:100,green:92,blue:103))//FillStyle(color:Color(.gray))
        let blackStrokeStyle = StrokeStyle(color:Color(.black))
        let lineWidth = LineWidth(width:3)
        let rect1 = Rectangle(rect:Rect(topLeft:Point(x:canvasWidth / 2,y:100),size:Size(width:360,height:630)),fillMode:.fillAndStroke)
        canvas.render(grayFillStyle,blackStrokeStyle,lineWidth,rect1)
        let silverFillStyle = FillStyle(color:Color(.silver))
        for y in 0 ..< 20
        {
            for x in 0 ..< 10
            {
                let rect2 = Rectangle(rect:Rect(topLeft:Point(x:canvasWidth / 2 + 30 + x * 30,y:100 + y * 30),size:Size(width:30,height:30)),fillMode:.fillAndStroke)
                canvas.render(silverFillStyle,rect2)
            }
        }
    }
}
