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
    private(set) var gpuImageMovie: GPUImageMovie!
    
    func setupPlayerIn(_ view: UIView) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
        gpuImageView.frame = view.bounds
        view.addSubview(gpuImageView)
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
        completion?(ImageCapture.captureFrom(url))
    }
    
    func applyFilterAt(_ index:Int) {
        Exporter.cleanup()
        Exporter.export(composer.composition)
        
        hasFilter = true

        gpuImageMovie = GPUImageMovie(asset: composer.composition)
        let playerItem = AVPlayerItem(asset: composer.composition)
        player.replaceCurrentItem(with: playerItem)

        gpuImageMovie.playerItem = playerItem
        let filter = Filters.all[index]

        gpuImageMovie.addTarget(filter)
        filter.addTarget(gpuImageView)
        
        gpuImageMovie.playAtActualSpeed = true
        gpuImageMovie.startProcessing()
        player.play()

    }
    
    private func playVideoIfPossible() {
        if hasMusic && hasVideo && hasFilter {
            let playerItem = AVPlayerItem(asset: composer.composition)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    
}

