import Foundation
import AVFoundation
import UIKit
import GPUImage

class Player {
    
    private var hasMusic = false
    private(set) var hasVideo = false
    private var hasFilter = false
    
    private var player = AVPlayer()
    private(set) var composer = Composer()
    
    private var gpuImageView = GPUImageView()
    private var gpuImageMovie: GPUImageMovie!
    
    func setupPlayerIn(_ view: UIView) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
//        gpuImageView.frame = view.bounds
//        view.addSubview(gpuImageView)
    }
    
    
    func addAudioAt(_ url:URL) {
        hasMusic = true
        composer.addAudio(AVAsset(url: url))
        playVideoIfPossible()
    }
    
    func addVideoAt(_ url:URL,_ completion: ( (UIImage?) -> Void )? = nil) {
        hasVideo = true
        composer.add(AVAsset(url: url))
        playVideoIfPossible()
        let asset = AVAsset(url: url)
        let imageGen = AVAssetImageGenerator(asset: asset)
        let image = try? UIImage(cgImage: imageGen.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))

        completion?(image)
    }
    
    func applyFilterAt(_ index:Int) {
//        Exporter.cleanup()
//        Exporter.export(composer.composition)
        hasFilter = true
//
//        gpuImageMovie = GPUImageMovie(url: Exporter.videoURL!)
//        let playerItem = AVPlayerItem(asset: composer.composition)
//        gpuImageMovie.playerItem = playerItem
//        let filter = GPUImageGammaFilter()
//        filter.gamma = 1.7
//        gpuImageMovie.addTarget(filter)
//        gpuImageMovie.playAtActualSpeed = true
//        filter.addTarget(gpuImageView)
//        gpuImageMovie.startProcessing()
//

        playVideoIfPossible()
    }
    
    private func playVideoIfPossible() {
        if hasMusic && hasVideo && hasFilter {
            let playerItem = AVPlayerItem(asset: composer.composition)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    
}

