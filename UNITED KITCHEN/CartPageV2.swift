//
//  CartPageV2.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 11/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView
import DCAnimationKit

class CartPageV2: UIViewController , UITableViewDelegate , UITableViewDataSource {

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
  //  var headerDates = [String]()
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
  //  var profileCount = 0
    var giftName = ""
    var giftNumber = ""
    var giftAddress = ""
    
    var ordersSaved = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
      
        
       
        
        
        tabBarController?.tabBar.items?[1].badgeValue = nil
        table.allowsSelection = false
        
        sectionHeaders.removeAll()
        dates.removeAll()
        times.removeAll()
        lunchDates.removeAll()
        dinnerDates.removeAll()
        allDatesArray.removeAll()
        print("called")
        itemsArrayINPARWITHDates.removeAll()
        profileCount = ProfileData().profileCount().0
      //  itemCount = 0
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
      //  header.frame.height = 2*UIScreen.main.bounds.width/27
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
//        if isGifted {
//            table.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
        
        if indexPath.section < dates.count {
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
        
        } else {
            
            switch indexPath.section {
            
            case dates.count:
                let cell = table.dequeueReusableCell(withIdentifier: "items1", for: indexPath)
               // table.rowHeight = (UIScreen.main.bounds.height/10 + 20)/3
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
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section < dates.count {
            if editingStyle == .delete {
                let itm = itemsArrayINPARWITHDates[indexPath.section][indexPath.row]
               // if CartData().deleteItem(ofName: itemsArrayINPARWITHDates[indexPath.section][indexPath.row].itemName!) {
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
    
    func addButtonPressed(sender : UIButton) {
        
        
        let tag = sender.tag
        let row = tag%1000
        let section = tag/1000
        let item = itemsArrayINPARWITHDates[section][row]
        if CartData().incrementQuantityfor(itemName: item.itemName!, date: item.addedDate!, time: item.deliveryTime!) {
            viewDidAppear(true)
        }
        
        print(itemsArrayINPARWITHDates[section][row].itemName)
        
    
    }
    
    func subButtonPressed(sender : UIButton) {
        
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
    
    func ordernowPressed(sender : UIButton) {
        
        isGifted = false
        print("Ordernow pressed")
        checkCheckBoxes()
    
    }
    
    func giftitPressed(sender : UIButton) {
        if isGifted {
            isGifted = false
            table.reloadData()
        } else if !isGifted {
            isGifted = true
            table.reloadData()
        }
    
    }
    
    func proceedPressed ( sender : UIButton) {
        
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
                    print("came till checkbox calling")
                }
            }
        }
        
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
        
        self.navigationItem.leftBarButtonItems?[0].isEnabled = false
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navbarIndicator.startAnimating()
        giftCell.proceedButton.isEnabled = false
        splCell.orderButton.isEnabled = false
        splCell.giftButton.isEnabled = false
//        var allDates = [Date]()
//        var allTimes = [String]()
//        var statusArray = [Bool]()
//        var tobeRemovedItems = [String]()
        
        allDates.removeAll()
        allTimes.removeAll()
        statusArray.removeAll()
        tobeRemovedItems.removeAll()
        
       
        
        for item in CartData().getItems().0 {
            allDates.append(item.addedDate!)
            allTimes.append(item.deliveryTime!)
        }
        
        backendless?.data.of(OrderTimes.ofClass()).find({ (data) in
            self.navigationItem.leftBarButtonItems?[0].isEnabled = true
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
            self.navbarIndicator.stopAnimating()
            self.giftCell.proceedButton.isEnabled = true
            self.splCell.orderButton.isEnabled = true
            self.splCell.giftButton.isEnabled = true
            print("data found")
            
            if let fecthedTimes = data?[0] as? OrderTimes {
                
                print("casted")
                /**
                 
                 First check for past date
                 if its past, turn false
                 If its present or fute, check times
                  **/
                let hour = Calendar.current.component(.hour, from: Date())
                for i in 0...(self.allDates.count - 1){
                    let ppf = DateHandler().isPastPresenFuture(date: self.allDates[i])
                    if ppf == 0 {
                        // pastDate
                        self.statusArray.append(false)
                    } else if ppf == 1 {
                        // present 
                    
                        let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: self.allDates[i]), data: fecthedTimes)
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
                        
                        let endTimes = self.closeTimes(weekday: DateHandler().getDayofweekfor(date: self.allDates[i]), data: fecthedTimes)
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
                
                
                // 
                
                
                //
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
                
                    // proceed to palcing order
                    // check for total order price
                    // to-do
                   // let finalTotal = getTotal()
                  //  let amt = Double(self.getTotal())
                  //  print("fetched mina mount \(amt!)")
                    if Double(self.getTotal())! >= Double(fecthedTimes.minAmount!)! {
                        print("reched next step")
                        self.placeOrder(addressType : addressType)
                        
                    } else {
                        SCLAlertView().showWarning("Min. amout required", subTitle: "The minimun amount required to place an ordr is $\(fecthedTimes.minAmount!) \n Plese add more item \n P.S You can place order for future dates also to meet the min amount requirement")
                    }
                    
                                   } else {
                    // display popup
                    print("popup reached")
                    
                    self.askForDelete(items : self.tobeRemovedItems)
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
    
    

    
    func placeOrder( addressType : Int) {
        
        // All orders are placed sequentially one after other , not simulatnaeously
        // in case of location type orders, first check for recieved location
        
        if addressType == 1{
            if locCell.coordinate != nil {
                print("Proceed")
                navbarIndicator.startAnimating()
               // updateProfile(addressType: addressType, numberOfOrders: dates.count, currentOrderNumber: 1)
                //generateOrderIds()
                generateOrderIds(addressType: 1)
            } else {
                SCLAlertView().showWarning("Location not found", subTitle: "We cannot determine your GPS location right now. Please press RETRY and try again or use another type of address mode")
            }
        } else {
            print("proceed")
            navbarIndicator.startAnimating()
           // updateProfile(addressType: addressType, numberOfOrders: dates.count, currentOrderNumber: 1)
            //generateOrderIds()
            
            generateOrderIds(addressType: 0)
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
        for i in 0...(dates.count - 1){
            
            let updatedProfile = ProfileData().incrementOrderCount().0
            orderIds.append(updatedProfile.phoneNumber!+updatedProfile.orderCount!)
            
        }
        
        // save profile in backendless
        self.navbarIndicator.startAnimating()

        backendless?.data.of(Profile.ofClass()).save(ProfileData().getProfile().0, response: { (data) in
            print("Updated profile saved")
            
                // save items
                // save orders
            /// relations are ignored
            // to-d0
                        self.saveOrders(addressType: addressType, updatedProfile: ProfileData().getProfile().0)
            }, error: { (fault) in
                self.splCell.orderButton.isEnabled = true
                self.splCell.giftButton.isEnabled = true
                self.giftCell.proceedButton.isEnabled = true
               // print("data not found \(fault)")
                self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                self.navbarIndicator.stopAnimating()
                self.navbarIndicator.stopAnimating()
                print("Error saving profile \(fault)")
                SCLAlertView().showWarning("Apologies", subTitle: "Cannot place your order as the following error has occured \n\(fault?.message) \n Please try again")
        })
        
        
    }
    
    
    func saveOrders(addressType : Int, updatedProfile : Profile) {
        
        
        orderCount = 0
        print("orderis for loop")
        for i in 0...(orderIds.count - 1) {
            print("order id is \(orderIds[i])")
            let orderDetails = OrderDetails()
            orderDetails.orderId = orderIds[i]
            orderDetails.deliveryDate = itemsArrayINPARWITHDates[i][0].addedDate
            orderDetails.deliveryTime = getDeliveryTime(time: itemsArrayINPARWITHDates[i][0].deliveryTime!)
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
            }
            if addressType == 1 {
                if locCell.coordinate != nil {
                    orderDetails.longitude = String(describing: locCell.coordinate?.longitude)
                    orderDetails.latitude = String(describing: locCell.coordinate?.latitude)
        }
            }
            
            print("initiated")
            initiateSave( items : itemsArrayINPARWITHDates[i], details : orderDetails , itemNumber : 1 , savedOrderItems: [OrderItems]())
            
            
        }
        
        isGifted = false
        
    }
    
    func initiateSave(items : [Cart], details : OrderDetails , itemNumber : Int , savedOrderItems : [OrderItems]) {
        
        if itemNumber <= items.count {
            let newItem = OrderItems()
            print(1)
            newItem.name = items[itemNumber - 1].itemName
            print(2)
            newItem.price = getPrice(item: getItemDetails(name: items[itemNumber - 1].itemName!).0, code: DateHandler().daysFromTodayTo(date: items[itemNumber - 1].addedDate!))
            newItem.orderId = details.orderId
            newItem.quantity = items[itemNumber - 1].itemQuantity
            print("backendless item save")
            backendless?.data.of(OrderItems.ofClass()).save(newItem, response: { (result) in
                if let data = result as? OrderItems {
                    print("backendless item data recieved")
                    var intr = savedOrderItems
                    intr.append(data)
                self.initiateSave(items: items, details: details, itemNumber: itemNumber + 1, savedOrderItems: intr)
                }
                }, error: { (error) in
                    self.splCell.orderButton.isEnabled = true
                    self.splCell.giftButton.isEnabled = true
                    self.giftCell.proceedButton.isEnabled = true
                    print("data not found \(error)")
                    self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                    self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.navbarIndicator.stopAnimating()
                    self.navbarIndicator.stopAnimating()
                    SCLAlertView().showWarning("Error", subTitle: "We cannot place the order as the following error has occured \n \(error?.message) Please try again ")
                    
            })
        } else {
            backendless?.data.of(OrderDetails.ofClass()).save(details, response: { (result) in
                if let data = result as? OrderDetails {
                    print("Order details casted")
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
                              //  print("data not found \(error)")
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
                    print("data not found \(error)")
                    self.navigationItem.leftBarButtonItems?[0].isEnabled = true
                    self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                    self.navbarIndicator.stopAnimating()
               self.navbarIndicator.stopAnimating()
                    SCLAlertView().showWarning("Error", subTitle: "We cannot place the order as the following error has occured \n \(error?.message) Please try again ")
            })
        }
        
        
        
        
    }
    
    func sendNotification(data : OrderDetails) {
        print("sending message")
        let publishOptions = PublishOptions()
        let headers = ["ios-alert":"New Order recieved","ios-badge":"1","ios-sound":"default","type":"neworder","orderId":data.orderId!]
        publishOptions.assignHeaders(headers)
        
        backendless?.messaging.publish("admin", message: "New order", publishOptions: publishOptions, response: { (status) in
            print("message publish success \(status)")
     //       self.LastTask(data: data)
            }, error: { (error) in
                print("Message publish error \(error)")
    //            self.LastTask(data: data)
        })
    }
    
    
    
//        for i in 0...(orderIds.count - 1) {
//            let cart = itemsArrayINPARWITHDates[i]
//            for item in cart {
////                let newItem = OrderItems()
////                newItem.name = item.itemName
////                newItem.orderId = orderIds[i]
////                newItem.price = getPrice(item: getItemDetails(name: item.itemName!).0, code: DateHandler().daysFromTodayTo(date: item.addedDate!))
////                newItem.quantity = item.itemQuantity
////                backendless?.data.of(OrderItems.ofClass()).save(newItem, response: { (data) in
////                    print("Saved")
////                    }, error: { (error) in
////                        SCLAlertView().showWarning("Save error", subTitle: "The item \(newItem.name) is not saved due to the following error )
////                })
//            }
//        }
  //  }
    
    
    
    func askForDelete( items : [String]) {
        var rm = ""
        for item in items {
            rm = rm + item + "\n"
        }
        
        SCLAlertView().showWarning("Apologies", subTitle: "We are sorry to inform you that we are not accpting any orders for the follwing dates and times. Please delete those items and proceed \n" + rm)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if CartData().deleteCart() {
          //  cartItems.removeAll()
           // itemCount = 0
           // table.reloadData()
//            print("All deleted")
//            viewDidAppear(true)
//            itemsArrayINPARWITHDates.removeAll()
//            lunchDates.removeAll()
//            dinnerDates.removeAll()
//            dates.removeAll()
//            times.removeAll()
            itemCount = 0
            table.reloadData()
            noItemsLabel.isHidden = false
            //viewDidAppear(true)
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
    
    
    @IBAction func testParse(_ sender: AnyObject) {
        print("test pressed")
//        navbarIndicator.startAnimating()
//        var query = PFQuery(className: "OrderTimes")
//        query.whereKey("objectId", equalTo: "eWYWGMDa6o")
//        query.findObjectsInBackground { (object, error) in
//            self.navbarIndicator.stopAnimating()
//            if error == nil {
//            print("object retieved \(object)")
//            } else {
//            print("error in retrieval \(error)")
//            }
//        }
    }

}
