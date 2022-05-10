import Igis
import Scenes

/*
 This class is responsible for the interaction Layer.
 Internally, it maintains the RenderableEntities for this layer.
 */


class InteractionLayer: Layer,KeyDownHandler
{
    let block = Block()
    var canvasWidth = 1916
    var canvasHeight = 973
    init()
    {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")
        // We insert our RenderableEntities in the constructor
        insert(entity:block,at:.front)
        insert(entity:block.lockBlock,at:.front)
    }
    override func preSetup(canvasSize:Size,canvas:Canvas)
    {
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
//        button1.move(to:Point(x:canvasWidth / 2 - button1.width / 2,y:canvasHeight / 2))
        dispatcher.registerKeyDownHandler(handler:self)
    }
    override func postTeardown()
    {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool)
    {
    }
}
