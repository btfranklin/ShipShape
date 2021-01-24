//  Created by B.T. Franklin on 1/4/21.

import CoreGraphics
import DunesailerUtilities
import Aesthete

public struct SideViewSpaceShipShape: ShipShape, Codable {

    private enum ConnectorType: String, Codable {
        case line
        case convexCurve
        case concaveCurve
    }

    private static let connectorProbabilities = ProbabilityGroup<ConnectorType>([
        .line           :   50,
        .convexCurve    :   25,
        .concaveCurve   :   25
    ], enforcePercent: true)

    private let path: CompositePath
    
    public init(xUnits: CGFloat = 1,
                yUnits: CGFloat = 1,
                complexity: Int) {

        guard complexity > 0 else {
            fatalError("complexity must be greater than 0")
        }

        var pathlets = [Pathlet]()
        var currentPoint = CGPoint.zero
        for _ in 1...complexity {

            let verticalOffset = CGFloat.random(in: 0.0...yUnits)
            let horizontalOffset = CGFloat.random(in: (xUnits * 0.05)...(xUnits * 0.1))

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
            let length = CGFloat.random(in: (xUnits * 0.1)...(xUnits * 0.3))
            let destinationX = (currentPoint.x + length > xUnits) ? xUnits : currentPoint.x + length
            destinationPoint = CGPoint(x: destinationX, y: currentPoint.y)
            let horizontalPathlet: Pathlet = .line(to: destinationPoint)

            currentPoint = destinationPoint

            pathlets.append(horizontalPathlet)
        }
        pathlets.append(.line(to: .init(x: xUnits, y: 0.0)))

        path = .init(pathlets: pathlets)
    }

    public func draw(on context: CGContext) {
        context.saveGState()
        context.setAllowsAntialiasing(true)

        context.addPath(path.createCGPath(usingRelativePositioning: false))
        context.strokePath()

        context.restoreGState()
    }

}
