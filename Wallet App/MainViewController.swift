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
        //chart.backgroundColor = .systemGray5
        //chart.xAxis.drawAxisLineEnabled = false
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
        
        drawChart()
    }
    
    func drawChart() {
        view.addSubview(barChart)
        barChart.frame = CGRect(x: 10, y: 280, width: view.frame.width*0.9, height: view.frame.width)
        
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<categories.count {
            let a = BarChartDataEntry(x: Double(i), y: Double(amounts[i]))
            dataEntries.append(a)
        }
        let barChartDataSet = BarChartDataSet(entries: dataEntries)
        let barChartdata = BarChartData(dataSet: barChartDataSet)
        barChartdata.setDrawValues(true)
        barChartdata.setValueFont(UIFont.systemFont(ofSize: 12))
        barChartdata.setValueTextColor(UIColor.black)
        barChartdata.barWidth = 0.5
        barChart.data = barChartdata
        
        formatChartDataSet(barChartDataSet)
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: categories)
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 14)
        barChart.setExtraOffsets(left: 80.0, top: 0.0, right: 20.0, bottom: 0.0)

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


