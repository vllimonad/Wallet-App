//
//  MainViewControllerDelegate.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

protocol StatisticsViewModelType {
    
    var viewDelegate: StatisticsViewModelViewDelegate? { get set }
    
    func showNextMonth()
    
    func showPreviousMonth()
    
    func getSelectedDateDescription() -> String
    
    func getSelectedMonthExpenses() -> [CategoryExpense]
    
    func getSelectedMonthTotalExpenses() -> Double
}
