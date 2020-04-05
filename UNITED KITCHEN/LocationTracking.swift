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
import Backendless

class LocationTracking: UIViewController , MKMapViewDelegate  {
    
 
    var map = MKMapView()
    let backendless = Backendless.shared
    var subscription = [RTSubscription]()
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
                
                channels.append(order.locationTrackingChannel!)
            }
        }
        
        if channels.count != 0 {
        for chennel in channels {
            
            //            backendless?.messaging.subscribe(chennel, subscriptionResponse: { (messages) in
            //
            //                if messages?.count != 0 {
            //                if   let data = messages?[0].data as? String {
            //
            //                    let coordinates = Misc().getCoordinates(data: data)
            //
            //                     let region = MKCoordinateRegion(center: coordinates, span: span)
            //                    self.map.setRegion(region, animated: true)
            //                    if self.points.count != 0 {
            //
            //                    }
            //                     let annotation = MKPointAnnotation()
            //                    annotation.coordinate = coordinates
            //                    self.points.removeAll()
            //                    self.points.append(annotation)
            //                    self.map.addAnnotation(annotation)
            //
            //                }
            //                }
            //                }, subscriptionError: { (fault) in
            //                    SCLAlertView().showWarning("Error", subTitle: "Cannot subscribe to location tracking channel because of the followinf error \n\(fault?.message)\nPlease try again")
            //
            //                }, response: { (subs) in
            //                  //  self.subscription.append(subs!)
            //                }, error: { (fault) in
            //
            //                // do nothing
            //            })
        

            
            
          let sub =   backendless.messaging.subscribe(channelName: chennel).addStringMessageListener(responseHandler: { (data) in
                let coordinates = Misc().getCoordinates(data: data)
                
                 let region = MKCoordinateRegion(center: coordinates, span: span)
                self.map.setRegion(region, animated: true)
                if self.points.count != 0 {

                }
                 let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                self.points.removeAll()
                self.points.append(annotation)
                self.map.addAnnotation(annotation)
            }) { (fault) in
                SCLAlertView().showWarning("Error", subTitle: "Cannot subscribe to location tracking channel because of the followinf error \n\(String(describing: fault.message))\nPlease try again")
            }!
            
            self.subscription.append(sub)
            
        }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for subs in subscription {
            //subs.cancel()
            (subs as! RTSubscription).stop()
        }
        
    }
    


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
            annotationView!.image = UIImage(named: "food.png")!
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    



}
