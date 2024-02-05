//
//  CalenderPickerViewModel.swift
//  DayCraft
//
//  Created by Arjun Mohan on 05/02/24.
//

import Foundation
import UIKit

class CalenderPickerViewModel {
    // MARK: - PROPERTIES
    private (set) var numberOfSections: [CalendarPicerCells] = []
    private (set) var numberOfItemsInSection = 1
    
    // MARK: - LIFE CYCLE
    init() {
        getNumberOfSections()
    }
    
    // MARK: - HELPERS
    private func getNumberOfSections() {
        numberOfSections.append(.monthNameCell)
        numberOfSections.append(.weekNameCell)
    }
    
    // MARK: - SETUP CELLS
    /// Function to setup the cell for `CalendarPickerCollectionView`
    /// - Parameters:
    ///   - sectionType: enumeration case of `CalendarPicerCells`
    ///   - collectionView: an instance of `UICollectionView`
    ///   - indexPath: `indexPath` of the UICollectionView
    /// - Returns: a configured `UICollectionViewCell`
    func configCells(sectionType: CalendarPicerCells, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionType {
        case .monthNameCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as? MonthCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case .weekNameCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCollectionViewCell", for: indexPath) as? WeekDayCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
