//
//  DateHandler.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 23/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation

class DateHandler {
    
    
    func isPastPresenFuture(date : Date) -> Int{
        /** 0 - past
            1 - -present
            2 - future 
 **/
        let today = Date()
        let calendar = Calendar.current
        let year1 = calendar.component(.year, from: date)
        let month1 = calendar.component(.month, from: date)
        let day1 = calendar.component(.day, from: date)
        let year2 = calendar.component(.year, from: today)
        let month2 = calendar.component(.month, from: today)
        let day2 = calendar.component(.day, from: today)
        if year1 > year2 {
            //future
            return 2
        } else if year1 < year2 {
            //past
            return 0
        } else if year1 == year2 {
            //check for month
            if month1 > month2 {
            //future
                return 2
            } else if month1 < month2 {
            //past
                return 0
        } else if month1 == month2 {
            //check for day
                if day1 > day2 {
                // future 
                    return 2
                } else if day1 < day2 {
                //past
                    return 0
                } else if day1 == day2 {
                // today
                    return 1
                }
        }
        }
    return 0
    }
    
    func comapareDatesForSame(date1 : Date , date2 : Date) -> Bool {
        let calendar = Calendar.current
        if calendar.component(.year, from: date1) == calendar.component(.year, from: date2) {
            if calendar.component(.month, from: date1) == calendar.component(.month, from: date2) {
                if calendar.component(.day, from: date1) == calendar.component(.day, from: date2) {
                    
                    return true
                }
            }
        }
    
        return false
    }
    
    
    func getDayofweekfor(date : Date) -> Int {
        return Calendar.current.component(.weekday, from: date)
    }
    
    func getNext7Days() -> ([String],[Date]){
        let today = Date()
        let calendar = Calendar.current
        var days = [String]()
        var dates = [Date]()
        var weekdays = [String]()
        
        for i in 0...6{
            dates.append(calendar.date(byAdding: .day, value: i, to: today)!)
        }
        switch calendar.component(.weekday, from: today) {
        case 1:
            //Its sunday
            weekdays = ["Sun : ","Mon : ","Tue : ","Wed : ","Thu : ","Fri : ","Sat : "]
            break
        case 2 :
            // Its monday
            weekdays = ["Mon : ","Tue : ","Wed : ","Thu : ","Fri : ","Sat : ","Sun : "]
            break
        case 3 :
            // Its tuesday
            weekdays = ["Tue : ","Wed : ","Thu : ","Fri : ","Sat : ","Sun : ","Mon : "]
            break
        case 4 :
            // Its wednesday
             weekdays = ["Wed : ","Thu : ","Fri : ","Sat : ","Sun : ","Mon : ","Tue : "]
             break
        case 5 :
            // Its thrusday
            weekdays = ["Thu : ","Fri : ","Sat : ","Sun : ","Mon : ","Tue : ","Wed : "]
            break
        case 6 :
            // Its friday
            weekdays = ["Fri : ","Sat : ","Sun : ","Mon : ","Tue : ","Wed : ","Thu : "]
            break
        case 7 :
            weekdays = ["Sat : ","Sun : ","Mon : ","Tue : ","Wed : ","Thu : ","Fri : "]
            break
        default:
            weekdays = ["","","","","","",""]
            break
        }
        
        for i in 0...6{
            days.append(weekdays[i]+"\(calendar.component(.day, from: dates[i]))"+"/"+"\(calendar.component(.month, from: dates[i]))"+"/"+"\(calendar.component(.year, from: dates[i]))")
        }
        
        return (days,dates)
    }
    
    func isTodayDate( date : Date) -> Bool {
        
        
        let today = Date()
        let calendar = Calendar.current
        
        
        let todayDate = calendar.component(.day, from: today)
        let todayMonth = calendar.component(.month, from: today)
        let todayYear = calendar.component(.year, from: today)
        let Cdate = calendar.component(.day, from: date)
        let Cmonth = calendar.component(.month, from: date)
        let Cyear = calendar.component(.year, from: date)
        
        if Cdate == todayDate {
            if Cmonth == todayMonth {
                if Cyear == todayYear {
                    return true
                }
            }
        }
        
        return false
        
    }
    
    func daysFromTodayTo(date : Date) -> Int {
        
        let today = Date()
        let calendar = Calendar.current
        
        guard let start = calendar.ordinality(of: .day, in: .era, for: today) else {return 0}
        guard let end = calendar.ordinality(of: .day, in: .era, for: date) else {return 0 }
        
        return end - start
        
    }
    
    func dateToString(date:Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        return String(day)+"/"+String(month)+"/"+String(year)
    }
    
}

