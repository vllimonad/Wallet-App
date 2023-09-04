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
        view.backgroundColor = .white
        setupChart()
    }
    
    func setupChart() {
        view.addSubview(pieChart)
        pieChart.frame.size = CGSize(width: 360, height: 360)
        pieChart.center = view.center
        
        var dataEntries = [PieChartDataEntry]()
        var sum = 0
        
        for i in 0..<categories.count {
            let a = PieChartDataEntry(value: Double(amounts[i]), label: categories[i])
            dataEntries.append(a)
            sum += amounts[i]
        }

        pieChart.holeRadiusPercent = 0.45
        pieChart.center = view.center
        pieChart.legend.enabled = false
        let centerText = NSAttributedString(string: "\(sum)")
        pieChart.centerAttributedText = centerText
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        let pieChartdata = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartdata
        
        pieChartDataSet.colors = ChartColorTemplates.pastel()
        
    }
    
    
}


