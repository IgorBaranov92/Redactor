import UIKit
import MediaPlayer
import AVFoundation
import LinkPresentation

class PlayerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var shareButton: ShareButton!// { didSet { shareButton.isHidden = true }}
    @IBOutlet weak var addVideoButton: AddMediaButton!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var previewImageView: UIImageView! { didSet {
        previewImageView.isHidden = true
        previewImageView.contentMode = .scaleAspectFill
    }}
    
    
    let player = Player()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.setupPlayerIn(playerView)
    }
    
    @IBAction func share(_ sender: ShareButton) {
        Exporter.cleanup()
        Exporter.export(player.composer.composition)
        let url = Exporter.videoURL!
        let items:[Any] = [url]
        
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: nil)
        
        present(activityVC, animated: true)
    }
    
    @IBAction func addMusic(_ sender: AddMediaButton) {
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        picker.showsCloudItems = false
        present(picker, animated: true)
    }

    @IBAction func addVideo(_ sender: AddMediaButton) {
        let imagePC = UIImagePickerController()
        imagePC.delegate = self
        imagePC.sourceType = .savedPhotosAlbum
        imagePC.mediaTypes = ["public.movie"]

        present(imagePC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath)
        if let filterCell = cell as? FilterCollectionViewCell {
            filterCell.label.text = Filters[indexPath.row]
            Filters.handle(filterCell.imageView.image!, at: indexPath.row) { [unowned filterCell] in
                filterCell.imageView.image = $0
            }
            return filterCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        player.applyFilterAt(indexPath.row)
        filtersCollectionView.visibleCells.forEach {
            if let filterCell = $0 as? FilterCollectionViewCell {
                filterCell.active = false
                if let index = filtersCollectionView.indexPath(for: $0) {
                    if index == indexPath {
                        filterCell.active = true
                    }
                }
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (filtersCollectionView.bounds.width - 30)/4, height: heightConstraint.constant)
    }
  
}


extension PlayerViewController: MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        if let mediaItem = mediaItemCollection.representativeItem,
           let url = mediaItem.assetURL {
            player.addAudioAt(url)
        }
        mediaPicker.dismiss(animated: true)
    }
    
}


extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaURL = info[.mediaURL] as? URL {
            playerLabel.isHidden = true
            shareButton.isHidden = false
            player.addVideoAt(mediaURL) {
                self.previewImageView.isHidden = false
                self.previewImageView.image = $0
            }
        }
        picker.dismiss(animated: true)
    }
}
