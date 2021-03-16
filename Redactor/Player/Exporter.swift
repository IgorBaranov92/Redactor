import Foundation
import AVFoundation

class Exporter {
    
    static func export(_ asset:AVAsset,completion: ( () -> () )? = nil ) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            cleanup()

            guard let videoURL = videoURL else { fatalError() }
            try? FileManager.default.removeItem(at: videoURL)
            
            if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset640x480) {
                exporter.outputURL = videoURL
                exporter.outputFileType = .mp4
                exporter.exportAsynchronously { completion?() }
            }
        }
        
    }

    static var videoURL: URL? {
        FileManager.default
                .urls(for: .documentDirectory, in:.userDomainMask)
                .first?.appendingPathComponent("newVideo.mp4")
    }
    
  
    static func cleanup() {
        if let videoURL = Exporter.videoURL {
            try? FileManager.default.removeItem(at: videoURL)
        }

    }
    
}
