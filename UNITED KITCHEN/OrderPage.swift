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


class OrderPage: UIViewController , UITableViewDelegate , UITableViewDataSource {
    let backendless = Backendless.sharedInstance()
    var navbarIndicator = UIActivityIndicatorView()
    var orders = [OrderDetails]()
    var activeOrders = [OrderDetails]()
    var passiveOrders = [OrderDetails]()
    var selection = 0
    var channels = [String]()
    var noItemsLabel = UILabel()
    
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
      //  print(OrderData().getOrders().count)
        
        print("did Appear")
        
        
        
        // Setting number badges
        
        
//        if CartData().getItems().1 != 0 {
//            
//            if ProfileData().profileCount().0 != 0 {
//                if ProfileData().getProfile().0.accountType == "admin" {
//                    
//                } else {
//                    self.navigationItem.rightBarButtonItems?.last?.addBadge(number: CartData().getItems().1)
//                    tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
//                }
//            } else {
//                self.navigationItem.rightBarButtonItems?.last?.addBadge(number: CartData().getItems().1)
//                tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
//            }
//        } else {
//            self.navigationItem.rightBarButtonItems?.last?.removeBadge()
//            tabBarController?.tabBar.items?[1].badgeValue = nil
//        }
        
        
        if CartData().getItems().1 != 0 {
          //  tabBarController?.tabBar.items[1].
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
    
    func loadlist(notification : Notification) {
        print("Notification detected for new orders")
        let orderId = (notification.userInfo?["orderId"])! as! String
        let status = (notification.userInfo?["status"])! as! String
        
        if OrderData().updateOrder(id: orderId, status: status) {
            print("saved")
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
        orderTable.rowHeight = 300 + CGFloat((activeOrders[indexPath.row].items?.count)!*40)
        cell.order = activeOrders[indexPath.row]
        } else if selection == 1 {
        orderTable.rowHeight = 300 + CGFloat((passiveOrders[indexPath.row].items?.count)!*40)
        cell.order = passiveOrders[indexPath.row]
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        if ProfileData().profileCount().0  == 0 {
        SCLAlertView().showError("No Profile", subTitle: "Please Signup/Login")
        } else {
        navbarIndicator.startAnimating()
        // check for reg
         let reqChannel = "C"+ProfileData().getProfile().0.phoneNumber!
        print("req channel \(reqChannel)")
        backendless?.messaging.getRegistrationAsync({ (response) in
            print("reg details \(response)")
            if (response?.channels.contains(reqChannel))!{
                self.refreshOrders()
            } else {
                self.registerForChennal(channel: reqChannel)
            }
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
                print("canot fetch reg details \(fault)")
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
        })
            
        }
        
        
        
    }
    
    
    func registerForChennal(channel : String){
        backendless?.messaging.registerDevice([channel], response: { (response) in
            print("reg attempt \(response)")
            self.refreshOrders()
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
                print("canot fetch reg details \(fault)")
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
        })
    }
    
    func refreshOrders() {
    
        let whereClause = "phoneNumber = "+ProfileData().getProfile().0.phoneNumber!+" or giftedBy = "+ProfileData().getProfile().0.phoneNumber!
        let query = DataQueryBuilder()
        query?.setPageSize(100)
        query?.setWhereClause(whereClause)
        
        backendless?.data.of(OrderDetails.ofClass()).find(query, response: { (data) in
            print("recieved data \(data?.count)")
            self.navbarIndicator.stopAnimating()
            if data?.count == 0 {
                if OrderData().deleteOrders(){
                    self.viewDidAppear(true)
                }
            } else {
                if OrderData().deleteOrders() {
                for item in data! {
                    if let order = item as? OrderDetails {
                        self.getItemsFromServer(data : order)
                    }
                }
            }
            }
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
                print("canot fetch \(fault)")
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
        })
        
    }
    
    func getItemsFromServer(data : OrderDetails) {
        print("getting items from server")
        let whereClause = "orderId = "+data.orderId!
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setPageSize(100)
        queryBuilder?.setWhereClause(whereClause)
        
        backendless?.data.of(OrderItems.ofClass()).find(queryBuilder, response: { (items) in
            for item in items! {
                if let orderItem = item as? OrderItems {
                    print("items casted")
                    data.items?.append(orderItem)
                }
            }
            // add to db
            if OrderData().addOrder(orderDetails: data) {
                print("data added")
                self.viewDidAppear(true)
            }
            
            }, error: { (fault) in
                 SCLAlertView().showError("Error", subTitle: "Cannot fetch items as the following error occured \(fault?.message)")
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
            if order.status == "3" {
                print("found order")
            statuses.append(true)
            } else {
            statuses.append(false)
            }
        }
        
        
        for i in 0...(statuses.count - 1){
            if statuses[i] {
            print("eligible ids")
            isEligible = true
            eligibleIDs.append(orders[i].orderId!)
            }
        }
        
        
        
        if !isEligible {
        SCLAlertView().showWarning("Not yet", subTitle: "None of your present orders are out for delivery")
        navbarIndicator.stopAnimating()
        } else {
            if eligibleIDs.count > 0 {
                print("eligible ids \(eligibleIDs.count)")
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
                    // to-do perform segue
                    print("print segue to be performed1")
                    performSegue(withIdentifier: "location", sender: self)
                }
                
            }
       // getLocationChannels(ids: eligibleIDs)
          //  channels.removeAll()
            //getLocationChannels(ids: eligibleIDs, idsCount: eligibleIDs.count, iterationNumber: 1)
        }
        
    }
    
    
    func getLocationChannels(ids : [String] , idsCount : Int , iterationNumber : Int){
        print("ids count \(idsCount)")
        print("iteration \(iterationNumber)")
        let whereclause = "orderId = "+ids[iterationNumber - 1]
        let query = DataQueryBuilder()
        query?.setWhereClause(whereclause)
        backendless?.data.of(OrderDetails.ofClass()).find(query, response: { (data) in
            if data?.count != 0 {
                if let obj = data?[0] as? OrderDetails {
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
                SCLAlertView().showNotice("Error", subTitle: "The following error has occured while fetching location tracking channels\n\(error?.message)\nPlease try again")
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
            // to-do perform segue
            print("segue to be performed2")
            performSegue(withIdentifier: "location", sender: self)
        }
    }
    
    
}
