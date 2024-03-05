//
//  DateCalculator.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

struct DateCalculator {
    
    // MARK: - Private property
    
    private let dateFormatter: DateFormatter
    
    // MARK: - Lifecycle
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    // MARK: Public
    
    func timeInterval(from string: String, since date: Date) -> TimeInterval {
        dateFormatter.date(from: string)?.timeIntervalSince(date) ?? 0
    }
}
