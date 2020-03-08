//
//  CloseTimesController.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 21/07/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class CloseTimesController: UIViewController , UIScrollViewDelegate{
    
    var ref : DatabaseReference!
    
    var navbarIndicator = UIActivityIndicatorView()
    var scrollView = UIScrollView()
    let days = ["SundayLunch","SundayDinner","MondayLunch","MondayDinner","TuesdayLunch","TuesdayDinner","WednesdayLunch","WednesdayDinner","ThrusdayLunch","ThrusdayDinner","FridayLunch","FridayDinner","SaturdayLunch","SaturdayDinner","MinimumAmount"]
    let daysLabels = ["sundayLunch","sundayDinner","mondayLunch","mondayDinner","tuesdayLunch","tuesdayDinner","wednesdayLunch","wednesdayDinner","thrusdayLunch","thrusdayDinner","fridayLunch","fridayDinner","saturdayLunch","saturdayDinner","minAmount"]
    var fields = [UITextField]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setRightBarButton(spinner, animated: true)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        fields.removeAll()
        
        for i in 0...14 {
        
            let dayLabel = UILabel(frame: CGRect(x: 10, y: 10 + (i*50), width: Int(UIScreen.main.bounds.width/2 - 10), height: 40))
            dayLabel.textAlignment = .left
            dayLabel.textColor = UIColor.black
            dayLabel.text = days[i]
            scrollView.addSubview(dayLabel)
            
           let valueField = UITextField(frame: CGRect(x: Int(UIScreen.main.bounds.width/2 + 10), y: 10 + (i*50), width: Int(UIScreen.main.bounds.width/2 - 10), height: 40))
            valueField.placeholder = "0"
            valueField.textColor = UIColor.black
            valueField.textAlignment = .center
            valueField.keyboardType = .numberPad
            fields.append(valueField)
            scrollView.addSubview(valueField)
            
        }
        
        scrollView.contentSize  = CGSize(width: scrollView.bounds.size.width, height: 10 + (15*50))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func uploadData(_ sender: AnyObject) {
        

        
        for i in 0...14 {
            
                ref.child("orderTimes").updateChildValues([daysLabels[i]:Int(fields[i].text!)!])
            

        }
        
        
    }

    @IBAction func downloadData(_ sender: AnyObject) {
        navbarIndicator.startAnimating()
        ref.child("orderTimes").observeSingleEvent(of: .value, with: { (snapshot) in
            self.navbarIndicator.stopAnimating()
            let value = snapshot.value as? NSDictionary
            let mondayLunch = value?["mondayLunch"] as? Int
            let tuesdayLunch = value?["tuesdayLunch"] as? Int
            let wednesdayLunch = value?["wednesdayLunch"] as? Int
            let thrusdayLunch = value?["thrusdayLunch"] as? Int
            let fridayLunch = value?["fridayLunch"] as? Int
            let saturdayLunch = value?["saturdayLunch"] as? Int
            let sundayLunch = value?["sundayLunch"] as? Int
            
            let mondayDinner = value?["mondayDinner"] as? Int
            let tuesdayDinner = value?["tuesdayDinner"] as? Int
            let wednesdayDinner = value?["wednesdayDinner"] as? Int
            let thrusdayDinner = value?["thrusdayDinner"] as? Int
            let fridayDinner = value?["fridayDinner"] as? Int
            let saturdayDinner = value?["saturdayDinner"] as? Int
            let sundayDinner = value?["sundayDinner"] as? Int
            
            let minAmount = value?["minAmount"] as? Int
            
            let dataArray = [sundayLunch,sundayDinner,mondayLunch,mondayDinner,tuesdayLunch,tuesdayDinner,wednesdayLunch,wednesdayDinner,thrusdayLunch,thrusdayDinner,fridayLunch,fridayDinner,saturdayLunch,saturdayDinner,minAmount]
            
            for i in 0...14 {
            self.fields[i].text = String(describing: dataArray[i]!)
            }
            
            }) { (error) in
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showError("Error", subTitle: "Cannot download data due to the following error \(error)")
        }
    }


}
