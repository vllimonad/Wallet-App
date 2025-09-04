//
//  MainViewController.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 02/09/2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let monthStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.layer.shadowColor = UIColor.systemGray.cgColor
        stack.layer.shadowOpacity = 0.2
        stack.layer.shadowOffset = .zero
        stack.layer.shadowRadius = 10
        stack.backgroundColor = UIColor(resource: .view)
        stack.layer.cornerRadius = 13
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let backgroundPanelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = UIColor(resource: .view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoriesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let categoriesTableView: UITableView
    
    private let emptyStatisticView: EmptyStatisticView
    
    private var viewModel: MainViewModelType
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    init(viewModel: MainViewModelType) {
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
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.register(StatisticViewCell.self, forCellReuseIdentifier: StatisticViewCell.reuseIdentifier())
        categoriesTableView.allowsSelection = false
        categoriesTableView.separatorStyle = .none
        categoriesTableView.rowHeight = 70
        categoriesTableView.isScrollEnabled = false
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
                
        view.addSubview(monthStackView)
        view.addSubview(backgroundPanelView)

        monthStackView.addArrangedSubview(backwardButton)
        monthStackView.addArrangedSubview(monthLabel)
        monthStackView.addArrangedSubview(forwardButton)
        
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
            
            categoriesTableView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 20),
            categoriesTableView.bottomAnchor.constraint(equalTo: backgroundPanelView.bottomAnchor, constant: -20),
            categoriesTableView.leadingAnchor.constraint(equalTo: backgroundPanelView.leadingAnchor, constant: 20),
            categoriesTableView.trailingAnchor.constraint(equalTo: backgroundPanelView.trailingAnchor, constant: -20),
        ])
        
        tableViewHeightConstraint = categoriesTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Statistics"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func reloadStatistic() {
        amountLabel.text = "Total: \(viewModel.getSelectedMonthTotalExpenses()) zł"
        
        monthLabel.text = viewModel.getSelectedDateDescription()
                
        categoriesTableView.reloadData()
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
        cell.bind(model)
        
        return cell
    }
}

extension MainViewController: MainViewModelViewDelegate {
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadStatistic()
        }
    }
}
