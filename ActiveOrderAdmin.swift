//
//  ActiveOrderAdmin.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 07/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView
import Backendless

class ActiveOrderAdmin: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate,UISearchResultsUpdating {
    
    var i = 0

    let backendless = Backendless.shared
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
        
 
        
        
        
        return cell
    }
    

    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
//        backendless.data.of(OrderDetails()).remove(entity: order.objectId, responseHandler: { (response) in
//            
//            if OrderData().deleteOrder(id: order.orderId!) {
//            self.orderDetails.removeAll()
//            self.viewDidAppear(true)
//            }
//            
//            // delete items 
//            for id in childIDs {
//            self.backendless?.data.of(OrderItems.ofClass()).remove(byId: id, response: { (nmbr) in
//              
//                }, error: { (fault) in
//                    
//            })
//            }
//            
//            }) { (fault) in
//                
//                SCLAlertView().showError("Cannot delete", subTitle: "Cannot delete the order as the following error has occured.\n\(fault?.message)\nPlease try again")
//        }
        
        
        backendless.data.of(OrderDetails.self).removeById(objectId: order.objectId!, responseHandler: { (response) in
            if OrderData().deleteOrder(id: order.orderId!){
                self.orderDetails.removeAll()
                self.viewDidAppear(true)
            }
            //delete items
            for id in childIDs {
                self.backendless.data.of(OrderItems.self).removeById(objectId: id, responseHandler: { (nmbr) in
                    
                }) { (fault) in
                    
                }
            }
        }) { (fault) in
            SCLAlertView().showError("Cannot delete", subTitle: "Cannot delete the order as the following error has occured.\n\(String(describing: fault.message))\nPlease try again")
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
        
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func loadlist(notification : Notification) {
        navbarIndicator.startAnimating()
       
        let id = notification.userInfo?["orderId"] as! String
        let whereCaluse = "orderId = "+id
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setWhereClause(whereClause: whereCaluse)
        backendless.data.of(OrderDetails.self).find(queryBuilder: queryBuilder, responseHandler: { (data) in
            
            for item in data{
                if let order = item as? OrderDetails {
                    
                    self.getItemsFromServer(data: order)
                }
            }
            
        }, errorHandler: { (error) in
                self.navbarIndicator.stopAnimating()
               
            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: error.message))\n Please refresh page for new order to appear")
        })
        
        

        
    }


    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
         navbarIndicator.startAnimating()
        self.registerForAdmin()
    }
        // check and register for admin
//        backendless.messaging.getRegistrationAsync({ (response) in
//
//            if (response?.channels.contains("admin"))!{
//            self.refreshItems()
//            } else {
//                self.registerForAdmin()
//            }
//            }, error: { (fault) in
//                self.navbarIndicator.stopAnimating()
//
//                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
//        })
        
//
//        backendless.messaging.getDeviceRegistrations(responseHandler: { (responses) in
//            var is_registered_for_admin = false
//            for response in responses {
//                if (response.channels?.contains("admin") ?? false) {
//                    is_registered_for_admin = true
//                }
//            }
//            if (is_registered_for_admin){
//                self.refreshItems()
//            } else {
//                self.registerForAdmin()
//            }
//        }) { (fault) in
//            self.navbarIndicator.stopAnimating()
//            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
//        }
//
        
        
        
  //  }
    
    func registerForAdmin() {
//        backendless?.messaging.registerDevice(deviceToken: ["admin"], responseHandler: { (response) in
//
//            self.refreshItems()
//        }, errorHandler: { (fault) in
//                self.navbarIndicator.stopAnimating()
//
//                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
//
//        })
        
       
        
//        backendless.messaging.unregisterDevice(channels: ["admin"], responseHandler: { (response) in
//            self.refreshItems()
//        }) { (fault) in
//            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
//        }
        
        backendless.messaging.getDeviceRegistrations(responseHandler: { (responses) in
            var is_registered_for_admin = false
            var device_token = ""
            for response in responses {
                if ((response.channels?.contains("admin"))!) {
                    is_registered_for_admin = true
                    device_token = response.deviceToken!
                    break
                }
            }
            if (is_registered_for_admin){
                self.refreshItems()
            } else {
                //register for admin channel
            
                self.backendless.messaging.registerDevice(deviceToken: Data(device_token.utf8), channels: ["admin"], responseHandler: { (response) in
                    self.refreshItems()
                }) { (fault) in
                    SCLAlertView().showError("Error", subTitle: "Cannot register this devie as admin as the following error occured : \(String(describing: fault.message))")
                    self.refreshItems()
                }
            }
        }) { (fault) in
            self.navbarIndicator.stopAnimating()
            SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
            self.refreshItems()
        }
        
        
        
    }
    
    func refreshItems() {
        i = 0
        // only today orders are refreshed
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
//        dateFormatter.dateFormat = "YYYYMMDDHHMMSS"
//        let dateString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        let dateString = dateFormatter.string(from:NSDate() as Date)
      //  print(dateString)
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 100)
      
        queryBuilder.setWhereClause(whereClause: String(format: "deliveryDate >= '%@'", dateString))
//        queryBuilder.setWhereClause(whereClause: String(format: "deliveryDate at or after %@", dateString))
        
   
        if OrderData().deleteOrders(){
            backendless.data.of(OrderDetails.self).find(queryBuilder: queryBuilder, responseHandler: { (data) in
                self.navbarIndicator.stopAnimating()
             //   print("orders recieved")
                if data.count == 0 {
                 //   print("Order count 0")
                    if OrderData().deleteOrders(){
                        self.orderDetails.removeAll()
                        
                        self.viewDidAppear(true)
                    }
                }
                
                
                for item in data {
                    if let order = item as? OrderDetails {
                        self.getItemsFromServer(data: order)
                    }
                }
            }, errorHandler: { (fault) in
                    self.navbarIndicator.stopAnimating()
                 //   print(fault)
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(String(describing: fault.message))")
            })
        }
    }
    
    
    
    func getItemsFromServer( data :OrderDetails) {
       // print("getting items for \(String(describing: data.orderId))")
        navbarIndicator.startAnimating()
        data.items = [OrderItems]()
        let whereClause = "orderId = "+data.orderId!
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setWhereClause(whereClause: whereClause)
        backendless.data.of(OrderItems.self).find(queryBuilder: queryBuilder, responseHandler: { (items) in
            self.navbarIndicator.stopAnimating()
          //  print(items.count)
            for item in items {
                if let orderitem = item as? OrderItems {
                    data.items?.append(orderitem)
                    
                }
            }
            if OrderData().addOrder(orderDetails: data) {
                
                self.orderDetails.removeAll()
                self.viewDidAppear(true)
            }
        }, errorHandler: { (error) in
                self.navbarIndicator.stopAnimating()
                
                if OrderData().addOrder(orderDetails: data) {
                 
                    self.orderDetails.removeAll()
                    self.viewDidAppear(true)
                }
        })
        
        
             }
    
    @objc func loadlist1(notification : Notification) {
        
        let orderId = (notification.userInfo?["orderId"])! as! String
        let status = (notification.userInfo?["status"])! as! String
        
        if OrderData().updateOrder(id: orderId, status: status) {
            
            viewDidAppear(true)
        }
        
        
    }
    
    
}
