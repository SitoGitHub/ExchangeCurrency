//
//  Model.swift
//  ExchangeApp
//
//  Created by Dana on 01/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

//структура для View курса валют
struct RateForViewStruct {
    var rates: [RateCurrency: Double]
}

//структура для кошелька struct for account
struct AmountMoney {
    var amount: [Currency: Double] // какой валюты, сколько есть
    var arrayOfCurrencyForScrollView: [Currency] //порядок отображения валют на экране
}





















