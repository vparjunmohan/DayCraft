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
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
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
    let viewModel: CalendarPickerViewModel
    private var containerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - LIFE CYCLE
    init(viewModel: CalendarPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CalendarPickerViewModel()
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
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 310)
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
        viewModel.updateContainerHeightClosure = { [weak self] in
            guard let self else { return }
            containerViewHeightConstraint.constant = CGFloat(viewModel.getSetNumberOfWeeksInMonth * 50) + CGFloat(60)
            // Animate if needed
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        viewModel.reloadCollectionViewClosure = { [weak self] in
            guard let self else { return }
            self.calendarPickerCollectionView.reloadData()
        }
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension CalendarPickerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(sectionType: viewModel.numberOfSections[section], month: viewModel.currentMonth, year: viewModel.currentYear)
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
