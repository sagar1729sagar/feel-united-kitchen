//
//  ActiveOrderAdmin.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 07/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView

class ActiveOrderAdmin: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate,UISearchResultsUpdating {
    
    var i = 0

    let backendless = Backendless.sharedInstance()
    var navbarIndicator = UIActivityIndicatorView()
    var orderDetails = [OrderDetails]()
    let searchController = UISearchController(searchResultsController: nil)
    var fids = [String]()
    var filtededids = [String]()
    var filterOrders = [OrderDetails]()
    

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observer for notification
        NotificationCenter.default.addObserver(self, selector: #selector(loadlist(notification:)), name: Notification.Name("neworder"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadlist1(notification:)), name: Notification.Name("orderupdateadmin"), object: nil)
        
        table.allowsSelection = false
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([left!,spinner], animated: true)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.keyboardType = .numberPad
        table.tableHeaderView = searchController.searchBar
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("did appear")
       
        orderDetails.removeAll()
        let allOrders = OrderData().getOrders()
        for order in allOrders {
            if order.isDelivered != "1" {
                orderDetails.append(order)
            }
        }
       
        
        fids.removeAll()
        filterOrders.removeAll()
        for order in orderDetails {
            fids.append(order.orderId!)
        }
        filtededids = fids
        filterOrders = orderDetails
        
         table.reloadData()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtededids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ordercell1", for: indexPath) as! OrderDisplayCell
        
        
        
        let searchText = searchController.searchBar.text
        
        if (searchText?.isEmpty)! {
            table.rowHeight = 800 + CGFloat((orderDetails[indexPath.row].items?.count)!*50)
            cell.order = orderDetails[indexPath.row]
        } else {
            table.rowHeight = 800 + CGFloat((filterOrders[indexPath.row].items?.count)!*50)
            cell.order = filterOrders[indexPath.row]
        }
        
      //  let items = orderDetails[indexPath.row].items
        //table.rowHeight = 400 + CGFloat(((items?.count)! * 50))
     //   table.rowHeight = 1000 + CGFloat((orderDetails[indexPath.row].items?.count)!*50)
      //  cell.navInd = navbarIndicator
      //  cell.order = orderDetails[indexPath.row]
//        if orderItems[indexPath.row].isGifted == "1" {
//            cell.giftedLabel.isHidden = false
//            cell.giftedLabel.text = "Gifted by : "+orderItems[indexPath.row].giftedBy!
//        } else {
//            cell.giftedLabel.isHidden = true
//        }
     //   cell.statusLabel.text = getStatus(code: orderItems[indexPath.row].status!)
       // print(Int(orderItems[indexPath.row].status!)!)
     //   cell.progressBar.currentIndex = Int(orderItems[indexPath.row].status!)!
        
        
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //to-do delete item
            deleteOrder(order: orderDetails[indexPath.row])
        }
    }
    
    func deleteOrder(order : OrderDetails) {
        var childIDs = [String]()
        for item in order.items! {
        childIDs.append(item.objectId!)
        }
        backendless?.data.of(OrderDetails.ofClass()).remove(byId: order.objectId, response: { (response) in
            print("order deleted \(response)")
            if OrderData().deleteOrder(id: order.orderId!) {
            self.orderDetails.removeAll()
            self.viewDidAppear(true)
            }
            
            // delete items 
            for id in childIDs {
            self.backendless?.data.of(OrderItems.ofClass()).remove(byId: id, response: { (nmbr) in
                print("removed")
                }, error: { (fault) in
                    print("cannot remove item \(fault)")
            })
            }
            
            }) { (fault) in
                print("cannot delete order \(fault)")
                SCLAlertView().showError("Cannot delete", subTitle: "Cannot delete the order as the following error has occured.\n\(fault?.message)\nPlease try again")
        }
        
        
        
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filtededids.removeAll()
        if (searchText?.isEmpty)! {
            filtededids = fids
            filterOrders.removeAll()
            filterOrders = orderDetails
            
        } else {
            
            filtededids = fids.filter({ (id) -> Bool in
                return id.lowercased().contains((searchText?.lowercased())!)
            })
        }
        
        filterOrders.removeAll()
        
        for order in orderDetails {
            
            if filtededids.contains(order.orderId!) {
                filterOrders.append(order)
            }
            
        }
        
        
        
        table.reloadData()
        
        print(filtededids)
        print(filterOrders.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getStatus(code : String) -> String {
//        switch code {
//        case "0":
//            return "Order placed"
//        case "1":
//            return "Order confirmed"
//        case "2":
//            return "Cooking started"
//        case "3":
//            return "Food packed"
//        case "4":
//            return "Out for delivery"
//        case "5":
//            return "Delivered"
//        default:
//            return "I have no idea where it is"
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadlist(notification : Notification) {
        navbarIndicator.startAnimating()
        print("Notification detected for new orders")
        let id = notification.userInfo?["orderId"] as! String
        let whereCaluse = "orderId = "+id
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause(whereCaluse)
        backendless?.data.of(OrderDetails.ofClass()).find(queryBuilder, response: { (data) in
            print("got notification order")
            print(data)
            for item in data!{
                if let order = item as? OrderDetails {
                print("notification order casted")
                    self.getItemsFromServer(data: order)
                }
            }
//            if let order = data?[0] as? OrderDetails {
//                print("notification order casted")
//                self.getItemsFromServer(data: order)
//            }
            }, error: { (error) in
                self.navbarIndicator.stopAnimating()
                print("canot fetch \(error)")
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(error?.message)\n Please refresh page for new order to appear")
        })
        
        
//        let orderId = (notification.userInfo?["orderId"])! as! String
//        getOrder(id: orderId)
        
    }


    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
         navbarIndicator.startAnimating()
        // check and register for admin
        backendless?.messaging.getRegistrationAsync({ (response) in
            print("reg details \(response)")
            if (response?.channels.contains("admin"))!{
            self.refreshItems()
            } else {
                self.registerForAdmin()
            }
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
                print("canot fetch reg details \(fault)")
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
        })
        
        
    }
    
    func registerForAdmin() {
        backendless?.messaging.registerDevice(["admin"], response: { (response) in
            print("registered to admin")
            self.refreshItems()
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
                print("canot fetch reg details \(fault)")
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
                
        })
    }
    
    func refreshItems() {
        i = 0
        // only today orders are refreshed
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
       // let dateString = dateFormatter.string(from: Date())
        let dateString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        print("date exp \(dateString)")
       print(dateString)
       // let whereClause = "isDelivered = '0'"
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setPageSize(100)
       // queryBuilder?.setWhereClause(whereClause)
        queryBuilder?.setWhereClause(String(format: "deliveryDate > %@", dateString))
        // to-do
       
      //  print(OrderData().getOrders().count)
        if OrderData().deleteOrders(){
            backendless?.data.of(OrderDetails.ofClass()).find(queryBuilder, response: { (data) in
                self.navbarIndicator.stopAnimating()
                print("data recieved \(data?.count)")
                if data?.count == 0 {
                    print("count zero")
                    if OrderData().deleteOrders(){
                        self.orderDetails.removeAll()
                        
                       self.viewDidAppear(true)
                    }
                }
                print(data?.count)
                for item in data! {
                    if let order = item as? OrderDetails {
                        self.getItemsFromServer(data: order)
                    }
                }
                }, error: { (fault) in
                    self.navbarIndicator.stopAnimating()
                    print("canot fetch \(fault)")
                    SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
            })
        }
    }
    
    
    
    func getItemsFromServer( data :OrderDetails) {
        print("getting items from server")
        navbarIndicator.startAnimating()
        let whereClause = "orderId = "+data.orderId!
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setPageSize(100)
        queryBuilder?.setWhereClause(whereClause)
        backendless?.data.of(OrderItems.ofClass()).find(queryBuilder, response: { (items) in
            self.navbarIndicator.stopAnimating()
            print("items found for \(data.orderId)")
            for item in items! {
                if let orderitem = item as? OrderItems {
                    data.items?.append(orderitem)
                    
                }
            }
            if OrderData().addOrder(orderDetails: data) {
                print("order added")
              //  print(self.i)
               // self.i += 1
               // print("reload table")
            //to-do reload table
                self.orderDetails.removeAll()
                self.viewDidAppear(true)
            }
            }, error: { (error) in
                self.navbarIndicator.stopAnimating()
                //print("items cannot be found \(error)")
                if OrderData().addOrder(orderDetails: data) {
                  //  print("reload data error side")
                    //to-do reload table
                    self.orderDetails.removeAll()
                    self.viewDidAppear(true)
                }
        })
        
        
    }
    
    func loadlist1(notification : Notification) {
        print("Notification detected for new orders")
        let orderId = (notification.userInfo?["orderId"])! as! String
        let status = (notification.userInfo?["status"])! as! String
        
        if OrderData().updateOrder(id: orderId, status: status) {
            print("saved")
            viewDidAppear(true)
        }
        
        
    }
    
    
}
