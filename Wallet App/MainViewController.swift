//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    
    let categories = ["Food", "Shopping", "Housing", "Health", "Transportation", "Entertainment"]
    let amounts = [43, 56, 52, 87, 56, 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setChart()
    }
    
    func setChart() {
        //var dataEntries: [ChartDataEntry]
    }

}


