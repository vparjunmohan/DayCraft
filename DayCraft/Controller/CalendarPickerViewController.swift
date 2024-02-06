//
//  CalendarPickerViewController.swift
//  DayCraft
//
//  Created by Arjun Mohan on 05/02/24.
//

import UIKit

class CalendarPickerViewController: UIViewController {
    // MARK: - PROPERTIES
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var calendarPickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: "MonthCollectionViewCell")
        collectionView.register(WeekDayCollectionViewCell.self, forCellWithReuseIdentifier: "WeekDayCollectionViewCell")
        collectionView.register(DatesCollectionViewCell.self, forCellWithReuseIdentifier: "DatesCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    let viewModel: CalenderPickerViewModel
    private var containerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - LIFE CYCLE
    init(viewModel: CalenderPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CalenderPickerViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configBinding()
    }
    
    // MARK: - CONFIG
    private func configUI() {
        view.addSubview(containerView)
        containerView.addSubview(calendarPickerCollectionView)
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 360)
        containerViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            calendarPickerCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            calendarPickerCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            calendarPickerCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            calendarPickerCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configBinding() {
        let current = viewModel.getCurrentMonthAndYear()
        let numberOfWeeks = viewModel.getNumberOfItemsInSection(sectionType: .datesCell, month: current.month, year: current.year)
        viewModel.updateContainerHeightClosure = { [weak self] in
            guard let self else { return }
            containerViewHeightConstraint.constant = CGFloat(numberOfWeeks * 50) + CGFloat(60)
            // Animate if needed
//            UIView.animate(withDuration: 2.0) {
//                self.view.layoutIfNeeded()
//            }
        }
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension CalendarPickerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let current = viewModel.getCurrentMonthAndYear()
        return viewModel.getNumberOfItemsInSection(sectionType: viewModel.numberOfSections[section], month: current.month, year: current.year)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.configCells(sectionType: viewModel.numberOfSections[indexPath.section], collectionView: collectionView, indexPath: indexPath)
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension CalendarPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - COLLECTION VIEW DELEGATE FLOW LAYOUT
extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionType = viewModel.numberOfSections[indexPath.section]
        switch sectionType {
        case .weekNameCell, .monthNameCell:
            return CGSize(width: collectionView.frame.width, height: 30)
        case .datesCell:
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
