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
    private (set) var numberOfSections: [CalendarPickerCells] = []
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
    
    func generateDates(forMonth month: Int, year: Int) -> [String] {
        var dates: [String] = []
        
        // Create a date component with the given month and year
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1 // Set to the first day of the month
        
        // Get the first day of the month
        guard let firstDayOfMonth = Calendar.current.date(from: dateComponents) else {
            return dates
        }
        
        // Calculate the range of days in the month
        guard let monthRange = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return dates
        }
        
        // Enumerate through the range and add each formatted date to the array
        for day in monthRange {
            dateComponents.day = day
            if let monthDay = Calendar.current.date(from: dateComponents) {
                let formattedDate = formatDate(monthDay)
                dates.append(formattedDate)
            }
        }
        
        return dates
    }
    
    /// Function to format the date to `String` in `yyyy-MM-dd` format
    /// - Parameter date: date in `Date` format
    /// - Returns: corresponding date in String` in `yyyy-MM-dd` format
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    /// Function to get the number of weeks in the given month
    /// - Parameters:
    ///   - month: month in `Int`
    ///   - year: year in `Int`
    /// - Returns: number of weeks in `Int`
    func numberOfWeeksInMonth(month: Int, year: Int) -> Int {
        let calendar = Calendar.current
        
        // Create a date component with the given month and year
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        
        // Get the first day of the month
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else {
            return 0
        }
        
        // Calculate the range of weeks in the month
        guard let range = calendar.range(of: .weekOfMonth, in: .month, for: firstDayOfMonth) else {
            return 0
        }
        
        return range.count
    }
    
    /// Function to get the dates in the given week
    /// - Parameters:
    ///   - week: week in `Int`
    ///   - month: month in `Int`
    ///   - year: year in `Int`
    /// - Returns: array of date string in `yyyy-MM-dd` format
    func datesInWeek(week: Int, month: Int, year: Int) -> [String] {
        let calendar = Calendar.current
        
        // Get the first day of the specified month and year
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return []
        }
        
        // Find the first day of the week
        guard let firstDayOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDayOfMonth)) else {
            return []
        }
        
        // Calculate the start and end of the week
        let startOfWeek = calendar.date(byAdding: .day, value: (week - 1) * 7, to: firstDayOfWeek)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        // Generate the dates in the week
        var currentDate = startOfWeek
        var dateStrings: [String] = []
        
        while currentDate <= endOfWeek {
            let formattedDate = formatDate(currentDate)
            dateStrings.append(formattedDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dateStrings
    }
    
    // MARK: - SETUP CELLS
    /// Function to setup the cell for `CalendarPickerCollectionView`
    /// - Parameters:
    ///   - sectionType: enumeration case of `CalendarPickerCells`
    ///   - collectionView: an instance of `UICollectionView`
    ///   - indexPath: `indexPath` of the UICollectionView
    /// - Returns: a configured `UICollectionViewCell`
    func configCells(sectionType: CalendarPickerCells, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
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
