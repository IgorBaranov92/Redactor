import UIKit

@IBDesignable
class CheckmarkView: UIView {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.width*0.15, y: rect.height*0.5))
        path.addLine(to: CGPoint(x: rect.width*0.35, y: rect.height*0.7))
        path.addLine(to: CGPoint(x: rect.width*0.8, y: rect.height*0.2))
        path.lineWidth = 1
        UIColor.white.setStroke()
        path.stroke()
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
        backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
}
