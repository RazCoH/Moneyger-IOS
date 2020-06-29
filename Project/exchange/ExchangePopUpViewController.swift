//
//  ExchangePopUpViewController.swift
//  Project
//
//  Created by raz cohen on 27/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class ExchangePopUpViewController: UIViewController {
    
    var currencies = ["AED", "ARS", "AUD", "BGN", "BRL", "BSD", "CAD", "CHF", "CLP", "CNY", "COP", "CZK", "DKK", "DOP", "EGP", "EUR", "FJD", "GBP", "GTQ", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JPY", "KRW", "KZT", "MXN", "MYR", "NOK", "NZD", "PAB", "PEN", "PHP", "PKR", "PLN", "PYG", "RON", "RUB", "SAR", "SEK", "SGD", "THB", "TRY", "TWD", "UAH", "USD", "UYU", "ZAR"]
    
    
    var delegate:RateDelegate?
    var delegateCur:CurrencyDelegate?
    var rateToMove:Double = 0
    var arr = [Currency.Rate]()
    var chosen:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDarkMode(view: myView, labels: nil)
        confirmUIBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
       makeCircle(button: confirmUIBtn, number: 2)
       myView.layer.masksToBounds = true
       myView.layer.cornerRadius = (myView.frame.height) / 14
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       setDarkMode(view: myView, labels: nil)
        
    }
    
    //MARK: outlets
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var confirmUIBtn: UIButton!
    @IBOutlet weak var myView: UIView!
    //MARK: actions
    
    @IBAction func confirm(_ sender: UIButton) {
        
        // get the user currency:
        let userCurrency = getUserCurr()
        

        //find the rates of the chosen currency - user currency:
        RatesDataSource.shared.getRates(callback: {[weak self] (rates) in
            let arr = rates?.conversionRates
            var rate = 0.0
            for dictionary in arr!{
                if dictionary.name == userCurrency{
                    rate = dictionary.rate
                    break
                }
            }
           
            //pass it with the protocol to the KeyBoardVC
            
            self?.delegate?.getRate(rate: rate)
            
            self?.delegateCur?.getCur(currency: self?.chosen ?? userCurrency)
            
            }, curr: chosen)

        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true)
    }
}

extension ExchangePopUpViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = currencies[row]
        chosen = currency
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = uiLabel(stringArray: currencies, row: row)
        if isItDarkMode(){
            label.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
        }
        return label
    }
}

extension ExchangePopUpViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    

}

extension ExchangePopUpViewController:Disign{}
extension ExchangePopUpViewController:PickerLabel{}
extension ExchangePopUpViewController:ScreenMode{}
