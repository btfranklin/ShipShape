//  Created by B.T. Franklin on 1/4/21.

import CoreGraphics
import ControlledChaos
import Aesthete

public struct SideViewSpaceShipShape: Codable {

    enum ConnectorType: String, Codable {
        case line
        case convexCurve
        case concaveCurve
    }

    enum EdgeType {
        case top
        case bottom
    }

    static let connectorProbabilities = ProbabilityGroup<ConnectorType>([
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
    public let size: CGSize
    public let purpose: SpaceShipPurpose
    public let augmentationPaths: [CompositePath]

    public init(size: CGSize = .init(width: 1.0, height: 1.0),
                complexity: Int,
                purpose: SpaceShipPurpose? = nil,
                allowCurvedConnectors: Bool = true) {

        guard complexity > 0 else {
            fatalError("complexity must be greater than 0")
        }
        self.size = size

        self.purpose = purpose ?? SpaceShipPurpose.allCases.randomElement()!

        var topPlatforms: [Platform] = []
        self.topEdgePath = SideViewSpaceShipShape.designVerticalHalf(.top,
                                                                     size: size,
                                                                     complexity: complexity,
                                                                     allowCurvedConnectors: allowCurvedConnectors,
                                                                     platforms: &topPlatforms)
        self.topPlatforms = topPlatforms

        var bottomPlatforms: [Platform] = []
        self.bottomEdgePath = SideViewSpaceShipShape.designVerticalHalf(.bottom,
                                                                        size: size,
                                                                        complexity: complexity,
                                                                        allowCurvedConnectors: allowCurvedConnectors,
                                                                        platforms: &bottomPlatforms)
        self.bottomPlatforms = bottomPlatforms

        self.path = CompositePath(pathlets: topEdgePath.pathlets + [.move(to: .zero)] + bottomEdgePath.pathlets)

        self.augmentationPaths = SideViewSpaceShipShape.designAugmentations(to: self.path,
                                                                            complexity: complexity)
    }

}
