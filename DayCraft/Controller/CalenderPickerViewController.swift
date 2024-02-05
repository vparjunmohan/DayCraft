//
//  CalenderPickerViewController.swift
//  DayCraft
//
//  Created by Arjun Mohan on 05/02/24.
//

import UIKit

class CalenderPickerViewController: UIViewController {
    // MARK: - PROPERTIES
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: "MonthCollectionViewCell")
        collectionView.register(WeekDayCollectionViewCell.self, forCellWithReuseIdentifier: "WeekDayCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    let calendar = Calendar.current
    var currentDate: Date!
    var daysInMonth: [String] = []
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        currentDate = Date()
        setupDaysInMonth()
    }
    
    // MARK: - CONFIG
    private func configUI() {
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // MARK: - HELPERS
    private func setupDaysInMonth() {
        // Get the first day of the month
        var firstDayComponents = calendar.dateComponents([.year, .month], from: currentDate)
        firstDayComponents.day = 1
        let firstDayOfMonth = calendar.date(from: firstDayComponents)!
        
        // Get the range of days in the month
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        daysInMonth = range.map { String($0) }
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension CalenderPickerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as? MonthCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCollectionViewCell", for: indexPath) as? WeekDayCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension CalenderPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - COLLECTION VIEW DELEGATE FLOW LAYOUT
extension CalenderPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
