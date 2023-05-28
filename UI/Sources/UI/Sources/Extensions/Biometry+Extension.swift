import Core
import UIKit

public extension Biometry {
    var image: UIImage {
        switch self {
        case .touchID: return Asset.touchID.image
        case .faceID: return Asset.faceID.image
        case .none: return UIImage()
        }
    }
}
