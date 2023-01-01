//
//  ViewController.swift
//  ExchangeApp
//
//  Created by Dana on 01/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
   
    var viewModel: ViewModelDelegate
    
    let fontsForView = Fonts.self
    let colorsForView = Colors.self
    
    let topView = UIView()
    let middleView = UIView()
       
    let exchangeButton = UIButton()
    let cancelButton = UIButton()
    
    lazy var topPageViews: [PageView]  = []
    lazy var middlePageViews: [PageView]  = []
    
    let topPageControl = UIPageControl()
    let middlePageControl = UIPageControl()
    
    lazy var numberOfPages = Int()
      
    let topScrollView = UIScrollView()
    let middleScrollView = UIScrollView()
    
    var incrementUpdateRate: Int?{
        didSet{
            updateRateLabel()
        }
    }
    
    lazy var indexTopScrollView = Int()
    lazy var indexMiddleScrollView = Int()
    
    var textOfTextField: String?

    init() {
        self.viewModel = ViewModel(apiService: APIService())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTopView()
        createMiddleView()
        createExchangeButton()
        createCancelButton()
        createPageControl(pageControl: topPageControl, view: topView)
        createPageControl(pageControl: middlePageControl, view: middleView)
        createScrollView(view: topView, scrollView: topScrollView, topAnchor: exchangeButton.bottomAnchor, bottomAnchor: topPageControl.topAnchor, topAnchorOffset: 10)
        createScrollView(view: middleView, scrollView: middleScrollView, topAnchor: topView.bottomAnchor, bottomAnchor: middlePageControl.topAnchor, topAnchorOffset: 0)
        configureScrollView(scrollView: topScrollView)
        configureScrollView(scrollView: middleScrollView)
        callToViewModelForUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //начинаем показ со второго экрана
        setStartCasePagesScrollViews()
        
    }
    
    //MARK: - Связь с ViewModel
    private func callToViewModelForUpdate(){
        viewModel.callFuncToGetRateData()
        self.viewModel.rateDataViewModelToController = { [weak self] incrementUpdateRate in
            self?.incrementUpdateRate = incrementUpdateRate
        }
    }
    
    // MARK: - Adding View
    // верхняя вьюшка
    private func createTopView() {
        topView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height*0.39)
        addTopViewLayerGradient()
        self.view.addSubview(topView)
    }
    
    //средняя вьюшка
    private func createMiddleView() {
        middleView.frame = CGRect(x: 0, y: topView.frame.maxY, width: view.bounds.width, height: topView.bounds.height*0.73)
        addMiddleViewLayerGradient()
        self.view.addSubview(middleView)
    }
    
    // create Button for Cancel of last Exchange
    private func createCancelButton(){
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(self.colorsForView.bottomColorTopView.colorViewUIColor, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = fontsForView.fontButton.fontsForViews
        cancelButton.isEnabled = false
        cancelButton.addTarget(self, action: #selector(cancelLastExchButton), for: .touchUpInside)
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: +30),
            cancelButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 7),
            cancelButton.heightAnchor.constraint(equalToConstant: 22),
            cancelButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    //создаем кнопку обмена валюты
    private func createExchangeButton(){
        exchangeButton.layer.masksToBounds = true
        exchangeButton.setTitle("Exchange", for: .normal)
        exchangeButton.setTitleColor(self.colorsForView.bottomColorTopView.colorViewUIColor, for: .normal)
        exchangeButton.backgroundColor = .clear
        exchangeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        exchangeButton.isEnabled = false
        exchangeButton.addTarget(self, action: #selector(exchangeMoneyButton), for: .touchUpInside)
        view.addSubview(exchangeButton)
        
        exchangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exchangeButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: +30),
            exchangeButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -7),
            exchangeButton.heightAnchor.constraint(equalToConstant: 22),
            exchangeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    //configure PageControl and add to top view
    private func createPageControl(pageControl: UIPageControl, view: UIView) {
        numberOfPages = viewModel.amountMoney.arrayOfCurrencyForScrollView.count
        pageControl.numberOfPages = numberOfPages - 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.2110153437, green: 0.6377091408, blue: 0.924474299, alpha: 1)
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    // func for both top and middle ScrollViews with creation views on it
    private func createScrollView(view: UIView, scrollView: UIScrollView, topAnchor: NSLayoutYAxisAnchor, bottomAnchor: NSLayoutYAxisAnchor, topAnchorOffset: CGFloat) {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: topAnchorOffset),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureScrollView(scrollView: UIScrollView) {
        let contentViewOfScrollView: UIView = UIView()
        var pageViews: [PageView] = []
        let topScrollViewBool: Bool
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        topScrollViewBool = scrollView == topScrollView ? true : false
        scrollView.addSubview(contentViewOfScrollView)
        
        //создаем contentview по размеру всех pageview
        contentViewOfScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentViewOfScrollView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentViewOfScrollView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentViewOfScrollView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentViewOfScrollView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
        ])
        NSLayoutConstraint.activate([
            contentViewOfScrollView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor), //без центра уплывет
            contentViewOfScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(numberOfPages)),
        ])
        
        //populate our ScrollView with views
        for (index, currency) in viewModel.amountMoney.arrayOfCurrencyForScrollView.enumerated() {
            let pageView = PageView(index: index, currency: currency, numberOfPages: numberOfPages, topScrollViewBool: topScrollViewBool)
            //set text of amountMoneyLabel
            viewModel.configureAmountString(currency: currency) { (amountString) in
                let amountInfoString = amountString
                pageView.amountMoneyLabel.text = amountInfoString
            }
            
            contentViewOfScrollView.addSubview(pageView)
            //ширина одной pageView - 1 часть от ширины contentView
            let pageWidthMultiplier = CGFloat(1) / CGFloat(numberOfPages)
            
            pageView.translatesAutoresizingMaskIntoConstraints = false
            //выстраиваем pageView друг за другом
            let leadingAnchor = (index == 0) ? (pageView.leadingAnchor.constraint(equalTo: contentViewOfScrollView.leadingAnchor)) : (pageView.leadingAnchor.constraint(equalTo: pageViews[index - 1].trailingAnchor))
            
            NSLayoutConstraint.activate([
                pageView.topAnchor.constraint(equalTo: contentViewOfScrollView.topAnchor),
                pageView.bottomAnchor.constraint(equalTo: contentViewOfScrollView.bottomAnchor),
                pageView.widthAnchor.constraint(equalTo: contentViewOfScrollView.widthAnchor, multiplier: pageWidthMultiplier),
                leadingAnchor
            ])
            //configure text for TextField
            pageView.valueForChangeMoneyTextField.addTarget(self, action: #selector(changingTextField), for: .editingChanged)
            pageViews.append(pageView)
        }
        switch scrollView {
        case topScrollView:
            topPageViews = pageViews
        case middleScrollView:
            middlePageViews = pageViews
        default: break
        }
    }
    
    func updateRateLabel(){
        self.viewModel.configureRateString(completion: { (rateString) in
            DispatchQueue.main.async {
                self.middlePageViews[self.indexMiddleScrollView].rateLabel.text = rateString
            }
        })
    }
    
    //configure initial data for places views in a scrolleview
    private func setStartCasePagesScrollViews(){
        //устанавливаем pages верхний - второй, нижний - третий
        topScrollView.contentOffset.x = topScrollView.frame.width
        middleScrollView.contentOffset.x = middleScrollView.frame.width * 2
        middlePageControl.currentPage = Int(middleScrollView.contentOffset.x/middleScrollView.frame.width) - 1
        //определяем индексы валюты и отправляем во viewModel для последующего формирования строки с курсом валюты
        indexTopScrollView = getIndexPage(contentOffSetscrollView: topScrollView.contentOffset)
        indexMiddleScrollView = getIndexPage(contentOffSetscrollView: middleScrollView.contentOffset)
        viewModel.topIndex = indexTopScrollView
        viewModel.middleIndex = indexMiddleScrollView
        updateRateLabel()
    }
    
    private func setRateString(indexTopScrollView: Int, indexMiddleScrollView: Int){
        viewModel.topIndex = indexTopScrollView
        viewModel.middleIndex = indexMiddleScrollView
        // запрашиваем во viewModel строку с курсом для нижнего scrollView
        self.viewModel.configureRateString(completion: { (rateString) in
            self.middlePageViews[indexMiddleScrollView].rateLabel.text = rateString
        })
    }
    // get current pages index
    private func getIndexPage(contentOffSetscrollView: CGPoint) -> Int{
        let offset = contentOffSetscrollView
        let widthPage = topView.frame.width
        let index = Int(offset.x/widthPage)
        return index
    }
    
    //editing text of textField (Amount for Exchange)
    @objc  func changingTextField(){
        getNewValueForTextFields()
    }
    //new setttings for view elements
    func getNewValueForTextFields() {
        guard let amountForConv = topPageViews[indexTopScrollView].valueForChangeMoneyTextField.text  else { return }
        //get data from viewModel
        viewModel.textFieldIsChanged(amountForConvesation: amountForConv, completion: { (isAvailableChangeAmountLabel, isAvailableChangeExchangeButton, convertedAmountForTextView) in
            self.middlePageViews[self.indexMiddleScrollView].valueForChangeMoneyTextField.attributedText = convertedAmountForTextView
            self.topPageViews[self.indexTopScrollView].amountMoneyLabel.textColor = isAvailableChangeAmountLabel ? self.colorsForView.labelColor.colorViewUIColor : self.colorsForView.redLabelColor.colorViewUIColor
            if isAvailableChangeExchangeButton {
                self.exchangeButton.setTitleColor(.white, for: .normal)
            } else {
                self.exchangeButton.setTitleColor(self.colorsForView.bottomColorTopView.colorViewUIColor, for: .normal)
            }
            self.exchangeButton.isEnabled = isAvailableChangeExchangeButton
        })
    }
    
    //exchange money
    @objc func exchangeMoneyButton() {
        //get amount for rate conversation
        guard let amountForConv = topPageViews[indexTopScrollView].valueForChangeMoneyTextField.text, let amountResultExch = middlePageViews[indexMiddleScrollView].valueForChangeMoneyTextField.text  else { return }
        //get data from viewModel
        viewModel.exchangeMoney(amountForConvesation: amountForConv, amountExchenged: amountResultExch) { (amountTopLabel, amountMiddleLabel, isSuccess) in
            self.topPageViews[self.indexTopScrollView].amountMoneyLabel.text = amountTopLabel
            self.middlePageViews[self.indexMiddleScrollView].amountMoneyLabel.text = amountMiddleLabel
            self.middlePageViews[self.indexTopScrollView].amountMoneyLabel.text = amountTopLabel
            self.topPageViews[self.indexMiddleScrollView].amountMoneyLabel.text = amountMiddleLabel
            
            self.topPageViews[self.indexTopScrollView].valueForChangeMoneyTextField.text = ""
            self.middlePageViews[self.indexMiddleScrollView].valueForChangeMoneyTextField.text = "0"
            self.topPageViews[self.indexTopScrollView].valueForChangeMoneyTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: self.colorsForView.placeHolderColor.colorViewUIColor, NSAttributedString.Key.font: self.fontsForView.fontTextField.fontsForViews])
            self.exchangeButton.isEnabled = !isSuccess
            self.exchangeButton.setTitleColor(self.colorsForView.bottomColorTopView.colorViewUIColor, for: .normal)
            self.cancelButton.isEnabled = isSuccess
            self.cancelButton.setTitleColor(.white, for: .normal)
        }
        
    }
    //Cancel exchange money
    @objc func cancelLastExchButton() {
        viewModel.cancelLastExch { (amountTopLabel, amountMiddleLabel, isSuccess) in
            self.topPageViews[self.indexTopScrollView].amountMoneyLabel.text = amountTopLabel
            self.middlePageViews[self.indexMiddleScrollView].amountMoneyLabel.text = amountMiddleLabel
            self.middlePageViews[self.indexTopScrollView].amountMoneyLabel.text = amountTopLabel
            self.topPageViews[self.indexMiddleScrollView].amountMoneyLabel.text = amountMiddleLabel
            self.cancelButton.isEnabled = !isSuccess
            self.cancelButton.setTitleColor(self.colorsForView.bottomColorTopView.colorViewUIColor, for: .normal)
        }
    }
    
}

//MARK: Delegate
extension ViewController: UIScrollViewDelegate {
    
    
    // PageControl swither is here
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let widthPage = topView.frame.width
        let index = getIndexPage(contentOffSetscrollView: scrollView.contentOffset)
        //определяем pageControl c текущего scrollView и с другого scrollView
        let (pageControl, anoverPageControl) = scrollView == topScrollView ? (topPageControl, middlePageControl) : (middlePageControl, topPageControl)
        //выставляем новое положение scrollView и pageControl
        if offset.x < widthPage {
            if anoverPageControl.currentPage == 2{
                let newPositionX = widthPage * 2
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            } else {
                let newPositionX = widthPage * 3
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            }
        } else if index == 4{
            if anoverPageControl.currentPage == 0{
                let newPositionX = widthPage * 2
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            } else {
                let newPositionX = widthPage
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            }
        } else if index == 3, pageControl.currentPage == 1{
            if anoverPageControl.currentPage == 2{
                let newPositionX = widthPage
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            } else {
                let newPositionX = widthPage * 3
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(offset.x/widthPage) - 1
            }
        } else if index == 2, pageControl.currentPage == 0{
            if anoverPageControl.currentPage == 1{
                let newPositionX = widthPage * 3
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            } else{
                let newPositionX = widthPage * 2
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(offset.x/widthPage) - 1
            }
        } else if index == 2, pageControl.currentPage == 2{
            if anoverPageControl.currentPage == 1{
                let newPositionX = widthPage
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            } else{
                let newPositionX = widthPage * 2
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(offset.x/widthPage) - 1
            }
        } else if index == 1, pageControl.currentPage == 1{
            if anoverPageControl.currentPage == 0{
                let newPositionX = widthPage * 3
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(newPositionX/widthPage) - 1
            } else{
                let newPositionX = widthPage
                scrollView.contentOffset.x = newPositionX
                pageControl.currentPage = Int(offset.x/widthPage) - 1
            }
        }
        //курс текущий выставляем на среднем scrollView
        indexTopScrollView = getIndexPage(contentOffSetscrollView: topScrollView.contentOffset)
        indexMiddleScrollView = getIndexPage(contentOffSetscrollView: middleScrollView.contentOffset)
        setRateString(indexTopScrollView: indexTopScrollView, indexMiddleScrollView: indexMiddleScrollView)
        //current top textField set active
        topPageViews[indexTopScrollView].valueForChangeMoneyTextField.becomeFirstResponder()
        // middle textView update data
        getNewValueForTextFields()
        cancelButton.isEnabled = false
        //cancelButton set unavailable
        cancelButton.setTitleColor(self.colorsForView.bottomColorTopView.colorViewUIColor, for: .normal)
    }
    
    // MARK: - View Gradient
    func addTopViewLayerGradient() {
        
        topView.layerGradient(startPoint: .topCenter, endPoint: .bottomCenter, colorArray: [
            colorsForView.upColorTopView.colorViewCGColor, colorsForView.bottomColorTopView.colorViewCGColor], type: .axial, locations: [0, 1])
    }
    func addMiddleViewLayerGradient() {
        
        middleView.layerGradient(startPoint: .centerLeft, endPoint: .centerRight, colorArray: [colorsForView.partsColormedimView.colorViewCGColor, colorsForView.centralColormedimView.colorViewCGColor, colorsForView.partsColormedimView.colorViewCGColor], type: .axial, locations: [0, 0.5, 1])
    }
    
}


