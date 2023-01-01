//
//  ViewModelDelegate.swift
//  ExchangeApp
//
//  Created by Dana on 01/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    
    var amountMoney: AmountMoney {get set}
    var topIndex: Int {get set}
    var middleIndex: Int {get set}
    var rateDataViewModelToController : ((Int) -> Void)? {get set}
   
    func callFuncToGetRateData()
    func configureRateString(completion : @escaping (String) -> ())
    func textFieldIsChanged(amountForConvesation: String, completion : @escaping (Bool, Bool, NSMutableAttributedString) -> ())
    func exchangeMoney(amountForConvesation: String, amountExchenged: String,  completion : @escaping (String, String, Bool) -> ())
    func configureAmountString(currency: Currency, completion : @escaping (String) -> ())
    func cancelLastExch(completion : @escaping (String, String, Bool) -> ())
}
