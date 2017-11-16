//
//  MenuViewController.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 06/10/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var table = UITableView()
    var starters = [Item]()
    var mainCourse = [Item]()
    var deserts = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 19))
//        lable.text = "Menu for date "+DateHandler().dateToString(date: MiscData().getSelectedDate())
//        lable.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.height/28.4)
//        lable.textAlignment = .center
//        self.view.addSubview(lable)
        
        table = UITableView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        table.delegate = self
        table.dataSource = self
        
        self.view.addSubview(table)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        starters.removeAll()
        mainCourse.removeAll()
        deserts.removeAll()
        (starters,mainCourse,deserts) = sortMenuData()
        table.reloadData()
        
        self.title = "Menu for "+DateHandler().dateToString(date: MiscData().getSelectedDate())
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return starters.count
        } else if section == 1 {
        return mainCourse.count
        } else if section == 2 {
        return deserts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Starters"
        case 1:
            return "Main Course"
        case 2:
            return "Deserts"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        table.rowHeight = UIScreen.main.bounds.height/10 + 20
        let itemImage = UIImageView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.height/10, height: UIScreen.main.bounds.height/10))
        cell.addSubview(itemImage)
        
        let name = UILabel(frame: CGRect(x: itemImage.frame.origin.x + itemImage.bounds.width + 10, y: (table.rowHeight)/4, width: UIScreen.main.bounds.width - itemImage.frame.origin.x - itemImage.bounds.width - 10, height:table.rowHeight/2))
        name.textAlignment = .left
        name.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/16.2)
        cell.addSubview(name)
        
//        let name = UILabel(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width, height: 40))
//        cell.addSubview(name)
        switch indexPath.section {
        case 0:
           // cell.textLabel?.text = starters[indexPath.row].itemName
            let url = URL(string: starters[indexPath.row].itemUrl!)
            itemImage.setImageWith(url, usingActivityIndicatorStyle: .gray)
            name.text = starters[indexPath.row].itemName
            break
        case 1:
            //cell.textLabel?.text = mainCourse[indexPath.row].itemName
            let url = URL(string: mainCourse[indexPath.row].itemUrl!)
            itemImage.setImageWith(url, usingActivityIndicatorStyle: .gray)
            name.text = mainCourse[indexPath.row].itemName
            break
        case 2:
            //cell.textLabel?.text = deserts[indexPath.row].itemName
            let url = URL(string: deserts[indexPath.row].itemUrl!)
            itemImage.setImageWith(url, usingActivityIndicatorStyle: .gray)
            name.text = deserts[indexPath.row].itemName
        default: break
            // nothing
        }
        
        return cell;
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func sortMenuData() -> ([Item],[Item],[Item]){
        // sorting data displaying items which are availale first
        var strs = [Item]()
        var mcs = [Item]()
        var desrts = [Item]()
        let selectedDate = MiscData().getSelectedDate()
       
        var sortedData = [Item]()
        let data = MenuItemsData().getMenu()
        if data.1 != 0 && data.2 {
                for item in data.0 {
                    if item.itemCategeory == "Straters" && checkForitemAvailablefor(weekday: DateHandler().getDayofweekfor(date: selectedDate), item: item){
                        strs.append(item)
                    }
                }
               
                for item in data.0 {
                    if item.itemCategeory == "Main Course" && checkForitemAvailablefor(weekday: DateHandler().getDayofweekfor(date: selectedDate), item: item){
                        mcs.append(item)
                    }
                }
               
                for item in data.0 {
                    if item.itemCategeory == "Desert" && checkForitemAvailablefor(weekday: DateHandler().getDayofweekfor(date: selectedDate), item: item){
                        desrts.append(item)
                    }
                }
                
                
            
        }
        return (strs,mcs,desrts)
    }
    
    
    func checkForitemAvailablefor(weekday : Int , item :Item) -> Bool {
        switch weekday - 1{
        case 0:
            if item.availableSunday == "1" {
                return true
            }
            break
        case 1:
            if item.availableMonday == "1" {
                return true
            }
            break
        case 2:
            if item.availableTuesday == "1" {
                return true
            }
            break
        case 3:
            if item.availableWednesday == "1" {
                return true
            }
            break
        case 4:
            if item.availableThrusday == "1" {
                return true
            }
            break
        case 5:
            if item.availableFriday == "1" {
                return true
            }
            break
        case 6:
            if item.availableSaturday == "1" {
                return true
            }
            break
        default:
            return false
        }
        return false
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
