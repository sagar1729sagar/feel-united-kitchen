//
//  OrderPage.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 06/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView
import BTNavigationDropdownMenu
import Backendless


class OrderPage: UIViewController , UITableViewDelegate , UITableViewDataSource {
    let backendless = Backendless.shared
    var navbarIndicator = UIActivityIndicatorView()
    var orders = [OrderDetails]()
    var activeOrders = [OrderDetails]()
    var passiveOrders = [OrderDetails]()
    var selection = 0
    var channels = [String]()
    var noItemsLabel = UILabel()
    var cartItems = [Cart]()
    var selectionForReorder = (Date(),"")
    
    @IBOutlet weak var locationUpdatingButton: UIBarButtonItem!
    @IBOutlet weak var orderTable: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(loadlist(notification:)), name: Notification.Name("orderupdate"), object: nil)
        noItemsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        noItemsLabel.textAlignment = .center
        noItemsLabel.textColor = UIColor.gray
        noItemsLabel.text = "No Orders"
        noItemsLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        noItemsLabel.font = UIFont.systemFont(ofSize: 50)
        self.view.addSubview(noItemsLabel)
        orderTable.allowsSelection = false
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([left!,spinner], animated: true)
        
     //   self.navigationItem.rightBarButtonItem?.isEnabled = false
     //   self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        // set dropdown menu
        
        let orderSelection = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: (self.navigationController?.view)!, title: "Select", items: ["Active" as AnyObject,"Delivered" as AnyObject])
        orderSelection.shouldKeepSelectedCellColor = true
        orderSelection.arrowTintColor = UIColor.blue
        orderSelection.cellBackgroundColor = UIColor.white
        orderSelection.cellSelectionColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
        self.navigationItem.titleView = orderSelection
        orderSelection.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.selection = indexPath
            self?.viewDidAppear(true)
            
            
            
        }

        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
     

        
        // Setting number badges

        
        if CartData().getItems().1 != 0 {
        
            tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        }
        
        
        orders.removeAll()
        activeOrders.removeAll()
        passiveOrders.removeAll()
        orders = OrderData().getOrders()
        for order in orders {
            if order.isDelivered == "0" {
                activeOrders.append(order)
            } else if order.isDelivered == "1" {
                passiveOrders.append(order)
            }
        }
        
        orderTable.reloadData()
        
        if selection == 0 {
            if activeOrders.count == 0 {
                noItemsLabel.isHidden = false
            } else {
                noItemsLabel.isHidden = true
            }
        }
        if selection == 1 {
            if passiveOrders.count == 0 {
                noItemsLabel.isHidden = false
            } else {
                noItemsLabel.isHidden = true
            }
        }
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadlist(notification : Notification) {
       
        let orderId = (notification.userInfo?["orderId"])! as! String
        let status = (notification.userInfo?["status"])! as! String
        
        if OrderData().updateOrder(id: orderId, status: status) {
            
            viewDidAppear(true)
        }
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selection == 0 {
            return activeOrders.count
        } else if selection == 1 {
            return passiveOrders.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = orderTable.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! OrderMainCell
        
        if selection == 0 {
        orderTable.rowHeight = 350 + CGFloat((activeOrders[indexPath.row].items?.count)!*40)
        cell.order = activeOrders[indexPath.row]
        cell.reOrderButton.tag = indexPath.row
        cell.reOrderButton.isHidden = false
        cell.reOrderButton.addTarget(self, action: #selector(reorderPressed(sender:)), for: .touchDown)
        } else if selection == 1 {
        orderTable.rowHeight = 350 + CGFloat((passiveOrders[indexPath.row].items?.count)!*40)
        cell.order = passiveOrders[indexPath.row]
        cell.reOrderButton.isHidden = false
        cell.reOrderButton.addTarget(self, action: #selector(reorderPressed(sender:)), for: .touchDown)
        cell.reOrderButton.tag = indexPath.row
        }
        
        return cell
    }
    
    @objc  
    func reorderPressed(sender : UIButton){
        
       
        cartItems.removeAll()
        if selection == 0 {
            // active orders
            let order = activeOrders[sender.tag]
            let items = order.items
            for item in items! {
                let cartItem = Cart()
                cartItem.itemName = item.name
                cartItem.itemQuantity = item.quantity
                cartItems.append(cartItem)
            }
        } else if selection == 1 {
            // passive order
            let order = passiveOrders[sender.tag]
            let items = order.items
            for item in items! {
                let cartItem = Cart()
                cartItem.itemName = item.name
                cartItem.itemQuantity = item.quantity
                cartItems.append(cartItem)
            }
        }
        
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton : false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        let dates = DateHandler().getNext7Days()
        
       
        for i in 0...6 {
//            alertView.addButton(dates.0[i], backgroundColor: UIColor.white, textColor: UIColor.blue, showDurationStatus: true, action: {
//                self.selectionForReorder.0 = dates.1[i]
//
//                self.lunchORdinnerAlert()
//            })
            alertView.addButton(dates.0[i], backgroundColor: UIColor.white, textColor: UIColor.blue, showTimeout: nil) {
                self.selectionForReorder.0 = dates.1[i]
                self.lunchORdinnerAlert()
            }
            
        }
       
        

        alertView.addButton("CANCEL") {
           
        }
        
        alertView.showInfo("Please select a date", subTitle: "")
      

    
    }
    
    
    func lunchORdinnerAlert() {
        
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton : false
        )
        let alertView = SCLAlertView(appearance: appearance)
       // let alertView = SCLAlertView(appearance: appearance)

        let times = ["Lunch","Dinner"]

        
        for i in 0...1 {
//            alertView.addButton(times[i], backgroundColor: UIColor.white, textColor: UIColor.blue, showDurationStatus: true, action: {
//                self.selectionForReorder.1 = times[i]
//
//                for cartItem in self.cartItems {
//                    cartItem.addedDate = self.selectionForReorder.0
//                    cartItem.deliveryTime = self.selectionForReorder.1
//                    CartData().addItem(item: cartItem)
//                }
//
//              self.tabBarController?.selectedIndex = 1
//            })
            
            alertView.addButton(times[i], backgroundColor: UIColor.white, textColor: UIColor.blue, showTimeout: nil) {
                self.selectionForReorder.1 = times[i]
                var nonAvailableItems = [String]();
                
                for cartItem in self.cartItems{
                    if(!MenuItemsData().check(forItem: cartItem.itemName!)){
                        nonAvailableItems.append(cartItem.itemName!)
                        self.cartItems.removeAll { $0 == cartItem }
                    } else if (!MenuItemsData().checkItemAvailability(name: cartItem.itemName!, dayOfWeek: DateHandler().getDayofweekfor(date: self.selectionForReorder.0)))  {
                  
                        nonAvailableItems.append(cartItem.itemName!)
                        self.cartItems.removeAll { $0 == cartItem }
                    }
                }
                
                if self.cartItems.count == 0 {
                    SCLAlertView().showInfo("Sorry", subTitle: "Items in this order are not available for delivery for your selected date ")
                } else if nonAvailableItems.count != 0{
                  //  print("Am I Heere")
                    var subtitle = "Items in this order are not available for delivery for your selected date \n"
                    for name in nonAvailableItems {
                        subtitle += name + "\n"
                    }
                    subtitle += "Would like to proceed with remaining items?"
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton : false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Proceed", backgroundColor: UIColor.blue, textColor: UIColor.white, showTimeout: nil) {
                        self.addItemsToCart()
//                        for cartItem in self.cartItems {
//                            cartItem.addedDate = self.selectionForReorder.0
//                            cartItem.deliveryTime = self.selectionForReorder.1
//                            CartData().addItem(item: cartItem)
//
//
//                        }
 //                       self.tabBarController?.selectedIndex = 1
                    }
                    
                    alertView.addButton("Cancel", backgroundColor: UIColor.red, textColor: UIColor.white, showTimeout: nil) {
                        alertView.dismiss(animated: true) {
                            //none
                        }
                    }
                    
                    alertView.showInfo("Attention!!", subTitle: subtitle)
                } else {
                    print("I am called")
                    self.addItemsToCart()
//                    for cartItem in self.cartItems {
//                        cartItem.addedDate = self.selectionForReorder.0
//                        cartItem.deliveryTime = self.selectionForReorder.1
//                        CartData().addItem(item: cartItem)
//                    }
//                    self.tabBarController?.selectedIndex = 1
                }
                //ToDO check when adding items to cart, that if items already exists for same date or not and then if exists, just increase quantity
            
                
//                if( nonAvailableItems.count != 0){
//                    let appearance = SCLAlertView.SCLAppearance(
//                        showCloseButton : false
//                    )
//                    let alertView = SCLAlertView(appearance: appearance)
//                    alertView.addButton("Continue", backgroundColor: UIColor.yellow, textColor: UIColor.white, showTimeout: nil) {
//                         cartItem.addedDate = self.selectionForReorder.0
//                        cartItem.deliveryTime = self.selectionForReorder.1
//                        CartData().addItem(item: cartItem)
//                        self.tabBarController?.selectedIndex = 1
//                    }
//                }
                
                
            //    print(nonAvailableItems.count)
              //  print(self.cartItems.count)
//                  for cartItem in self.cartItems {
//
                
////                    if (!MenuItemsData().check(forItem: cartItem.itemName!)){
////                        nonAvailableItems.append(cartItem.itemName!);
////                        cartItems.remove
////                    }
//
////                      cartItem.addedDate = self.selectionForReorder.0
////                      cartItem.deliveryTime = self.selectionForReorder.1
////                      CartData().addItem(item: cartItem)
//                  }
                  
            //    self.tabBarController?.selectedIndex = 1
            }
        }
        alertView.addButton("CANCEL") {
           
        }
        alertView.showInfo("Please select a time", subTitle: "")

        
        
    }
    
//    func checkForItem(name : String , items : [Item]) -> Bool{
//
//           for item in items {
//
//               if item.itemName == name {
//                   return true
//               }
//
//           }
//
//           return false
//
//       }

//    func addItemsToCart(){
//        var i = 0
//        for cartItem in self.cartItems {
//            i += 1
//            print(i)
//            if CartData().checkCartForItem(itemName: cartItem.itemName!, date: self.selectionForReorder.0, time: self.selectionForReorder.1) {
//              //  print("here 1")
//                let appearance = SCLAlertView.SCLAppearance(
//                    showCloseButton : false
//                )
//                let alertView = SCLAlertView(appearance: appearance)
//                let subtitle = "The following item is already in your cart for your selected date and time : \n \(cartItem.itemName!) \n Would like to add increase the quantity?"
//                alertView.addButton("Proceed", backgroundColor: UIColor.blue, textColor: UIColor.white, showTimeout: nil) {
//                    CartData().incrementQuantityfor(itemName: cartItem.itemName!, date: self.selectionForReorder.0, time: self.selectionForReorder.1)
//                    if i == self.cartItems.count {
//                        self.tabBarController?.selectedIndex = 1
//                    }
//                }
//                alertView.addButton("No", backgroundColor: UIColor.red, textColor: UIColor.blue, showTimeout: nil) {
//                    alertView.dismiss(animated: true) {
//                         if i == self.cartItems.count {
//                                self.tabBarController?.selectedIndex = 1
//                                }
//                    }
//                }
//
//
//            } else {
//              //  print("Here 2")
//            cartItem.addedDate = self.selectionForReorder.0
//            cartItem.deliveryTime = self.selectionForReorder.1
//            CartData().addItem(item: cartItem)
//                if i == self.cartItems.count {
//                                       self.tabBarController?.selectedIndex = 1
//                                   }
//        }
//
//        }
//      //  self.tabBarController?.selectedIndex = 1
//    }
    
    
    func addItemsToCart(){
        var alreadyPresentItems = [Cart]()
        for cartItem in self.cartItems{
            if CartData().checkCartForItem(itemName: cartItem.itemName!, date: self.selectionForReorder.0, time: self.selectionForReorder.1) {
                alreadyPresentItems.append(cartItem)
                self.cartItems.removeAll { $0 == cartItem }
            }
        }
        intelligentIteration(alreadyPresentItems: alreadyPresentItems, iterationPosition: 0)
    }
    
    func intelligentIteration(alreadyPresentItems : [Cart], iterationPosition :Int){
        if alreadyPresentItems.count != 0 {
            if iterationPosition != alreadyPresentItems.count {
               askForQuantityIncrease(alreadyPresentItems: alreadyPresentItems, iterationPosition: iterationPosition)
            } else {
                addRemainingItems()
            }
        } else {
            addRemainingItems()
        }
    }
    
    func askForQuantityIncrease(alreadyPresentItems : [Cart], iterationPosition : Int){
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton : false
                        )
                       let alert = SCLAlertView(appearance: appearance)
        var subtitle = "The following item is already present in your cart for your selected date and time: \n \(alreadyPresentItems[iterationPosition].itemName!) \n Would you like to increase the quantity"
        
        alert.addButton("Proceed", backgroundColor: UIColor.blue, textColor: UIColor.white, showTimeout: nil) {
            CartData().incrementQuantityfor(itemName: alreadyPresentItems[iterationPosition].itemName!, date: self.selectionForReorder.0, time: self.selectionForReorder.1)
            self.intelligentIteration(alreadyPresentItems: alreadyPresentItems, iterationPosition: iterationPosition+1)
        }
        alert.addButton("Skip", backgroundColor: UIColor.red, textColor: UIColor.white, showTimeout: nil) {
            self.intelligentIteration(alreadyPresentItems: alreadyPresentItems, iterationPosition: iterationPosition+1)
        }
        alert.showInfo("Attention!!", subTitle: subtitle)
    }
    
    func addRemainingItems(){
        for cartItem in self.cartItems{
            cartItem.addedDate = self.selectionForReorder.0
            cartItem.deliveryTime = self.selectionForReorder.1
            CartData().addItem(item: cartItem)
        }
        self.tabBarController?.selectedIndex = 1
    }
    //todo fix redirect to cart page . stop adding alertviews to for loop. figure out another way

    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        if ProfileData().profileCount().0  == 0 {
        SCLAlertView().showError("No Profile", subTitle: "Please Signup/Login")
        } else {
        navbarIndicator.startAnimating()
        // check for reg
         let reqChannel = "C"+ProfileData().getProfile().0.phoneNumber!
        registerForChennal(channel: reqChannel)
        }
    }
     // print(678)
//            backendless.messaging.getRegistrationAsync({ (response) in
//            
//            if (response?.channels.contains(reqChannel))!{
//                self.refreshOrders()
//            } else {
//                self.registerForChennal(channel: reqChannel)
//            }
//            }, error: { (fault) in
//                self.navbarIndicator.stopAnimating()
//                
//                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
//        })
            
//            backendless.messaging.getDeviceRegistrations(responseHandler: { (responses) in
//                var is_req_channel_present = false
//                for response in responses{
//                    if (response.channels?.contains(reqChannel))! {
//                        is_req_channel_present = true
//                    }
//                }
//                is_req_channel_present ? self.refreshOrders() : self.registerForChennal(channel: reqChannel)
//            }) { (fault) in
//                self.navbarIndicator.stopAnimating()
//
//                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
//            }
//
//        }
//
//
//
//    }
    
    
    func registerForChennal(channel : String){
        backendless.messaging.getDeviceRegistrations(responseHandler: { (responsnes) in
            var is_registered_for_req_channel = false
            var device_token = ""
            for response in responsnes{
                if ((response.channels?.contains(channel))!){
                    is_registered_for_req_channel = true
                    device_token = response.deviceToken!
                    break
                }
            }
            if(is_registered_for_req_channel){
                self.refreshOrders()
            } else {
                self.backendless.messaging.registerDevice(deviceToken: Data(device_token.utf8), channels: [channel], responseHandler: { (response) in
                    self.refreshOrders()
                }) { (fault) in
            SCLAlertView().showError("Error", subTitle: "Cannot register for notification channel as the following error occured \(String(describing: fault.message))")
                    self.refreshOrders()
                }
            }
        }) { (fault) in
            self.navbarIndicator.stopAnimating()
            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
            self.refreshOrders()
        }
    }
//        backendless?.messaging.registerDevice(deviceToken: [channel], responseHandler: { (response) in
//
//            self.refreshOrders()
//        }, errorHandler: { (fault) in
//                self.navbarIndicator.stopAnimating()
//
//                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
//        })
        
//        backendless.messaging.unregisterDevice(channels: [channel], responseHandler: { (response) in
//            self.refreshOrders()
//        }) { (fault) in
//            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
//        }
//
//    }
    
    func refreshOrders() {
        
      //  print(1)
    
        let whereClause = "phoneNumber = "+ProfileData().getProfile().0.phoneNumber!+" or giftedBy = "+ProfileData().getProfile().0.phoneNumber!
        let query = DataQueryBuilder()
        query.setPageSize(pageSize: 100)
        query.setWhereClause(whereClause: whereClause)
        query.setSortBy(sortBy: ["deliveryDate ASC"])
        
        backendless.data.of(OrderDetails.self).find(queryBuilder: query, responseHandler: { (data) in
            // print(2)
            // print(data)
            self.navbarIndicator.stopAnimating()
            if data.count == 0 {
                if OrderData().deleteOrders(){
                    self.viewDidAppear(true)
                }
            } else {
                if OrderData().deleteOrders() {
                    for item in data {
                        // print(3)
                        if let order = item as? OrderDetails {
                            //  print(order)
                            self.getItemsFromServer(data : order)
                            // print(4)
                        }
                    }
                }
            }
        }, errorHandler: { (fault) in
               // print(fault)
                self.navbarIndicator.stopAnimating()
               
            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
        })
        
    }
    
    func getItemsFromServer(data : OrderDetails) {
      // print("getting items for \(data.orderId!)")
       // print(data.orderId)
      //  print(data.items)
        data.items = [OrderItems]()
        let whereClause = "orderId = "+data.orderId!
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setWhereClause(whereClause: whereClause)
        
        backendless.data.of(OrderItems.self).find(queryBuilder: queryBuilder, responseHandler: { (items) in
            // print(items)
            // print("Found objects: \(items as! [OrderItems])")
            for item in items {
                // print(item)
                // print("got items for \(data.orderId!)")
                if let orderItem = item as? OrderItems {
                    //                   print(6)
                    //                    print(orderItem.name)
                    //                    print(type(of: orderItem))
                    data.items?.append(orderItem)
                    //  print(data.items?.count)
                }
            }
            // add to db
            if OrderData().addOrder(orderDetails: data) {
                //print(7)
                self.viewDidAppear(true)
            }
            
        }, errorHandler: { (fault) in
            SCLAlertView().showError("Error", subTitle: "Cannot fetch items as the following error occured \(String(describing: fault.message))")
        })
    }
    
    
    
    @IBAction func locPressed(_ sender: UIBarButtonItem) {
        var isEligible = false
        var eligibleIDs = [String]()
        var cheannels = [String]()
        navbarIndicator.startAnimating()
        let orders = OrderData().getOrders()
        var statuses = [Bool]()
        for order in orders {
            if order.status == "4" {
              
            statuses.append(true)
            } else {
            statuses.append(false)
            }
        }
        
        
        for i in 0...(statuses.count - 1){
            if statuses[i] {
         
            isEligible = true
            eligibleIDs.append(orders[i].orderId!)
            }
        }
        
        
        
        if !isEligible {
        SCLAlertView().showWarning("Not yet", subTitle: "None of your present orders are out for delivery")
        navbarIndicator.stopAnimating()
        } else {
            if eligibleIDs.count > 0 {
               
                for id in eligibleIDs {
                    for order in orders {
                        if order.orderId == id {
                            cheannels.append(order.locationTrackingChannel!)
                        }
                    }
                }
                
                if cheannels.contains("nil"){
                    channels.removeAll()
                    getLocationChannels(ids: eligibleIDs, idsCount: eligibleIDs.count, iterationNumber: 1)
                } else {
                    
                    navbarIndicator.stopAnimating()
                  
                    performSegue(withIdentifier: "location", sender: self)
                }
                
            }
       
        }
        
    }
    
    
    func getLocationChannels(ids : [String] , idsCount : Int , iterationNumber : Int){
     
        let whereclause = "orderId = "+ids[iterationNumber - 1]
        let query = DataQueryBuilder()
        query.setWhereClause(whereClause: whereclause)
        backendless.data.of(OrderDetails.self).find(queryBuilder: query, responseHandler: { (data) in
            if data.count != 0 {
                if let obj = data[0] as? OrderDetails {
                    if OrderData().updateLocationTrackingChannel(id: obj.orderId!, channel: obj.locationTrackingChannel!){
                    self.channels.append(obj.locationTrackingChannel!)
                    }
                }
            }
            if iterationNumber == idsCount {
                self.checkForValidChannels( channels : self.channels)
            } else if iterationNumber < idsCount {
                self.getLocationChannels(ids: ids, idsCount: idsCount, iterationNumber: iterationNumber + 1)
            }
            }) { (error) in
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showNotice("Error", subTitle: "The following error has occured while fetching location tracking channels\n\(String(describing: error.message))\nPlease try again")
                self.navbarIndicator.stopAnimating()
        }
        
        
    }
    
    func checkForValidChannels(channels : [String]) {
        navbarIndicator.stopAnimating()
        var name = [String]()
        for channel in channels {
            if channel != "nil" {
            name.append(channel)
            }
        }
        
        if name.count == 0 {
        SCLAlertView().showWarning("Not yet", subTitle: "Your order hasn't assigned a tracking channel. Please try again in some time")
        } else {
            performSegue(withIdentifier: "location", sender: self)
        }
    }
    
    func didSelectButton(selectedButton: UIButton?) {
        
    }
    
    
}
