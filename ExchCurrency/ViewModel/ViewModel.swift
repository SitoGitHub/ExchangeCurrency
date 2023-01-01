//
//  ViewModel.swift
//  ExchangeApp
//
//  Created by Dana on 01/11/2022.
//  Copyright © 2022 Sito. All rights reserved.

import Foundation

final class ViewModel: ViewModelDelegate {
    
    var topIndex = 0, middleIndex = 0
    
    lazy var amountMoney = AmountMoney(amount: [.EUR : 100, .RUB : 100, .USD : 100], arrayOfCurrencyForScrollView: [.EUR, .RUB, .USD, .EUR, .RUB])
    lazy var incrementUpdateRate = 0
    
    var rateForViewData: RateForViewStruct?{
        didSet{
            incrementUpdateRate += 1
            rateDataViewModelToController?(incrementUpdateRate)
        }
    }
    
    var rateString: String?
    
    var timer: Timer?
    
    // save value for canceling last Exchange
    var tempAmountMoneyTop: Double?
    var tempAmountMoneyMiddle: Double?
    
    var apiService: APIServiceProtocol
    
    var rateDataViewModelToController: ((Int) -> Void)?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //call function for get rates from API and repeat it every 5 min
    func callFuncToGetRateData() {
        refreshJsonRateData()
       
        self.timer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true, block: { (timer) in
            self.refreshJsonRateData()})
    }
    
    //get rates from api with Generic method and save it in structure
    func refreshJsonRateData() {
        apiService.fetchData(urlString: "https://www.cbr-xml-daily.ru/daily_json.js") { (result : Result<WebSiteDecodable,Error>) in
            switch result {
            case .success(let rateDataParsing):
                var rateData: RateForViewStruct = RateForViewStruct(rates: [:])
                if let rateRUBEURData = rateDataParsing.valute["EUR"]?.value{
                    rateData.rates[.RUBEUR] = rateRUBEURData
                    rateData.rates[.EURRUB] = 1/rateRUBEURData
                }
                if let rateRUBUSDData = rateDataParsing.valute["USD"]?.value{
                    rateData.rates[.RUBUSD] = rateRUBUSDData
                    rateData.rates[.USDRUB] = 1/rateRUBUSDData
                }
                if let rateRUBEURData = rateDataParsing.valute["EUR"]?.value, let rateRUBUSDData = rateDataParsing.valute["USD"]?.value{
                    rateData.rates[.EURUSD] = rateRUBUSDData/rateRUBEURData
                    rateData.rates[.USDEUR] = rateRUBEURData/rateRUBUSDData
                }
                
                self.rateForViewData = rateData
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //configure string with rate for middle scrollView
    func configureRateString(completion : (String) -> ()){
        var rateString = String()
        let rate = getRate()
        let currencyMiddle = self.amountMoney.arrayOfCurrencyForScrollView[self.middleIndex]
        let currencyTop = self.amountMoney.arrayOfCurrencyForScrollView[self.topIndex]
        if currencyTop == .RUB{
            rateString = String(format: "\(currencyMiddle.currencySymbol)1 = %.03f ₽", rate)
        } else{
            if currencyMiddle == .RUB{
                rateString = String(format: "1₽ = \(currencyTop.currencySymbol)%.03f", rate)
            } else {
                rateString = String(format: "\(currencyMiddle.currencySymbol)1 = \(currencyTop.currencySymbol)%.03f", rate)
            }
        }
        completion(rateString)
    }
    
    //формируем сумму со значком валюты
    fileprivate func setAmountString(_ currency: Currency) -> String {
        var amountString = String()
        switch currency {
        case .EUR:
            if let value = amountMoney.amount[currency]{
                amountString = String(format: "You have €%.02f", value)
            }
        case .USD:
            if let value = amountMoney.amount[currency]{
                amountString = String(format: "You have $%.02f", value)
            }
        case .RUB:
            if let value = amountMoney.amount[currency]{
                amountString = String(format: "You have %.02f ₽", value)
            }
        }
        return amountString
    }
    //send to view amount with currency symbol сумму со значком валюты
    func configureAmountString(currency: Currency, completion : (String) -> ()){
        let amountString = setAmountString(currency)
        completion(amountString)
    }
    
    //cancel a last Exchange operation
    func cancelLastExch(completion : (String, String, Bool) -> ()){
        var amountTopString = String()
        var amountMiddleString = String()
        let currencyMiddle = self.amountMoney.arrayOfCurrencyForScrollView[self.middleIndex]
        let currencyTop = self.amountMoney.arrayOfCurrencyForScrollView[self.topIndex]
        var isSuccess = false
        //восстанавливаем данные, записанные во временные переменные
        if let _ = amountMoney.amount[currencyTop], let tempAmountMoneyTop = tempAmountMoneyTop  {
            amountMoney.amount[currencyTop] = tempAmountMoneyTop
            isSuccess = true
        }
        if let _ = amountMoney.amount[currencyMiddle], let tempAmountMoneyMiddle = tempAmountMoneyMiddle  {
            amountMoney.amount[currencyMiddle] = tempAmountMoneyMiddle
        } else {
            isSuccess = false
        }
        //формируем строки для view и отправляем
            amountTopString = setAmountString(currencyTop)
            amountMiddleString = setAmountString(currencyMiddle)
            completion(amountTopString, amountMiddleString, isSuccess)
    }
    
    //work when text of textField have been changed
    func textFieldIsChanged(amountForConvesation: String, completion : (Bool, Bool, NSMutableAttributedString) -> ()){
        var amountForConvesationDouble: Double?
        var isAvailableChangeAmountLabel = Bool()
        var isAvailableChangeExchangeButton = Bool()
        var convertedAmountForTextView = 0.0
        var myAttributedString = NSMutableAttributedString()
        let currencyTop = self.amountMoney.arrayOfCurrencyForScrollView[self.topIndex]
        var rate = Double()
        if let amountForConvesation = Double(amountForConvesation){
            amountForConvesationDouble = amountForConvesation
        }
        //get rate for exchange operation
        rate = getRate()
        if let amountForConvesation = amountForConvesationDouble, rate != 0, amountForConvesation > 0 {
            convertedAmountForTextView = amountForConvesation * 1/rate
            //configure string  will have been converted amount for middle scrollView
            let convertedAmounted = String(format: "%.02f", convertedAmountForTextView)
            let index = convertedAmounted.firstIndex(of: ".") ?? convertedAmounted.endIndex
            myAttributedString = NSMutableAttributedString(string: convertedAmounted)
            let wholePartCovertedAmount = convertedAmounted.prefix(upTo: index)
            let fractPartCovertedAmount = convertedAmounted.suffix(from: index)
            myAttributedString.addAttribute(.font, value: Fonts.fontTextField.fontsForViews,
                range: NSRange (location:0,length: wholePartCovertedAmount.count))
            myAttributedString.addAttribute(.font, value: Fonts.fontFractPArtTextField.fontsForViews,
                range: NSRange (location: wholePartCovertedAmount.count,length: fractPartCovertedAmount.count))
            //get flags for configurating view's alements after textfield have changed
            if let amount = amountMoney.amount[currencyTop], let amountForConvesation = amountForConvesationDouble {
                isAvailableChangeAmountLabel = (amount >= amountForConvesation)
                isAvailableChangeExchangeButton = isAvailableChangeAmountLabel
            }
            if  (amountForConvesationDouble == nil) {
                isAvailableChangeAmountLabel = true
            }
            if rate == 0 {
                isAvailableChangeExchangeButton = false
            }
        } else {
            myAttributedString = NSMutableAttributedString(string: "0")
            myAttributedString.addAttribute(
                .font,
                value: Fonts.fontTextField.fontsForViews,
                range: NSRange (location:0,length: 1))
            isAvailableChangeExchangeButton = false
            isAvailableChangeAmountLabel = true
        }
        completion(isAvailableChangeAmountLabel, isAvailableChangeExchangeButton, myAttributedString)
    }
    //get rates from saved structure
    func getRate() -> Double{
        let currencyMiddle = self.amountMoney.arrayOfCurrencyForScrollView[self.middleIndex]
        let currencyTop = self.amountMoney.arrayOfCurrencyForScrollView[self.topIndex]
        var rate = Double()
        
        switch (currencyMiddle, currencyTop) {
        case (.USD, .RUB):
            if let value = self.rateForViewData?.rates[.RUBUSD]{
                rate = value
            }
        case (.USD, .EUR):
            if let value = self.rateForViewData?.rates[.EURUSD]{
                rate = value
            }
        case (.EUR, .RUB):
            if let value = self.rateForViewData?.rates[.RUBEUR]{
                rate = value
            }
        case (.EUR, .USD):
            if let value = rateForViewData?.rates[.USDEUR]{
                rate = value
            }
        case (.RUB, .USD):
            if let value = rateForViewData?.rates[.USDRUB]{
                rate = value
            }
        case (.RUB, .EUR):
            if let value = rateForViewData?.rates[.EURRUB]{
                rate = value
            }
        default:
            rate = 0
        }
        return rate
    }
    
    //exchange amount when button have been pressed
    func exchangeMoney(amountForConvesation: String, amountExchenged: String,  completion : (String, String, Bool) -> ()){
        var amountForConvesationDouble: Double?
        var amountExchengedDouble: Double?
        
        var amountTopString = String()
        var amountMiddleString = String()
        
        let currencyMiddle = self.amountMoney.arrayOfCurrencyForScrollView[self.middleIndex]
        let currencyTop = self.amountMoney.arrayOfCurrencyForScrollView[self.topIndex]
        var isSuccess = false
        
        if let amountForConvesation = Double(amountForConvesation){
            amountForConvesationDouble = amountForConvesation
        }
        if let amountExchenged = Double(amountExchenged){
            amountExchengedDouble = amountExchenged
        }
        if var amount = amountMoney.amount[currencyTop], let amountForExch = amountForConvesationDouble{
            tempAmountMoneyTop = amount
            amount -= amountForExch
            amountMoney.amount[currencyTop] = amount
            isSuccess = true
        }
        if var amount = amountMoney.amount[currencyMiddle], let amountExch = amountExchengedDouble, isSuccess{
            tempAmountMoneyMiddle = amount
            amount += amountExch
            amountMoney.amount[currencyMiddle] = amount
        } else {
            isSuccess = false
        }
        if isSuccess{
            amountTopString = setAmountString(currencyTop)
            amountMiddleString = setAmountString(currencyMiddle)
            completion(amountTopString, amountMiddleString, isSuccess)
        } else{
            amountMoney.amount[currencyTop] = tempAmountMoneyTop
            amountMoney.amount[currencyMiddle] = tempAmountMoneyTop
        }
    }
}














