import CoreGraphics
import ShipShape

let unitSizeInPixels = 500
let shipXSizeInUnits = 8
let shipYSizeInUnits = 2

// Prepare a graphics context
func createGraphicsContext() -> CGContext {
    let contextWidth = shipXSizeInUnits * unitSizeInPixels
    let contextHeight = shipYSizeInUnits * unitSizeInPixels
    guard let context = CGContext(data: nil,
                                  width: contextWidth,
                                  height: contextHeight,
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
        fatalError("Could not create graphics context")
    }

    // Need to translate drawing context because ships are rendered along 0 Y baseline
    context.translateBy(x: 0, y: CGFloat(contextHeight / 2) )

    // Need to scale drawing context because ships are created using unitary sizing
    context.scaleBy(x: CGFloat(unitSizeInPixels), y: CGFloat(unitSizeInPixels))
    return context
}

let context = createGraphicsContext()
context.fill(CGRect(origin: .init(x: 0, y: -500), size: .init(width: 500, height: 1000)))

let themeColor = CGColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)).hsbaColor
let renderer = SideViewSpaceShipShapeGreebledRenderer(themeColor: themeColor)
let sideViewShipShape = SideViewSpaceShipShape(size: .init(width: shipXSizeInUnits, height: 1),
                                               complexity: 7,
                                               allowCurvedConnectors: false)

renderer.render(sideViewShipShape, on: context)
context.makeImage()! // Click "Show Result" or "Quick Look" button to view rendered output
