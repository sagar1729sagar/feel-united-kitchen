//
//  TodayOrders.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 10/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView

class TodayOrders: UIViewController, UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , UISearchResultsUpdating {
    
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
            if order.isDelivered == "0" {
                
                if DateHandler().isTodayDate(date: order.deliveryDate!) {
                    
                    orderDetails.append(order)
                }
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
        let cell = table.dequeueReusableCell(withIdentifier: "activetodaycell", for: indexPath) as! OrderDisplayCell
        
        
        
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
    



    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        navbarIndicator.startAnimating()
        // check and register for admin
        backendless?.messaging.getRegistrationAsync({ (response) in
           
            if (response?.channels.contains("admin"))!{
                self.refreshItems()
            } else {
                self.registerForAdmin()
            }
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
               
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
        })
    }
    func refreshItems() {
        i = 0
        // only active orders are refreshed
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: Date())
    
       
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setPageSize(100)
        
        queryBuilder?.setWhereClause(String(format: "deliveryDate >= %@", dateString))
  
        if OrderData().deleteOrders(){
            backendless?.data.of(OrderDetails.ofClass()).find(queryBuilder, response: { (data) in
                self.navbarIndicator.stopAnimating()
               
                if data?.count == 0 {
                  
                    if OrderData().deleteOrders(){
                        self.orderDetails.removeAll()
                        
                        self.viewDidAppear(true)
                    }
                }
                
                for item in data! {
                    if let order = item as? OrderDetails {
                        self.getItemsFromServer(data: order)
                    }
                }
                }, error: { (fault) in
                    self.navbarIndicator.stopAnimating()
                   
                    SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
            })
        }
    }
    
    func registerForAdmin() {
        backendless?.messaging.registerDevice(["admin"], response: { (response) in
          
            self.refreshItems()
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
               
                SCLAlertView().showError("Error", subTitle: "Cannot fetch details as the following error occured \(fault?.message)")
                
        })
    }
    
    func getItemsFromServer( data :OrderDetails) {
       
        navbarIndicator.startAnimating()
        let whereClause = "orderId = "+data.orderId!
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setPageSize(100)
        queryBuilder?.setWhereClause(whereClause)
        backendless?.data.of(OrderItems.ofClass()).find(queryBuilder, response: { (items) in
            self.navbarIndicator.stopAnimating()
           
            for item in items! {
                if let orderitem = item as? OrderItems {
                    data.items?.append(orderitem)
                    
                }
            }
            if OrderData().addOrder(orderDetails: data) {
              

                self.orderDetails.removeAll()
                self.viewDidAppear(true)
            }
            }, error: { (error) in
                self.navbarIndicator.stopAnimating()
             
                if OrderData().addOrder(orderDetails: data) {
 
                    self.orderDetails.removeAll()
                    self.viewDidAppear(true)
                }
        })
        
        
    }

}
