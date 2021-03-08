import CoreGraphics
import ShipShape

// Prepare a graphics context
func createGraphicsContext() -> CGContext {
    let fullRect = CGRect(origin: .zero, size: CGSize(width: 4000, height: 1000))
    guard let context = CGContext(data: nil,
                                  width: Int(fullRect.width),
                                  height: Int(fullRect.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
        fatalError("Could not create graphics context")
    }
    context.translateBy(x: 0, y: 500 )
    context.scaleBy(x: 500, y: 500)
    return context
}

var context = createGraphicsContext()
let themeColor = CGColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)).hsbaColor
let renderer = SideViewSpaceShipShapeGreebledRenderer(themeColor: themeColor)

let sideViewShipShape = SideViewSpaceShipShape(xUnits: 8, complexity: 7)

context = createGraphicsContext()
renderer.render(sideViewShipShape, on: context)
context.makeImage()! // Click "Show Result" or "Quick Look" button to view rendered output
