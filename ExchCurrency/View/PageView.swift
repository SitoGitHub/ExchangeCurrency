//
//  PageView.swift
//  WalkThroughScreen
//
//  Created by   admin on 04.10.2020.
//  Copyright © 2020 Evgeny Ezub. All rights reserved.
//

import Foundation
import UIKit


// view with text label
class PageView: UIView {
    
    let colorsForView = Colors.self
    let fonts = Fonts.self
    
    var (currencyNameLabel, amountMoneyLabel, minusLabel, rateLabel) = (UILabel(), UILabel(), UILabel(), UILabel())
    let valueForChangeMoneyTextField = UITextField()
    
    let index: Int
    let currency: Currency
    let numberOfPages: Int
    let topScrollViewBool: Bool
    
    init(index: Int, currency: Currency, numberOfPages: Int, topScrollViewBool: Bool) {
        self.index = index
        self.currency = currency
        self.numberOfPages = numberOfPages
        self.topScrollViewBool = topScrollViewBool
        super.init(frame: .zero)
        
        setupCurrencyNameLabel()
        createAmountMoneyLabel()
        setupValueForChangeMoneyTextField()
        setupMinusPlusLabel()
        if !topScrollViewBool{
            setupRateLabel()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //setup currencyNameLabel
    private func setupCurrencyNameLabel() {
        currencyNameLabel.font = fonts.fontTextField.fontsForViews
        currencyNameLabel.textColor = .white
        currencyNameLabel.text = currency.currencyString
        self.addSubview(currencyNameLabel)
        
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            currencyNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    //configure amountMoneyLabel
    private func createAmountMoneyLabel() {
        amountMoneyLabel.font = fonts.fontamountMoneyLabel.fontsForViews
        amountMoneyLabel.textColor = colorsForView.labelColor.colorViewUIColor
        self.addSubview(amountMoneyLabel)
        amountMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountMoneyLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor, constant: 5),
            amountMoneyLabel.leadingAnchor.constraint(equalTo: currencyNameLabel.leadingAnchor)
        ])
    }
    //configure TextView on both scrollViews
    private func setupValueForChangeMoneyTextField(){
        if index == 1, topScrollViewBool{
            valueForChangeMoneyTextField.becomeFirstResponder()
        }
        valueForChangeMoneyTextField.font = fonts.fontTextField.fontsForViews
        valueForChangeMoneyTextField.isUserInteractionEnabled = topScrollViewBool ? true : false
        let colorPlaceHolder = topScrollViewBool ? colorsForView.placeHolderColor.colorViewUIColor : UIColor.white
        valueForChangeMoneyTextField.textColor = .white
        valueForChangeMoneyTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: colorPlaceHolder, NSAttributedString.Key.font: fonts.fontTextField.fontsForViews])
        valueForChangeMoneyTextField.textAlignment = .center
        valueForChangeMoneyTextField.keyboardType = .decimalPad
        self.addSubview(valueForChangeMoneyTextField)
        
        valueForChangeMoneyTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueForChangeMoneyTextField.topAnchor.constraint(equalTo: currencyNameLabel.topAnchor),
            valueForChangeMoneyTextField.centerXAnchor.constraint(equalTo:
                self.trailingAnchor, constant: -90),
            valueForChangeMoneyTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }
    // перед суммой ставим знак минус - "списание", плюс - "зачисление"
    private func setupMinusPlusLabel() {
        
        minusLabel.textColor = .white
        (minusLabel.text, minusLabel.font)  = topScrollViewBool ? ("-", fonts.fontMinusLabel.fontsForViews) : ("+", fonts.fontPlusLabel.fontsForViews)
        self.addSubview(minusLabel)
        minusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minusLabel.centerYAnchor.constraint(equalTo: self.valueForChangeMoneyTextField.centerYAnchor),
            minusLabel.trailingAnchor.constraint(equalTo: self.valueForChangeMoneyTextField.leadingAnchor, constant: -3),
        ])
    }
    
    //configure rateLabel курс для выбранных валют cо значком валюты
    private func setupRateLabel() {
        rateLabel.font = fonts.fontamountMoneyLabel.fontsForViews
        rateLabel.textColor = colorsForView.labelColor.colorViewUIColor
        self.addSubview(rateLabel)
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rateLabel.topAnchor.constraint(equalTo: valueForChangeMoneyTextField.bottomAnchor, constant: 5),
            rateLabel.trailingAnchor.constraint(equalTo: valueForChangeMoneyTextField.trailingAnchor)
        ])
    }
}

