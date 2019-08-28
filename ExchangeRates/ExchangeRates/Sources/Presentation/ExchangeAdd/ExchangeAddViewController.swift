//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

protocol ExchangeViewDelegate: class {
    func exchangeDidAdded(firstCurrency: Currency, secondCurrency: Currency)
}

class ExchangeAddViewController: UIViewController {

    var viewModel: ExchangeAddViewModelProtocol?

    weak var delegate: ExchangeViewDelegate?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.title
        tableView.register(ExchangeAddTableViewCell.self)
    }
}

// MARK: 

extension ExchangeAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currencies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExchangeAddTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        guard let viewModel = viewModel else { return cell }
        let currency = viewModel.currencies[indexPath.row]
        cell.currency = currency
        cell.isActive = !viewModel.inactiveCurrencies.contains(currency)
        return cell
    }
}

// MARK: -

extension ExchangeAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard
            let currency = viewModel?.currencies[indexPath.row],
            let viewModel = viewModel
        else {
            return nil
        }

        return viewModel.inactiveCurrencies.contains(currency) ? nil : indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { return }

        let currency = viewModel.currencies[indexPath.row]
        if let from = viewModel.selectedCurrency {
            delegate?.exchangeDidAdded(firstCurrency: from, secondCurrency: currency)
            navigationController?.popToRootViewController(animated: true)
        } else {
            let repository = CurrenciesRepository(fromPath: "currencies", ofType: "json")
            let controller = ExchangeAddViewController()
            controller.delegate = delegate
            controller.viewModel = ExchangeAddViewModel(repository, viewModel.pairs, currency)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
