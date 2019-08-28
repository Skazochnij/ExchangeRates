//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

protocol ExchangeAddTableViewCellProtocol: NibLoadable & ViewReusable {
    var isActive: Bool { get set }
    var currency: Currency? { get set }
}

class ExchangeAddTableViewCell: UITableViewCell & ExchangeAddTableViewCellProtocol {
    var currency: Currency? {
        didSet {
            guard let currency = currency else {
                code.text = nil
                name.text = nil
                flag.image = nil
                return
            }

            code.text = currency.code
            name.text = currency.name
            flag.image = UIImage(named: currency.code)
        }
    }

    var isActive: Bool = true {
        didSet {
            name.textColor = isActive ? UIColor.shark : UIColor.regentGray
            selectionStyle = isActive ? .blue : .none
        }
    }

    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
    }
}
