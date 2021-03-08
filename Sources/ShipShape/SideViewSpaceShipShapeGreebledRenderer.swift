//  Created by B.T. Franklin on 2/22/21.

import Foundation
import CoreGraphics
import Aesthete
import Greebler

public class SideViewSpaceShipShapeGreebledRenderer {

    public let themeColor: HSBAColor
    public let allowsAntialiasing: Bool
    public let lineWidth: CGFloat
    public let drawsDividingLine: Bool
    public let dividingLineWidth: CGFloat
    public let drawsTrench: Bool
    public let trenchThemeColor: HSBAColor
    public let topHalfWindowZoneCount: Int
    public let bottomHalfWindowZoneCount: Int

    public init(themeColor: HSBAColor = CGColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).hsbaColor,
                allowsAntialiasing: Bool = true,
                lineWidth: CGFloat = 0.005,
                drawsDividingLine: Bool = true,
                dividingLineWidth: CGFloat = 0.02,
                drawsTrench: Bool = true,
                trenchThemeColor: HSBAColor? = nil,
                topHalfWindowZoneCount: Int = 3,
                bottomHalfWindowZoneCount: Int = 3) {
        self.themeColor = themeColor
        self.allowsAntialiasing = allowsAntialiasing
        self.lineWidth = lineWidth
        self.drawsDividingLine = drawsDividingLine
        self.dividingLineWidth = dividingLineWidth
        self.drawsTrench = drawsTrench

        if let trenchThemeColor = trenchThemeColor {
            self.trenchThemeColor = trenchThemeColor
        } else {
            self.trenchThemeColor = themeColor.brightnessAdjusted(by: -0.1)
        }

        self.topHalfWindowZoneCount = topHalfWindowZoneCount
        self.bottomHalfWindowZoneCount = bottomHalfWindowZoneCount
    }

    public func render(_ shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()
        context.setAllowsAntialiasing(allowsAntialiasing)

        let shipShapePath = shipShape.path.createCGPath(usingRelativePositioning: false)

        context.addPath(shipShapePath)
        context.clip()

        drawTopHalf(of: shipShape, on: context)
        drawBottomHalf(of: shipShape, on: context)
        if drawsDividingLine {
            drawDividingLine(across: shipShape, on: context)
        }
        if drawsTrench {
            drawTrench(across: shipShape, on: context)
        }

        context.resetClip()

        context.addPath(shipShapePath)

        context.setLineWidth(lineWidth)
        context.strokePath()

        context.restoreGState()
    }

    private func drawTopHalf(of shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        context.clip(to: CGRect(x: 0, y: 0, width: shipShape.xUnits, height: shipShape.yUnits))
        let greebles = CompositeGreebles(greeblesAssortment: [
            CapitalShipSurfaceGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: themeColor),
            CapitalShipWindowsGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: themeColor, windowZoneCount: topHalfWindowZoneCount)
        ])
        greebles.draw(on: context)

        context.restoreGState()
    }

    private func drawBottomHalf(of shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        context.clip(to: CGRect(x: 0, y: -shipShape.yUnits, width: shipShape.xUnits, height: shipShape.yUnits))

        let darkenedThemeColor = themeColor.brightnessAdjusted(by: -0.1)
        let greebles = CompositeGreebles(greeblesAssortment: [
            CapitalShipSurfaceGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: darkenedThemeColor),
            CapitalShipWindowsGreebles(xUnits: shipShape.xUnits, yUnits: shipShape.yUnits, themeColor: darkenedThemeColor, windowZoneCount: bottomHalfWindowZoneCount)
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
        context.setLineWidth(dividingLineWidth)
        context.strokePath()

        context.restoreGState()
    }

    private func drawTrench(across shipShape: SideViewSpaceShipShape, on context: CGContext) {
        context.saveGState()

        let trenchYPosition = CGFloat.random(in: 0...shipShape.yUnits / 2)
        let greebles = EquipmentTrenchGreebles(xUnits: shipShape.xUnits,
                                               yUnits: shipShape.yUnits,
                                               themeColor: trenchThemeColor,
                                               trenchYPosition: trenchYPosition)
        context.translateBy(x: 0, y: -shipShape.yUnits / 2)
        greebles.draw(on: context)

        context.restoreGState()
    }

}
