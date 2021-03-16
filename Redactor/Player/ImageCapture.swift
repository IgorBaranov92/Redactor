import UIKit
import AVFoundation

class ImageCapture {
    
    static func captureFrom(_ url:URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGen = AVAssetImageGenerator(asset: asset)
        let image = try? UIImage(cgImage: imageGen.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
        return image

    }
    
}
