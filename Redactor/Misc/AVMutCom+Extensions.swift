import AVFoundation

extension AVMutableComposition {
    
    func addVideoTrack() -> AVMutableCompositionTrack? {
        return self.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
    }
    func addAudioTrack() -> AVMutableCompositionTrack? {
        return self.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
    }
}
