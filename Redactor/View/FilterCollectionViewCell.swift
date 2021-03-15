import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    var active = false { didSet { checkmarkView.isHidden = !active }}
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView! { didSet {
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Template")
    }}
    
    @IBOutlet weak var checkmarkView: CheckmarkView! { didSet {
        checkmarkView.isHidden = true
    }}
    
}
