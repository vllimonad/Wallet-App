//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let monthLabel: UILabel
    
    private let backwardButton: UIButton
    
    private let forwardButton: UIButton
    
    private let amountLabel: UILabel
    
    private let categoriesTableView: UITableView
    
    private let emptyStatisticView: EmptyStatisticView
    
    private var viewModel: MainViewModelType
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    init(viewModel: MainViewModelType) {
        self.monthLabel = UILabel()
        self.backwardButton = UIButton()
        self.forwardButton = UIButton()
        self.amountLabel = UILabel()
        self.categoriesTableView = UITableView()
        self.emptyStatisticView = EmptyStatisticView()
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDelegate = self
        
        configureUI()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadStatistic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewHeightConstraint?.constant = categoriesTableView.contentSize.height
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .background)
        
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonImageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        forwardButton.setImage(UIImage(systemName: "chevron.forward", withConfiguration: buttonImageConfiguration), for: .normal)
        forwardButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        
        backwardButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: buttonImageConfiguration), for: .normal)
        backwardButton.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        
        let monthStackView = UIStackView(arrangedSubviews: [backwardButton, monthLabel, forwardButton])
        monthStackView.axis = .horizontal
        monthStackView.backgroundColor = UIColor(resource: .view)
        monthStackView.applyCustomShadow()
        monthStackView.layer.cornerRadius = 16
        monthStackView.translatesAutoresizingMaskIntoConstraints = false
        
        amountLabel.font = UIFont.boldSystemFont(ofSize: 22)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.register(StatisticViewCell.self, forCellReuseIdentifier: StatisticViewCell.reuseIdentifier())
        categoriesTableView.allowsSelection = false
        categoriesTableView.separatorStyle = .none
        categoriesTableView.rowHeight = 70
        categoriesTableView.isScrollEnabled = false
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundPanelView = UIView()
        backgroundPanelView.backgroundColor = UIColor(resource: .view)
        backgroundPanelView.applyCustomShadow()
        backgroundPanelView.layer.cornerRadius = 32
        backgroundPanelView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStatisticView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(monthStackView)
        view.addSubview(backgroundPanelView)
        
        backgroundPanelView.addSubview(emptyStatisticView)
        backgroundPanelView.addSubview(amountLabel)
        backgroundPanelView.addSubview(categoriesTableView)
        
        NSLayoutConstraint.activate([
            backwardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            forwardButton.widthAnchor.constraint(equalTo: backwardButton.widthAnchor),

            monthStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            monthStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            monthStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            monthStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            backgroundPanelView.topAnchor.constraint(equalTo: monthStackView.bottomAnchor, constant: 20),
            backgroundPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backgroundPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

            amountLabel.topAnchor.constraint(equalTo: backgroundPanelView.topAnchor, constant: 20),
            amountLabel.leadingAnchor.constraint(equalTo: backgroundPanelView.leadingAnchor, constant: 20),
            
            categoriesTableView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            categoriesTableView.bottomAnchor.constraint(equalTo: backgroundPanelView.bottomAnchor, constant: -20),
            categoriesTableView.leadingAnchor.constraint(equalTo: backgroundPanelView.leadingAnchor, constant: 20),
            categoriesTableView.trailingAnchor.constraint(equalTo: backgroundPanelView.trailingAnchor, constant: -20),
            
            emptyStatisticView.topAnchor.constraint(equalTo: backgroundPanelView.topAnchor, constant: 20),
            emptyStatisticView.bottomAnchor.constraint(equalTo: backgroundPanelView.bottomAnchor, constant: -20),
            emptyStatisticView.leadingAnchor.constraint(equalTo: backgroundPanelView.leadingAnchor, constant: 20),
            emptyStatisticView.trailingAnchor.constraint(equalTo: backgroundPanelView.trailingAnchor, constant: -20),
        ])
        
        tableViewHeightConstraint = categoriesTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func didTapNextButton() {
        viewModel.showNextMonth()
        reloadStatistic()
    }
    
    @objc
    private func didTapPreviousButton() {
        viewModel.showPreviousMonth()
        reloadStatistic()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getSelectedMonthExpenses().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticViewCell.reuseIdentifier(), for: indexPath) as? StatisticViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.getSelectedMonthExpenses()[indexPath.row]
        let totalExpenes = viewModel.getSelectedMonthTotalExpenses()
        
        cell.bind(model, totalExpenes)
        
        return cell
    }
}

extension MainViewController: MainViewModelViewDelegate {
    
    func reloadStatistic() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let hasRecords = !viewModel.getSelectedMonthExpenses().isEmpty
            
            monthLabel.text = viewModel.getSelectedDateDescription()

            amountLabel.text = "Total: \(viewModel.getSelectedMonthTotalExpenses()) zł"
            amountLabel.isHidden = !hasRecords
                    
            categoriesTableView.isHidden = !hasRecords
            categoriesTableView.reloadData()
            
            emptyStatisticView.isHidden = hasRecords
        }
    }
}
