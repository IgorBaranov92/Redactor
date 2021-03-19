import Foundation
import AVFoundation
import GPUImage


class Player {
    
    private var hasMusic = false
    private(set) var hasVideo = false
    private var hasFilter = false
    var isPlaying: Bool { hasMusic && hasVideo && hasFilter && player.rate != 0 }
    
    private var player = AVPlayer()
    private lazy var playerLayer = AVPlayerLayer(player: player)
    private(set) var composer = Composer()
    
    private var gpuImageView = GPUImageView()
    private var gpuImageMovie: GPUImageMovie!
    private var filter = Filters.all[0]

    
    func setupPlayerIn(_ view: UIView) {
//        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
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
        composer.addVideo(AVAsset(url: url))
        playVideoIfPossible()
        completion?(ImageCapture.captureFrom(url))
    }
    
    
    func applyFilterAt(_ index:Int) {
        hasFilter = true

        gpuImageMovie = GPUImageMovie(url: Exporter.videoURL!)
        let playerItem = AVPlayerItem(asset: composer.composition)
        player.replaceCurrentItem(with: playerItem)

        gpuImageMovie.playerItem = playerItem
        
        filter = Filters.all[index]
        
        gpuImageMovie.addTarget(filter)
        gpuImageMovie.playAtActualSpeed = false
        filter.addTarget(gpuImageView)
        gpuImageMovie.startProcessing()
        playerLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
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
