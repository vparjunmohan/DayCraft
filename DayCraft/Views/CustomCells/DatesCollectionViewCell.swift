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
    
    private func setupWeekDays() {
        for day in days {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
//            label.widthAnchor.constraint(equalToConstant: 60).isActive = true
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(label)
        }
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
}
