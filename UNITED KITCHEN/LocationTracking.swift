//
//  LocationTracking.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 09/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView

class LocationTracking: UIViewController , MKMapViewDelegate  {
    
    //@IBOutlet weak var map: MKMapView!
    var map = MKMapView()
    let backendless = Backendless.sharedInstance()
    var subscription = [BESubscription]()
    var points = [MKPointAnnotation]()
    var channels = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        map.delegate = self
        self.view.addSubview(map)
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lanDelta: CLLocationDegrees = 0.05
        
        let lonDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        
        let orders = OrderData().getOrders()
        channels.removeAll()
        for order in orders {
            if order.locationTrackingChannel != "nil" && order.isDelivered != "1" {
                print("location tracking chennels \(order.locationTrackingChannel)")
                channels.append(order.locationTrackingChannel!)
            }
        }
        
        if channels.count != 0 {
        for chennel in channels {
        
            backendless?.messaging.subscribe(chennel, subscriptionResponse: { (messages) in
                print("datareceived")
                if messages?.count != 0 {
                if   let data = messages?[0].data as? String {
                 print("subscription response \(data)")
                    let coordinates = Misc().getCoordinates(data: data)
                     print("coordinates are \(coordinates)")
                     let region = MKCoordinateRegion(center: coordinates, span: span)
                    self.map.setRegion(region, animated: true)
                    if self.points.count != 0 {
                   // self.map.removeAnnotations(self.points)
                    }
                     let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    self.points.removeAll()
                    self.points.append(annotation)
                    self.map.addAnnotation(annotation)

                }
                }
                }, subscriptionError: { (fault) in
                    SCLAlertView().showWarning("Error", subTitle: "Cannot subscribe to location tracking channel because of the followinf error \n\(fault?.message)\nPlease try again")
          
                }, response: { (subs) in
                    self.subscription.append(subs!)
                }, error: { (fault) in
                    print(fault)
                // do nothing
            })
        }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for subs in subscription {
            subs.cancel()
        }
    }
    
//        backendless?.messaging.subscribe("map", subscriptionResponse: { (messages) in
//            if (messages?.count)! > 0 {
//                print("datareceived")
//                if   let data = messages?[0].data as? String {
//                    
//                    print("subscription response \(data)")
//                    
//                    let coordinates = Util().getCoordinates(data: data)
//                    
//                    print("coordinates are \(coordinates)")
//                    
//                    
//                    let region = MKCoordinateRegion(center: coordinates, span: span)
//                    self.map.setRegion(region, animated: true)
//                    
//                    if self.points.count != 0 {
//                        self.map.removeAnnotations(self.points)
//                    }
//                    
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = coordinates
//                    self.points.removeAll()
//                    self.points.append(annotation)
//                    
//                    self.map.addAnnotation(annotation)
//                    
//                }
//                
//            }
//            
//            }, subscriptionError: { (error) in
//                print("error subscription \(error)")
//            }, response: { (response) in
//                print("messaging response \(response)")
//                self.subscription = response!
//            }, error: { (error) in
//                print("messaging error \(error)")
//        })
//        
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "food.png")!   // go ahead and use forced unwrapping and you'll be notified if it can't be found; alternatively, use `guard` statement to accomplish the same thing and show a custom error message
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
