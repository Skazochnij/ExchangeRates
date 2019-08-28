//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let repository = RatesRepository(CoreDataWorker<PairManagedObject, CurrencyRate>())
        let controller = ExchangeRatesViewController()
        controller.viewModel = ExchangeRatesViewModel(repository)

        let navigation = UINavigationController(rootViewController: controller)

        window?.rootViewController = navigation
        window?.makeKeyAndVisible()

        return true
    }
}
