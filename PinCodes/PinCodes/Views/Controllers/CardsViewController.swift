import UIKit

enum PaymentSystem: String, CaseIterable {
    case visa = "Visa.svg"
    case mastercard = "Mastercard.svg"
    case cirrus = "Cirrus.svg"
    case jcb = "JCB.svg"
    case unionPay = "UnionPay.svg"
    case maestro = "Maestro.svg"
    case plus = "PLUS.svg"
}

struct Card {
    var watermark: String
    var number: String
    var color: UIColor
    var monthYear: String
    var paymentSystem: PaymentSystem
}

class CardCell: UITableViewCell {
    
    @IBOutlet weak var watermarkLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var paymentSystemImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var copyButton: UIButton!
    
    private var state: CellState = .front
    
    enum CellState {
        case front, back
    }
    
    func setup(_ card: Card) {
        self.watermarkLabel.text = card.watermark
        self.numberLabel.text = card.number
        self.monthYearLabel.text = card.monthYear
        self.paymentSystemImageView.image = UIImage(named: card.paymentSystem.rawValue)
        self.cardView.backgroundColor = card.color
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor.black.cgColor
        self.cardView.layer.cornerRadius = 10
        self.cardView.layer.shadowColor = UIColor.black.cgColor
        self.cardView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.cardView.layer.shadowRadius = 3
        self.cardView.layer.shadowOpacity = 1.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(switchState))
        self.cardView.addGestureRecognizer(recognizer)
    }
    
    @objc func switchState() {
        let state = self.state
        UIView.transition(with: self.cardView, duration: 1, options: .transitionFlipFromRight, animations: { [weak self] in
            switch state {
            case .front:
                self?.setBack()
            case .back:
                self?.setFront()
            }
        }, completion: nil)
    }
    
    private func setFront() {
        self.cardView.subviews.forEach({ $0.isHidden = false })
        self.state = .front
        self.copyButton.isHidden = true
    }
    
    private func setBack() {
        self.cardView.subviews.forEach({ $0.isHidden = true })
        self.state = .back
        self.copyButton.isHidden = false
    }
    
}

class CardsViewController: UIViewController {
    
    @IBOutlet weak var cardsTableView: UITableView!
    var cards: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemOrange, .systemPurple, .systemBrown, .systemCyan, .systemMint, .systemYellow]
        for _ in 0..<20 {
            self.cards.append(Card(watermark: "Card watermark", number: String(repeating: "7777 ", count: 4), color: colors.randomElement() ?? .purple, monthYear: "77/77", paymentSystem: PaymentSystem.allCases.randomElement() ?? .mastercard))
        }
        self.cardsTableView.dataSource = self
        self.cardsTableView.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension CardsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.setup(self.cards[indexPath.row])
        return cell
    }

}

extension CardsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configuration = UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .normal, title: "", handler: { _, _, _ in
                
            })
        ])
        configuration.actions.first?.backgroundColor = UIColor.lightGray
        configuration.actions.first?.image = UIImage(systemName: "square.and.pencil")
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configuration = UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "", handler: { _, _, _ in
                
            })
        ])
        configuration.actions.first?.image = UIImage(systemName: "trash")
        return configuration
    }
    
}
