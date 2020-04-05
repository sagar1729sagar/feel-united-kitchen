//
//  TestViewController.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 21/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import Backendless

class TestViewController: UIViewController {
    
    let backendless = Backendless.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        backendless.messaging.publish(channelName: "default", message: "Hello", responseHandler: { (status) in
            
        }, errorHandler: { (fault) in
            
        })
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

}
