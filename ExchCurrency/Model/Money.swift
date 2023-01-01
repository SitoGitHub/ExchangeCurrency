//
//  Money.swift
//  ExchCurrency
//
//  Created by Dana on 21/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

enum Currency {
    case USD
    case EUR
    case RUB
    var currencyString: String{
        switch self {
        case .USD: return "USD"
        case .EUR: return "EUR"
        case .RUB: return "RUB"
        }
    }
    var currencySymbol: String{
        switch self {
        case .USD: return "$"
        case .EUR: return "€"
        case .RUB: return "₽"
        }
    }
    
}

enum RateCurrency: String {
    case USDRUB
    case USDEUR
    case EURRUB
    case EURUSD
    case RUBUSD
    case RUBEUR
}
