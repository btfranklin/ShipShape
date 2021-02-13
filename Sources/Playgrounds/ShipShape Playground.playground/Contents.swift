import CoreGraphics
import ShipShape

// Prepare a graphics context
func createGraphicsContext() -> CGContext {
    let fullRect = CGRect(origin: .zero, size: CGSize(width: 800, height: 200))
    guard let context = CGContext(data: nil,
                                  width: Int(fullRect.width),
                                  height: Int(fullRect.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
        fatalError("Could not create graphics context")
    }
    context.translateBy(x: 0, y: 100 )
    context.scaleBy(x: 100, y: 100)
    return context
}

let sideViewShipShape = SideViewSpaceShipShape(xUnits: 8, complexity: 7)

var context = createGraphicsContext()

sideViewShipShape.draw(on: context)
context.makeImage()! // Click "Show Result" or "Quick Look" button to view rendered output
