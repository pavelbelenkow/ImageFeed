import UIKit

@IBDesignable
final class GradientView: UIView {
    
    @IBInspectable private var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable private var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            CAGradientLayer.self
        }
    }
    
    private func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.locations = [0, 1]
    }
}
