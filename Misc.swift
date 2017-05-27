//
//  Misc.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 23/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation

class Misc {
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func getCoordinates( data : String) -> CLLocationCoordinate2D {
        
        let index1 = data.characters.index(of: ":")
        let str1 = data.substring(from: index1!)
        let index2 = str1.index(str1.startIndex, offsetBy: 2)
        let str2 = str1.substring(from: index2)
        let index3 = str2.characters.index(of: ",")
        let str3 = str2.substring(to: index3!)
        let index4 = str2.characters.index(of: ":")
        let str4 = str2.substring(from: index4!)
        let index5 = str4.index(str4.startIndex, offsetBy: 2)
        let str5 = str4.substring(from: index5)
        let index6 = str5.characters.index(of: ")")
        let str6 = str5.substring(to: index6!)
        
        let lat : CLLocationDegrees = Double(str3)!
        let long : CLLocationDegrees = Double(str6)!
        
        print("latitude \(lat) longitude \(long)")
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        return coordinates
    }
    
}
