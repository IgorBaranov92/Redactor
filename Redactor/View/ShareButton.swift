import UIKit

@IBDesignable
class ShareButton: UIButton {

    @IBInspectable
    var color: UIColor = .red
    
    @IBInspectable
    var lineWidth: CGFloat = 4
    
    override func draw(_ rect: CGRect) {
        
        let p1 = CGPoint(x: rect.width*0.2, y: rect.height*0.2)
        let p2 = CGPoint(x: rect.width*0.8, y: rect.height*0.5)
        let p3 = CGPoint(x: rect.width*0.2, y: rect.height*0.8)
        
        drawCircleAt(p1)
        drawCircleAt(p2)
        drawCircleAt(p3)

        drawLineBetween(p1: p1, p2: p2)
        drawLineBetween(p1: p2, p2: p3)

    }
    
    
    private func drawCircleAt(_ point: CGPoint) {
        let path = UIBezierPath(arcCenter: point, radius: bounds.width*0.15, startAngle: 0, endAngle: .pi*2, clockwise: false)
        color.setFill()
        path.fill()
    }
    
    private func drawLineBetween(p1:CGPoint,p2:CGPoint) {
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }

}
