//
//  Time.swift
//  GundyMarket
//
//  Created by Gundy on 3/15/24.
//

struct Time {
    
    // MARK: - Private property
    
    private var year = 0
    private var month = 0
    private var day = 0 {
        didSet {
            month = day/31
            year = day/365
        }
    }
    private var hour = 0 {
        didSet { day = hour/24 }
    }
    private var minute = 0 {
        didSet { hour = minute/60 }
    }
    private var second = 0 {
        didSet { minute = second/60 }
    }
    
    // MARK: - Lifecycle
    
    init(timeInterval: Double) {
        setTime(timeInterval)
    }
    
    // MARK: - Public
    
    func string() -> String {
        if year > 0 {
            return String(year) + "년"
        } else if month > 0 {
            return String(month) + "달"
        } else if day > 0 {
            return String(day) + "일"
        } else {
            return "방금"
        }
    }
    
    // MARK: - Private
    
    private mutating func setTime(_ timeInterval: Double) {
        second = Int(timeInterval)
    }
}
