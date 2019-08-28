//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

class ExchangeRatesViewController: UIViewController {
    var viewModel: ExchangeRatesViewModelProtocol?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCurrencyView: UIView!
    @IBOutlet weak var addCurrencyButton: OrientationalButton!
    @IBOutlet weak var addCurrencyLabel: UILabel!

    var lastConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Rates"
        tableView.register(ExchangeRateTableViewCell.self)

        viewModel?.delegate = self
        if viewModel?.rates.isEmpty ?? true {
            moveToBottom(false)
        }
    }

    @IBAction func pairAddTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }

        let repository = CurrenciesRepository(fromPath: "currencies", ofType: "json")
        let controller = ExchangeAddViewController()
        controller.viewModel = ExchangeAddViewModel(repository, viewModel.rates.map { $0.pair })
        controller.delegate = self

        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExchangeRatesViewController: ExchangeRatesProtocol {
    func pairDidAdded() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.tableView.endUpdates()

            if self.viewModel?.rates.count == 1 {
                self.moveToTop()
            }
        }
    }

    func pairDidRemoved(at index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? ExchangeRateTableViewCell {
                cell.rate = nil
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)

            if self.viewModel?.rates.count == 0 {
                self.moveToBottom()
            }
        }
    }

    func ratesDidUpdated(_ rates: [String: Decimal]) {
        DispatchQueue.main.async {
            guard let cells = self.tableView.visibleCells as? [ExchangeRateTableViewCell] else {
                return
            }
            for cell in cells {
                if let rate = cell.rate {
                    let key = "\(rate.pair.base.code)\(rate.pair.counter.code)"
                    let pair = Pair(base: rate.pair.base, counter: rate.pair.counter)
                    cell.rate = CurrencyRate(pair: pair, lastRate: rates[key])
                }
            }
        }
    }

    private func moveToTop(_ animate: Bool = true) {
        addCurrencyLabel.isHidden = true
        addCurrencyButton.isVertical = false
        lastConstraint?.isActive = false
        lastConstraint = addCurrencyView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        lastConstraint?.isActive = true
        updateLayout(animate)
    }

    private func moveToBottom(_ animate: Bool = true) {
        addCurrencyLabel.isHidden = false
        addCurrencyButton.isVertical = true
        lastConstraint?.isActive = false
        lastConstraint = addCurrencyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        lastConstraint?.isActive = true
        updateLayout(animate)
    }

    private func updateLayout(_ animate: Bool) {
        if animate {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }
}

extension ExchangeRatesViewController: ExchangeViewDelegate {
    func exchangeDidAdded(firstCurrency: Currency, secondCurrency: Currency) {
        viewModel?.addPair(firstCurrency, secondCurrency)
    }
}

// MARK: 

extension ExchangeRatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rates.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExchangeRateTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.rate = viewModel?.rates[indexPath.row]
        return cell
    }
}

// MARK: -

extension ExchangeRatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.removePair(at: indexPath.row)
        }
    }
}
