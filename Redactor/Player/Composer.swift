import Foundation
import AVFoundation

class Composer {
    
    private(set) var videos = [AVAsset]()
    private(set) var composition = AVMutableComposition()
    
    private lazy var videoTrack = composition.addVideoTrack()
    private lazy var audioTrack = composition.addAudioTrack()
    
    private var totalDuration: CMTime { videos.reduce(.zero) { $0 + $1.duration } }

    func add(_ asset:AVAsset) {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            insertVideo(asset,
                        track: videoTrack!,
                        duration: asset.duration,
                        at: totalDuration)
            
            insertAudio(asset,
                        track: audioTrack!,
                        duration: asset.duration,
                        at: totalDuration)
            
            videos.append(asset)
        }
        
    }
    
    func addAudio(_ asset:AVAsset) {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            composition.removeTrack(audioTrack!)
            guard let audioTrack = composition.addAudioTrack() else { fatalError() }
            
            insertAudio(asset,
                        track: audioTrack,
                        duration: totalDuration,
                        at: .zero)
        }
        
    }
    
    
   
    
    private func insertVideo(_ video:AVAsset,
                        track:AVMutableCompositionTrack,
                        duration:CMTime,
                        at:CMTime) {
        
        try! track.insertTimeRange(CMTimeRangeMake(start: .zero, duration: duration),
                                        of: video.tracks(withMediaType: .video).first!,
                                        at: at)
    }
    
    private func insertAudio(_ audio:AVAsset,
                             track:AVMutableCompositionTrack,
                             duration:CMTime,
                             at:CMTime) {
        
        try! track.insertTimeRange(CMTimeRangeMake(start: .zero, duration: duration),
                                        of: audio.tracks(withMediaType: .audio).first!,
                                        at: at)
    }
}
