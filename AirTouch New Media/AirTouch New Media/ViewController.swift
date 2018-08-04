//
//  ViewController.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 02/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import Alamofire
import SVProgressHUD
import UIKit

class ViewController: UIViewController {

    private var productList: [String] = []
    private var transactions: [ProductData] = []
    private var transactionsToDisplay: [ProductData] = []
    private var conversions: [ConversionData] = []

    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var productPickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        GetService.shared.getConversionJSONs { [weak self] success, conversionDataArray in
            dispatchGroup.leave()
            if success {
                guard let conversionDataArray = conversionDataArray else {
                    self?.showError(withMessage: "Corrupted conversion values")
                    return
                }
                self?.conversions = conversionDataArray.compactMap { ConversionData(rawData: $0) }
                print("YAY")
            } else {
                print("NAY")
            }
        }

        dispatchGroup.enter()
        GetService.shared.getTransationJSONs { [weak self] (success, transactionDataArray) in
            dispatchGroup.leave()
            if success {
                guard let transactionDataArray = transactionDataArray else {
                    self?.showError(withMessage: "Corrupted transactions values")
                    return
                }
                self?.transactions = transactionDataArray.compactMap { ProductData(rawData: $0) }
                self?.productList = transactionDataArray.map { $0.sku }
                self?.productList.removeDuplicates()
            } else {
                print("NONO")
            }
        }

        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
            self.productPickerView.selectRow(0, inComponent: 0, animated: false)
            self.productPickerView.delegate?.pickerView!(self.productPickerView, didSelectRow: 0, inComponent: 0)
            self.productPickerView.reloadComponent(0)
            ConversionCalculator.createConversionsToEur(fromExistingConversions: self.conversions) { [weak self] (newConversions) in
                if let newConversions = newConversions {
                    print(newConversions)
                } else {
                    self?.showError(withMessage: "Could not get new conversions to EUR")
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func showError(withMessage message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return productList[row]
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return productList.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        transactionsToDisplay = transactions.filter { $0.sku == productList[row] }
        transactionsTableView.reloadData()
        totalValueLabel.text = "Calculating..."
        ConversionCalculator.addValues(forTransactions: transactionsToDisplay,
                                       withConversions: conversions) { [weak self] sum in
                                        DispatchQueue.main.async {
                                            if let sum = sum {
                                                if let doubleValue = Double(sum.description) {
                                                    let roundedValue = (doubleValue * 100).rounded(.toNearestOrEven) / 100
                                                    self?.totalValueLabel.text = String(describing: roundedValue)
                                                }
                                            } else {
                                                self?.totalValueLabel.text = "Error while calculating total"
                                            }
                                        }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsToDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else {
            return UITableViewCell()
        }
        cell.configure(withTransaction: transactionsToDisplay[indexPath.row], andIndex: indexPath.row + 1)
        return cell
    }

}

