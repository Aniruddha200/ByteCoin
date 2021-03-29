//  ViewController.swift
//  ByteCoin

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ExchangeRateDelegate{
    

    @IBOutlet weak var coinValueLable: UILabel!
    
    @IBOutlet weak var fiatcurrencyLable: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
     
    var coinManager = CoinManager()
    
    var apihandler: ApiManger?
    
    var fiatName: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        coinValueLable.text = "100"
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fiatName = coinManager.currencyArray[row]
        updateUI(with: fiatName)
    }
    func updateUI(with currency: String){
        fiatcurrencyLable.text = currency
        // Api call
        apihandler = ApiManger(base: coinManager.baseURL, currency: fiatName, key: coinManager.apiKey)
        apihandler?.exchangerDelegate = self
        apihandler?.apiCall()
        
    }
    
    func currentRate(_ apiManager: ApiManger, _ rate: Double) {
        DispatchQueue.main.async{
            self.coinValueLable.text = String(format: "%.2f", rate)
        }
    }
    
}
