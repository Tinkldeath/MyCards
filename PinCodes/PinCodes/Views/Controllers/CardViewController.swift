import UIKit

class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTouch))
        self.view.addGestureRecognizer(recognizer)
    }

    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTouch(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
