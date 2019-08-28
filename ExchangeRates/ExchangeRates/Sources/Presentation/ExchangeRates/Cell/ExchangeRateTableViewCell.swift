//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

protocol ExchangeRateTableViewCellProtocol: NibLoadable & ViewReusable {
    var rate: CurrencyRate? { get set }
}

class ExchangeRateTableViewCell: UITableViewCell & ExchangeRateTableViewCellProtocol {
    var rate: CurrencyRate? {
        didSet {
            guard let rate = rate else {
                fromCurrency.text = nil
                fromCurrencyName.text = nil
                toCurrency.text = nil
                toCurrencyName.text = nil
                return
            }

            fromCurrency.text = String(format: "1 %@", rate.pair.base.code)
            fromCurrencyName.text = rate.pair.base.name
            toCurrencyName.text = String(format: "%@  %@", rate.pair.counter.name, rate.pair.counter.code)

            if let value = rate.lastRate {
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 4
                formatter.maximumFractionDigits = 4
                guard let string = formatter.string(for: value) else {
                    return
                }
                
                let count = string.count
                let attributed = NSMutableAttributedString(
                        string: String(string.prefix(count - 2)),
                        attributes: [.font: UIFont.applicationFont(20.0)]
                )
                let smallAttributed = NSMutableAttributedString(
                    string: String(string.suffix(2)),
                    attributes: [.font: UIFont.applicationFont(14.0)]
                )
                attributed.append(smallAttributed)
                
                toCurrency.attributedText = attributed
            } else {
                toCurrency.attributedText = nil
            }
        }
    }

    @IBOutlet weak var fromCurrency: UILabel!
    @IBOutlet weak var fromCurrencyName: UILabel!
    @IBOutlet weak var toCurrency: UILabel!
    @IBOutlet weak var toCurrencyName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
    }
}
