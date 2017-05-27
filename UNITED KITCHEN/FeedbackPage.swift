//
//  FeedbackPage.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 09/05/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import SCLAlertView

class FeedbackPage: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    let backendless = Backendless.sharedInstance()
    var addPRessed : Bool = false
    var reviews = [feedback]()
    var addCell = AddFBCell()
    var noItemsLabel = UILabel()

    var navbarIndicator = UIActivityIndicatorView()
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        noItemsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        noItemsLabel.textAlignment = .center
        noItemsLabel.textColor = UIColor.gray
        noItemsLabel.text = "No FeedBack"
        noItemsLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        noItemsLabel.font = UIFont.systemFont(ofSize: 50)
        self.view.addSubview(noItemsLabel)
        
        table.allowsSelection = false
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([left!,spinner], animated: true)
        
        addPRessed = false

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CartData().getItems().1 != 0 {
            //  tabBarController?.tabBar.items[1].
            tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        }
        
        
        if FeedbackDB().fbCount() == 0 {
            noItemsLabel.isHidden = false
        } else {
            noItemsLabel.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        reviews = FeedbackDB().getFeedback()
        reviews = reviews.reversed()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addPRessed {
            return FeedbackDB().fbCount() + 1
        } else {
            return FeedbackDB().fbCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dummy = UITableViewCell()
        table.rowHeight = 250
        if addPRessed {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fbcell", for: indexPath) as! AddFBCell
                
                cell.fbtext.layer.borderWidth = 1
                cell.nameLabel.text = ProfileData().getProfile().0.personName
                cell.fbtext.isEditable = true
                cell.rating.settings.updateOnTouch = true
                cell.submitButton.addTarget(self, action: #selector(submitPressed(sender:)), for: .touchDown)
                cell.dismissButton.addTarget(self, action: #selector(dismissPressed(sender:)), for: .touchDown)
                //  self.tableView.rowHeight = cell.submitButton.frame.origin.y + cell.submitButton.frame.height + 30
                
                if addPRessed && indexPath.row == 0 {
                    //addCell = cell as! AddFBTableViewCell
                    addCell = cell
                    print("cell added")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fbcell", for: indexPath) as! AddFBCell
                
                let review = reviews[indexPath.row - 1]
                cell.nameLabel.text = review.name
                cell.fbtext.text = review.feedbackText
                cell.fbtext.layer.borderWidth = 0
                cell.rating.rating = Double(review.rating!)!
                cell.submitButton.isHidden = true
                cell.dismissButton.isHidden = true
                cell.fbtext.isEditable = false
                cell.rating.settings.updateOnTouch = false
                
                // self.tableView.rowHeight = cell.fbtext.frame.origin.y + cell.fbtext.contentSize.height + 20
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fbcell", for: indexPath) as! AddFBCell
            
            let review = reviews[indexPath.row]
            cell.nameLabel.text = review.name
            cell.fbtext.text = review.feedbackText
            cell.fbtext.layer.borderWidth = 0
            cell.rating.rating = Double(review.rating!)!
            cell.submitButton.isHidden = true
            cell.dismissButton.isHidden = true
            print(cell.fbtext.frame.origin.y)
            print(cell.fbtext.contentSize.height)
            cell.fbtext.isEditable = false
            cell.rating.settings.updateOnTouch = false
            
            
            
            return cell
        }
        
        // Configure the cell...
        
        return dummy

    }
    
    
    func submitPressed(sender : UIButton ){
        
        let review = (feedback)()
        let profile = ProfileData().getProfile().0
       // let profile = profiles[0]
        
        review.anonymous = "0"
        review.name = profile.personName
        review.rating = "\(addCell.rating.rating)"
        review.feedbackId = "\(FeedbackDB().fbCount() + 1)"
        
        let length = addCell.fbtext.text.characters.count
        if length < 2000 {
            review.feedbackText = addCell.fbtext.text
        } else {
            //self.addToast(message: "Length is more")
            SCLAlertView().showWarning("Character limit", subTitle: "Please limit your characters to 2000 and submit again")
        }
        
        saveInBackendless(review: review)
    
    }
    
    func dismissPressed(sender:UIButton){
        addPRessed = false
        self.table.reloadData()
    }
    
    
    func saveInBackendless (review : feedback) {
    
      //  SVProgressHUD.show()
        navbarIndicator.startAnimating()
        
        backendless?.data.of(feedback.ofClass()).save(review, response: { (result) in
            //SVProgressHUD.dismiss()
            self.navbarIndicator.stopAnimating()
            if let saved = result as? feedback {
                if FeedbackDB().addFeedback(fb: saved){
                    print("saved")
                    //     self.addCell.fbtext.layer.borderWidth = 0
                    self.addCell.submitButton.isHidden = true
                    self.addCell.dismissButton.isHidden = true
                    self.addPRessed = false
                    self.table.reloadData()
                    
                }
            }
            
            // send notification
           // self.registrationCheck(review: review)
            }, error: { (error) in
                print(error)
               // SVProgressHUD.dismiss()
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showWarning("Couldnt save", subTitle: "Couldnt save your review as the following error has occured \n \(error?.message) \n Please try again")
               // self.addToast(message: "Error in saving")
        })
        

    }

   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refresh(_ sender: UIBarButtonItem) {
         getFeedBackData()
    }
    @IBAction func addFB(_ sender: UIBarButtonItem) {
        if ProfileData().profileCount().0 == 0 {
            // self.createPopup(object: "", identifier: 0, actionButtonText: "Login")
           // self.createPopup(object: "", identifier: 0, actionButtonText: "LOGIN", title: "User not found", message: "Please login to add a review")
            SCLAlertView().showWarning("Login required", subTitle: "Please signup/login to proceed further")
        } else {
            addPRessed = true
            self.table.reloadData()
        }
    }
    
    func getFeedBackData() {
        
       /// SVProgressHUD.show()
        navbarIndicator.startAnimating()
     //   let dataQuery = BackendlessDataQuery()
       // let queryOptions = B
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setSortBy(["created ASC"])
        backendless?.data.of(feedback.ofClass()).find(queryBuilder, response: { (data) in
            self.navbarIndicator.stopAnimating()
                //let results = data?.getCurrentPage()
                if data?.count != 0 {
                    FeedbackDB().removeFB()
                    for result in data! {
                        if let fb = result as? feedback {
                            FeedbackDB().addFeedback(fb: fb)
                        }
                            }
                        }
                        self.addPRessed = false
                        self.table.reloadData()
            }) { (error) in
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showWarning("Cannot fetch", subTitle: "The following error has occured while fetching reviews \(error?.message) \n Please try again")
        }
    }
     //   queryOptions.sort(by: ["created ASC"])
//        dataQuery.queryOptions = queryOptions
//        backendless?.data.of(feedback.ofClass()).find(dataQuery, response: { (data) in
//            SVProgressHUD.dismiss()
//            let results = data?.getCurrentPage()
//            if results?.count != 0 {
//                FeedbackDB().removeFB()
//                for result in results! {
//                    if let fb = result as? feedback {
//                        FeedbackDB().addFeedback(fb: fb)
//                    }
//                }
//            }
//            self.addPRessed = false
//            self.tableView.reloadData()
//            }, error: { (error) in
//                SVProgressHUD.dismiss()
//                print(error)
//                self.createPopup(object: "", identifier: 1, actionButtonText: "RETRY", title: "Unknown error :(", message: "Would you like to try again?")
//        })
   // }

    
}
