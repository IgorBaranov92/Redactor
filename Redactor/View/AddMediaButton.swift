import UIKit

@IBDesignable
class AddMediaButton: UIButton {

    @IBInspectable
    var color: UIColor = .blue
    
    @IBInspectable
    var radius: CGFloat = 8
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        color.setFill()
        path.fill()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
    }
    
    
}
