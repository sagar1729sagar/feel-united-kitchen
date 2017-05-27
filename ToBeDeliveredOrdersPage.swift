//
//  ToBeDeliveredOrdersPage.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 09/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView
import DCAnimationKit
import SwiftLocation
import MapKit

class ToBeDeliveredOrdersPage: UIViewController , UITableViewDelegate , UITableViewDataSource {

    let backendless = Backendless.sharedInstance()
    var navbarIndicator = UIActivityIndicatorView()
    var searchTF = UITextField()
    var addButton = UIButton()
    var startNavigationButton = UIButton()
    var orderDetails = [OrderDetails]()
    //var isNavigationStarted = false
   // var table = UITableView()
   // @IBOutlet weak var table: UITableView!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(spinner, animated: true)
        // Do any additional setup after loading the view.
        
        let navBarwidth = self.navigationController?.navigationBar.frame.width
        let navBarHeight = (self.navigationController?.navigationBar.frame.height)!*1.5
        
        
        searchTF = UITextField(frame: CGRect(x: 10, y: navBarHeight + 10, width: UIScreen.main.bounds.width - 20, height: 30))
        searchTF.layer.cornerRadius = 5
        searchTF.layer.borderWidth = 1
        searchTF.textAlignment = .center
        searchTF.keyboardType = .numberPad
        searchTF.placeholder = "  Enter OrderId"
        self.view.addSubview(searchTF)
        
        addButton = UIButton(frame: CGRect(x: 2*UIScreen.main.bounds.width/3 - 20, y:navBarHeight + 50, width: UIScreen.main.bounds.width/3, height: 30))
        addButton.setTitle("ADD", for: .normal)
        addButton.backgroundColor = UIColor.blue
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.addTarget(self, action: #selector(addPressed(sender:)), for: .touchDown)
        self.view.addSubview(addButton)
        
        startNavigationButton = UIButton(frame: CGRect(x: 10, y: navBarHeight + 50, width: 2*UIScreen.main.bounds.width/3 - 40, height: 30))
        startNavigationButton.setTitleColor(UIColor.white, for: .normal)
      //  if isNavigationStarted {
      //  startNavigationButton.setTitle("STOP NAVIGATION", for: .normal)
       // } else {
        startNavigationButton.setTitle("START NAVIGATION", for: .normal)
     //   }
        startNavigationButton.backgroundColor = UIColor.blue
        startNavigationButton.addTarget(self, action: #selector(startNavigation(sender:)), for: .touchDown)
        self.view.addSubview(startNavigationButton)
        
        table.frame = CGRect(x: 0, y: navBarHeight + 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - navBarHeight - 100)
        table.allowsSelection = false
       // table.separatorStyle = .singleLineEtched
        table.separatorColor = UIColor.red
        //table.backgroundColor = UIColor.blue
        
//        table = UITableView(frame: CGRect(x: 0, y: navBarHeight + 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - navBarHeight - 100))
//        table.delegate = self
//        table.dataSource = self
//        table.allowsSelection = false
//        self.view.addSubview(table)
        

        
        
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        orderDetails.removeAll()
        orderDetails = OrderData().getOrders()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows \(OrderData().getOrders().count)")
    //    print(OrderData().getOrders().count)
        return OrderData().getOrders().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        table.rowHeight = 400
        let cell = UITableViewCell()
        let idlabel = UILabel(frame: CGRect(x: 5, y: 5, width: UIScreen.main.bounds.width - 10, height: 30))
        idlabel.text = "Order ID : "+orderDetails[indexPath.row].orderId!
        cell.addSubview(idlabel)
        let cuslabel = UILabel(frame: CGRect(x: 5, y: 45, width: UIScreen.main.bounds.width - 10, height: 30))
        cuslabel.text = "Customer name : "+orderDetails[indexPath.row].customerName!
        cell.addSubview(cuslabel)
        let phnlabel = UILabel(frame: CGRect(x: 5, y: 85, width: UIScreen.main.bounds.width - 10, height: 30))
        phnlabel.text = "Customer number : "+orderDetails[indexPath.row].phoneNumber!
        cell.addSubview(phnlabel)
        let preflabel = UILabel(frame: CGRect(x: 5, y: 115, width: UIScreen.main.bounds.width - 10, height: 60))
        preflabel.numberOfLines = 2
        if orderDetails[indexPath.row].addressType == "0" {
            preflabel.text = "Delivery preference : \n Registered address"
        } else {
            preflabel.text = "Delivery preference : \n GPS Location"
        }
        cell.addSubview(preflabel)
        let giftlabel = UILabel(frame: CGRect(x: 5, y: 185, width: UIScreen.main.bounds.width - 10, height: 60))
        giftlabel.numberOfLines = 2
        if orderDetails[indexPath.row].isGifted == "0" {
            giftlabel.text = "Delivery for : \n self"
        } else {
            giftlabel.text = "Gifted by : \n "+orderDetails[indexPath.row].giftedBy!
        }
        cell.addSubview(giftlabel)
        
        let regAddTV = UITextView(frame: CGRect(x: 5, y: 255, width: UIScreen.main.bounds.width - 20, height: 100))
        regAddTV.font = UIFont.systemFont(ofSize: 15)
        regAddTV.text = "Registeres address : \n"+orderDetails[indexPath.row].deliveryAddress!
        cell.addSubview(regAddTV)
        
        let delComButton = UIButton(frame: CGRect(x: 5, y: 365, width: UIScreen.main.bounds.width - 10, height: 30))
        delComButton.setTitle("DELIVERY DONE", for: .normal)
        delComButton.setTitleColor(UIColor.white, for: .normal)
        delComButton.backgroundColor = UIColor.blue
        delComButton.tag = indexPath.row
        delComButton.addTarget(self, action: #selector(deliveryDone(sender:)), for: .touchDown)
        cell.addSubview(delComButton)
        
        if orderDetails[indexPath.row].addressType == "1" {
            table.rowHeight = 700
            let coordLabel = UILabel(frame: CGRect(x: 5, y: 400, width: UIScreen.main.bounds.width - 10, height: 90))
            let cordnts = getCoordinates(lat: orderDetails[indexPath.row].latitude!, long: orderDetails[indexPath.row].longitude!)
            coordLabel.numberOfLines = 3
            coordLabel.text = "GPS location : \n lat : "+cordnts.1+"\n long : "+cordnts.2
            cell.addSubview(coordLabel)
            
            let revGeoHeadLabel = UILabel(frame: CGRect(x: 5, y: 500, width: UIScreen.main.bounds.width - 10, height: 30))
            revGeoHeadLabel.text = "Reverse Geo coded placemark : "
            cell.addSubview(revGeoHeadLabel)
            
            let revGeoTV = UITextView(frame: CGRect(x: 5, y: 540, width: UIScreen.main.bounds.width - 10, height: 100))
            revGeoTV.font = UIFont.systemFont(ofSize: 15)
            revGeoTV.text = "Please wait..."
            revGeoTV.isEditable = false
            cell.addSubview(revGeoTV)
            let loc = CLLocation(latitude: cordnts.0.latitude, longitude: cordnts.0.longitude)
            Location.getPlacemark(forLocation: loc, success: { (placemark) -> (Void) in
                print("Placemark found \(placemark)")
                revGeoTV.text = "Placemark found \n \(placemark)"
                }, failure: { (error) -> (Void) in
                    print("reverse geo coding error \(error)")
                    revGeoTV.text = "Reverse geo coding error \(error)"
            })
            
            let setDIrectionsButton = UIButton(frame: CGRect(x: 5, y: 650, width: UIScreen.main.bounds.width, height: 30))
            setDIrectionsButton.setTitle("OPEN MAP", for: .normal)
            setDIrectionsButton.setTitleColor(UIColor.white, for: .normal)
            setDIrectionsButton.backgroundColor = UIColor.blue
            setDIrectionsButton.tag = indexPath.row
            setDIrectionsButton.addTarget(self, action: #selector(openMaps(sender:)), for: .touchDown)
            cell.addSubview(setDIrectionsButton)
            
        }
        
        // show location
        // location button
        
        
        return cell
        
    }
    
    
    
    func openMaps(sender : UIButton) {
        let tag = sender.tag
        let cords = getCoordinates(lat: orderDetails[tag].latitude!, long: orderDetails[tag].longitude!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: cords.0))
        mapItem.name = orderDetails[tag].orderId
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    
    func getCoordinates( lat : String , long :String) -> (CLLocationCoordinate2D,String,String) {
        
        let index1 = lat.characters.index(of: "(")
        let str1 = lat.substring(from: index1!)
        let index2 = str1.index(str1.startIndex, offsetBy: 1)
        //let index2 = str1.characters.index(of: ")")
        let str2 = str1.substring(from: index2)
        let index3 = str2.characters.index(of: ")")
        let str3 = str2.substring(to: index3!)
        
        let index4 = long.characters.index(of: "(")
        let str4 = long.substring(from: index4!)
        let index5 = str4.index(str4.startIndex, offsetBy: 1)
        //let index2 = str1.characters.index(of: ")")
        let str5 = str4.substring(from: index5)
        let index6 = str5.characters.index(of: ")")
        let str6 = str5.substring(to : index6!)
        
        
        
        
        
//        let index3 = long.characters.index(of: "(")
//        let str3 = long.substring(from: index3!)
//        let index4 = str3.characters.index(of: ")")
//        let str4 = str3.substring(to: index4!)
//        
        let crd = CLLocationCoordinate2D(latitude: Double(str3)!, longitude: Double(str6)!)
        
        return (crd,str3,str6)
    }
    
//        let index1 = data.characters.index(of: ":")
//        let str1 = data.substring(from: index1!)
//        let index2 = str1.index(str1.startIndex, offsetBy: 2)
//        let str2 = str1.substring(from: index2)
//        let index3 = str2.characters.index(of: ",")
//        let str3 = str2.substring(to: index3!)
//        let index4 = str2.characters.index(of: ":")
//        let str4 = str2.substring(from: index4!)
//        let index5 = str4.index(str4.startIndex, offsetBy: 2)
//        let str5 = str4.substring(from: index5)
//        let index6 = str5.characters.index(of: ")")
//        let str6 = str5.substring(to: index6!)
//        
//        let lat : CLLocationDegrees = Double(str3)!
//        let long : CLLocationDegrees = Double(str6)!
//        
//        print("latitude \(lat) longitude \(long)")
//        
//        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        return coordinates
  //  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func addPressed(sender : UIButton) {
        if searchTF.text?.characters.count == 0 {
        searchTF.tada(nil)
        } else {
        navbarIndicator.startAnimating()
        let whereClause = "orderId = "+searchTF.text!
        let query = DataQueryBuilder()
        query?.setWhereClause(whereClause)
        backendless?.data.of(OrderDetails.ofClass()).find(query, response: { (data) in
           // self.navbarIndicator.stopAnimating()
            if data?.count == 0 {
                self.navbarIndicator.stopAnimating()
            SCLAlertView().showWarning("Error", subTitle: "No such order exist")
            } else {
                if let order = data![0] as? OrderDetails {
                    if order.status != "3" {
                        self.navbarIndicator.stopAnimating()
                    SCLAlertView().showWarning("Too soon", subTitle: "Order not ready for delivery")
                    } else {
                        self.changeLocationTackingChannel(data: order)
//                        if OrderData().addOrder(orderDetails: order) {
//                        print("order added")
//                        self.table.reloadData()
//                        }
                    }
                }
            }
            }, error: { (fault) in
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showWarning("Cannot fetch", subTitle: "Error : \(fault)")
        })
    }
    }
    
    
    func changeLocationTackingChannel(data :OrderDetails) {
    print("updating location tracking channel")
    data.status = "4"
    data.locationTrackingChannel = "C"+ProfileData().getProfile().0.phoneNumber!
    backendless?.data.of(OrderDetails.ofClass()).save(data, response: { (result) in
        print("Örder updated")
        if let returned = data as? OrderDetails {
            if OrderData().addOrder(orderDetails: data) {
                self.sendNotification(data : returned)
                self.table.reloadData()
            }
        }
        }, error: { (error) in
            self.navbarIndicator.stopAnimating()
            print("updating location tracking hcannel error \(error)")
            SCLAlertView().showWarning("Error", subTitle: "The following error has occured while updating order status \n\(error)\n Please try again")
    })
    }
    
    func sendNotification(data : OrderDetails) {
        let publishOptions = PublishOptions()
        let headers = ["ios-alert":" Order Update recieved","ios-badge":"1","ios-sound":"default","type":"orderupdate","orderId":data.orderId!,"status":data.status!]
        publishOptions.assignHeaders(headers)
        backendless?.messaging.publish("C"+data.phoneNumber!, message: "Any", publishOptions: publishOptions, response: { (response) in
            print("notification published \(response)")
            self.navbarIndicator.stopAnimating()
            self.sendOrderUpdatesToAdmin(data: data)
            
            if data.isGifted == "1" {
                
                
                self.backendless?.messaging.publish("C"+data.giftedBy!, message: "any", publishOptions: publishOptions, response: { (response) in
                    print("notification published gifted \(response)")
                    }, error: { (error) in
                        print("Cannot publish notification")

                })
                
            }
            
            
            
            
            }, error: { (error) in
                self.navbarIndicator.stopAnimating()
                print("Cannot publish notification")
        })

    }

    @IBAction func clear(_ sender: UIBarButtonItem) {
        if OrderData().deleteOrders() {
            print("items deleted")
            table.reloadData()
            
        }
        
    }
    
    
    
    
    func startNavigation(sender : UIButton) {
      //  if isNavigationStarted {
        //Request.cancel()
      //  Lo
      //
      //  }
        print("Navigation started")
        
    
        
//        Location.getLocation(withAccuracy: .navigation, frequency: .significant, timeout: nil, onSuccess: { (location) in
//            //            print(location)
//            let coordinates = location.coordinate
//            //            let message = Message()
//            //            message.data = coordinates
//            SVProgressHUD.show()
//            self.backendless?.messaging.publish("map", message: "\(coordinates)", response: { (status) in
//                SVProgressHUD.dismiss()
//                print("message published status \(status)")
//                }, error: { (error) in
//                    SVProgressHUD.dismiss()
//                    print("Message publishing error \(error)")
//            })
//        }) { (location, error) in
//            print("cannot get location \(error)")
//        }
//     
        
        Location.getLocation(accuracy: .navigation, frequency: .significant, timeout: nil, success: { (locReq, location) -> (Void) in
            print(location)
            let coordinates = location.coordinate
            let message = Message()
            message.data = coordinates
            self.backendless?.messaging.publish("C"+ProfileData().getProfile().0.phoneNumber!, message: "\(coordinates)", response: { (response) in
                print("data published \(response)")
                self.navbarIndicator.stopAnimating()
                }, error: { (error) in
                    self.navbarIndicator.stopAnimating()
                    print("cannot publish data")
            })
            }) { (locReq, loc, error) -> (Void) in
                self.navbarIndicator.stopAnimating()
                print("Cannot get location error")
        }
        
    }
    
    func deliveryDone(sender : UIButton) {
        print("Dleivey done presed")
    
        let order = orderDetails[sender.tag]
        
        order.status = "5"
        order.isDelivered = "1"
        navbarIndicator.startAnimating()
        backendless?.data.of(OrderDetails.ofClass()).save(order, response: { (response) in
            print("saving done")
            if let data = response as? OrderDetails {
                print("casted")
                if OrderData().updateOrder(id: data.orderId!, status: data.status!) {
                    print("Data updated")
                    
                    sender.setTitle("DONE", for: .normal)
                    sender.backgroundColor = UIColor.yellow
                    
                    self.sendNotification(data: data)
                    
                    
                    // send notification
                }
            }
            }) { (fault) in
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showWarning("Error", subTitle: "Order status cannot be updated as the following error has occured \n(fault?.message)\n Please try again")
        }
        
        
    }
    
    func sendOrderUpdatesToAdmin(data : OrderDetails) {
        let publishOptions = PublishOptions()
        let headers = ["ios-alert":" Order Update recieved","ios-badge":"1","ios-sound":"default","type":"orderupdateadmin","orderId":data.orderId!,"status":data.status!]
        publishOptions.assignHeaders(headers)
        backendless?.messaging.publish("admin", message: "Any", publishOptions: publishOptions, response: { (response) in
            print("notification published \(response)")
          //  self.navbarIndicator.stopAnimating()
            
            
            }, error: { (error) in
               // self.navbarIndicator.stopAnimating()
                print("Cannot publish notification")
        })
        
    }
    
    
}
