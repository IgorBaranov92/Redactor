import UIKit

class ErrorAlert {
    
    static func show(in vc: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: "Нельзя добавлять видео/музыка во время просмотра", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        vc.present(alert, animated: true)
    }
    
}
