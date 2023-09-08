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
    
    let barChart: BarChartView = {
        let chart = BarChartView()
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        return chart
    }()
    let categories = ["Food", "Shopping", "Housing", "Health", "Transportation", "Entertainment"]
    var amounts = [43, 56, 52, 87, 56, 0]
    var totalSum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        setupChart()
    }
    
    func setupChart() {
        view.addSubview(barChart)
        barChart.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.width)
        
        var dataEntries = [BarChartDataEntry]()
        var totalSum = 0
        
        for i in 0..<categories.count {
            let a = BarChartDataEntry(x: Double(i), y: Double(amounts[i]))
            dataEntries.append(a)
            totalSum += amounts[i]
        }
        
        let barChartDataSet = BarChartDataSet(entries: dataEntries)
        let barChartdata = BarChartData(dataSet: barChartDataSet)
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
    
}


