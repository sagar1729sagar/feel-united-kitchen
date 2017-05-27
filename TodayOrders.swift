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
                print(order.deliveryDate)
                if DateHandler().isTodayDate(date: order.deliveryDate!) {
                    print("today")
                    orderDetails.append(order)
                }
            }
        }
        print(orderDetails)
        
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
        print("rows \(filtededids.count)")
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
        
        print(filtededids)
        print(filterOrders.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    func refreshItems() {
        i = 0
        // only active orders are refreshed
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: Date())
        print("date exp \(dateString)")
        print(dateString)
        // let whereClause = "isDelivered = '0'"
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setPageSize(100)
        // queryBuilder?.setWhereClause(whereClause)
        queryBuilder?.setWhereClause(String(format: "deliveryDate >= %@", dateString))
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

}
