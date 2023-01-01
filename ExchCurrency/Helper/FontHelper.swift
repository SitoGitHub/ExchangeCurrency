//
//  File.swift
//  ExchCurrency
//
//  Created by Dana on 20/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import UIKit

enum Fonts {
    case fontTextField
    case fontFractPArtTextField
    case fontamountMoneyLabel
    case fontMinusLabel
    case fontPlusLabel
    case fontButton
    var fontsForViews: UIFont{
        switch self {
        case .fontTextField:
            return UIFont(name: "PingFang HK", size: 50) ?? UIFont.italicSystemFont(ofSize: 50)
        case .fontFractPArtTextField:
            return UIFont(name: "PingFang HK", size: 37) ?? UIFont.italicSystemFont(ofSize: 37)
        case .fontamountMoneyLabel:
            return UIFont(name: "Helvetica", size: 17) ?? UIFont.italicSystemFont(ofSize: 17)
        case .fontMinusLabel:
        return UIFont(name: "PingFang HK", size: 25) ?? UIFont.italicSystemFont(ofSize: 25)
        case .fontPlusLabel:
            return UIFont(name: "PingFang HK", size: 33) ?? UIFont.italicSystemFont(ofSize: 33)
        case .fontButton:
            return UIFont(name: "Helvetica", size: 20) ?? UIFont.italicSystemFont(ofSize: 20)
            
        }
    }
}
