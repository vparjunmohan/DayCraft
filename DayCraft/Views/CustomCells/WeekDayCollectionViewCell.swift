//
//  WeekDayCollectionViewCell.swift
//  DayCraft
//
//  Created by Arjun Mohan on 05/02/24.
//

import UIKit

class WeekDayCollectionViewCell: UICollectionViewCell {
    // MARK: - PROPERTIES
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupWeekDays()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - CONFIG
    private func setupUI() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - HELPERS
    private func setupWeekDays() {
        for day in days {
            let label = UILabel()
            label.text = day
            label.textColor = updateWeekdayColour(dayName: day)
            label.textAlignment = .center
            //            label.backgroundColor = .red.withAlphaComponent(0.2)
            //            label.layer.borderColor = UIColor.black.cgColor
            //            label.layer.borderWidth = 1.0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: 30).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(label)
        }
    }
    
    private func updateWeekdayColour(dayName: String) -> UIColor{
        switch dayName {
        case "Sun":
            return UIColor.red
        default:
            return UIColor.blue
        }
    }
}
