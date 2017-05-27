//
//  Util.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 16/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import Foundation
import SCLAlertView

class BackendlessErrorHandler {
    

    
    
    func backendlessPasswordRecoveryErrorhandler(code : String){
        let warningImage = UIImage(named: "warning.png")
        switch code {
        case "3020":
            SCLAlertView().showTitle("Error", subTitle: "Unable to find the user", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        default:
            SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
        }
    }
    
    func backendlessLoginErrorHandler(code : String) {
        let warningImage = UIImage(named: "warning.png")
        switch code {
        case "3000":
            SCLAlertView().showTitle("Error", subTitle: " Login disabled for this account. Please contact administrator", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3002" :
            SCLAlertView().showTitle("Error", subTitle: "User already logged in another device", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3003" :
            SCLAlertView().showTitle("Error", subTitle: "Please check your password and try again ", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3036" :
            SCLAlertView().showTitle("Error", subTitle: "Account locked out due to too many failed attempts. Please contact administrator", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3044" :
            SCLAlertView().showTitle("Error", subTitle: "Maximum multiple logins limit for an user reached ", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3090" :
            SCLAlertView().showTitle("Error", subTitle: "User account is disabled. Please contact administrator", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        default:
            SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        }
    }
    
    
    func backendUserRegistrationErrorHandler( code : String) {
         let warningImage = UIImage(named: "warning.png")
        switch code {
        case "2002" :
            SCLAlertView().showTitle("Error", subTitle: " Invalid application info,Please contact the developer ", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3009" :
            SCLAlertView().showTitle("Error", subTitle: " User registration is disabled for this application,Please contact the developer ", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3010" :
            SCLAlertView().showTitle("Error", subTitle: "Unknown dynamic property,Please contact the developer ", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3011" :
            SCLAlertView().showTitle("Error", subTitle: " Password property missing", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3012" :
            SCLAlertView().showTitle("Error", subTitle: "One or more required properties missing", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3013" :
            SCLAlertView().showTitle("Error", subTitle: "Phone number is missing", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3014" :
            SCLAlertView().showTitle("Error", subTitle: "External registration failed,Please try again", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3021" :
            SCLAlertView().showTitle("Error", subTitle: "General user registration error,Please try again", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3033" :
            SCLAlertView().showTitle("Error", subTitle: "Email id already exists", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3038" :
            SCLAlertView().showTitle("Error", subTitle: "Some of the user properties missing", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3039" :
            SCLAlertView().showTitle("Error", subTitle: "Id property cannot be used while calling registration", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3040" :
            SCLAlertView().showTitle("Error", subTitle: "Email address is in wrong format", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3041" :
            SCLAlertView().showTitle("Error", subTitle: "One of the required properties is missing", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "3043" :
            SCLAlertView().showTitle("Error", subTitle: "Duplicate properties found in registration request", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        case "8000" :
            SCLAlertView().showTitle("Error", subTitle: "One of the properties is too long", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        default:
            SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            break
        }
    }
    

}
