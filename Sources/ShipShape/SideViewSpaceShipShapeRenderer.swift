//  Created by B.T. Franklin on 2/22/21.

import Foundation
import Aesthete
import Greebler

public class SideViewSpaceShipShapeRenderer {

    let themeColor: HSBAColor

    public init(themeColor: HSBAColor) {
        self.themeColor = themeColor
    }

    public func render(_ shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()
        context.setAllowsAntialiasing(true)

        let shipShapePath = shipShape.path.createCGPath(usingRelativePositioning: false)

        context.addPath(shipShapePath)
        context.clip()

        drawTopHalf(of: shipShape, on: context)
        drawBottomHalf(of: shipShape, on: context)
        drawDividingLine(across: shipShape, on: context)
        drawTrench(across: shipShape, on: context)

        context.resetClip()

        context.addPath(shipShapePath)

        context.setLineWidth(0.005)
        context.strokePath()

        context.restoreGState()
    }

    private func drawTopHalf(of shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        context.clip(to: CGRect(x: 0, y: 0, width: shipShape.xUnits, height: shipShape.yUnits))

        let windowZoneCount = 3
        let greebles = CompositeGreebles(greeblesAssortment: [
            CapitalShipSurfaceGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: themeColor),
            CapitalShipWindowsGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: themeColor, windowZoneCount: windowZoneCount)
        ])
        greebles.draw(on: context)

        context.restoreGState()
    }

    private func drawBottomHalf(of shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        context.clip(to: CGRect(x: 0, y: -shipShape.yUnits, width: shipShape.xUnits, height: shipShape.yUnits))

        let darkenedThemeColor = themeColor.brightnessAdjusted(by: -0.1)
        let windowZoneCount = 3
        let greebles = CompositeGreebles(greeblesAssortment: [
            CapitalShipSurfaceGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: darkenedThemeColor),
            CapitalShipWindowsGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: darkenedThemeColor, windowZoneCount: windowZoneCount)
        ])
        context.translateBy(x: 0, y: -shipShape.yUnits)
        greebles.draw(on: context)

        context.restoreGState()
    }

    private func drawDividingLine(across shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        let darkenedThemeColor = themeColor.brightnessAdjusted(by: -0.2)

        context.move(to: .zero)
        context.addLine(to: CGPoint(x: shipShape.xUnits, y: 0))
        context.setStrokeColor(CGColor.create(from: darkenedThemeColor))
        context.setLineWidth(0.02)
        context.strokePath()

        context.restoreGState()
    }

    private func drawTrench(across shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        let darkenedThemeColor = themeColor.brightnessAdjusted(by: -0.1)
        let trenchYPosition = CGFloat.random(in: 0...shipShape.yUnits / 2)
        let greebles = EquipmentTrenchGreebles(xUnits: shipShape.xUnits,
                                               yUnits: shipShape.yUnits,
                                               themeColor: darkenedThemeColor,
                                               trenchYPosition: trenchYPosition)
        context.translateBy(x: 0, y: -shipShape.yUnits / 2)
        greebles.draw(on: context)

        context.restoreGState()
    }


}
