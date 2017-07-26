//
//  AddMenuItem.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 23/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SwiftForms
import SCLAlertView

class AddMenuItem: FormViewController {
    
    let backendless = Backendless.sharedInstance()
    let warningImage = UIImage(named: "warning.png")
    let doneImage = UIImage(named: "done.png")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let form = FormDescriptor()
        form.title = "Add a new yummy food item"
        
        // Define first section
        let section1 = FormSectionDescriptor(headerTitle: "Add a new yummy food item", footerTitle: "")
        
        
        let rowName = FormRowDescriptor(tag: "name", type: .text, title: "Item Name : ")
        section1.rows.append(rowName)
        
        let rowID = FormRowDescriptor(tag: "id", type: .text, title: "Item ID : ")
        section1.rows.append(rowID)
        
        let rowUrl = FormRowDescriptor(tag: "url", type: .url, title: "Image URL : ")
        section1.rows.append(rowUrl)
        
        let cat = FormRowDescriptor(tag: "cat", type: .number, title: "Categeory : ")
        section1.rows.append(cat)
        
        let cat1 = FormRowDescriptor(tag: "catDesc", type: .label, title: " 0 - Starters , 1 - Main course , 2 - Desert")
        section1.rows.append(cat1)

        let vNv = FormRowDescriptor(tag:"vNv", type: .number, title: "Veg/NonVeg : ")
        section1.rows.append(vNv)
        
        let n1 = FormRowDescriptor(tag: "n1", type: .label, title: " 0 - Veg , 1 - Nonveg")
        section1.rows.append(n1)
        
        let desc = FormRowDescriptor(tag: "desc", type: .label, title: "Description : ")
        section1.rows.append(desc)
        
        let desc1 = FormRowDescriptor(tag: "desc1", type: .multilineText, title: "")
        section1.rows.append(desc1)
        
        let section2 = FormSectionDescriptor(headerTitle: "Price ", footerTitle: "")
        
        let priceToday = FormRowDescriptor(tag: "p1", type: .decimal, title: "For today : ")
        section2.rows.append(priceToday)
        
        let priceTomorrow = FormRowDescriptor(tag: "p2", type: .decimal, title: "For tomorrow : ")
        section2.rows.append(priceTomorrow)
        
        let priceLater = FormRowDescriptor(tag: "p3", type: .decimal, title: "After tomorrow : ")
        section2.rows.append(priceLater)
        
        let section3 = FormSectionDescriptor(headerTitle: "Availability", footerTitle: "")
        
        let avai_desc = FormRowDescriptor(tag: "av", type: .label, title: " 0 - Unavailable , 1 - Available")
        section3.rows.append(avai_desc)
        
        let avai_sun = FormRowDescriptor(tag: "a1", type: .number, title: "Sunday : ")
        section3.rows.append(avai_sun)
        
        let avai_mon = FormRowDescriptor(tag: "a2", type: .number, title: "Monday : ")
        section3.rows.append(avai_mon)

        let avai_tue = FormRowDescriptor(tag: "a3", type: .number, title: "Tuesday : ")
        section3.rows.append(avai_tue)

        let avai_wed = FormRowDescriptor(tag: "a4", type: .number, title: "Wednesday : ")
        section3.rows.append(avai_wed)

        let avai_thu = FormRowDescriptor(tag: "a5", type: .number, title: "Thrusday : ")
        section3.rows.append(avai_thu)

        let avai_fri = FormRowDescriptor(tag: "a6", type: .number, title: "Friday : ")
        section3.rows.append(avai_fri)

        let avai_sat = FormRowDescriptor(tag: "a7", type: .number, title: "Saturday : ")
        section3.rows.append(avai_sat)
        
        let section4 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
        
        let submit = FormRowDescriptor(tag: "submit", type: .button, title: "Add Item")
        section4.rows.append(submit)


        form.sections = [section1,section2,section3,section4]
        
        self.form = form
        
        
        
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 3 && indexPath.row == 0 {

            if areAllFilled() {
                let item = Item()
                item.itemName = self.form.sections[0].rows[0].value as? String
                item.itemId = self.form.sections[0].rows[1].value as? String
                item.itemUrl = self.form.sections[0].rows[2].value as? String
                item.itemCategeory = getCategeoty(code: (self.form.sections[0].rows[3].value as? String)!)
                item.foodType = getType(code: (self.form.sections[0].rows[5].value as? String)!)
                item.itemDescription = self.form.sections[0].rows[8].value as? String
                item.priceToday = self.form.sections[1].rows[0].value as? String
                item.priceTomorrow = self.form.sections[1].rows[1].value as? String
                item.priceLater = self.form.sections[1].rows[2].value as? String
                item.availableSunday = self.form.sections[2].rows[1].value as? String
                item.availableMonday = self.form.sections[2].rows[2].value as? String
                item.availableTuesday = self.form.sections[2].rows[3].value as? String
                item.availableWednesday = self.form.sections[2].rows[4].value as? String
                item.availableThrusday = self.form.sections[2].rows[5].value as? String
                item.availableFriday = self.form.sections[2].rows[6].value as? String
                item.availableSaturday = self.form.sections[2].rows[7].value as? String
                item.displayOrder = "0"
                
               let intr_view =  SCLAlertView().showTitle("Saving...", subTitle: "Please wait while we save...", style: .info, closeButtonTitle: "OK", duration: 100, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: doneImage , animationStyle: .bottomToTop)
                
                backendless?.data.of(Item.ofClass()).save(item, response: { (data) in
                   

                    let publishOptions = PublishOptions()
                    let headers = ["ios-alert":"Menu updated","ios-badge":"1","ios-sound":"default","type":"menuupdate"]
                    publishOptions.assignHeaders(headers)
                    self.backendless?.messaging.publish("default", message: "Menu Updated", publishOptions: publishOptions, response: { (response) in
                      
                        intr_view.close()
                        SCLAlertView().showTitle("Saved", subTitle: "Item successfully added", style: .info, closeButtonTitle: "OK", duration: 10, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: self.doneImage , animationStyle: .bottomToTop)
                        }, error: { (fault) in
                           
                            intr_view.close()
                            SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", duration: 10, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: self.warningImage , animationStyle: .bottomToTop)
                    })
                    }, error: { (error) in
                        intr_view.close()
                       
                       
                        SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", duration: 10, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: self.warningImage , animationStyle: .bottomToTop)
                })
            
            
            
            } else {
                
                 SCLAlertView().showTitle("Error", subTitle: "Please fill all the fields", style: .info, closeButtonTitle: "OK", duration: 30, colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            }
            
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func areAllFilled() -> Bool {
        
        if self.form.sections[0].rows[0].value != nil {
            if self.form.sections[0].rows[1].value != nil {
                if self.form.sections[0].rows[2].value != nil {
                    if self.form.sections[0].rows[3].value != nil {
                        if self.form.sections[0].rows[5].value != nil {
                            if  self.form.sections[0].rows[8].value != nil {
                                if self.form.sections[1].rows[0].value != nil {
                                    if self.form.sections[1].rows[1].value != nil {
                                        if self.form.sections[1].rows[2].value != nil {
                                            if self.form.sections[2].rows[1].value != nil {
                                                if self.form.sections[2].rows[2].value != nil {
                                                    if self.form.sections[2].rows[3].value != nil {
                                                        if self.form.sections[2].rows[4].value != nil {
                                                            if self.form.sections[2].rows[5].value != nil {
                                                                if self.form.sections[2].rows[6].value != nil {
                                                                    if self.form.sections[2].rows[7].value != nil {
                                                                        return true
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return false
    
    }
    
    func getCategeoty(code : String) -> String {
        switch code {
        case "0":
            return "Straters"
        case "1":
            return "Main Course"
        case "2":
            return "Desert"
        default:
            return ""
        }
        
        return ""
    }
    
    func getType(code : String) -> String {
        switch code {
        case "0":
            return "Veg"
        case "1":
            return "Non-Veg"
        default:
            return ""
        }
        
        return ""
    }
    
    func clearAllFields(){
        self.form.sections[0].rows[0].value = "" as AnyObject?
        self.form.sections[0].rows[1].value = "" as AnyObject?
        self.form.sections[0].rows[2].value = "" as AnyObject?
        self.form.sections[0].rows[3].value = "" as AnyObject?
        self.form.sections[0].rows[5].value = "" as AnyObject?
        self.form.sections[0].rows[8].value = "" as AnyObject?
        self.form.sections[1].rows[0].value = "" as AnyObject?
        self.form.sections[1].rows[1].value = "" as AnyObject?
        self.form.sections[1].rows[2].value = "" as AnyObject?
        self.form.sections[2].rows[1].value = "" as AnyObject?
        self.form.sections[2].rows[2].value = "" as AnyObject?
        self.form.sections[2].rows[3].value = "" as AnyObject?
        self.form.sections[2].rows[4].value = "" as AnyObject?
        self.form.sections[2].rows[5].value = "" as AnyObject?
        self.form.sections[2].rows[6].value = "" as AnyObject?
        self.form.sections[2].rows[7].value = "" as AnyObject?
    }
    


}
