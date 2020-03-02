//
//  LocationCell.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 01/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import MapKit
import SwiftLocation

class LocationCell: UITableViewCell {
    
    let lanDelta: CLLocationDegrees = 0.05
    
    let lonDelta: CLLocationDegrees = 0.05
    var coordinate : CLLocationCoordinate2D? = nil
    let annotation = MKPointAnnotation()
    var map = MKMapView()
    var retryButton = UIButton()
    var hasLocaton = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//       print("awake")
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        map = MKMapView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20))
        self.contentView.addSubview(map)
        
//        print(100)
      //  Location.requestAuthorizationIfNeeded(.always)
        
    Location.getLocation(accuracy: .navigation, frequency: .oneShot, success: { (_, location) -> (Void) in
        self.coordinate = location.coordinate
        let region = MKCoordinateRegion(center: self.coordinate!, span: span)
        self.map.setRegion(region, animated: true)
        self.annotation.coordinate = self.coordinate!
        self.map.addAnnotation(self.annotation)
//        print("Location found \(location.coordinate)")
//
//        self.hasLocaton = true
        }) { (_, location, error) -> (Void) in
         //   self.coordinate = (location?.coordinate)!
//            print("location error \(error)")
           
        }

//        print(101)
      retryButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: map.frame.origin.y + map.bounds.height, width: 60, height: 40))
        retryButton.addTarget(self, action: #selector(retryPressed(sender:)), for: .touchDown)
        retryButton.setTitle("RETRY", for: .normal)
        retryButton.setTitleColor(UIColor.blue, for: .normal)
        self.contentView.addSubview(retryButton)
        

        
    }
    
    func retryPressed(sender : UIButton){
   
        Location.getLocation(accuracy: .navigation, frequency: .oneShot, success: { (_, location) -> (Void) in
            self.map.removeAnnotation(self.annotation)
            self.coordinate = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: self.lanDelta, longitudeDelta: self.lonDelta)
            let region = MKCoordinateRegion(center: self.coordinate!, span: span)
            self.map.setRegion(region, animated: true)
            self.annotation.coordinate = self.coordinate!
            self.map.addAnnotation(self.annotation)
        }) { (_, location, error) -> (Void) in
         //   self.coordinate = location?.coordinate
//            print("location error \(error)")
           
        }
    }
    
    
    override func prepareForReuse() {
       
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
