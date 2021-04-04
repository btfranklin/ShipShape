//  Created by B.T. Franklin on 3/23/21.

import CoreGraphics
import DunesailerUtilities
import Aesthete

extension SideViewSpaceShipShape {

    static func designVerticalHalf(_ edge: EdgeType,
                                   size: CGSize,
                                   complexity: Int,
                                   allowCurvedConnectors: Bool,
                                   platforms: inout [Platform]) -> CompositePath {

        let verticalOffsetRange = edge == .top ? (0.1...size.height) : ((-0.66*size.height)...(-0.1))

        let minimumConnectorOffset: CGFloat = (0.3 / CGFloat(complexity+1)) * size.width
        let maximumConnectorOffset: CGFloat = (0.6 / CGFloat(complexity+1)) * size.width

        var pathlets: [Pathlet] = []
        var currentPoint = CGPoint.zero
        for _ in 1...complexity {

            let verticalOffset = CGFloat.random(in: verticalOffsetRange)
            let horizontalOffset = CGFloat.random(in: minimumConnectorOffset...maximumConnectorOffset)

            var destinationPoint = CGPoint(x: currentPoint.x + horizontalOffset, y: verticalOffset)

            // Connector
            let connector = allowCurvedConnectors ? SideViewSpaceShipShape.connectorProbabilities.randomItem() : .line
            switch connector {
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

            // Horizontal Platform
            let minimumHorizontalLength: CGFloat = (0.75 / CGFloat(complexity)) * (size.width - currentPoint.x)
            let maximumHorizontalLength: CGFloat = (0.95 / CGFloat(complexity)) * (size.width - currentPoint.x)

            let length = CGFloat.random(in: minimumHorizontalLength...maximumHorizontalLength)
            let destinationX = (currentPoint.x + length > size.width) ? size.width : currentPoint.x + length
            destinationPoint = CGPoint(x: destinationX, y: currentPoint.y)
            let horizontalPathlet: Pathlet = .line(to: destinationPoint)

            platforms.append(Platform(startPoint: currentPoint, width: length))

            currentPoint = destinationPoint

            pathlets.append(horizontalPathlet)
        }

        // Final connector
        let endPoint = CGPoint(x: size.width, y: 0.0)
        let connector = allowCurvedConnectors ? SideViewSpaceShipShape.connectorProbabilities.randomItem() : .line
        switch connector {
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
