//  Created by B.T. Franklin on 1/4/21.

import CoreGraphics
import DunesailerUtilities
import Aesthete

public struct SideViewSpaceShipShape: Codable {

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

    public struct Platform: Codable {
        public let startPoint: CGPoint
        public let width: CGFloat

        init(startPoint: CGPoint, width: CGFloat) {
            self.startPoint = startPoint
            self.width = width
        }
    }

    public let topEdgePath: CompositePath
    public let topPlatforms: [Platform]
    public let bottomEdgePath: CompositePath
    public let bottomPlatforms: [Platform]
    public let path: CompositePath
    public let xUnits: CGFloat
    public let yUnits: CGFloat

    public init(xUnits: CGFloat = 1,
                yUnits: CGFloat = 1,
                complexity: Int) {

        guard complexity > 0 else {
            fatalError("complexity must be greater than 0")
        }

        self.xUnits = xUnits
        self.yUnits = yUnits

        var topPlatforms = [Platform]()
        topEdgePath = SideViewSpaceShipShape.design(.top, xUnits: xUnits, yUnits: yUnits, complexity: complexity, platforms: &topPlatforms)
        self.topPlatforms = topPlatforms

        var bottomPlatforms = [Platform]()
        bottomEdgePath = SideViewSpaceShipShape.design(.bottom, xUnits: xUnits, yUnits: yUnits, complexity: complexity, platforms: &bottomPlatforms)
        self.bottomPlatforms = bottomPlatforms

        path = CompositePath(pathlets: topEdgePath.pathlets + [.move(to: .zero)] + bottomEdgePath.pathlets)
    }

    static private func design(_ edge: EdgeType,
                               xUnits: CGFloat,
                               yUnits: CGFloat,
                               complexity: Int,
                               platforms: inout [Platform]) -> CompositePath {

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

            // Horizontal Platform
            let minimumHorizontalLength: CGFloat = (0.75 / CGFloat(complexity)) * (xUnits - currentPoint.x)
            let maximumHorizontalLength: CGFloat = (0.95 / CGFloat(complexity)) * (xUnits - currentPoint.x)

            let length = CGFloat.random(in: minimumHorizontalLength...maximumHorizontalLength)
            let destinationX = (currentPoint.x + length > xUnits) ? xUnits : currentPoint.x + length
            destinationPoint = CGPoint(x: destinationX, y: currentPoint.y)
            let horizontalPathlet: Pathlet = .line(to: destinationPoint)

            platforms.append(Platform(startPoint: currentPoint, width: length))

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
