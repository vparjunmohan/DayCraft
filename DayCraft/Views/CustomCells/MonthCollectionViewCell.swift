//
//  MonthCollectionViewCell.swift
//  DayCraft
//
//  Created by Arjun Mohan on 05/02/24.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    // MARK: - PROPERTIES
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.text = "Month"
        return label
    }()
    
    lazy var previousMonth: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    lazy var nextMonth: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - CONFIG
    private func setupUI() {
        contentView.addSubview(monthLabel)
        contentView.addSubview(previousMonth)
        contentView.addSubview(nextMonth)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            monthLabel.trailingAnchor.constraint(equalTo: previousMonth.leadingAnchor, constant: -5),
            monthLabel.heightAnchor.constraint(equalToConstant: 40),
            
            previousMonth.centerYAnchor.constraint(equalTo: nextMonth.centerYAnchor),
            previousMonth.trailingAnchor.constraint(equalTo: nextMonth.leadingAnchor),
            previousMonth.heightAnchor.constraint(equalToConstant: 40),
            previousMonth.widthAnchor.constraint(equalToConstant: 40),
            previousMonth.topAnchor.constraint(equalTo: contentView.topAnchor),
            previousMonth.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nextMonth.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nextMonth.heightAnchor.constraint(equalToConstant: 40),
            nextMonth.widthAnchor.constraint(equalToConstant: 40),
            nextMonth.topAnchor.constraint(equalTo: contentView.topAnchor),
            nextMonth.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    // MARK: - HELPERS
    
}