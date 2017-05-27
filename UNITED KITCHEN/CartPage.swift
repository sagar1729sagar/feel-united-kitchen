//
//  CartPage.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 27/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SDWebImage
import UIActivityIndicator_for_SDWebImage
import SCLAlertView
import M13Checkbox
import DCAnimationKit

class CartPage: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    let backendless = Backendless.sharedInstance()
    
    var cartItems = [Cart]()
    var itemCount = 0
    var menuItems = [Item]()
    var addressChecked = "Unchecked"
    var locationChecked = "Checked"
    var splCell = AddressSelectionCell()
    var giftCell = GiftedPersonDetailsCell()
    var addrCell = AddressCell()
    var locCell = LocationCell()
    let warning = UIImage(named: "warning.png")
    var navbarIndicator = UIActivityIndicatorView()
    var isGifted = false
    var profileCount = 0
    var giftName = ""
    var giftNumber = ""
    var giftAddress = ""
    var savedItems = [OrderItems]()


    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("Didappear table")
        
        profileCount = ProfileData().profileCount().0
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([left!,spinner], animated: true)
        
        
        tabBarController?.tabBar.items?[1].badgeValue = nil
        
        table.allowsSelection = false
        
        let cart = CartData().getItems()
        let menu = MenuItemsData().getMenu()
        if cart.2 && menu.2{
            cartItems.removeAll()
            cartItems = cart.0
            itemCount = cart.1
            menuItems.removeAll()
            menuItems = menu.0
        }
        table.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if itemCount == 0 {
            return 0
        } else if isGifted {
            return 6
        }
       return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemCount
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            if profileCount == 0 {
            return 0
            } else {
            return 1
            }
        case 4:
            if profileCount == 0 {
                return 0
            } else {
                return 1
            }
        case 5 :
            return 1
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Items : "
        case 2:
            return "Delivery Address"
        case 3:
            if profileCount == 0 {
            return ""
            } else {
            return "Delivery Location"
            }
        case 4:
            if profileCount == 0 {
                return ""
            } else {
            return "Choose address type to use"
            }
        case 5:
            return "Enter the details of recieving person"
        default:
            return ""
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isGifted {
        table.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        switch indexPath.section {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "items", for: indexPath) as! CartItems
            table.rowHeight = UIScreen.main.bounds.height/10 + 20
            let itemDetails = getItemDetails(name: cartItems[indexPath.row].itemName!)
            if itemDetails.1 {
            let url = URL(string: itemDetails.0.itemUrl!)
            cell.itemImage.setImageWith(url, usingActivityIndicatorStyle: .gray)
//            cell.priceLabel = getPrice(item: itemDetails.0, code: DateHandler().daysFromTodayTo(date: cartItems[indexPath.row].addedDate!))
            cell.nameLabel.text = cartItems[indexPath.row].itemName
            cell.priceLabel.text = "$"+multiply(quantity: cartItems[indexPath.row].itemQuantity!, price: getPrice(item: itemDetails.0, code: DateHandler().daysFromTodayTo(date: cartItems[indexPath.row].addedDate!)))
            cell.addButton.tag = indexPath.row
            cell.addButton.addTarget(self, action: #selector(addButtonPressed(sender:)), for: .touchDown)
            cell.quantityLabel.text = cartItems[indexPath.row].itemQuantity
            cell.subButton.tag = indexPath.row
            cell.subButton.addTarget(self, action: #selector(subButtonPressed(sender:)), for: .touchDown)
           
            
            }
            return cell
            
        case 1 :
            let cell = table.dequeueReusableCell(withIdentifier: "items1", for: indexPath)
            table.rowHeight = (UIScreen.main.bounds.height/10 + 20)/3
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.text = " Total : $"+getTotal()
            return cell
        
        case 2 :
            addrCell = table.dequeueReusableCell(withIdentifier: "items2", for: indexPath) as! AddressCell
            
            if ProfileData().profileCount().0 == 0 {
                table.rowHeight = UIScreen.main.bounds.height/10 + 20
                addrCell.add.isHidden = false
                addrCell.addressTV.isHidden = true
                addrCell.addressChangeButton.isHidden = false
                addrCell.add.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchDown)
                print("Add called")
            } else {
                print("Address called")
                addrCell.add.isHidden = true
                addrCell.addressTV.isHidden = false
                addrCell.addressChangeButton.isHidden = false
                addrCell.addressTV.text = ProfileData().getProfile().0.address
                table.rowHeight = UIScreen.main.bounds.height/6 + 50
            }

            return addrCell
        case 3:
            locCell = table.dequeueReusableCell(withIdentifier: "items4", for: indexPath) as! LocationCell
            table.rowHeight = UIScreen.main.bounds.width + 40
            return locCell
        case 4 :
            splCell = table.dequeueReusableCell(withIdentifier: "items3", for: indexPath) as! AddressSelectionCell
            table.rowHeight = 220
            splCell.orderButton.addTarget(self, action: #selector(ordernowPressed(sender:)), for: .touchDown)
            splCell.giftButton.addTarget(self, action: #selector(giftitPressed(sender:)), for: .touchDown)
            
            return splCell
        case 5:
            giftCell = table.dequeueReusableCell(withIdentifier: "items5", for: indexPath) as! GiftedPersonDetailsCell
            table.rowHeight = UIScreen.main.bounds.height/2 + 20
            giftCell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            giftCell.proceedButton.addTarget(self, action: #selector(proceedPressed(sender:)), for: .touchDown)
            table.scrollToRow(at: indexPath, at: .bottom, animated: true)
            return giftCell
            
        default:
            return UITableViewCell()
        }
        
        
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        if editingStyle == .delete {
          //  if CartData().deleteItem(ofName: cartItems[indexPath.row].itemName!) {
            if CartData().deleteItem(ofName: cartItems[indexPath.row].itemName!, date: Date(), time: "Lunch") {
                viewDidAppear(true)
            }
        }
        }
    }
    
    func giftitPressed(sender : UIButton) {
//        isGifted = true
//     //   splCell.orderButton.isEnabled = false
//      //  splCell.giftButton.isEnabled = false
//        table.reloadData()
//       // checkCheckBoxes()
        
        if isGifted {
            isGifted = false
            table.reloadData()
        } else if !isGifted {
            isGifted = true
            table.reloadData()
        }
    }
    
    func proceedPressed(sender:UIButton){
        
        
        
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
//                    giftCell.proceedButton.isEnabled = false
//                    splCell.orderButton.isEnabled = false
//                    splCell.giftButton.isEnabled = false
                    //splCell.orderButton.isEnabled = false
                    checkCheckBoxes()
                }
            }
        }
    
    }
    
    func ordernowPressed( sender : UIButton){
//        splCell.orderButton.isEnabled = false
//        splCell.giftButton.isEnabled = false
        isGifted = false
        print("Ordernow pressed")
        checkCheckBoxes()
        
//        print(splCell.b1.checkState.rawValue)
//        print(splCell.b2.checkState.rawValue)
//        if splCell.b1.checkState.rawValue == "Unchecked" && splCell.b2.checkState.rawValue == "Unchecked" {
//            SCLAlertView().showError("No selection found!!", subTitle: "Please select the type of address you want us to use for delivery")
//        } else if splCell.b1.checkState.rawValue == "Checked" && splCell.b2.checkState.rawValue == "Unchecked" {
//            print("Address is used")
//            checkForDate(addressType: 0)
//        } else if splCell.b1.checkState.rawValue == "Unchecked" && splCell.b2.checkState.rawValue == "Checked" {
//            print("Location is used")
//            checkForDate(addressType: 1)
//        } else if splCell.b1.checkState.rawValue == "Checked" && splCell.b2.checkState.rawValue == "Checked" {
//            print("Both are used")
//            SCLAlertView().showError("Invalid selection found!!", subTitle: "Please select only one type of address you want us to use for delivery")
//        }
    }
    
    func checkCheckBoxes(){
        print(splCell.b1.checkState.rawValue)
        print(splCell.b2.checkState.rawValue)
        if splCell.b1.checkState.rawValue == "Unchecked" && splCell.b2.checkState.rawValue == "Unchecked" {
          //  splCell.orderButton.isEnabled = true
           // splCell.giftButton.isEnabled = true
            //giftCell.proceedButton.isEnabled = true
            SCLAlertView().showError("No selection found!!", subTitle: "Please select the type of address you want us to use for delivery")
        } else if splCell.b1.checkState.rawValue == "Checked" && splCell.b2.checkState.rawValue == "Unchecked" {
            print("Address is used")
            checkForDate(addressType: 0)
        } else if splCell.b1.checkState.rawValue == "Unchecked" && splCell.b2.checkState.rawValue == "Checked" {
            print("Location is used")
            checkForDate(addressType: 1)
        } else if splCell.b1.checkState.rawValue == "Checked" && splCell.b2.checkState.rawValue == "Checked" {
           // splCell.orderButton.isEnabled = true
            //splCell.giftButton.isEnabled = true
            //giftCell.proceedButton.isEnabled = true
            print("Both are used")
            SCLAlertView().showError("Invalid selection found!!", subTitle: "Please select only one type of address you want us to use for delivery")
        }
    }
    
    func checkForDate(addressType : Int) {
        let items = CartData().getItems().0
        var dates = [Date]()
        for item in items {
            if dates.count == 0 {
                dates.append(item.addedDate!)
            } else {
                if DateHandler().comapareDatesForSame(date1: item.addedDate!, date2: dates[dates.count - 1]){
                    // Do nothing
                } else {
                    dates.append(item.addedDate!)
                }
            }
            
        }
        
            
        
        if dates.count == 1 {
        // move to next step
        MiscData().addDate(date: dates[0])
        let ppf = DateHandler().isPastPresenFuture(date: MiscData().getSelectedDate())
            if ppf == 0 {
             //   splCell.orderButton.isEnabled = true
               // splCell.giftButton.isEnabled = true
                //giftCell.proceedButton.isEnabled = true
                SCLAlertView().showError("Invalid Date", subTitle: "Please delete cart and start fresh")
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                //splCell.giftButton.isEnabled = false
                isGifted = false
            } else {
                checkForavailabiltyofCartItems(addressType: addressType, date: MiscData().getSelectedDate())
      //  placeOrder(addressType: addressType)
            }
                } else {
        // ask to choose a date
           askToChooseADate(addressType: addressType, dates: dates)

        }
        
    }
    
    func askToChooseADate(addressType : Int , dates : [Date]){
        var lables = [UILabel]()
        var boxes = [M13Checkbox]()
        var checkedStatus = [Bool]()
        var checkedCount = 0
        print("I should choose date")
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 100), height: 40 + (dates.count*35)))
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 30))
        lb.text = "Please select a date"
        subView.addSubview(lb)
        
        
        
        let count = dates.count
        
        for i in 0...(count - 1){
            if i == 0 {
            let l1 = UILabel(frame: CGRect(x: 50, y: 35, width: subView.bounds.width - 50, height: 30))
            l1.text = DateHandler().dateToString(date: dates[i])
            subView.addSubview(l1)
            lables.append(l1)
           // let b1 = M13Checkbox(frame: CGRect(x: subView.bounds.width - 50, y: 35, width: 40, height: 30))
                let b1 = M13Checkbox(frame: CGRect(x: 10, y: 35, width: 40, height: 30))
            subView.addSubview(b1)
            boxes.append(b1)
            } else {
                let l1 = UILabel(frame: CGRect(x: 50, y: lables[i-1].frame.origin.y + lables[i-1].bounds.height + 5, width: UIScreen.main.bounds.width - 100, height: 30))
                l1.text = DateHandler().dateToString(date: dates[i])
                subView.addSubview(l1)
                lables.append(l1)
                
               // let b1 = M13Checkbox(frame: CGRect(x: subView.bounds.width - 50, y: boxes[i-1].frame.origin.y + boxes[i-1].bounds.height + 3, width: 40, height: 30))
                let b1 = M13Checkbox(frame: CGRect(x: 10, y: boxes[i-1].frame.origin.y + boxes[i-1].bounds.height + 3, width: 40, height: 30))
                subView.addSubview(b1)
                boxes.append(b1)
            }
        }
        
//        let l1 = UILabel(frame: CGRect(x: 0, y: 35, width: UIScreen.main.bounds.width - 100, height: 30))
        alert.customSubview = subView
        alert.addButton("Date Selected", backgroundColor: UIColor.blue, textColor: UIColor.white, showDurationStatus: true) {
            print("Selected pressed")
            for box in boxes {
                if box.checkState.rawValue == "Checked" {
                    checkedCount += 1
                    checkedStatus.append(true)
                } else {
                    checkedStatus.append(false)
                }
            }
            if checkedCount == 0 {
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                SCLAlertView().showWarning("No date selected!!", subTitle: "Select a date to continue")
            } else if checkedCount == 1 {
                // check for items in cart for avaialability in selected date
                for i in 0...(dates.count - 1) {
                    if checkedStatus[i] {
                        self.checkForavailabiltyofCartItems(addressType:
                            addressType, date: dates[i])
                        print("I came")
                    }
                }
            } else {
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                SCLAlertView().showWarning("Multiple dates!!", subTitle: "Select only one date to continue")
            }
        }
        alert.showInfo("Multiple dates found", subTitle: "Please select a date for your order delivery")
        
        
    }
    
    func checkForavailabiltyofCartItems(addressType : Int, date : Date){
    
        print("Check initiated")
        var availability = [Bool]()
        var notAvailableCount = 0
        // set selected date
        MiscData().addDate(date: date)
        // set dates in Cart DB
        CartData().updateDates(date: date)
       
        for i in 0...(cartItems.count - 1) {
//            availability[i] = checkForitemAvailablefor(weekday: DateHandler().getDayofweekfor(date: date), cartItem: cartItems[i], items: menuItems)
            availability.append(checkForitemAvailablefor(weekday: DateHandler().getDayofweekfor(date: date), cartItem: cartItems[i], items: menuItems))
        }
        
        for a in availability {
            if !a {
                notAvailableCount += 1
            }
        }
        
        if notAvailableCount == 0 {
            //  Proceed to price check
            let today = Date()
           // let selectedDate = MiscData().getSelectedDate()
//            if selectedDate == today {
//            print("Today is selected")
//            } else if selectedDate > today {
//            print("future is selected")
//            } else if selectedDate < today {
//            print("past is selected")
//            } else {
//            print("I got fooled")
//            }
            
            let dayCode = DateHandler().isPastPresenFuture(date: date)
            switch dayCode {
            case 0:
                print("past")
                splCell.orderButton.isEnabled = true
                splCell.giftButton.isEnabled = true
                giftCell.proceedButton.isEnabled = true
                SCLAlertView().showError("Date has passed", subTitle: "the date selected was in past. Please delete the cart and start fresh")
                break
            case 1:
                print("present")
                
                // As selected date is added to cart, no need for a price adjusmnet again
                viewDidAppear(true)
                placeOrder(addressType: addressType)
                break
            case 2:
                print("future")
                
                // As selected date is added to cart, no need for a price adjusmnet again
                viewDidAppear(true)
                placeOrder(addressType: addressType)
                break
            default:
                print("days just flew")
            }
        } else {
            // ask to delete
            askItemsToDelete(addressType: addressType, availabilities: availability)
        }
    }

    func placeOrder(addressType : Int){
    print("place order")
    
        if DateHandler().isTodayDate(date: MiscData().getSelectedDate()) {
            checkOrderTimes(addressType: addressType)
            // get orderclose times
//           let hour = calendar.component(.hour, from: today)
//            print(hour)
//            if hour > 13 && hour < 20 {
//            let colr = UIColor(red: 0/255, green: 255/255, blue: 127/255, alpha: 1)
//            let orderImage = UIImage(named: "order.png")
//            onlyDinner(addressType: addressType)
//                
//            } else if hour >= 20 {
//                SCLAlertView().showWarning("Closed", subTitle: "We are sorry but out orders are closed for today")
//                if CartData().deleteCart() {
//                    cartItems.removeAll()
//                    itemCount = 0
//                    table.reloadData()
//                }
//            } else {
//                
//                print("Lunch or dinner called")
//                lunchOrDinner(addressType: addressType)
//            }
        } else {
       // lunchOrDinner(addressType: addressType)
            checkNextDayOrderTimings(addressType: addressType)
        }
    }
    
    func checkNextDayOrderTimings(addressType : Int) {
        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navbarIndicator.startAnimating()
        giftCell.proceedButton.isEnabled = false
        splCell.orderButton.isEnabled = false
        splCell.giftButton.isEnabled = false
        
        backendless?.data.of(OrderTimes.ofClass()).find({ (data) in
            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
            self.navbarIndicator.stopAnimating()
            self.giftCell.proceedButton.isEnabled = true
            self.splCell.orderButton.isEnabled = true
            self.splCell.giftButton.isEnabled = true
            print("data found")
            if let times = data?[0] as? OrderTimes {
                let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: MiscData().getSelectedDate()), data: times)
                if endTimes.0 == 0 && endTimes.1 == 0 {
                    SCLAlertView().showWarning("Closed", subTitle: "We regret to inform you that we are not accepting any orders on your selected date. Please delete the cart and proceed with another date")
                } else if endTimes.0 == 0 && endTimes.1 != 0 {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                        let subView = UIView(frame: CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width - 100, height: 240))
                    let txt = UILabel(frame: CGRect(x: 5, y: 5, width: subView.bounds.width - 10, height: 240))
                    txt.text = "We are accepting orders only for dinner for your selected date. \n Would you like to proceed to order for dinner?"
                    txt.numberOfLines = 6
                    subView.addSubview(txt)
                    alert.customSubview = subView
                    alert.addButton("Proceed", action: { 
                        self.onlyDinner(addressType: addressType)
                    })
                    alert.addButton("Close", action: { 
                        alert.dismiss(animated: true, completion: { 
                            
                        })
                    })
                    alert.showInfo("Important", subTitle: "")
                } else if endTimes.0 != 0 && endTimes.1 == 0 {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    let subView = UIView(frame: CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width - 100, height: 240))
                    let txt = UILabel(frame: CGRect(x: 5, y: 5, width: subView.bounds.width - 10, height: 240))
                    txt.text = "We are accepting orders only for Lunch for your selected date. \n Would you like to proceed to order for Lunch?"
                    txt.numberOfLines = 6
                    subView.addSubview(txt)
                    alert.customSubview = subView
                    alert.addButton("Proceed", action: {
                       // self.onlyDinner(addressType: addressType)
                        self.onlyLunch(addressType: addressType)
                    })
                    alert.addButton("Close", action: {
                        alert.dismiss(animated: true, completion: {
                            
                        })
                    })
                    alert.showInfo("Important", subTitle: "")
                } else if endTimes.0 != 0 && endTimes.1 != 0 {
                self.lunchOrDinner(addressType: addressType)
                }
//                let today = Date()
//                let calendar = Calendar.current
//                let hour = calendar.component(.hour, from: today)
//                if endTimes.0 == 0 && endTimes.1 != 0 {
//                    if hour < endTimes.1 {
//                        self.onlyDinner(addressType: addressType)
//                    } else {
//                        //self.splCell.orderButton.isEnabled = true
//                        //self.splCell.giftButton.isEnabled = true
//                        //self.giftCell.proceedButton.isEnabled = true
//                        SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
//                        if CartData().deleteCart() {
//                            self.cartItems.removeAll()
//                            self.itemCount = 0
//                            self.table.reloadData()
//                        }
//                    }
//                }
//                
//                if endTimes.0 != 0 && endTimes.1 == 0 {
//                    if hour < endTimes.0 {
//                        self.onlyLunch(addressType: addressType)
//                    } else {
//                        // self.splCell.orderButton.isEnabled = true
//                        //self.splCell.giftButton.isEnabled = true
//                        //self.giftCell.proceedButton.isEnabled = true
//                        SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
//                        if CartData().deleteCart() {
//                            self.cartItems.removeAll()
//                            self.itemCount = 0
//                            self.table.reloadData()
//                        }
//                    }
//                }
//                
//                if endTimes.0 == 0 && endTimes.1 == 0 {
//                    self.splCell.orderButton.isEnabled = true
//                    self.splCell.giftButton.isEnabled = true
//                    self.giftCell.proceedButton.isEnabled = true
//                    SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
//                    if CartData().deleteCart() {
//                        self.cartItems.removeAll()
//                        self.itemCount = 0
//                        self.table.reloadData()
//                    }
//                }
//                
//                if endTimes.0 != 0 && endTimes.1 != 0{
//                    if hour < endTimes.0 {
//                        self.lunchOrDinner(addressType: addressType)
//                    } else if hour >= endTimes.0 && hour < endTimes.1 {
//                        self.onlyDinner(addressType: addressType)
//                    } else {
//                        self.splCell.orderButton.isEnabled = true
//                        self.splCell.giftButton.isEnabled = true
//                        self.giftCell.proceedButton.isEnabled = true
//                        SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
//                        if CartData().deleteCart() {
//                            self.cartItems.removeAll()
//                            self.itemCount = 0
//                            self.table.reloadData()
//                        }
//                    }
//                }
//                
//                
//                
            }
            }, error: { (error) in
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                print("data not found \(error)")
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showError("Cannot connect", subTitle: "Cannot connect to kitchen with error : \(error?.detail!). Please check your internet connection and try again")
        })
    }
    
    func checkOrderTimes(addressType : Int) {
        
        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navbarIndicator.startAnimating()
        giftCell.proceedButton.isEnabled = false
        splCell.orderButton.isEnabled = false
        splCell.giftButton.isEnabled = false
        
        backendless?.data.of(OrderTimes.ofClass()).find({ (data) in
            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
            self.navbarIndicator.stopAnimating()
            self.giftCell.proceedButton.isEnabled = true
            self.splCell.orderButton.isEnabled = true
            self.splCell.giftButton.isEnabled = true
            print("data found")
            if let times = data?[0] as? OrderTimes {
            let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: MiscData().getSelectedDate()), data: times)
                let today = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: today)
                if endTimes.0 == 0 && endTimes.1 != 0 {
                    if hour < endTimes.1 {
                    self.onlyDinner(addressType: addressType)
                    } else {
                        //self.splCell.orderButton.isEnabled = true
                        //self.splCell.giftButton.isEnabled = true
                        //self.giftCell.proceedButton.isEnabled = true
                    SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
                    if CartData().deleteCart() {
                    self.cartItems.removeAll()
                    self.itemCount = 0
                    self.table.reloadData()
                        }
                    }
                }
                
                if endTimes.0 != 0 && endTimes.1 == 0 {
                    if hour < endTimes.0 {
                    self.onlyLunch(addressType: addressType)
                    } else {
                       // self.splCell.orderButton.isEnabled = true
                        //self.splCell.giftButton.isEnabled = true
                        //self.giftCell.proceedButton.isEnabled = true
                    SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
                    if CartData().deleteCart() {
                    self.cartItems.removeAll()
                    self.itemCount = 0
                    self.table.reloadData()
                        }
                    }
                }
                
                if endTimes.0 == 0 && endTimes.1 == 0 {
                    self.splCell.orderButton.isEnabled = true
                    self.splCell.giftButton.isEnabled = true
                    self.giftCell.proceedButton.isEnabled = true
                    SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
                    if CartData().deleteCart() {
                        self.cartItems.removeAll()
                        self.itemCount = 0
                        self.table.reloadData()
                    }
                }
                
                if endTimes.0 != 0 && endTimes.1 != 0{
                    if hour < endTimes.0 {
                    self.lunchOrDinner(addressType: addressType)
                    } else if hour >= endTimes.0 && hour < endTimes.1 {
                    self.onlyDinner(addressType: addressType)
                    } else {
                        self.splCell.orderButton.isEnabled = true
                        self.splCell.giftButton.isEnabled = true
                        self.giftCell.proceedButton.isEnabled = true
                        SCLAlertView().showWarning("Closed", subTitle: "We are sorry but  orders are closed for today")
                        if CartData().deleteCart() {
                            self.cartItems.removeAll()
                            self.itemCount = 0
                            self.table.reloadData()
                        }
                    }
                }
                

            
            }
            }, error: { (error) in
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                print("data not found \(error)")
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showError("Cannot connect", subTitle: "Cannot connect to kitchen with error : \(error?.detail!). Please check your internet connection and try again")
        })
        
    }
    
    func closeTimes(weekday : Int,data : OrderTimes) -> (Int,Int) {
        print("close times called")
        
       switch weekday {
        case 1:
            return (Int(data.sundayLunch!)! , Int(data.sundayDinner!)!)
        case 2:
            print("Monday called")
            return (Int(data.mondayLunch!)! , Int(data.mondayDinner!)!)
        case 3:
            return (Int(data.tuesdayLunch!)! , Int(data.tuesdayDinner!)!)
       case 4:
           print("wednedday called")
           print(Int(data.wednesdayDinner!)!)
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
    
    func placeOderInitiate(addressType : Int, timeCode : Int) {
    /** 0-Lunch
        1 - Dinner
         
         save all items 
         write down item IDs 
         if any item is not saved, a check fucntion is called and it will list out the unsaved items.
         the , the unsaved items are saved again and hence repeated till al items are saved
         when all items are saved, it is proceeded to order item save and then relation to be established
 **/
        print("Order initiated")
        
        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navbarIndicator.startAnimating()
        giftCell.proceedButton.isEnabled = false
        splCell.orderButton.isEnabled = false
        splCell.giftButton.isEnabled = false

        
        let updatedProfile = ProfileData().incrementOrderCount().0
        
        backendless?.data.of(Profile.ofClass()).save(updatedProfile, response: { (data) in
            print("updated profile saved")
            if let prof = data as? Profile {
                if ProfileData().removeProfiles() {
                    if ProfileData().addProfile(profile: prof) {
                        // items to be added
                        var itemIds = [String : String]()
                          self.savedItems.removeAll()
                        for item in self.cartItems {
                            let newItem = OrderItems()
                            newItem.name = item.itemName
                            newItem.price = self.getPrice(item: self.getItemDetails(name: item.itemName!).0, code: DateHandler().daysFromTodayTo(date: MiscData().getSelectedDate()))
                            newItem.quantity = item.itemQuantity
                            newItem.orderId = updatedProfile.phoneNumber! + updatedProfile.orderCount!
                            
                          
                            
                            self.backendless?.data.of(OrderItems.ofClass()).save(newItem, response: { (data) in
                                if let result = data as? OrderItems {
                                    self.savedItems.append(result)
                                    print("ïtem saved \(result.name)")
                                    //itemIds.append([result.name! : result.objectId!])
                                    itemIds[result.name!] = result.objectId!
                                    if itemIds.count == self.cartItems.count {
                                        //self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems)
                                       // self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems, orderId: result.orderId!)
                                        self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems, orderId: result.orderId!, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile)
                                    }
                                    // itemIds.append([result.name : resul])
                                    
                                }
                                }, error: { (error) in
                                    print("cannot save item \(newItem.name) with error \(error)")
                                    // itemIds.append([newItem.name! : "no"])
                                    itemIds[newItem.name!] = "no"
                                    if itemIds.count == self.cartItems.count {
                                        //self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems)
                                       // self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems, orderId: newItem.orderId!)
                                        self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems, orderId: newItem.orderId!, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile)
                                    }
                            })
                        }
                    }
                }
            }
            }, error: { (error) in
                SCLAlertView().showError("Cannot place Order", subTitle: "Please check your internet connection and try again")
        })
//        let orderDetails = OrderDetails()
//        orderDetails.orderId = updatedProfile.phoneNumber! + updatedProfile.orderCount!
//        orderDetails.deliveryDate = MiscData().getSelectedDate()
//        orderDetails.deliveryTime = String(timeCode)
//        orderDetails.status = "0"
//        orderDetails.isDelivered = "0"
//        orderDetails.locationTrackingChannel = "nil"
//        orderDetails.addressType = String(addressType)
//        if !isGifted {
//        orderDetails.phoneNumber = updatedProfile.phoneNumber
//        orderDetails.customerName = updatedProfile.personName
//        orderDetails.email = updatedProfile.emailAddress
//        orderDetails.deliveryAddress = addrCell.addressTV.text
//        orderDetails.isGifted = "0"
//        orderDetails.giftedBy = "noone"
//        }
//        if isGifted {
//        orderDetails.phoneNumber = giftNumber
//        orderDetails.customerName = giftName
//        orderDetails.email = "nil"
//        orderDetails.deliveryAddress = giftAddress
//        orderDetails.isGifted = "1"
//        orderDetails.giftedBy = updatedProfile.phoneNumber
//        }
//        if addressType == 0 {
//            if locCell.coordinate != nil {
//            orderDetails.longitude = String(describing: locCell.coordinate?.longitude)
//            orderDetails.latitude = String(describing: locCell.coordinate?.latitude)
//            } else {
//            orderDetails.latitude = "0"
//            orderDetails.longitude = "0"
//            }
//            
//        }
//        if addressType == 1 {
//            if locCell.coordinate != nil {
//                orderDetails.longitude = String(describing: locCell.coordinate?.longitude)
//                orderDetails.latitude = String(describing: locCell.coordinate?.latitude)
//            } else {
//                self.splCell.orderButton.isEnabled = true
//                self.splCell.giftButton.isEnabled = true
//                self.giftCell.proceedButton.isEnabled = true
//                SCLAlertView().showWarning("Location not found", subTitle: "Please tap retry button to get your location or change address mode as your location cannot be determined at the moment")
//            }
//            
//        }
        
//       // items to be added
//        var itemIds = [String : String]()
//        for item in cartItems {
//            var newItem = OrderItems()
//            newItem.name = item.itemName
//            newItem.price = getPrice(item: getItemDetails(name: item.itemName!).0, code: DateHandler().daysFromTodayTo(date: MiscData().getSelectedDate()))
//            newItem.quantity = item.itemQuantity
//            newItem.orderId = updatedProfile.phoneNumber! + updatedProfile.orderCount!
        
//            // pop-up for saved items
//            var checkBoxes = [M13Checkbox]()
//            var buttons = [UIButton]()
//            let appearance = SCLAlertView.SCLAppearance(
//                            showCloseButton: false)
//            let alert = SCLAlertView(appearance: appearance)
//            let subView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 100))
//            for i in 0...(cartItems.count - 1) {
//            
//            }
            
            
//            
//            backendless?.data.of(OrderItems.ofClass()).save(newItem, response: { (data) in
//                if let result = data as? OrderItems {
//                print("ïtem saved \(result.name)")
//                    //itemIds.append([result.name! : result.objectId!])
//                    itemIds[result.name!] = result.objectId!
//                    if itemIds.count == self.cartItems.count {
//                        //self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems)
//                        self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems, orderId: result.orderId!)
//                    }
//                   // itemIds.append([result.name : resul])
//                    
//                }
//                }, error: { (error) in
//                    print("cannot save item \(newItem.name) with error \(error)")
//                   // itemIds.append([newItem.name! : "no"])
//                    itemIds[newItem.name!] = "no"
//                    if itemIds.count == self.cartItems.count {
//                        //self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems)
//                        self.checkForSaveStatus(itemIds: itemIds, items: self.cartItems, orderId: newItem.orderId!)
//                    }
//            })
//            
//            
//          //  orderDetails.items?.append(newItem)
//        }
    }
    
    func checkForSaveStatus(itemIds : [String:String], items : [Cart], orderId : String , timeCode : Int, addressType : Int, updatedProfile : Profile) {
            var unsavedNames = [String]()
            //navbarIndicator.stopAnimating()
            print("Check for status called")
            for item in cartItems {
                if itemIds[item.itemName!] == "no" {
                    unsavedNames.append(item.itemName!)
                }
            }
            
            if unsavedNames.count == 0 {
            print("All are saved")
                var ids = [String]()
                for item in cartItems {
                ids.append(itemIds[item.itemName!]!)
                }
            //  proceed to save order item
               // saveOrderDEtails(orderId: orderId, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile)
                saveOrderDEtails(orderId: orderId, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile, ids: ids)
                
            } else {
                for name in unsavedNames {
                // save again
                    print("save again required")
                //saveUnsavedItems(itemsIds: itemIds, items: items, unSavedlist: unsavedNames, orderId: orderId)
                    saveUnsavedItems(itemsIds: itemIds, items: items, unSavedlist: unsavedNames, orderId: orderId, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile)
                
                }
            }
            
        }
    
    func saveUnsavedItems(itemsIds : [String:String],items:[Cart],unSavedlist : [String], orderId : String, timeCode : Int, addressType : Int , updatedProfile : Profile){
        var ids = itemsIds
        var intrIds = [String:String]()
        
            for name in unSavedlist {
                for item in items {
                if name ==  item.itemName {
                    let itemToBeSaved = OrderItems()
                    itemToBeSaved.name = item.itemName
                    itemToBeSaved.orderId = orderId
                    itemToBeSaved.price = getPrice(item: getItemDetails(name: item.itemName!).0, code: DateHandler().daysFromTodayTo(date: MiscData().getSelectedDate()))
                    itemToBeSaved.quantity = item.itemQuantity
                    backendless?.data.of(OrderItems.ofClass()).save(itemToBeSaved, response: { (data) in
                        print("retyr items saved")
                        if let result = data as? OrderItems {
                            self.savedItems.append(result)
                        //ids[result.name!] = result.objectId
                        intrIds[result.name!] = result.objectId!
                        }
                        if intrIds.count == unSavedlist.count {
                            for nme in unSavedlist {
                            ids[nme] = intrIds[nme]
                            }
                          //  self.checkForSaveStatus(itemIds: ids, items: items)
                           // self.checkForSaveStatus(itemIds: ids, items: items, orderId: orderId)
                            self.checkForSaveStatus(itemIds: ids, items: items, orderId: orderId, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile)
                        }
                        }, error: { (error) in
                        intrIds[itemToBeSaved.name!] = "no"
                        print("retry item couldnt be saved")
                            if intrIds.count == unSavedlist.count {
                                for nme in unSavedlist {
                                    ids[nme] = intrIds[nme]
                                }
                              //  self.checkForSaveStatus(itemIds: ids, items: items)
                               // self.checkForSaveStatus(itemIds: ids, items: items, orderId: orderId)
                                self.checkForSaveStatus(itemIds: ids, items: items, orderId: orderId, timeCode: timeCode, addressType: addressType, updatedProfile: updatedProfile)
                            }
                    })
                }
            }
        
        }
    }
    
    
    func saveOrderDEtails(orderId : String, timeCode : Int , addressType : Int , updatedProfile : Profile, ids : [String]) {
        print(orderId)
                let orderDetails = OrderDetails()
                orderDetails.orderId = orderId
                orderDetails.deliveryDate = MiscData().getSelectedDate()
                orderDetails.deliveryTime = String(timeCode)
                orderDetails.status = "0"
                orderDetails.isDelivered = "0"
                orderDetails.locationTrackingChannel = "nil"
                orderDetails.addressType = String(addressType)
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
                    print(orderDetails.longitude!)
                    } else {
                    orderDetails.latitude = "0"
                    orderDetails.longitude = "0"
                    }
                    
                    backendless?.data.of(OrderDetails.ofClass()).save(orderDetails, response: { (data) in
                        print("order details aved successfully")
                        if let result = data as? OrderDetails {
                            self.createItemsRelation(ids: ids, data: result)
                            //            self.backendless?.data.of(OrderDetails.ofClass()).addRelation("items:OrderItems:n", parentObjectId: result.objectId, childObjects: ids, response: { (response) in
                            //                print("relation created successfully with response \(response)")
                            //                }, error: { (fzult) in
                            //                    print("failed to create relation with fualt \(fzult)")
                            //            })
                        }
                        }, error: { (error) in
                            print("order cannot be saved")
                            SCLAlertView().showError("Order cannot be placed", subTitle: "The following error has occured \n\(error?.message)\n Please try again")
                            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                            self.navbarIndicator.stopAnimating()
                            self.giftCell.proceedButton.isEnabled = true
                            self.splCell.orderButton.isEnabled = true
                            self.splCell.giftButton.isEnabled = true
                    })
        
                }
                if addressType == 1 {
                    if locCell.coordinate != nil {
                        orderDetails.longitude = String(describing: locCell.coordinate?.longitude)
                        orderDetails.latitude = String(describing: locCell.coordinate?.latitude)
                        print(" Deatils saving started")
                        backendless?.data.of(OrderDetails.ofClass()).save(orderDetails, response: { (data) in
                            print("order details aved successfully")
                            if let result = data as? OrderDetails {
                                self.createItemsRelation(ids: ids, data: result)
                                //            self.backendless?.data.of(OrderDetails.ofClass()).addRelation("items:OrderItems:n", parentObjectId: result.objectId, childObjects: ids, response: { (response) in
                                //                print("relation created successfully with response \(response)")
                                //                }, error: { (fzult) in
                                //                    print("failed to create relation with fualt \(fzult)")
                                //            })
                            }
                            }, error: { (error) in
                                print("order cannot be saved")
                                SCLAlertView().showError("Order cannot be placed", subTitle: "The following error has occured \n\(error?.message)\n Please try again")
                                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                                self.navbarIndicator.stopAnimating()
                                self.giftCell.proceedButton.isEnabled = true
                                self.splCell.orderButton.isEnabled = true
                                self.splCell.giftButton.isEnabled = true
                        })
                        
                        
                        
                        
                    } else {
                        // when location is not found
                        self.splCell.orderButton.isEnabled = true
                        self.splCell.giftButton.isEnabled = true
                        self.giftCell.proceedButton.isEnabled = true
                        SCLAlertView().showWarning("Location not found", subTitle: "Please tap retry button to get your location or change address mode as your location cannot be determined at the moment")
                        self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                        self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                        navbarIndicator.stopAnimating()
                        giftCell.proceedButton.isEnabled = true
                        splCell.orderButton.isEnabled = true
                        splCell.giftButton.isEnabled = true
                        
                    }
                    
                }
        
    

    
    }
    
    func createItemsRelation( ids : [String], data : OrderDetails) {
        
        backendless?.data.of(OrderDetails.ofClass()).addRelation("items:OrderItems:n", parentObjectId: data.objectId, childObjects: ids, response: { (nm) in
            print("relations created \(nm)")
            print("address type \(data.addressType)")
            // to - do if addresstype is location, add a geo point
            if data.addressType == "1"{
                print("Geo save started")
                self.saveGeoPoint(data: data)
            } else {
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                self.giftCell.proceedButton.isEnabled = true
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                data.items = self.savedItems
                self.isGifted = false
                self.sendMessage(data: data)
//                if OrderData().addOrder(orderDetails: data) {
//                    print("data added")
//                    if CartData().deleteCart() {
//                        //self.viewDidAppear(true)
//                        self.cartItems.removeAll()
//                        self.itemCount = 0
//                        self.table.reloadData()
//                        self.tabBarController?.selectedIndex = 2
//                    }
//                }
            }
            }, error: { (fault) in
                SCLAlertView().showError("Order cannot be placed", subTitle: "The following error has occured \n\(fault?.message)\n Please try again")
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                self.giftCell.proceedButton.isEnabled = true
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
        })
    
    }
    
    func saveGeoPoint(data : OrderDetails) {
        
        let point = GeoPoint()
       // point.latitude = locCell.coordinate?.latitude
      //  point.longitude = locCell.coordinate?.longitude
        
        point.latitude((locCell.coordinate?.latitude)!)
        point.longitude((locCell.coordinate?.longitude)!)
        point.addMetadata("order", value: data.orderId)
        
        backendless?.geoService.save(point, response: { (response) in
            print("geopoint saved with response \(response)")
           // if let loc = response as? GeoPoint {
                print("Casted to geopoint")
            self.addRelationToGeoPoint(data: data, point: response!)
            //}
            }, error: { (fault) in
                print("error saving geo point \(fault)")
                SCLAlertView().showError("GPS location not found", subTitle: "GPS location has not been consistent. We shall call you for delivery address as soon as your order is ready")
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                self.giftCell.proceedButton.isEnabled = true
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
        })
        
    }
    
    func addRelationToGeoPoint( data : OrderDetails , point : GeoPoint){
        
        backendless?.data.of(OrderDetails.ofClass()).addRelation("location:Default:1", parentObjectId: data.objectId, childObjects: [point.objectId], response: { (rel) in
            print("Geo location related with response \(rel)")
            self.sendMessage(data: data)
           // self.sendMessage(orderId: data.orderId!)
//            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//            self.navbarIndicator.stopAnimating()
//            self.giftCell.proceedButton.isEnabled = true
//            self.splCell.orderButton.isEnabled = true
//            self.splCell.giftButton.isEnabled = true
//            //to-do add relations in DB
//            data.items = self.savedItems
//            self.isGifted = false
//            if OrderData().addOrder(orderDetails: data) {
//            print("data added")
//                if CartData().deleteCart() {
////                self.viewDidAppear(true)
//                    self.cartItems.removeAll()
//                    self.itemCount = 0
//                    self.table.reloadData()
//                self.tabBarController?.selectedIndex = 2
//                }
//            }
            
            }, error: { (fault) in
                print("Geo relation addidn error \(fault)")
                SCLAlertView().showError("GPS location not found", subTitle: "GPS location has not been consistent. We shall call you for delivery address as soon as your order is ready")
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                self.giftCell.proceedButton.isEnabled = true
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                
        })
        
    }
    
    func LastTask( data : OrderDetails) {
        
                    self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                    self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.navbarIndicator.stopAnimating()
                    self.giftCell.proceedButton.isEnabled = true
                    self.splCell.orderButton.isEnabled = true
                    self.splCell.giftButton.isEnabled = true
                    //to-do add relations in DB
                    data.items = self.savedItems
                    self.isGifted = false
                    if OrderData().addOrder(orderDetails: data) {
                    print("data added")
                        if CartData().deleteCart() {
        //                self.viewDidAppear(true)
                            self.cartItems.removeAll()
                            self.itemCount = 0
                            self.table.reloadData()
                        self.tabBarController?.selectedIndex = 2
                        }
                    }

        
    }
    
    func sendMessage(data : OrderDetails ) {
        let reqChannel = "C"+ProfileData().getProfile().0.phoneNumber!
        // get registration
        backendless?.messaging.getRegistrationAsync({ (response) in
            print("reg info \(response)")
            if (response?.channels.contains(reqChannel))! {
                // proceed
               // self.sendNotification()
                self.sendNotification(data: data)
            } else {
                //registerToChannel(channel: reqChannel)
                // register
                self.registerToChannel(channel: reqChannel, data: data)
            }
            }, error: { (error) in
                print("reg info error \(error)")
                SCLAlertView().showNotice("Notice", subTitle: "Our notification services cannot reach your devices. Your order is placed tough but we are sorry to say that you may not recieve notifications. You can retry by logout and logging in again.")
                self.LastTask(data: data)
        })
    
    }
    
    func registerToChannel(channel : String, data : OrderDetails) {
        
        backendless?.messaging.registerDevice([channel], response: { (reponse) in
            print("channel registeres \(reponse)")
           // self.sendNotification()
            //self.sendMessage(data: data)
            self.sendNotification(data: data)
            
            }, error: { (fault) in
                print("cannot rgister to channel \(fault)")
                SCLAlertView().showNotice("Notice", subTitle: "Our notification services cannot reach your devices. Your order is placed tough but we are sorry to say that you may not recieve notifications. You can retry by logout and logging in again.")
                self.LastTask(data: data)
        })
    
    }
    
    func sendNotification(data : OrderDetails) {
        print("sending message")
        let publishOptions = PublishOptions()
        let headers = ["ios-alert":"New Order recieved","ios-badge":"1","ios-sound":"default","type":"neworder","orderId":data.orderId!]
        publishOptions.assignHeaders(headers)
        
        backendless?.messaging.publish("admin", message: "New order", publishOptions: publishOptions, response: { (status) in
            print("message publish success \(status)")
            self.LastTask(data: data)
            }, error: { (error) in
                print("Message publish error \(error)")
                self.LastTask(data: data)
        })
        
        
//        backendless?.messaging.publish("New order", publishOptions: publishOptions, response: { (status) in
//            print("message publish success \(status)")
//            self.LastTask(data: data)
//            }, error: { (error) in
//                print("Message publish error \(error)")
//            self.LastTask(data: data)
//        })
    }
    
    
//        func checkForItemsSave(ids : [[String:String]], itemCount : Int) -> Bool {
//              l
//        }
        
        // save in backendless
        
      //  let chidIds = [String]()
      //  for item in cartItems{
        
      //  }
        // study more on relations and experiment
        
//        backendless?.data.of(OrderDetails.ofClass()).save(orderDetails, response: { (data) in
//            print("order placed successfully")
//                        self.splCell.orderButton.isEnabled = true
//                        self.splCell.giftButton.isEnabled = true
//                        self.giftCell.proceedButton.isEnabled = true
//                        self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//                        self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//                        self.navbarIndicator.stopAnimating()
//            }, error: { (error) in
//                                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//                                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//                                self.navbarIndicator.stopAnimating()
//                                print("error \(error)")
//                                SCLAlertView().showError("Cannot place your order", subTitle: "The following error has occured \n\(error?.message)\nPlease try again")
//                        })
        
//        backendless?.data.save(orderDetails, response: { (data) in
//            print("order placed successfully")
//            self.splCell.orderButton.isEnabled = true
//            self.splCell.giftButton.isEnabled = true
//            self.giftCell.proceedButton.isEnabled = true
//            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//            self.navbarIndicator.stopAnimating()
//            // add to order db and delete cart and move to next tab
//            }, error: { (error) in
//                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
//                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
//                self.navbarIndicator.stopAnimating()
//                print("error \(error)")
//                SCLAlertView().showError("Cannot place your order", subTitle: "The following error has occured \n\(error?.message)\nPlease try again")
//        })
        
        
 //   }
    
        
        
    
        
//        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
//        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
//        navbarIndicator.startAnimating()
        // if gifted, show popup asking for phone number, verify it and then
        // check in backend, if registered user, go to create entry
        // if not registered user, then open anither popup asking for address and name and then create a profile
        // same used for gifted and normal ,so code carefully
        // datestring, isgifted and gifted to are needed extra
        
        
//        if isGifted{
//            
//            let appearance = SCLAlertView.SCLAppearance(
//                showCloseButton: false
//            )
//            let alert = SCLAlertView(appearance: appearance)
//            let subView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 100), height: 200))
//            let name = UITextField(frame: CGRect(x: 5, y: 5, width: subView.bounds.width - 10, height: 30))
//            name.layer.borderColor = UIColor.blue.cgColor
//            name.layer.borderWidth = 1
//            name.layer.cornerRadius = 5
//            name.placeholderText = "Enter name of the person"
//            subView.addSubview( name )
//            
//            let mobile = UITextField(frame: CGRect(x: 5, y: 40, width: subView.bounds.width - 10, height: 30))
//            mobile.layer.borderColor = UIColor.blue.cgColor
//            mobile.layer.borderWidth = 1
//            mobile.layer.cornerRadius = 5
//            mobile.placeholderText = "Enter mobile number"
//            mobile.keyboardType = .namePhonePad
//            subView.addSubview( mobile )
//            
//            let email = UITextField(frame: CGRect(x: 5, y: 75, width: subView.bounds.width - 10, height: 30))
//            email.layer.borderColor = UIColor.blue.cgColor
//            email.layer.borderWidth = 1
//            email.layer.cornerRadius = 5
//            email.placeholderText = "Enter email address"
//            email.keyboardType = .emailAddress
//            subView.addSubview( email )
//            
//            let address = UITableView(frame: CGRect(x: 5, y: 110, width: subView.bounds.width - 10, height: 50))
//            address.layer.borderWidth = 1
//            address.layer.borderColor = UIColor.blue.cgColor
//            address.layer.cornerRadius = 5
//            address.placeholderText = "Enter adddress"
//            subView.addSubview(address)
//            
//            alert.customSubview = subView
//            alert.addButton("Proceed", action: { 
//                if name.text?.characters.count != 0 {
//                
//                }else {
//                    name.tada(nil)
//                }
//            })
//            
//            alert.showInfo("Details", subTitle: "")
            
//        }else {
//            
//            createBackendlessEntry(addressType: addressType, timeCode: timeCode)
//        }
    
    
//    func createBackendlessEntry(addressType : Int , timeCode : Int) {
//                self.navigationItem.leftBarButtonItems?[0].isEnabled = false
//                self.navigationItem.rightBarButtonItems?[0].isEnabled = false
//                navbarIndicator.startAnimating()
//        
//    }
    
    func lunchOrDinner(addressType : Int) {
        
        var boxes = [M13Checkbox]()
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 100), height: 120))
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: subView.bounds.width, height: 30))
        lb.text = "When shall we deliver it?"
        subView.addSubview(lb)
        
        let b1 = M13Checkbox(frame: CGRect(x: 10, y: 40, width: 40, height: 30))
        subView.addSubview(b1)
        boxes.append(b1)
        let l1 = UILabel(frame: CGRect(x: 50, y: 40, width: subView.bounds.width - 50, height: 30))
        l1.text = "Lunch"
        subView.addSubview(l1)
        let b2 = M13Checkbox(frame: CGRect(x: 10, y: 80, width: 40, height: 30))
        subView.addSubview(b2)
        boxes.append(b2)
        let l2 = UILabel(frame: CGRect(x: 50, y: 80, width: subView.bounds.width - 50, height: 30))
        l2.text = "Dinner"
        subView.addSubview(l2)
        
        alert.customSubview = subView
        
        alert.addButton("Place order", backgroundColor: UIColor.blue, textColor: UIColor.white, showDurationStatus: true) { 
            
            if b1.checkState.rawValue == "Checked" && b2.checkState.rawValue == "Checked" {
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
                SCLAlertView().showWarning("Invalid selection", subTitle: "CHeck any one option only")
                
            } else if b1.checkState.rawValue == "Checked" && b2.checkState.rawValue == "Unchecked" {
            self.placeOderInitiate(addressType: addressType, timeCode: 0)
            } else if b1.checkState.rawValue == "Unchecked" && b2.checkState.rawValue == "Checked" {
            self.placeOderInitiate(addressType: addressType, timeCode: 1)
            } else if b1.checkState.rawValue == "Unchecked" && b2.checkState.rawValue == "Unchecked" {
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
            SCLAlertView().showWarning("No selection", subTitle: "Please select when to deliver")
            }
            
            
        }
        
        alert.showInfo("Lunch/Dinner?", subTitle: "")
        
        
    }
    
    
    func onlyDinner(addressType : Int) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 100), height: 40))
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: subView.bounds.width, height: 40))
        lb.text = "Confirm order for dinner?"
        subView.addSubview(lb)
        alert.customSubview = subView
        alert.addButton("Continue...", backgroundColor: UIColor.blue, textColor: UIColor.white, showDurationStatus: true) { 
            self.placeOderInitiate(addressType: addressType, timeCode: 1)
        }
        alert.showInfo("Confirm", subTitle: "")
        
    }
    
    func onlyLunch(addressType : Int) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 100), height: 40))
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: subView.bounds.width, height: 40))
        lb.text = "Confirm order for lunch?"
        subView.addSubview(lb)
        alert.customSubview = subView
        alert.addButton("Continue...", backgroundColor: UIColor.blue, textColor: UIColor.white, showDurationStatus: true) {
            self.placeOderInitiate(addressType: addressType, timeCode: 0)
        }
        alert.showInfo("Confirm", subTitle: "")
        
    }
    
    

    
    func askItemsToDelete(addressType : Int , availabilities : [Bool]) {
        splCell.orderButton.isEnabled = true
        splCell.giftButton.isEnabled = true
        giftCell.proceedButton.isEnabled = true
        print("Ask to delete")
        let alert = SCLAlertView()
        var NAItems = [String]()
        for i in 0...(availabilities.count - 1) {
            if !availabilities[i] {
                NAItems.append(cartItems[i].itemName!)
            }
        }
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 100), height: 100 + NAItems.count*35 ))
        let desTV = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 50))
        desTV.text = "The following items are not available for your selected date. Please delete them from the cart and place the order"
        subView.addSubview(desTV)
        
        for i in 0...(NAItems.count - 1) {
            let l1 = UILabel(frame: CGRect(x: 0, y: 55 + i*30, width: Int(UIScreen.main.bounds.width - 100), height: 30))
            l1.text = NAItems[i]
            subView.addSubview(l1)
        }
        
        alert.customSubview = subView
        alert.showInfo("Invalid items found", subTitle: "")
    }
    
    
    func addButtonPressed(sender : UIButton) {
        let cartItem = cartItems[sender.tag]
      //  if CartData().incrementQuantityfor(itemName: cartItem.itemName!) {
        if CartData().incrementQuantityfor(itemName: cartItem.itemName!, date: Date(), time: "Lunch") {
            let items = CartData().getItems()
            if items.2 {
            cartItems.removeAll()
            cartItems = items.0
            table.reloadData()
            }
            
        }
    }
    
    func subButtonPressed(sender:UIButton){
        
        let cartItem = cartItems[sender.tag]
       // if CartData().decrementQuantityfor(itemName: cartItem.itemName!) {
        if CartData().decrementQuantityfor(itemName: cartItem.itemName!, date: Date(), time: "Dinenr") {
            let items = CartData().getItems()
            if items.2 {
            cartItems.removeAll()
            cartItems = items.0
            table.reloadData()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func deleteCart(_ sender: UIBarButtonItem) {
        
        if CartData().deleteCart() {
            cartItems.removeAll()
            itemCount = 0
            table.reloadData()
        }
    }
    
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func getItemDetails( name : String) -> (Item,Bool) {
    
        for item in menuItems {
            if item.itemName == name {
                return (item , true)
            }
        }
        return (Item(),false)
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
    
    func multiply(quantity : String , price : String ) -> String {
    
        let quan = Double(quantity)
        let pr = Double(price)
        let final = quan! * pr!
        return String(final)
        
        
    }
    
    func getTotal() -> String {
        print("Called")
        var total : Double = 0
        let items = CartData().getItems().0
        for item in items {
            let price = multiply(quantity: item.itemQuantity!, price: getPrice(item: getItemDetails(name: item.itemName!).0, code: DateHandler().daysFromTodayTo(date: item.addedDate!)))
            let priceD = Double(price)
            total = total + priceD!
        }
        return String(total)
        
    }
    
    func loginPressed(sender:UIButton){
        self.tabBarController?.selectedIndex = 4
    }
    
    func checkForitemAvailablefor(weekday : Int , cartItem :Cart, items : [Item]) -> Bool {
        
        for item in items {
            if cartItem.itemName == item.itemName {
        
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
        }
            
        }
        return false
    }
    
    
    
    
    
}
