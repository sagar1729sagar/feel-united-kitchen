//
//  ItemsList.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 10/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView

class ItemsList: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    let backendless = Backendless.sharedInstance()
    var navbarIndicator = UIActivityIndicatorView()
    var lunchDates = [String]()
    var dinnerDates = [String]()
    var orders = [OrderDetails]()
    var allDates = [String]()
    var sectionHeaders = [String]()
    var dates = [String]()
    var times = [String]()
    var items = [String]()
    var qunatities = [Int]()
    var itemEntries = [[String]]()
    var quantityEntries = [[Int]]()

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([left!,spinner], animated: true)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        orders.removeAll()
        lunchDates.removeAll()
        dinnerDates.removeAll()
        sectionHeaders.removeAll()
        dates.removeAll()
        times.removeAll()
        allDates.removeAll()
        items.removeAll()
        qunatities.removeAll()
        itemEntries.removeAll()
        quantityEntries.removeAll()
        orders = OrderData().getOrders()
        // Create dates list
     
        for order in orders {
            if order.deliveryTime == "0" {
                //lunch
                let dateString = DateHandler().dateToString(date: order.deliveryDate!)
                if !lunchDates.contains(dateString) {
                    lunchDates.append(dateString)
                }
                if !allDates.contains(dateString){
                    allDates.append(dateString)
                }
            } else if order.deliveryTime == "1" {
                let dateString = DateHandler().dateToString(date: order.deliveryDate!)
                if !dinnerDates.contains(dateString){
                    dinnerDates.append(dateString)
                }
                if !allDates.contains(dateString) {
                    allDates.append(dateString)
                }
            }
        }
    
        for date in allDates {
            if lunchDates.contains(date) {
                sectionHeaders.append(date+" (Lunch)")
                dates.append(date)
                times.append("0")
                
            }
            if dinnerDates.contains(date) {
                sectionHeaders.append(date+" (Dinner)")
                dates.append(date)
                times.append("1")
            }
        }
   
        
    
        if dates.count != 0 {
        for i in 0...(dates.count - 1){
           
            items.removeAll()
            qunatities.removeAll()
            for order in orders {
                
                if order.deliveryTime == times[i] {
                 
                    if DateHandler().dateToString(date: order.deliveryDate!) == dates[i] {
                       
                        for item in order.items! {
                        
                            if items.contains(item.name!) {
                           
                                for j in 0...(items.count - 1){
                                
                                    if items[j] == item.name! {
                                     
                                        qunatities[j] = qunatities[j] + Int(item.quantity!)!
                                        
                                    }
                                }
                            } else {
                             
                                items.append(item.name!)
                                qunatities.append(Int(item.quantity!)!)
                            }
                        }
                    }
                }
            }
          
            itemEntries.append(items)
            quantityEntries.append(qunatities)
        }
        }
       
        
        
    table.reloadData()
     
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return lunchDates.count + dinnerDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemEntries[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        cell.textLabel?.text = itemEntries[indexPath.section][indexPath.row]
        let qL = UILabel(frame: CGRect(x: 2*UIScreen.main.bounds.width/3, y: (cell.textLabel?.frame.origin.y)! + 10, width: UIScreen.main.bounds.width/3 - 30, height: 20))
        qL.textAlignment = .right
        qL.text = String(quantityEntries[indexPath.section][indexPath.row])
        cell.addSubview(qL)

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 
        return sectionHeaders[section]
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func refersh(_ sender: UIBarButtonItem) {
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
      //  i = 0
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

                self.viewDidAppear(true)
            }
            }, error: { (error) in
                self.navbarIndicator.stopAnimating()
               
                if OrderData().addOrder(orderDetails: data) {

                    self.viewDidAppear(true)
                }
        })
        
        
    }

    
   
}
