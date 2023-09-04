//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    let pieChart = PieChartView()
    let categories = ["Food", "Shopping", "Housing", "Health", "Transportation", "Entertainment"]
    let amounts = [43, 56, 52, 87, 56, 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setChart()
    }
    
    func setChart() {
        view.addSubview(pieChart)
        
        var dataEntries = [PieChartDataEntry]()
        for i in 0..<categories.count {
            let entry = ChartDataEntry(x: Double(i), y: Double(amounts[i]), data: categories[i] as String)
            let a = PieChartDataEntry(value: Double(amounts[i]), label: categories[i])
            dataEntries.append(a)
        }
        
        pieChart.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        pieChart.center = view.center
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        pieChartDataSet.colors = ChartColorTemplates.pastel()
        let pieChartdata = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartdata
        
    }

}


