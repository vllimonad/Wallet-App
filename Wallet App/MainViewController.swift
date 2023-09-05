//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import Charts

final class MainViewController: UIViewController {
    
    let pieChart = PieChartView()
    let categories = ["Food", "Shopping", "Housing", "Health", "Transportation", "Entertainment"]
    let amounts = [43, 56, 52, 87, 56, 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupChart()
    }
    
    func setupChart() {
        view.addSubview(pieChart)
        pieChart.frame.size = CGSize(width: 360, height: 360)
        pieChart.center = view.center
        
        var dataEntries = [PieChartDataEntry]()
        var totalSum = 0
        
        for i in 0..<categories.count {
            let a = PieChartDataEntry(value: Double(amounts[i]), label: categories[i])
            dataEntries.append(a)
            totalSum += amounts[i]
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartdata = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartdata
        formatChart(totalSum)
        formatChartDataSet(pieChartDataSet)
    }
    
    func formatChart(_ totalSum: Int) {
        pieChart.holeRadiusPercent = 0.5
        pieChart.transparentCircleRadiusPercent = 0.0
        pieChart.legend.enabled = false
        pieChart.rotationEnabled = false
        
        let centerText = NSAttributedString(string: "\(totalSum) pln", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 19)
        ])
        pieChart.centerAttributedText = centerText
    }
    
    func formatChartDataSet(_ pieChartDataSet: PieChartDataSet) {
        pieChartDataSet.colors = ChartColorTemplates.pastel()
        pieChartDataSet.valueFont = NSUIFont.systemFont(ofSize: 16)
    }
    
}


