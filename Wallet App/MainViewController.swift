//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    var newTransactionDelegate: NewTransactionViewControllerDelegate?
    var monthIndex = 1
    
    var monthLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .systemGray6
        label.text = "Current month"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var backwardButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(showPreviousMonth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var forwardButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var barChart: HorizontalBarChartView = {
        let chart = HorizontalBarChartView()
        chart.drawValueAboveBarEnabled = true
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = true
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.axisMinimum = 0
        chart.legend.enabled = false
        return chart
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Total: 0 eur"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categories = ["Food", "Shopping", "Housing", "Health", "Transportation", "Entertainment"]
    var amounts = [10, 29, 43, 52, 56, 87]
    var totalSum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        
        setupLayout()
        //drawChart()
    }
    
    func setupLayout() {
        let bar = Bar()
        view.addSubview(bar)
        bar.frame = CGRect(x: 10, y: 300, width: view.frame.width-20, height: 30)
        //bar.layer.position = CGPoint(x: 0, y: 300)
        view.addSubview(amountLabel)
        view.addSubview(backwardButton)
        view.addSubview(forwardButton)
        view.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backwardButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            backwardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            backwardButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalTo: backwardButton.widthAnchor),
            forwardButton.heightAnchor.constraint(equalTo: backwardButton.heightAnchor),
            
            monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),
            monthLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            monthLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),

            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountLabel.topAnchor.constraint(equalTo: backwardButton.bottomAnchor, constant: 20)
        ])
    }
    
    func drawChart() {
        view.addSubview(barChart)
        barChart.frame = CGRect(x: 10, y: 270, width: view.frame.width*0.9, height: view.frame.width)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: categories)
        barChart.xAxis.labelPosition = .top
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 14)
        barChart.setExtraOffsets(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0)
        
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<categories.count {
            let a = BarChartDataEntry(x: Double(i), y: Double(amounts[i]))
            dataEntries.append(a)
        }
        let barChartDataSet = BarChartDataSet(entries: dataEntries)
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChart.data = barChartData
        
        formatChartData(barChartData)
        formatChartDataSet(barChartDataSet)
    }
    
    func formatChartData(_ barChartData: BarChartData) {
        barChartData.setDrawValues(true)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 12))
        barChartData.setValueTextColor(UIColor.black)
        barChartData.barWidth = 0.5
    }
    
    func formatChartDataSet(_ barChartDataSet: BarChartDataSet) {
        barChartDataSet.colors = ChartColorTemplates.pastel()
        barChartDataSet.valueFont = NSUIFont.systemFont(ofSize: 16)
    }
    
    @objc func addTransaction() {
        let transactionView = NewTransactionViewController()
        transactionView.modalPresentationStyle = .formSheet
        transactionView.delegateController = newTransactionDelegate
        present(UINavigationController(rootViewController: transactionView), animated: true)
    }
    
    @objc func showPreviousMonth() {
        let index = Calendar.current.component(.month, from: Date())
        let month = "\(Calendar.current.standaloneMonthSymbols[index-monthIndex]) \(Calendar.current.component(.year, from: Date()))"
        monthLabel.text = month
    }
    
}

class Bar: UIView {
    
    let categoryLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.text = "food"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountLabel: UILabel = {
        var label = UILabel()
        label.text = "134.0"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 0.5
        progress.layer.cornerRadius = 12
        progress.progressViewStyle = .default
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .systemGray6
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(categoryLabel)
        addSubview(amountLabel)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            progressView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            progressView.heightAnchor.constraint(equalToConstant: 30),
            progressView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
