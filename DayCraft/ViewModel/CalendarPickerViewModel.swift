//
//  CalendarPickerViewModel.swift
//  DayCraft
//
//  Created by Arjun Mohan on 05/02/24.
//

import Foundation
import UIKit

class CalendarPickerViewModel {
    // MARK: - PROPERTIES
    private (set) var numberOfSections: [CalendarPickerCells] = []
    private (set) var numberOfItemsInSection = 1
    var updateContainerHeightClosure: (() -> Void)?
    var reloadCollectionViewClosure: (() -> Void)?
    var numberOfWeeks: Int = 0
    var currentMonth: Int = 1
    var currentYear: Int = 2024
    var getSetNumberOfWeeksInMonth: Int {
        get {
            return numberOfWeeks
        }
        set(newvalue) {
            numberOfWeeks = newvalue
        }
    }
    var getSetCurrentMonth: Int {
        get {
            return currentMonth
        }
        set(newvalue) {
            currentMonth = newvalue
        }
    }
    var getSetCurrentYear: Int {
        get {
            return currentYear
        }
        set(newvalue) {
            currentYear = newvalue
        }
    }
    
    // MARK: - LIFE CYCLE
    init() {
        getNumberOfSections()
        getSetCurrentYear = getCurrentMonthAndYear().year
        getSetCurrentMonth = getCurrentMonthAndYear().month
        getSetNumberOfWeeksInMonth = numberOfWeeksInMonth(month: getSetCurrentMonth, year: getSetCurrentYear)
    }
    
    // MARK: - HELPERS
    private func getNumberOfSections() {
        numberOfSections.append(.monthNameCell)
        numberOfSections.append(.weekNameCell)
        numberOfSections.append(.datesCell)
    }

    func getNumberOfItemsInSection(sectionType: CalendarPickerCells, month: Int, year: Int) -> Int {
        switch sectionType {
        case .monthNameCell, .weekNameCell:
            return 1
        case .datesCell:
            getSetCurrentYear = year
            getSetCurrentMonth = month
            getSetNumberOfWeeksInMonth = numberOfWeeksInMonth(month: month, year: year)
            updateContainerHeightClosure?()
            return numberOfWeeks
        }
    }
    
    /// Function to get the current month and the year
    /// - Returns: a set with month and year in `Int`
    func getCurrentMonthAndYear() -> (month: Int, year: Int) {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        guard let month = components.month, let year = components.year else {
            // Return a default value or handle the error as needed
            return (0, 0)
        }
        
        return (month, year)
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
    private func numberOfWeeksInMonth(month: Int, year: Int) -> Int {
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
            cell.setupCell(selectedMonth: currentMonth)
            cell.delegate = self
            return cell
        case .weekNameCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCollectionViewCell", for: indexPath) as? WeekDayCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case .datesCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatesCollectionViewCell", for: indexPath) as? DatesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setupCell(currentWeek: indexPath.row + 1, selectedMonth: currentMonth, selectedYear: currentYear)
            return cell
        }
    }
    
    /// Function to check if the date is current date
    /// - Parameter dateString: date in` yyyy-MM-dd` format
    /// - Returns: Returns `True` if it is current date or else return `False`
    func isCurrentDate(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let inputDate = dateFormatter.date(from: dateString) {
            let currentDate = Date()
            // Compare the input date with the current date
            return Calendar.current.isDate(inputDate, inSameDayAs: currentDate)
        }
        // Invalid date format
        return false
    }
}

// MARK: - MONTH COLLECTION VIEW CELL DELEGATE
extension CalendarPickerViewModel: MonthCollectionViewCellDelegate {
    /// Delegate method to display the previous month
    func displayPreviousMonth() {
        if getSetCurrentMonth > 1 {
            getSetCurrentMonth -= 1
            reloadCollectionViewClosure?()
            updateContainerHeightClosure?()
        }
    }
    
    /// Delegate method to display the next month
    func displayNextMonth() {
        if getSetCurrentMonth < 12 {
            getSetCurrentMonth += 1
            reloadCollectionViewClosure?()
            updateContainerHeightClosure?()
        }
    }
}
