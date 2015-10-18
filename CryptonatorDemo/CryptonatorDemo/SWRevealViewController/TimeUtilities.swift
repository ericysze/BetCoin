//
//  TimeUtilities.swift
//  Countdown
//
//  Created by Z on 8/29/15.
//  Copyright © 2015 dereknetto. All rights reserved.
//

import UIKit

func timeToTargetDate(targetDate: NSDate) -> NSTimeInterval{
    let currentDate = NSDate()
    let timeToTargetDate = targetDate.timeIntervalSinceDate(currentDate)
    return timeToTargetDate
}

func dateAndTimeStringsfromDate(date:NSDate) -> ([String]){
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    formatter.timeStyle = .ShortStyle
    let fullString = formatter.stringFromDate(date)
    return (fullString.componentsSeparatedByString(" at "))
}

enum unit: Int {
    case Year, Month, Day, Hour, Minute, Second, Millisecond, Poop
}

extension NSTimeInterval{
    
    func timeUnits() -> [Int]{
        let intInterval = Int(self)
        let years = (intInterval / 31556900)
        let months = (intInterval / 2629740) % 12
        let days = Int(floor((self / (3600 * 24)) % 30.4368))
        let hours = (intInterval / 3600) % 24
        let minutes = (intInterval / 60) % 60
        let seconds = intInterval % 60
        let milliseconds = Int(floor(((self - floor(self)) * 100)))
        
        return [years, months, days, hours, minutes, seconds, milliseconds]
    }
    
    func stringFromTimeInterval(withMilliseconds:Bool) -> String{
        let timeUnits = self.timeUnits()
        
        var foundFirstNonzero = false
        var timeString = ""
        
        // remove leading 0s
        for (idx, unit) in timeUnits.enumerate() {
            if unit == 0 && !foundFirstNonzero {
                continue
            }
            foundFirstNonzero = true
            let unitString = unit > 9 ? "\(unit)" : "0\(unit)"
            
            if (withMilliseconds == true){
                if idx == timeUnits.count - 1 {
                    timeString = timeString + unitString
                }
                else if (idx == timeUnits.count - 2){
                    timeString = timeString + unitString + "."
                }else{
                    timeString = timeString + unitString + ":"
                }
            }else{
                if idx == timeUnits.count - 1 {
                    //do nothing
                }
                else if (idx == timeUnits.count - 2){
                    timeString = timeString + unitString
                }else{
                    timeString = timeString + unitString + ":"
                }
            }
        }
        
        return timeString
    }
    
    func largestTimeUnit() -> unit{        
        var unitID = 0
        for (idx, unit) in self.timeUnits().enumerate() {
            if unit > 0{
                unitID = idx
                break
            }
        }
        switch unitID{
        case 0:
            return .Year
        case 1:
            return .Month
        case 2:
            return .Day
        case 3:
            return .Hour
        case 4:
            return .Minute
        case 5:
            return .Second
        case 6:
            return .Millisecond
        default:
            return .Poop
        }
    }
}
