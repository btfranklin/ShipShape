//  Created by B.T. Franklin on 1/4/21.

import CoreGraphics
import DunesailerUtilities
import Aesthete
import Greebler

public struct SideViewSpaceShipShape: ShipShape, Codable {

    private enum ConnectorType: String, Codable {
        case line
        case convexCurve
        case concaveCurve
    }

    private enum EdgeType {
        case top
        case bottom
    }

    private static let connectorProbabilities = ProbabilityGroup<ConnectorType>([
        .line           :   50,
        .convexCurve    :   25,
        .concaveCurve   :   25
    ], enforcePercent: true)

    private let topEdgePath: CompositePath
    private let bottomEdgePath: CompositePath
    private let path: CompositePath
    private let xUnits: CGFloat
    private let yUnits: CGFloat

    public init(xUnits: CGFloat = 1,
                yUnits: CGFloat = 1,
                complexity: Int) {

        guard complexity > 0 else {
            fatalError("complexity must be greater than 0")
        }

        self.xUnits = xUnits
        self.yUnits = yUnits

        topEdgePath = SideViewSpaceShipShape.design(.top, xUnits: xUnits, yUnits: yUnits, complexity: complexity)
        bottomEdgePath = SideViewSpaceShipShape.design(.bottom, xUnits: xUnits, yUnits: yUnits, complexity: complexity)

        path = CompositePath(pathlets: topEdgePath.pathlets + [.move(to: .zero)] + bottomEdgePath.pathlets)
    }

    public func draw(on context: CGContext) {
        context.saveGState()

        let shipShapePath = path.createCGPath(usingRelativePositioning: false)

        context.addPath(shipShapePath)
        context.clip()

        drawTopHalf(on: context)
        drawBottomHalf(on: context)
        drawDividingLine(on: context)
        drawTrench(on: context)

        context.resetClip()

        context.setAllowsAntialiasing(true)
        context.addPath(shipShapePath)
        context.strokePath()

        context.restoreGState()
    }

    private func drawTopHalf(on context: CGContext) {
        context.saveGState()

        context.clip(to: CGRect(x: 0, y: 0, width: xUnits, height: yUnits))

        let grayThemeColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).hsbaColor
        let windowZoneCount = 3
        let greebles = CompositeGreebles(greeblesAssortment: [
            CapitalShipSurfaceGreebles(xUnits: xUnits, yUnits: yUnits, themeColor: grayThemeColor),
            CapitalShipWindowsGreebles(xUnits: xUnits, yUnits: yUnits, themeColor: grayThemeColor, windowZoneCount: windowZoneCount)
        ])
        greebles.draw(on: context)

        context.restoreGState()
    }

    private func drawBottomHalf(on context: CGContext) {
        context.saveGState()

        context.clip(to: CGRect(x: 0, y: -yUnits, width: xUnits, height: yUnits))

        let grayThemeColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).hsbaColor.brightnessAdjusted(by: -0.1)
        let windowZoneCount = 3
        let greebles = CompositeGreebles(greeblesAssortment: [
            CapitalShipSurfaceGreebles(xUnits: xUnits, yUnits: yUnits, themeColor: grayThemeColor),
            CapitalShipWindowsGreebles(xUnits: xUnits, yUnits: yUnits, themeColor: grayThemeColor, windowZoneCount: windowZoneCount)
        ])
        context.translateBy(x: 0, y: -yUnits)
        greebles.draw(on: context)

        context.restoreGState()
    }

    private func drawDividingLine(on context: CGContext) {
        context.saveGState()

        let grayThemeColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).hsbaColor.brightnessAdjusted(by: -0.2)

        context.move(to: .zero)
        context.addLine(to: CGPoint(x: xUnits, y: 0))
        context.setStrokeColor(CGColor.create(from: grayThemeColor))
        context.strokePath()

        context.restoreGState()
    }

    private func drawTrench(on context: CGContext) {
        context.saveGState()

        let grayThemeColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).hsbaColor.brightnessAdjusted(by: -0.1)
        let trenchYPosition = CGFloat.random(in: 0...yUnits / 2)
        let greebles = EquipmentTrenchGreebles(xUnits: xUnits,
                                               yUnits: yUnits,
                                               themeColor: grayThemeColor,
                                               trenchYPosition: trenchYPosition)
        context.translateBy(x: 0, y: -yUnits / 2)
        greebles.draw(on: context)

        context.restoreGState()
    }

    static private func design(_ edge: EdgeType,
                               xUnits: CGFloat,
                               yUnits: CGFloat,
                               complexity: Int) -> CompositePath {

        let verticalOffsetRange = edge == .top ? (0.1...yUnits) : ((-0.66*yUnits)...(-0.1))

        let minimumConnectorOffset: CGFloat = (0.3 / CGFloat(complexity+1)) * xUnits
        let maximumConnectorOffset: CGFloat = (0.6 / CGFloat(complexity+1)) * xUnits

        var pathlets = [Pathlet]()
        var currentPoint = CGPoint.zero
        for _ in 1...complexity {

            let verticalOffset = CGFloat.random(in: verticalOffsetRange)
            let horizontalOffset = CGFloat.random(in: minimumConnectorOffset...maximumConnectorOffset)

            var destinationPoint = CGPoint(x: currentPoint.x + horizontalOffset, y: verticalOffset)

            // Connector
            switch SideViewSpaceShipShape.connectorProbabilities.randomItem() {
            case .line:
                pathlets.append(.line(to: destinationPoint))

            case .convexCurve:
                let controlPoint = CGPoint(x: currentPoint.x, y: destinationPoint.y)
                pathlets.append(.quadCurve(to: destinationPoint, control: controlPoint))

            case .concaveCurve:
                let controlPoint = CGPoint(x: destinationPoint.x, y: currentPoint.y)
                pathlets.append(.quadCurve(to: destinationPoint, control: controlPoint))
            }

            currentPoint = destinationPoint

            // Horizontal
            let minimumHorizontalLength: CGFloat = (0.75 / CGFloat(complexity)) * (xUnits - currentPoint.x)
            let maximumHorizontalLength: CGFloat = (0.95 / CGFloat(complexity)) * (xUnits - currentPoint.x)

            let length = CGFloat.random(in: minimumHorizontalLength...maximumHorizontalLength)
            let destinationX = (currentPoint.x + length > xUnits) ? xUnits : currentPoint.x + length
            destinationPoint = CGPoint(x: destinationX, y: currentPoint.y)
            let horizontalPathlet: Pathlet = .line(to: destinationPoint)

            currentPoint = destinationPoint

            pathlets.append(horizontalPathlet)
        }

        // Final connector
        let endPoint = CGPoint(x: xUnits, y: 0.0)
        switch SideViewSpaceShipShape.connectorProbabilities.randomItem() {
        case .line:
            pathlets.append(.line(to: endPoint))

        case .convexCurve:
            let controlPoint = CGPoint(x: currentPoint.x, y: endPoint.y)
            pathlets.append(.quadCurve(to: endPoint, control: controlPoint))

        case .concaveCurve:
            let controlPoint = CGPoint(x: endPoint.x, y: currentPoint.y)
            pathlets.append(.quadCurve(to: endPoint, control: controlPoint))
        }

        return .init(pathlets: pathlets)
    }

}
