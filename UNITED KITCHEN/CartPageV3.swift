//
//  CartPageV3.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 13/11/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView
import DCAnimationKit
import Firebase
import UIDropDown
//import DropDown

class CartPageV3: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    var ref : DatabaseReference!
    
    
    @IBOutlet weak var table: UITableView!
    var navbarIndicator = UIActivityIndicatorView()
    var profileCount = 0
    let backendless = Backendless.sharedInstance()
    var itemCount = 0
    var menuItems = [Item]()
    var splCell = AddressSelectionCell()
    var giftCell = GiftedPersonDetailsCell()
    var addrCell = AddressCell()
    var locCell = LocationCell()
    var cartItems = [Cart]()
    var allDatesArray = [String]()
    var itemsArrayINPARWITHDates = [[Cart]]()
    var sectionHeaders = [String]()
    var lunchDates = [String]()
    var dinnerDates = [String]()
    var dates = [String]()
    var datesD = [Date]()
    var times = [String]()
    var segItems = [Cart]()
    var itemsSaved = [[OrderItems]]()
    var orderCount = 0
    
    var allDates = [Date]()
    var allTimes = [String]()
    var statusArray = [Bool]()
    var tobeRemovedItems = [String]()
    var orderIds = [String]()
    var noItemsLabel = UILabel()
    
    var savedItems = [[OrderItems]]()
    
    var isGifted = false
    var giftName = ""
    var giftNumber = ""
    var giftAddress = ""
    
    var ordersSaved = 0
    
   // var popupView = UIView()
    var areas = [String]()
    var slots = [String]()
    var slotCells = [UITableViewCell]()
    var areadd = UIDropDown()
    var timedd = UIDropDown()
    var timesDictionary : NSDictionary = [:]
    var popupView = UIView()
    var intr_addressType = 0
//    var areasNslotsForLunch = [String:String]()
//    var areasNslotsForDinner = [String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        ref = Database.database().reference()
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([left!,spinner], animated: true)
        
        noItemsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        noItemsLabel.textAlignment = .center
        noItemsLabel.textColor = UIColor.gray
        noItemsLabel.text = "No Items"
        noItemsLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        noItemsLabel.font = UIFont.systemFont(ofSize: 50)
        self.view.addSubview(noItemsLabel)
        
       // createPopupVIew()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
       
        
        
        
        tabBarController?.tabBar.items?[1].badgeValue = nil
        table.allowsSelection = false
        slotCells.removeAll()
        sectionHeaders.removeAll()
        dates.removeAll()
        times.removeAll()
        lunchDates.removeAll()
        dinnerDates.removeAll()
        allDatesArray.removeAll()
        itemsArrayINPARWITHDates.removeAll()
        profileCount = ProfileData().profileCount().0
        
        
        
        let cart = CartData().getItems()
        let menu = MenuItemsData().getMenu()
        if cart.2 && menu.2{
            cartItems.removeAll()
            cartItems = cart.0
            itemCount = cart.1
            menuItems.removeAll()
            menuItems = menu.0
        }
        
       
        // create dates list
        if itemCount != 0 {
            
            for item in cartItems {
                if item.deliveryTime == "Lunch" {
                    let dateString = DateHandler().dateToString(date: item.addedDate!)
                    if !lunchDates.contains(dateString) {
                        lunchDates.append(dateString)
                    }
                    if !allDatesArray.contains(dateString) {
                        allDatesArray.append(dateString)
                    }
                } else if item.deliveryTime == "Dinner" {
                    let dateSTring = DateHandler().dateToString(date: item.addedDate!)
                    if !dinnerDates.contains(dateSTring) {
                        dinnerDates.append(dateSTring)
                    }
                    if !allDatesArray.contains(dateSTring) {
                        allDatesArray.append(dateSTring)
                    }
                }
            }
           
            
            // section headers
            
            for date in allDatesArray {
                if lunchDates.contains(date) {
                    sectionHeaders.append(date+" (Lunch)")
                    dates.append(date)
                    times.append("Lunch")
                }
                if dinnerDates.contains(date) {
                    sectionHeaders.append(date+" (Dinner)")
                    dates.append(date)
                    times.append("Dinner")
                }
            }
           
            
            for i in 0...(dates.count - 1) {
                segItems.removeAll()
                for item in cartItems {
                    if item.deliveryTime == times[i] {
                        if DateHandler().dateToString(date: item.addedDate!) == dates[i] {
                            segItems.append(item)
                        }
                    }
                }
                
                itemsArrayINPARWITHDates.append(segItems)
            }
        }
        
        table.reloadData()
        
        
        if itemCount == 0 {
            noItemsLabel.isHidden = false
        } else {
            noItemsLabel.isHidden = true
        }
       
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if itemCount == 0 {
            return 0
        } else if isGifted {
            return dates.count + 5
        }
        return lunchDates.count + dinnerDates.count + 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < dates.count {
            return dates[section]+" ("+times[section]+")"
        } else {
            switch section {
            case dates.count+1:
                return "Delivery Address"
            case dates.count+2:
                if profileCount == 0 {
                    return ""
                } else {
                    return "GPS Location"
                }
            case dates.count+3:
                if profileCount == 0 {
                    return ""
                } else {
                    return "Choose preferred address type for delivery"
                }
            case dates.count+4:
                return "Enter the details of recieving person"
            default:
                return ""
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/27)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.5*UIScreen.main.bounds.width/27
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dates.count {
            return itemsArrayINPARWITHDates[section].count
        } else {
            switch section {
            case dates.count:
                return 1
            case dates.count+1:
                return 1
            case dates.count+2:
                if profileCount == 0 {
                    return 0
                } else {
                    return 1
                }
            case dates.count+3:
                if profileCount == 0 {
                    return 0
                } else {
                    return 1
                }
            case dates.count+4:
                return 1
            default:
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section < dates.count {
//            if indexPath.row < itemsArrayINPARWITHDates[indexPath.section].count {
            let cell = table.dequeueReusableCell(withIdentifier: "items", for: indexPath) as! CartItems
            let item = itemsArrayINPARWITHDates[indexPath.section][indexPath.row]
            table.rowHeight = UIScreen.main.bounds.height/10 + 20
            let itemDetails = getItemDetails(name: item.itemName!)
            if itemDetails.1 {
                let url = URL(string: itemDetails.0.itemUrl!)
                cell.itemImage.setImageWith(url, usingActivityIndicatorStyle: .gray)
                cell.nameLabel.text = item.itemName
                cell.priceLabel.text = "$"+multiply(quantity: item.itemQuantity!, price: getPrice(item: itemDetails.0, code: DateHandler().daysFromTodayTo(date: item.addedDate!)))
                cell.addButton.tag = (indexPath.section*1000)+(indexPath.row)
                cell.addButton.addTarget(self, action: #selector(addButtonPressed(sender:)), for: .touchDown)
                cell.quantityLabel.text = item.itemQuantity
                cell.subButton.tag = (indexPath.section*1000)+(indexPath.row)
                cell.subButton.addTarget(self, action: #selector(subButtonPressed(sender:)), for: .touchDown)
                
            }
            return cell
//            } else {
//            let cell = table.dequeueReusableCell(withIdentifier: "items6", for: indexPath) as! SlotSelectionCell
//            table.rowHeight =  2 * (UIScreen.main.bounds.height/10 + 20)
//            cell.dropDown.tableDidAppear(completion: { 
//                self.table.rowHeight = 3 * (UIScreen.main.bounds.height/10 + 20)
//                let path1 = NSIndexPath(row: indexPath.row, section: indexPath.section)
//                self.table.reloadRows(at: [path1 as IndexPath], with: .fade)
//            })
//            slotCells.append(cell)
//            return cell
//            }
            
        } else {
            
            switch indexPath.section {
                
            case dates.count:
                let cell = table.dequeueReusableCell(withIdentifier: "items1", for: indexPath)
                
                table.rowHeight = (UIScreen.main.bounds.height/16.2 + 20)
                cell.textLabel?.textAlignment = .right
                cell.textLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/16.2)
                cell.textLabel?.text = " Total : $"+getTotal()
                return cell
            case dates.count+1:
                addrCell = table.dequeueReusableCell(withIdentifier: "items2", for: indexPath) as! AddressCell
               
                if ProfileData().profileCount().0 == 0 {
                    table.rowHeight = UIScreen.main.bounds.height/10 + 20
                    addrCell.add.isHidden = false
                    addrCell.addressTV.isHidden = true
                    addrCell.addressChangeButton.isHidden = false
                    addrCell.add.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchDown)
                    
                } else {
                    
                    addrCell.add.isHidden = true
                    addrCell.addressTV.isHidden = false
                    addrCell.addressChangeButton.isHidden = false
                    addrCell.addressTV.text = ProfileData().getProfile().0.address
                    table.rowHeight = UIScreen.main.bounds.height/6 + 50
                }
                
                return addrCell
            case dates.count+2:
               
                locCell = table.dequeueReusableCell(withIdentifier: "items4", for: indexPath) as! LocationCell
                table.rowHeight = UIScreen.main.bounds.width + 40
                return locCell
            case dates.count+3:
                
                splCell = table.dequeueReusableCell(withIdentifier: "items3", for: indexPath) as! AddressSelectionCell
                
                table.rowHeight = UIScreen.main.bounds.width*0.525
                
                splCell.orderButton.addTarget(self, action: #selector(ordernowPressed(sender:)), for: .touchDown)
                
                splCell.giftButton.addTarget(self, action: #selector(giftitPressed(sender:)), for: .touchDown)
                
                
                return splCell
            case dates.count+4:
                
                giftCell = table.dequeueReusableCell(withIdentifier: "items5", for: indexPath) as! GiftedPersonDetailsCell
                table.rowHeight = UIScreen.main.bounds.height/2 + 20
                giftCell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                giftCell.proceedButton.addTarget(self, action: #selector(proceedPressed(sender:)), for: .touchDown)
                table.scrollToRow(at: indexPath, at: .bottom, animated: true)
                return giftCell
            default :
                return UITableViewCell()
            }
            
        }
        
        
        return UITableViewCell()
    }
    
    
    
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section < dates.count {
            if editingStyle == .delete {
                let itm = itemsArrayINPARWITHDates[indexPath.section][indexPath.row]
                
                if CartData().deleteItem(ofName: itm.itemName!, date: itm.addedDate!, time: itm.deliveryTime!) {
                    viewDidAppear(true)
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func getItemDetails( name : String) -> (Item,Bool) {
        
        for item in menuItems {
            if item.itemName == name {
                return (item , true)
            }
        }
        return (Item(),false)
    }
    
    func multiply(quantity : String , price : String ) -> String {
        
        let quan = Double(quantity)
        let pr = Double(price)
        let final = quan! * pr!
        return String(final)
        
        
    }
    
    func getPrice(item :Item ,code : Int) -> String {
        switch code {
        case 0:
            return item.priceToday!
        case 1:
            return item.priceTomorrow!
        default:
            return item.priceLater!
        }
    }
    
    @objc func addButtonPressed(sender : UIButton) {
        
        
        let tag = sender.tag
        let row = tag%1000
        let section = tag/1000
        let item = itemsArrayINPARWITHDates[section][row]
        if CartData().incrementQuantityfor(itemName: item.itemName!, date: item.addedDate!, time: item.deliveryTime!) {
            viewDidAppear(true)
        }
        
        
        
        
    }
    
    @objc func subButtonPressed(sender : UIButton) {
        
        let tag = sender.tag
        let row = tag%1000
        let section = tag/1000
        let item = itemsArrayINPARWITHDates[section][row]
        if item.itemQuantity != "1" {
            if CartData().decrementQuantityfor(itemName: item.itemName!, date: item.addedDate!, time: item.deliveryTime!) {
                viewDidAppear(true)
            }
        } else {
            if CartData().deleteItem(ofName: item.itemName!, date: item.addedDate!, time: item.deliveryTime!) {
                viewDidAppear(true)
            }
        }
        
    }
    
    @objc func ordernowPressed(sender : UIButton) {
        
        if splCell.b2.checkState.rawValue == "Checked" {
            if locCell.coordinate != nil {
                isGifted = false
                
                checkCheckBoxes()
            } else {
                SCLAlertView().showError("Location not found", subTitle: "We couldnt find your location. Please try again or redirect you delivery to registered address")
            }
            
        } else {
            isGifted = false
            
            checkCheckBoxes()
        }
        
    }
    
    @objc func giftitPressed(sender : UIButton) {
        if isGifted {
            isGifted = false
            table.reloadData()
        } else if !isGifted {
            isGifted = true
            table.reloadData()
        }
        
    }
    
    @objc func proceedPressed ( sender : UIButton) {
        
        if giftCell.nameTF.text?.characters.count == 0 {
            giftCell.nameTF.tada(nil)
        } else {
            if giftCell.mobileTF.text?.characters.count == 0 {
                giftCell.mobileTF.tada(nil)
            }else{
                if giftCell.addressTV.text.characters.count == 0 {
                    giftCell.addressTV.tada(nil)
                } else {
                    giftName = giftCell.nameTF.text!
                    giftNumber = giftCell.mobileTF.text!
                    giftAddress = giftCell.addressTV.text
                    checkCheckBoxes()
                    
                }
            }
        }
        
    }
    
    
    func checkCheckBoxes(){
        
        if splCell.b1.checkState.rawValue == "Unchecked" && splCell.b2.checkState.rawValue == "Unchecked" {
            
            SCLAlertView().showError("No selection found!!", subTitle: "Please select the type of address you want us to use for delivery")
        } else if splCell.b1.checkState.rawValue == "Checked" && splCell.b2.checkState.rawValue == "Unchecked" {
            
            checkForDateFireBase(addressType: 0)
        } else if splCell.b1.checkState.rawValue == "Unchecked" && splCell.b2.checkState.rawValue == "Checked" {
            
            checkForDateFireBase(addressType: 1)
        } else if splCell.b1.checkState.rawValue == "Checked" && splCell.b2.checkState.rawValue == "Checked" {
            
            SCLAlertView().showError("Invalid selection found!!", subTitle: "Please select only one type of address you want us to use for delivery")
        }
    }
    
    
    func checkForDateFireBase(addressType : Int){
        
        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navbarIndicator.startAnimating()
        giftCell.proceedButton.isEnabled = false
        splCell.orderButton.isEnabled = false
        splCell.giftButton.isEnabled = false
        
        allDates.removeAll()
        allTimes.removeAll()
        statusArray.removeAll()
        tobeRemovedItems.removeAll()
        
        
        for item in CartData().getItems().0 {
            allDates.append(item.addedDate!)
            allTimes.append(item.deliveryTime!)
        }
        
        ref.child("orderTimes").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
            self.navbarIndicator.stopAnimating()
            self.giftCell.proceedButton.isEnabled = true
            self.splCell.orderButton.isEnabled = true
            self.splCell.giftButton.isEnabled = true
            
            
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
            
            let fetchedTimes = OrderTimes()
            fetchedTimes.mondayLunch = String(mondayLunch!)
            fetchedTimes.mondayDinner = String(mondayDinner!)
            fetchedTimes.tuesdayLunch = String(tuesdayLunch!)
            fetchedTimes.tuesdayDinner = String(tuesdayDinner!)
            fetchedTimes.wednesdayLunch = String(wednesdayLunch!)
            fetchedTimes.wednesdayDinner = String(wednesdayDinner!)
            fetchedTimes.thrusdayLunch = String(thrusdayLunch!)
            fetchedTimes.thrusdayDinner = String(thrusdayDinner!)
            fetchedTimes.fridayLunch = String(fridayLunch!)
            fetchedTimes.fridayDinner = String(fridayDinner!)
            fetchedTimes.saturdayLunch = String(saturdayLunch!)
            fetchedTimes.saturdayDinner = String(saturdayDinner!)
            fetchedTimes.sundayLunch = String(sundayLunch!)
            fetchedTimes.sundayDinner = String(sundayDinner!)
            fetchedTimes.minAmount = String(minAmount!)
            
            let hour = Calendar.current.component(.hour, from: Date())
            
            for i in 0...(self.allDates.count - 1){
                let ppf = DateHandler().isPastPresenFuture(date: self.allDates[i])
                if ppf == 0 {
                    // pastDate
                    self.statusArray.append(false)
                } else if ppf == 1 {
                    // present
                    
                    let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: self.allDates[i]), data: fetchedTimes)
                    if self.allTimes[i] == "Lunch" {
                        if hour < endTimes.0 {
                            self.statusArray.append(true)
                        } else {
                            self.statusArray.append(false)
                        }
                    } else if self.allTimes[i] == "Dinner" {
                        if hour < endTimes.1 {
                            self.statusArray.append(true)
                        } else {
                            self.statusArray.append(false)
                        }
                    }
                } else if ppf == 2 {
                    // future
                    
                    let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: self.allDates[i]), data: fetchedTimes)
                    if self.allTimes[i] == "Lunch" {
                        if endTimes.0 == 0 {
                            self.statusArray.append(false)
                        } else {
                            self.statusArray.append(true)
                        }
                    } else if self.allTimes[i] == "Dinner" {
                        if endTimes.1 == 0 {
                            self.statusArray.append(false)
                        } else {
                            self.statusArray.append(true)
                        }
                    }
                }
                
            }
            
            //strings to be removed
            for i in 0...(self.statusArray.count - 1) {
                
                if !self.statusArray[i] {
                    let removedString = DateHandler().dateToString(date: self.allDates[i])+" ("+self.allTimes[i]+")"
                    // self.tobeRemovedItems.append(DateHandler().dateToString(date: self.allDates[i])+" ("+self.allTimes[i]+")")
                    if !self.tobeRemovedItems.contains(removedString) {
                        
                        self.tobeRemovedItems.append(removedString)
                    }
                }
            }
            
            if self.tobeRemovedItems.count == 0 {
                
                
                if Double(self.getTotal())! >= Double(fetchedTimes.minAmount!)! {
                    
                    self.placeOrder(addressType : addressType)
                
                    
                } else {
                    SCLAlertView().showWarning("Min. amout required", subTitle: "The minimun amount required to place an ordr is $\(fetchedTimes.minAmount!) \n Plese add more item \n P.S You can place order for future dates also to meet the min amount requirement")
                }
                
            } else {
                // display popup
                
                
                self.askForDelete(items : self.tobeRemovedItems)
            }
            
            
            
        }) { (error) in
            
            
            self.splCell.orderButton.isEnabled = true
            self.splCell.giftButton.isEnabled = true
            self.giftCell.proceedButton.isEnabled = true
            
            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
            self.navbarIndicator.stopAnimating()
            SCLAlertView().showError("Cannot connect", subTitle: "Cannot connect to kitchen with error : \(error). Please check your internet connection and try again")
            
        }
        
        
        
        
    }
    
    
    //not used moved to firebase
//    func checkForDate(addressType : Int) {
//        
//        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
//        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
//        navbarIndicator.startAnimating()
//        giftCell.proceedButton.isEnabled = false
//        splCell.orderButton.isEnabled = false
//        splCell.giftButton.isEnabled = false
//        
//        
//        allDates.removeAll()
//        allTimes.removeAll()
//        statusArray.removeAll()
//        tobeRemovedItems.removeAll()
//        
//        
//        
//        for item in CartData().getItems().0 {
//            allDates.append(item.addedDate!)
//            allTimes.append(item.deliveryTime!)
//        }
//        
//        backendless?.data.of(OrderTimes.ofClass()).find({ (data) in
//            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//            self.navbarIndicator.stopAnimating()
//            self.giftCell.proceedButton.isEnabled = true
//            self.splCell.orderButton.isEnabled = true
//            self.splCell.giftButton.isEnabled = true
//            
//            
//            if let fecthedTimes = data?[0] as? OrderTimes {
//                
//                
//                /**
//                 
//                 First check for past date
//                 if its past, turn false
//                 If its present or fute, check times
//                 **/
//                let hour = Calendar.current.component(.hour, from: Date())
//                for i in 0...(self.allDates.count - 1){
//                    let ppf = DateHandler().isPastPresenFuture(date: self.allDates[i])
//                    if ppf == 0 {
//                        // pastDate
//                        self.statusArray.append(false)
//                    } else if ppf == 1 {
//                        // present
//                        
//                        let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: self.allDates[i]), data: fecthedTimes)
//                        if self.allTimes[i] == "Lunch" {
//                            if hour < endTimes.0 {
//                                self.statusArray.append(true)
//                            } else {
//                                self.statusArray.append(false)
//                            }
//                        } else if self.allTimes[i] == "Dinner" {
//                            if hour < endTimes.1 {
//                                self.statusArray.append(true)
//                            } else {
//                                self.statusArray.append(false)
//                            }
//                        }
//                    } else if ppf == 2 {
//                        // future
//                        
//                        let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: self.allDates[i]), data: fecthedTimes)
//                        if self.allTimes[i] == "Lunch" {
//                            if endTimes.0 == 0 {
//                                self.statusArray.append(false)
//                            } else {
//                                self.statusArray.append(true)
//                            }
//                        } else if self.allTimes[i] == "Dinner" {
//                            if endTimes.1 == 0 {
//                                self.statusArray.append(false)
//                            } else {
//                                self.statusArray.append(true)
//                            }
//                        }
//                    }
//                    
//                }
//                
//                
//                //
//                
//                
//                //
//                //strings to be removed
//                for i in 0...(self.statusArray.count - 1) {
//                    
//                    if !self.statusArray[i] {
//                        let removedString = DateHandler().dateToString(date: self.allDates[i])+" ("+self.allTimes[i]+")"
//                        
//                        if !self.tobeRemovedItems.contains(removedString) {
//                            
//                            self.tobeRemovedItems.append(removedString)
//                        }
//                    }
//                }
//                
//                if self.tobeRemovedItems.count == 0 {
//                    
//                    
//                    if Double(self.getTotal())! >= Double(fecthedTimes.minAmount!)! {
//                        
//                        self.placeOrder(addressType : addressType)
//                        
//                    } else {
//                        SCLAlertView().showWarning("Min. amout required", subTitle: "The minimun amount required to place an ordr is $\(fecthedTimes.minAmount!) \n Plese add more item \n P.S You can place order for future dates also to meet the min amount requirement")
//                    }
//                    
//                } else {
//                    // display popup
//                    
//                    
//                    self.askForDelete(items : self.tobeRemovedItems)
//                }
//                
//                
//            }
//            }, error: { (error) in
//                self.splCell.orderButton.isEnabled = true
//                self.splCell.giftButton.isEnabled = true
//                self.giftCell.proceedButton.isEnabled = true
//                
//                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//                self.navbarIndicator.stopAnimating()
//                SCLAlertView().showError("Cannot connect", subTitle: "Cannot connect to kitchen with error : \(error?.detail!). Please check your internet connection and try again")
//        })
//        
//        
//        
//    }
    
    
    
    
    func placeOrder( addressType : Int) {
        
        intr_addressType = addressType
        
        navbarIndicator.startAnimating()
        
        //to-do 
       
        ref.child("slots").observeSingleEvent(of: .value, with: { (snapshot) in
            self.navbarIndicator.stopAnimating()
            if let intr_times = snapshot.value as? NSDictionary {
                // to-do continue
            self.timesDictionary = intr_times
                self.areas.removeAll()
                self.slots.removeAll()
                let popupString : String = self.itemsArrayINPARWITHDates[0][0].deliveryTime!+" on "+DateHandler().dateToString(date: self.itemsArrayINPARWITHDates[0][0].addedDate!)
//                let selectionTimeString = self.itemsArrayINPARWITHDates[0][0].deliveryTime
//                print(intr_times["lunchSlots"])
              
                self.createPopupVIew(count: 1, orderString: popupString, timeOfDay: self.itemsArrayINPARWITHDates[0][0].deliveryTime!, data: intr_times)
//                self.createPopupVIew(count: 1, orderString: popupString, timeOfDay: self.itemsArrayINPARWITHDates[0][0].deliveryTime!, data: intr_times, addressType: addressType)
                
                
            }
            
            
            }) { (error) in
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showError("Cannot connect", subTitle: "Cannot connect to kitchen with error : \(error). Please check your internet connection and try again")
        }
        /**
         
         pass date
         argument also
         check in firebase and ask for locations
 **/
        
        // All orders are placed sequentially one after other , not simulatnaeously
        // in case of location type orders, first check for recieved location
        
        //to-do to be put back
        
//        if addressType == 1{
//            if locCell.coordinate != nil {
//                
//                navbarIndicator.startAnimating()
//                
//                generateOrderIds(addressType: 1)
//            } else {
//                SCLAlertView().showWarning("Location not found", subTitle: "We cannot determine your GPS location right now. Please press RETRY and try again or use another type of address mode")
//            }
        
//        } else {
//            
//            navbarIndicator.startAnimating()
//            
//            
//            generateOrderIds(addressType: 0)
//        }
        
        
        
    }
    
    func createPopupVIew(count : Int,orderString : String, timeOfDay : String, data : NSDictionary){
        
//        var tempArea : String = ""
//        var tempSlot : String = ""
        
       popupView = UIView(frame: CGRect(x: UIScreen.main.bounds.width/8, y: UIScreen.main.bounds.height/6, width: 6*UIScreen.main.bounds.width/8, height: 4*UIScreen.main.bounds.height/6))
        popupView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        let rect1 = UIView(frame: CGRect(x: popupView.bounds.origin.x+2, y: popupView.bounds.origin.y+2, width: popupView.bounds.width-4, height: popupView.bounds.height-4))
        rect1.backgroundColor = UIColor.white.withAlphaComponent(0)
       // rect1.backgroundColor = UIColor.blue
        rect1.layer.borderColor = UIColor.blue.cgColor
        rect1.layer.borderWidth = 1
        popupView.addSubview(rect1)
        let rect2 = UIView(frame: CGRect(x: popupView.bounds.origin.x+4, y: popupView.bounds.origin.y+4, width: popupView.bounds.width-8, height: popupView.bounds.height-8))
        rect2.backgroundColor = UIColor.white.withAlphaComponent(0)
        // rect1.backgroundColor = UIColor.blue
        rect2.layer.borderColor = UIColor.blue.cgColor
        rect2.layer.borderWidth = 1
        popupView.addSubview(rect2)
        let icon = UIImageView(frame: CGRect(x: popupView.bounds.origin.x, y: popupView.bounds.origin.y + 20, width: popupView.bounds.width, height: (UIScreen.main.bounds.width*40)/568))
        
        icon.image = UIImage(named: "time.png")
        icon.contentMode = .scaleAspectFit
        popupView.addSubview(icon)
        
        let inform_text = UITextView(frame: CGRect(x: popupView.bounds.origin.x + 20, y: icon.bounds.origin.y + icon.bounds.height + 20, width: popupView.bounds.width - 40, height: UIScreen.main.bounds.height * 120/568))
        
        inform_text.text = "Please select your area and time slot for delivery of your order for "+orderString
        inform_text.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 30/568)
        inform_text.isEditable = false
        inform_text.contentMode = .left
        popupView.addSubview(inform_text)
        
         areadd = UIDropDown(frame: CGRect(x: popupView.bounds.origin.x + 10, y: inform_text.bounds.origin.y + inform_text.bounds.height + 20, width: popupView.bounds.width - 20, height: (UIScreen.main.bounds.height*40)/568))
        areadd.placeholder = "Select your area of delivery"
        areadd.hideOptionsWhenSelect = true
        areadd.fontSize = UIScreen.main.bounds.height * 17/568
         popupView.addSubview(areadd)
        
        
        
        timedd = UIDropDown(frame: CGRect(x: popupView.bounds.origin.x + 10, y: inform_text.bounds.origin.y + inform_text.bounds.height + (UIScreen.main.bounds.height*40)/568 + 40, width: popupView.bounds.width - 20, height: (UIScreen.main.bounds.height*40)/568))

        timedd.placeholder = "Please select a time slot"
        timedd.hideOptionsWhenSelect = true
        timedd.isHidden = true
         areadd.fontSize = UIScreen.main.bounds.height * 17/568
        popupView.addSubview(timedd)
        
        
        let proceedButton = UIButton(frame: CGRect(x: popupView.bounds.origin.x + 20, y: inform_text.bounds.origin.y + inform_text.bounds.height + (UIScreen.main.bounds.height*80)/568 + 60, width: popupView.bounds.width - 40, height: (UIScreen.main.bounds.width)/8.1))
        proceedButton.backgroundColor = UIColor.blue
        proceedButton.setTitle("PROCEED", for: .normal)
        proceedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width/16.2)
        proceedButton.isHidden = true
        proceedButton.tag = count
        proceedButton.addTarget(self, action: #selector(popupProceedPressed(sender:)), for: .touchDown)
        popupView.addSubview(proceedButton)
        
//        var heightofButton = inform_text.bounds.origin.y + inform_text.bounds.height + (UIScreen.main.bounds.height*80)/568 + 100 + ((UIScreen.main.bounds.width)/8.1) + 30
        
        var heights = inform_text.bounds.origin.y
        heights += inform_text.bounds.height
        heights += UIScreen.main.bounds.height * 80/568
        heights += UIScreen.main.bounds.width/8.1
        heights += 80
        

        
        let cancelButton = UIButton(frame: CGRect(x: popupView.bounds.origin.x + 20, y: heights, width: popupView.bounds.width - 40, height: (UIScreen.main.bounds.width)/8.1))
        cancelButton.backgroundColor = UIColor.red
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width/16.2)
        cancelButton.isHidden = true
        //proceedButton.tag = count
        cancelButton.addTarget(self, action: #selector(popupCancelPressed(sender:)), for: .touchDown)
        popupView.addSubview(cancelButton)
        
        areadd.tableDidAppear {
            self.timedd.isHidden = true
            proceedButton.isHidden = true
            cancelButton.isHidden = true
        }
        
        timedd.tableDidAppear {
            //self.timedd.isHidden = true
            proceedButton.isHidden = true
            cancelButton.isHidden = true
        }
        
        
        if let areasPresent = data[timeOfDay] as? NSDictionary {
            areadd.options = areasPresent.allKeys as! [String]
            
            areadd.didSelect(completion: { (area, index) in
               // self.areas.append(area)
                   // self.areas[count - 1] = area
                if let slotsPResent = areasPresent[area] as? NSDictionary {
                    self.timedd.options.removeAll()
                    for key in slotsPResent.allKeys as! [String] {
                        self.timedd.options.append(slotsPResent[key] as! String)
                        self.timedd.isHidden = false
                    }
        
                }
            })
            
            timedd.didSelect(completion: { (slot, index) in
               // tempSlot = slot
                //self.slots[count - 1] = slot
                proceedButton.isHidden = false
                cancelButton.isHidden = false
            })
        }
        
    
       
       
        
        
        
        view.addSubview(popupView)
        
        

    
    }
    
    @objc func popupCancelPressed(sender:UIButton){
        areas.removeAll()
        slots.removeAll()
        popupView.removeFromSuperview()
    }
    
    @objc  func popupProceedPressed(sender : UIButton){
       
        
        areas.append(areadd.options[areadd.selectedIndex!])
        slots.append(timedd.options[timedd.selectedIndex!])
        
        
        
       // self.view.willRemoveSubview(popupView)
        
        popupView.removeFromSuperview()
        
        
        
        if sender.tag == itemsArrayINPARWITHDates.count {
            //to-do proceed
                    if intr_addressType == 1{
                        if locCell.coordinate != nil {
            
                            navbarIndicator.startAnimating()
            
                            generateOrderIds(addressType: 1)
                        } else {
                            SCLAlertView().showWarning("Location not found", subTitle: "We cannot determine your GPS location right now. Please press RETRY and try again or use another type of address mode")
                        }
            
                    } else {
            
                        navbarIndicator.startAnimating()
                        
                        
                        generateOrderIds(addressType: 0)
                    }
        } else {
            let popupString : String = self.itemsArrayINPARWITHDates[sender.tag][0].deliveryTime!+" on "+DateHandler().dateToString(date: self.itemsArrayINPARWITHDates[sender.tag][0].addedDate!)
            createPopupVIew(count: sender.tag + 1, orderString: popupString, timeOfDay: itemsArrayINPARWITHDates[sender.tag][0].deliveryTime!, data: timesDictionary)
        }

    }
    
    func generateOrderIds( addressType : Int) {
        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navbarIndicator.startAnimating()
        giftCell.proceedButton.isEnabled = false
        splCell.orderButton.isEnabled = false
        splCell.giftButton.isEnabled = false
        orderIds.removeAll()
        ordersSaved = 0
        for _ in 0...(dates.count - 1){
            
            let updatedProfile = ProfileData().incrementOrderCount().0
            orderIds.append(updatedProfile.phoneNumber!+updatedProfile.orderCount!)
            
        }
        
        // save profile in backendless
        self.navbarIndicator.startAnimating()
        
        backendless?.data.of(Profile.ofClass()).save(ProfileData().getProfile().0, response: { (data) in
            
            
            // save items
            // save orders
            /// relations are ignored
            
            self.saveOrders(addressType: addressType, updatedProfile: ProfileData().getProfile().0)
            }, error: { (fault) in
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                self.navbarIndicator.stopAnimating()
                
                SCLAlertView().showWarning("Apologies", subTitle: "Cannot place your order as the following error has occured \n\(fault?.message) \n Please try again")
        })
        
        
    }
    
    
    func saveOrders(addressType : Int, updatedProfile : Profile) {
        
        
        orderCount = 0
        
        for i in 0...(orderIds.count - 1) {
            
            let orderDetails = OrderDetails()
            orderDetails.orderId = orderIds[i]
            orderDetails.deliveryDate = itemsArrayINPARWITHDates[i][0].addedDate
            orderDetails.deliveryTime = getDeliveryTime(time: itemsArrayINPARWITHDates[i][0].deliveryTime!)
            orderDetails.status = "0"
            orderDetails.isDelivered = "0"
            orderDetails.locationTrackingChannel = "nil"
            orderDetails.addressType = String(addressType)
            
            orderDetails.area = areas[i]
            orderDetails.slot = slots[i]
            if !isGifted {
                orderDetails.phoneNumber = updatedProfile.phoneNumber
                orderDetails.customerName = updatedProfile.personName
                orderDetails.email = updatedProfile.emailAddress
                orderDetails.deliveryAddress = addrCell.addressTV.text
                orderDetails.isGifted = "0"
                orderDetails.giftedBy = "noone"
            }
            if isGifted {
                orderDetails.phoneNumber = giftNumber
                orderDetails.customerName = giftName
                orderDetails.email = "nil"
                orderDetails.deliveryAddress = giftAddress
                orderDetails.isGifted = "1"
                orderDetails.giftedBy = updatedProfile.phoneNumber
                orderDetails.addressType = "0"
            }
            if addressType == 0 {
                if locCell.coordinate != nil {
                    orderDetails.longitude = "\(locCell.coordinate?.longitude)"
                    orderDetails.latitude = "\(locCell.coordinate?.latitude)"
                    
                } else {
                    orderDetails.latitude = "0"
                    orderDetails.longitude = "0"
                }
            }
            if addressType == 1 {
                if locCell.coordinate != nil {
                    orderDetails.longitude = String(describing: locCell.coordinate?.longitude)
                    orderDetails.latitude = String(describing: locCell.coordinate?.latitude)
                }
            }
            
            
            initiateSave( items : itemsArrayINPARWITHDates[i], details : orderDetails , itemNumber : 1 , savedOrderItems: [OrderItems]())
            
            
        }
        
        isGifted = false
        
    }
    
    func initiateSave(items : [Cart], details : OrderDetails , itemNumber : Int , savedOrderItems : [OrderItems]) {
        
        if itemNumber <= items.count {
            let newItem = OrderItems()
            
            newItem.name = items[itemNumber - 1].itemName
            
            newItem.price = getPrice(item: getItemDetails(name: items[itemNumber - 1].itemName!).0, code: DateHandler().daysFromTodayTo(date: items[itemNumber - 1].addedDate!))
            newItem.orderId = details.orderId
            newItem.quantity = items[itemNumber - 1].itemQuantity
            
            backendless?.data.of(OrderItems.ofClass()).save(newItem, response: { (result) in
                if let data = result as? OrderItems {
                    
                    var intr = savedOrderItems
                    intr.append(data)
                    self.initiateSave(items: items, details: details, itemNumber: itemNumber + 1, savedOrderItems: intr)
                }
                }, error: { (error) in
                    self.splCell.orderButton.isEnabled = true
                    self.splCell.giftButton.isEnabled = true
                    self.giftCell.proceedButton.isEnabled = true
                    
                    self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                    self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.navbarIndicator.stopAnimating()
                    self.navbarIndicator.stopAnimating()
                    SCLAlertView().showWarning("Error", subTitle: "We cannot place the order as the following error has occured \n \(error?.message) Please try again ")
                    
            })
        } else {
            backendless?.data.of(OrderDetails.ofClass()).save(details, response: { (result) in
                if let data = result as? OrderDetails {
                    
                    self.sendNotification(data: data)
                    data.items = savedOrderItems
                    if OrderData().addOrder(orderDetails: data) {
                        self.orderCount += 1
                        if self.orderCount == self.orderIds.count {
                            self.navbarIndicator.stopAnimating()
                            if CartData().deleteCart() {
                                self.splCell.orderButton.isEnabled = true
                                self.splCell.giftButton.isEnabled = true
                                self.giftCell.proceedButton.isEnabled = true
                                
                                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                                self.navbarIndicator.stopAnimating()
                                self.tabBarController?.selectedIndex = 2
                            }
                        } else {
                            for item in items {
                                if CartData().deleteItem(ofName: item.itemName!, date: item.addedDate!, time: item.deliveryTime!) {
                                    // do nothing
                                }
                            }
                        }
                    }
                }
                
                
                }, error: { (error) in
                    self.splCell.orderButton.isEnabled = true
                    self.splCell.giftButton.isEnabled = true
                    self.giftCell.proceedButton.isEnabled = true
                    
                    self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                    self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.navbarIndicator.stopAnimating()
                    self.navbarIndicator.stopAnimating()
                    SCLAlertView().showWarning("Error", subTitle: "We cannot place the order as the following error has occured \n \(error?.message) Please try again ")
            })
        }
        
        
        
        
    }
    
    func sendNotification(data : OrderDetails) {
        
        let publishOptions = PublishOptions()
        let headers = ["ios-alert":"New Order recieved","ios-badge":"1","ios-sound":"default","type":"neworder","orderId":data.orderId!]
        publishOptions.assignHeaders(headers)
        
        backendless?.messaging.publish("admin", message: "New order", publishOptions: publishOptions, response: { (status) in
            
            }, error: { (error) in
                
        })
    }
    
    
    
    
    func askForDelete( items : [String]) {
        var rm = ""
        for item in items {
            rm = rm + item + "\n"
        }
        
        SCLAlertView().showWarning("Apologies", subTitle: "We are sorry to inform you that we are not accpting any orders for the follwing dates and times. Please delete those items and proceed \n" + rm)
    }
    
    
    func closeTimes(weekday : Int,data : OrderTimes) -> (Int,Int) {
        
        switch weekday {
        case 1:
            return (Int(data.sundayLunch!)! , Int(data.sundayDinner!)!)
        case 2:
            
            return (Int(data.mondayLunch!)! , Int(data.mondayDinner!)!)
        case 3:
            return (Int(data.tuesdayLunch!)! , Int(data.tuesdayDinner!)!)
        case 4:
            
            return (Int(data.wednesdayLunch!)! , Int(data.wednesdayDinner!)!)
        case 5:
            return (Int(data.thrusdayLunch!)! , Int(data.thrusdayDinner!)!)
        case 6:
            return (Int(data.fridayLunch!)! , Int(data.fridayDinner!)!)
        case 7:
            return (Int(data.saturdayLunch!)! , Int(data.saturdayDinner!)!)
        default:
            return (0,0)
        }
        
    }
    
    
    func getTotal() -> String {
        
        var total : Double = 0
        let items = CartData().getItems().0
        for item in items {
            let price = multiply(quantity: item.itemQuantity!, price: getPrice(item: getItemDetails(name: item.itemName!).0, code: DateHandler().daysFromTodayTo(date: item.addedDate!)))
            let priceD = Double(price)
            total = total + priceD!
        }
        return String(total)
        
    }
    
    @objc func loginPressed(sender:UIButton){
        self.tabBarController?.selectedIndex = 4
    }
    
    
    
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if CartData().deleteCart() {
            
            itemCount = 0
            table.reloadData()
            noItemsLabel.isHidden = false
            
        }
    }
    
    func getDeliveryTime(time : String) -> String {
        switch time {
        case "Lunch":
            return "0"
        case "Dinner":
            return "1"
        default:
            return "0"
        }
    }
    
    
    
}
