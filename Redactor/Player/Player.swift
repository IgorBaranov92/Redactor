import Foundation
import AVFoundation
import UIKit
import GPUImage
import AssetsLibrary

class Player {
    
    private var hasMusic = false
    private(set) var hasVideo = false
    private var hasFilter = false
    var isPlaying: Bool { hasMusic && hasVideo && hasFilter }
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
        hasFilter = true

        gpuImageMovie = GPUImageMovie(url: Exporter.videoURL!)
        let playerItem = AVPlayerItem(asset: composer.composition)
        player.replaceCurrentItem(with: playerItem)

        gpuImageMovie.playerItem = playerItem
        
        let filter = Filters.all[index]
        
        gpuImageMovie.asset = composer.composition
        gpuImageMovie.addTarget(filter)
        gpuImageMovie.playAtActualSpeed = false
        filter.addTarget(gpuImageView)
        gpuImageMovie.startProcessing()

        playVideoIfPossible()
    }
    
    private func playVideoIfPossible() {
        if hasMusic && hasVideo && hasFilter {
            player.play()
        }
    }
    
    
}


/*
 private var writer: GPUImageMovieWriter!
 writer = GPUImageMovieWriter(movieURL: Exporter.videoURL!, size: CGSize(width: 640, height: 480))

 filter.addTarget(writer)
  gpuImageMovie.runBenchmark = true

 writer!.shouldPassthroughAudio = true
 gpuImageMovie.audioEncodingTarget = writer
 gpuImageMovie.enableSynchronizedEncoding(using: writer)
 writer!.startRecording()
 writer.completionBlock = { [unowned writer,weak self] in
     filter.removeTarget(writer!)
     writer!.finishRecording()
     self?.gpuImageMovie.cancelProcessing()
 }
 */
