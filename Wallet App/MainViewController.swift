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
    
    let barChart: BarChartView = {
        let chart = BarChartView()
        chart.backgroundColor = .systemGray4
        chart.layer.cornerRadius = 20
        chart.layer.borderWidth = 1
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        //chart.leftAxis.drawLabelsEnabled = false
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
    var amounts = [43, 56, 52, 87, 56, 0]
    var totalSum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        
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
        //setupChart()
    }
    
    func setupChart() {
        view.addSubview(barChart)
        barChart.frame = CGRect(x: 0, y: 200, width: view.frame.width*0.8, height: view.frame.width*0.8)
        
        var dataEntries = [BarChartDataEntry]()
        var totalSum = 0
        
        for i in 0..<categories.count {
            let a = BarChartDataEntry(x: Double(i), y: Double(amounts[i]))
            dataEntries.append(a)
            totalSum += amounts[i]
        }
        
        let barChartDataSet = BarChartDataSet(entries: dataEntries)
        let barChartdata = BarChartData(dataSet: barChartDataSet)
        barChart.data?.setDrawValues(true)
        barChart.data = barChartdata
        formatChart(totalSum)
        formatChartDataSet(barChartDataSet)
    }
    
    func formatChart(_ totalSum: Int) {
        
    }
    
    func formatChartDataSet(_ pieChartDataSet: BarChartDataSet) {
        pieChartDataSet.colors = ChartColorTemplates.pastel()
        pieChartDataSet.valueFont = NSUIFont.systemFont(ofSize: 16)
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


