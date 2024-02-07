//
//  DatesCollectionViewCell.swift
//  DayCraft
//
//  Created by Arjun Mohan on 06/02/24.
//

import UIKit

class DatesCollectionViewCell: UICollectionViewCell {
    // MARK: - PROPERTIES
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .green
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let viewModel: CalendarPickerViewModel
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        self.viewModel = CalendarPickerViewModel()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = CalendarPickerViewModel()
        super.init(coder: aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - CONFIG
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .red
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - HELPERS
    func setupCell(currentWeek: Int, selectedMonth: Int, selectedYear: Int) {
        let dates = viewModel.datesInWeek(week: currentWeek, month: selectedMonth, year: selectedYear)
        setupWeekDays(dates: dates, selectedMonth: selectedMonth)
    }
    
    /// Function to set up the weekly days
    /// - Parameters:
    ///   - dates: an array of date string in `yyyy-MM-dd` format
    ///   - selectedMonth: selected month in `Int`
    private func setupWeekDays(dates: [String], selectedMonth: Int) {
        for date in dates {
            let label = UILabel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: date) {
                let dayComponent = Calendar.current.component(.day, from: date)
                let monthComponent = Calendar.current.component(.month, from: date)
                
                if monthComponent == selectedMonth {
                    label.text = String(dayComponent)
                } else {
                    label.text = ""
                }
            }
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(label)
        }
    }
}
