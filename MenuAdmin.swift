//
//  MenuAdmin.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 23/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import HMSegmentedControl
import SDWebImage
import UIActivityIndicator_for_SDWebImage
import iCarousel
import SCLAlertView
import DCAnimationKit


class MenuAdmin: UIViewController , iCarouselDataSource , iCarouselDelegate{
    
    let backendless = Backendless.sharedInstance()
   // let coachMarksController = CoachMarksController()
    var days = [String]()
    var firstDate : Date?
    var selectedDate = Date()
    var dateTitleString = ""
    var navbarIndicator = UIActivityIndicatorView()
    var foodTypeSelection = HMSegmentedControl()
    var carousel = iCarousel()
    var menuItems = [Item]()
    var datesDifference : Int = 0
    var nmbrofStarters = 0
    var nmbrofMaincourseItems = 0
    var nmbrofDeserts = 0
    var cartItems = [Cart]()
    var dinnerButton = UIButton()
    var addButton = UIButton()
    var priceLabel = UILabel()
    var priceLabel1 = UILabel()
    var priceLabel2 = UILabel()
    
    
    
    

    override func viewDidLoad() {
        
        print("didload")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadlist(notification:)), name: Notification.Name("menuupdate"), object: nil)
        
  
        
        
        if let firstOpen = UserDefaults.standard.object(forKey: "firstOpen") as? Bool {
            
            // not first launch
          //  print("Not first launch")
            
            if firstOpen {
                
                getMenuData()
            }
            
        } else {
            // first launch
          //  print("first launch")
            getMenuData()
            UserDefaults.standard.set(false, forKey: "firstOpen")
        }
        
        MiscData().addIndex(index: 0)
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
       // self.view.backgroundColor = UIColor.clear

        foodTypeSelection = HMSegmentedControl(sectionTitles: ["Starters","Main Course","Deserts"])
        foodTypeSelection.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!*1.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/12)
        foodTypeSelection.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
        foodTypeSelection.selectionStyle = .fullWidthStripe
        foodTypeSelection.selectionIndicatorColor = UIColor(red: 153/255, green: 153/255, blue: 255/255, alpha: 1)
        foodTypeSelection.selectionIndicatorHeight = 5
        foodTypeSelection.titleTextAttributes = ["titleColor" : UIColor.white]
        foodTypeSelection.selectionIndicatorLocation = .down
        foodTypeSelection.selectedSegmentIndex = 0
        foodTypeSelection.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(foodTypeSelection)
        
        carousel = iCarousel(frame: CGRect(x: 0, y: foodTypeSelection.frame.origin.y + foodTypeSelection.bounds.height , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - foodTypeSelection.bounds.height - (self.navigationController?.navigationBar.frame.height)! - (self.tabBarController?.tabBar.frame.height)!*1.5))
//        carousel = iCarousel(frame: CGRect(x: 0, y: foodTypeSelection.frame.origin.y , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - foodTypeSelection.bounds.height - (self.navigationController?.navigationBar.frame.height)! - (self.tabBarController?.tabBar.frame.height)!))
        carousel.type = .coverFlow2
        carousel.dataSource = self
        carousel.delegate = self
        self.view.addSubview(carousel)
        //carousel.reloadData()
        
        
        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        let left = self.navigationItem.leftBarButtonItems
        let spinner = UIBarButtonItem(customView: navbarIndicator)
       // self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        self.navigationItem.setLeftBarButtonItems([(left?[0])!,(left?[1])!,spinner], animated: true)
        
        

        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        
       // coachMarksController.startOn(self)
        
        print("View appeared")
        
        
        if DateHandler().dateToString(date: Date()) == DateHandler().dateToString(date: MiscData().getRefreshDate()) {
            // check for cart items
            print("Same day")
            if CartData().getItems().1 != 0 {
            let names = MenuItemsData().getMenu().0
            let carts = CartData().getItems().0
            for cartsItem in carts {
                if !checkForItem(name: cartsItem.itemName!, items: names) {
                    if CartData().deleteItems(ofName: cartsItem.itemName!) {
                        // donothing
                    }
                }
            }
        }
        MiscData().addRefreshDate(date: Date())
        } else {
            print("Other day")
            MiscData().addRefreshDate(date: Date())
            getMenuData()
        }
        
        
        
        
        
        let items = MenuItemsData().getMenu()
        let cart = CartData().getItems()
        if cart.2 {
            cartItems.removeAll()
            cartItems = cart.0
        }
        if items.2 {
          //  print("value returned \(items.1)")
            menuItems.removeAll()
            menuItems = items.0
            countCategerioes(items: menuItems)
            
        }
        
        
        
        // Setting number badges
    
        
        if CartData().getItems().1 != 0 {
        
        if ProfileData().profileCount().0 != 0 {
            if ProfileData().getProfile().0.accountType == "admin" {
                
            } else {
                 self.navigationItem.rightBarButtonItems?.last?.addBadge(number: CartData().getItems().1)
                 tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
            }
        } else {
            self.navigationItem.rightBarButtonItems?.last?.addBadge(number: CartData().getItems().1)
            tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
        }
        } else {
            self.navigationItem.rightBarButtonItems?.last?.removeBadge()
            tabBarController?.tabBar.items?[1].badgeValue = nil
        }
        
        // setting up dates DropDownMenu
        var date_intr = DateHandler().getNext7Days()
        
        if dateTitleString == "" {
            dateTitleString = date_intr.0[0]
        }
        
        if days.count == 0 {
      //  print("zero count")
            days = date_intr.0
            firstDate = date_intr.1[0]
        } else {
      //  print("Non zero")
            if DateHandler().isTodayDate(date: firstDate! ) {
                print("today")
//                selectedDate = date_intr.1[0]
//                MiscData().addDate(date: selectedDate)
            } else {
                print("Not today")
                days.removeAll()
                days = date_intr.0
                selectedDate = date_intr.1[0]
                MiscData().addDate(date: selectedDate)
                firstDate = date_intr.1[0]
                dateTitleString = date_intr.0[0]
            }
        }
        
        
        
        let datesMenu = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: (self.navigationController?.view)!, title: dateTitleString, items: days as [AnyObject])
        datesMenu.shouldKeepSelectedCellColor = true
        datesMenu.arrowTintColor = UIColor.blue
        datesMenu.cellBackgroundColor = UIColor.white
        datesMenu.cellSelectionColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
        self.navigationItem.titleView = datesMenu
//        if CartData().getItems().1  == 0 {
//            datesMenu.isUserInteractionEnabled = false
//        } else {
//            datesMenu.isUserInteractionEnabled = true
//        }
        datesMenu.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.selectedDate = date_intr.1[indexPath]
            MiscData().addDate(date: (self?.selectedDate)!)
            self?.dateTitleString = date_intr.0[indexPath]
            self?.removeCarouselSubviews()
            self?.carousel.reloadData()
          //  print("selected date \(self?.selectedDate)")
          //  print("selected date string \(self?.dateTitleString)")
            
        }
        
        removeCarouselSubviews()
        carousel.reloadData()
        
        
    }
    
    func valueChanged(sender:HMSegmentedControl) {
        
        switch foodTypeSelection.selectedSegmentIndex {
        case 0:
            carousel.scrollToItem(at: 0, animated: true)
            break
        case 1:
            carousel.scrollToItem(at: nmbrofStarters, animated: true)
            break
        case 2:
            carousel.scrollToItem(at: nmbrofStarters + nmbrofMaincourseItems, animated: true)
            break
        default:
            carousel.scrollToItem(at: 0, animated: true)
            break
        }
        
    }
    
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
        let mainVIew = UIView(frame: CGRect(x: 0, y: 0, width: 3*carousel.bounds.width/5, height: carousel.bounds.height))
        mainVIew.backgroundColor = UIColor.white
        
        
        let itemImage = UIImageView(frame: CGRect(x: 7, y: 7, width: mainVIew.bounds.width - 14, height: mainVIew.bounds.width - 14))
        let imageURL = URL(string: menuItems[index].itemUrl!)
        itemImage.setImageWith(imageURL, usingActivityIndicatorStyle: .gray)
        mainVIew.addSubview(itemImage)
        
       let type = UIImageView(frame: CGRect(x: itemImage.frame.origin.x + itemImage.bounds.width - 40, y: itemImage.frame.origin.y + itemImage.bounds.height - 40, width: 30, height: 30))
        if menuItems[index].foodType == "Veg"{
            type.image = UIImage(named: "veg.png")
        } else {
            type.image = UIImage(named: "nonveg.png")
        }
        mainVIew.addSubview(type)
        
        
        let nameLabel = UILabel(frame: CGRect(x: 7, y: itemImage.frame.origin.y + itemImage.bounds.height + 3, width: mainVIew.bounds.width - 14, height: UIScreen.main.bounds.height / 19))
        nameLabel.text = menuItems[index].itemName
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.height/28.4)
        mainVIew.addSubview(nameLabel)
        
        
        
        let line1 = UIView(frame: CGRect(x: 7, y: nameLabel.frame.origin.y + nameLabel.bounds.height + 3, width: mainVIew.bounds.width - 14, height: 1))
        line1.backgroundColor = UIColor.gray
        mainVIew.addSubview(line1)
        
        let line2 = UIView(frame: CGRect(x: 7, y: nameLabel.frame.origin.y + nameLabel.bounds.height + 6, width: mainVIew.bounds.width - 14, height: 1))
        line2.backgroundColor = UIColor.gray
        mainVIew.addSubview(line2)
        
        
        // draw circles to show availablity on several days
//        let circle1 = UIView(frame: CGRect(x: 7, y: itemImage.frame.origin.y + itemImage.bounds.height + 15, width: itemImage.bounds.width/7, height: itemImage.bounds.width/7))
//        circle1.layer.cornerRadius = itemImage.bounds.width/14
//        circle1.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
//        circle1.clipsToBounds = true
//        mainVIew.addSubview(circle1)
        let available = [menuItems[index].availableSunday,menuItems[index].availableMonday,menuItems[index].availableTuesday,menuItems[index].availableWednesday,menuItems[index].availableThrusday,menuItems[index].availableFriday,menuItems[index].availableSaturday]
        let day = ["Su","M","Tu","W","Th","F","Sa"]
        var circle1 = UILabel()
        for i in 0...6{
        circle1 = UILabel(frame: CGRect(x: 7 + (CGFloat(i)*line2.bounds.width/7) + 0.5, y: line2.frame.origin.y + 5, width: line2.bounds.width/7 - 1, height: line2.bounds.width/7))
             circle1.layer.cornerRadius = itemImage.bounds.width/14
            if available[i] == "1" {
            circle1.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        } else {
            circle1.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
            }
        circle1.textAlignment = .center
        circle1.text = day[i]
        circle1.textColor = UIColor.white
        circle1.clipsToBounds = true
        circle1.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/28.4)
        mainVIew.addSubview(circle1)
        }
        
        let line3 = UIView(frame: CGRect(x: 7, y: line2.frame.origin.y + 11 + circle1.bounds.height + 3 , width: mainVIew.bounds.width - 14, height: 1))
        line3.backgroundColor = UIColor.gray
        mainVIew.addSubview(line3)
        
        let line4 = UIView(frame: CGRect(x: 7, y: line2.frame.origin.y + 11 + circle1.bounds.height + 6 , width: mainVIew.bounds.width - 14, height: 1))
        line4.backgroundColor = UIColor.gray
        mainVIew.addSubview(line4)
        
      //  print(DateHandler().daysFromTodayTo(date: selectedDate))
        priceLabel = UILabel(frame: CGRect(x: 5, y: line4.bounds.height + line4.frame.origin.y + 2, width: 2*mainVIew.bounds.width/3 - 10, height: UIScreen.main.bounds.height/28.4))
        priceLabel.text = "$" + setPriceforDisplay(item: menuItems[index], howfarfrom: DateHandler().daysFromTodayTo(date: selectedDate))+" (Today)"
        //priceLabel.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.height/28.4)
        priceLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/38)
        mainVIew.addSubview(priceLabel)
        
        
        
        priceLabel1 = UILabel(frame: CGRect(x: 5, y: priceLabel.bounds.height + priceLabel.frame.origin.y + 2, width: 2*mainVIew.bounds.width/3 - 10, height: UIScreen.main.bounds.height/28.4))
        priceLabel1.text = "$" + setPriceforDisplay(item: menuItems[index], howfarfrom: DateHandler().daysFromTodayTo(date: selectedDate) + 1)+" (Next day)"
       // priceLabel1.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.height/28.4)
        priceLabel1.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/38)
        mainVIew.addSubview(priceLabel1)
        
        priceLabel2 = UILabel(frame: CGRect(x: 5, y: priceLabel1.bounds.height + priceLabel1.frame.origin.y + 2, width: 2*mainVIew.bounds.width/3 - 10, height: UIScreen.main.bounds.height/28.4))
        priceLabel2.text = "$" + setPriceforDisplay(item: menuItems[index], howfarfrom: DateHandler().daysFromTodayTo(date: selectedDate) + 2)+" (Later)"
        //priceLabel2.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.height/28.4)
        priceLabel2.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/38)
        mainVIew.addSubview(priceLabel2)
        
        if checkForitemAvailablefor(weekday: DateHandler().getDayofweekfor(date: selectedDate), item: menuItems[index]) {
        // addButton in lunch Button
         //let addButton = UIButton(frame: CGRect(x: 2*mainVIew.bounds.width/3, y: line4.bounds.height + line4.frame.origin.y + 2, width: mainVIew.bounds.width/3 - 5, height: 30))
             addButton = UIButton(frame: CGRect(x: 2*mainVIew.bounds.width/3 - 10, y: line4.bounds.height + line4.frame.origin.y + 2, width: mainVIew.bounds.width/3, height: UIScreen.main.bounds.height / 19))
            //if isInCart(name: menuItems[index].itemName!) {
           // if isInCart(name: menuItems[index].itemName!, date: selectedDate){
            if isInCart(name: menuItems[index].itemName!, date: selectedDate, time: "Lunch"){
                addButton.setTitle("In Cart", for: .normal)
                addButton.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 0.6)
                addButton.isEnabled = false
            } else {
            addButton.setTitle("Lunch", for: .normal)
            addButton.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)
            }
        
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/28.4)
       // addButton.layer.cornerRadius = 10
       // print(carousel.currentItemIndex)
       // addButton.tag = carousel.currentItemIndex
       // print(addButton.tag)
        addButton.tag = 0
        addButton.addTarget(self, action: #selector(addButtonPressed(sender:)), for: .touchDown)
        mainVIew.addSubview(addButton)
            
        
        
    
        // Dinner button
            
             dinnerButton = UIButton(frame: CGRect(x: 2*mainVIew.bounds.width/3 - 10, y: addButton.bounds.height + addButton.frame.origin.y + 2, width: mainVIew.bounds.width/3, height: UIScreen.main.bounds.height / 19))
           // if isInCart(name: menuItems[index].itemName!) {
//            if isInCart(name: menuItems[index].itemName!, date: selectedDate){
             if isInCart(name: menuItems[index].itemName!, date: selectedDate, time: "Dinner"){
                dinnerButton.setTitle("In Cart", for: .normal)
                dinnerButton.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 0.6)
                dinnerButton.isEnabled = false
            } else {
                dinnerButton.setTitle("Dinner", for: .normal)
                dinnerButton.backgroundColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)
            }
            
            dinnerButton.setTitleColor(UIColor.white, for: .normal)
            dinnerButton.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/28.4)
          //  dinnerButton.layer.cornerRadius = 10
            // print(carousel.currentItemIndex)
            // addButton.tag = carousel.currentItemIndex
            // print(addButton.tag)
            dinnerButton.tag = 1
            dinnerButton.addTarget(self, action: #selector(addButtonPressed(sender:)), for: .touchDown)
            mainVIew.addSubview(dinnerButton)
        
            
            
        } else {
            let NALabel = UILabel(frame: CGRect(x: line4.bounds.width / 2, y: line4.bounds.height + line4.frame.origin.y + UIScreen.main.bounds.height / 76 , width: line4.bounds.width / 2, height: 3*UIScreen.main.bounds.height / 38))
            NALabel.text = "N/A"
            NALabel.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.height/28.4)
            NALabel.textAlignment = .center
            mainVIew.addSubview(NALabel)
        }
        
        let line5 = UIView(frame: CGRect(x: 7, y: dinnerButton.frame.origin.y + dinnerButton.bounds.height + 2 , width: mainVIew.bounds.width - 14, height: 1))
        line5.backgroundColor = UIColor.gray
        mainVIew.addSubview(line5)
       
        let line6 = UIView(frame: CGRect(x: 7, y: dinnerButton.frame.origin.y + dinnerButton.bounds.height + 5, width: mainVIew.bounds.width - 14, height: 1))
        line6.backgroundColor = UIColor.gray
        mainVIew.addSubview(line6)
        
        let descTV = UITextView(frame :CGRect(x: 7, y: line6.frame.origin.y + 3, width: mainVIew.bounds.width - 14, height: mainVIew.bounds.height - line6.frame.origin.y - 5 - 11))
        descTV.text = menuItems[index].itemDescription
        descTV.isEditable = false
        descTV.clipsToBounds = true
        descTV.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/47.5)
        mainVIew.addSubview(descTV)
        //let factor = UIScreen.main.bounds.height/12
       // print("textview font factor \(factor)")
        
//        let line7 = UIView(frame: CGRect(x: 7, y: descTV.frame.origin.y + descTV.bounds.height + 10 , width: mainVIew.bounds.width - 14, height: 1))
//        line7.backgroundColor = UIColor.gray
//        mainVIew.addSubview(line7)
//        
//        let line8 = UIView(frame: CGRect(x: 7, y: descTV.frame.origin.y + descTV.bounds.height + 14 , width: mainVIew.bounds.width - 14, height: 1))
//        line8.backgroundColor = UIColor.gray
//        mainVIew.addSubview(line8)
        
        
        return mainVIew
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value*1.5
        }
        if option == .angle {
            return value*0.5
        }
        return value
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
        if menuItems[carousel.currentItemIndex].itemCategeory == "Straters" {
            foodTypeSelection.selectedSegmentIndex = 0
        } else if menuItems[carousel.currentItemIndex].itemCategeory == "Main Course" {
            foodTypeSelection.selectedSegmentIndex = 1
        } else if menuItems[carousel.currentItemIndex].itemCategeory == "Desert" {
            foodTypeSelection.selectedSegmentIndex = 2
        }
        
        //UserDefaults.standard.set(carousel.currentItemIndex, forKey: "item")
       // print("add index \(carousel.currentItemIndex)")
        MiscData().addIndex(index: carousel.currentItemIndex)
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
 
        let items = MenuItemsData().getMenu()
      //  let cart = CartData().getItems()
//        if cart.2 {
//            cartItems.removeAll()
//            cartItems = cart.0
//        }
        if items.2 {
          //  print("value returned \(items.1)")
           menuItems.removeAll()
           menuItems = items.0
            countCategerioes(items: menuItems)
            return items.1
        }
        return 0
    }
    
    func checkForitemAvailablefor(weekday : Int , item :Item) -> Bool {
        switch weekday - 1{
        case 0:
            if item.availableSunday == "1" {
                return true
            }
            break
        case 1:
            if item.availableMonday == "1" {
                return true
            }
            break
        case 2:
            if item.availableTuesday == "1" {
                return true
            }
            break
        case 3:
            if item.availableWednesday == "1" {
                return true
            }
            break
        case 4:
            if item.availableThrusday == "1" {
                return true
            }
            break
        case 5:
            if item.availableFriday == "1" {
                return true
            }
            break
        case 6:
            if item.availableSaturday == "1" {
                return true
            }
            break
        default:
            return false
        }
        return false
    }
    
    
    func loadlist(notification : Notification) {
        print("Notification detected for new menu")
        if CartData().deleteCart(){
            self.navigationItem.rightBarButtonItems?.last?.removeBadge()
            tabBarController?.tabBar.items?[1].badgeValue = nil
        getMenuData()
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
       // print("refresh pressed")
        if CartData().deleteCart() {
            self.navigationItem.rightBarButtonItems?.last?.removeBadge()
            tabBarController?.tabBar.items?[1].badgeValue = nil
        getMenuData()
        }

    }
    
    
    
   func getMenuData(){
    
    navbarIndicator.startAnimating()
    let queryBuilder = DataQueryBuilder()
    queryBuilder?.setPageSize(100)
    backendless?.data.of(Item.ofClass()).find(queryBuilder, response: { (data) in
        self.navbarIndicator.stopAnimating()
       // print("date recieved \(data?.count)")
        if (data?.count)! > 0 {
            if MenuItemsData().deleteMenu() {
            for object in data! {
                if let item = object as? Item {
                    if MenuItemsData().addItem(item: item) {
                       // print("Adding")
                    }
                }
            }
            }
        }
       // print("Items added")
        self.sortMenuData()
        self.removeCarouselSubviews()
       // self.carousel.reloadData()
        self.viewDidAppear(true)
        }, error: { (fault) in
            self.navbarIndicator.stopAnimating()
          //  print("cannnot recieve data with error \(fault)")
    })

    }
    
    func sortMenuData() {
        var sortedData = [Item]()
        let data = MenuItemsData().getMenu()
        if data.1 != 0 && data.2 {
            if MenuItemsData().deleteMenu() {
                for item in data.0 {
                    if item.itemCategeory == "Straters" {
                        MenuItemsData().addItem(item: item)
                    }
                }
                for item in data.0 {
                    if item.itemCategeory == "Main Course" {
                        MenuItemsData().addItem(item: item)
                    }
                }
                for item in data.0 {
                    if item.itemCategeory == "Desert" {
                        MenuItemsData().addItem(item: item)
                    }
                }
          
            }
        }
    }
    
    
    func setPriceforDisplay(item:Item, howfarfrom today:Int) -> String {
        if today == 0 {
            return item.priceToday!
        } else if today == 1 {
            return item.priceTomorrow!
        }
        return item.priceLater!
    }
    
    func countCategerioes(items : [Item]) {
        if items.count != 0  {
            nmbrofDeserts = 0
            nmbrofStarters = 0
            nmbrofMaincourseItems = 0
            for item in items {
                if item.itemCategeory == "Straters" {
                    nmbrofStarters += 1
                }
                if item.itemCategeory == "Main Course" {
                    nmbrofMaincourseItems += 1
                }
                if item.itemCategeory == "Desert" {
                    nmbrofDeserts += 1
                }
            
            }
        }
    }
    
    
  
    
    
    func addButtonPressed(sender:UIButton) {
        
      //  print("add Pressed")
        print("sender\(sender.tag)")
        
        if ProfileData().profileCount().0 != 0 {
            if ProfileData().getProfile().0.accountType == "admin" {
                
            } else {
                // add item to cart
              //  addItemToCart(tag: carousel.currentItemIndex)
                addItemToCart(tag: carousel.currentItemIndex, time: sender.tag)
              //  print("here1")
            }
        } else {
            // add item to Cart
           // addItemToCart(tag: carousel.currentItemIndex)
            addItemToCart(tag: carousel.currentItemIndex, time: sender.tag)
          //  print("here2")
        }
        
        cartItems.removeAll()
        cartItems = CartData().getItems().0
//        for item in cartItems {
//            print(item.itemName)
//        }
        removeCarouselSubviews()
       carousel.reloadData()
    }
    
    func isInCart(name : String , date : Date , time : String) -> Bool {
        let dateString = DateHandler().dateToString(date: date)
        for item in CartData().getItems().0 {
          //  print(item.itemName)
          //  print(name)
            if item.itemName == name && DateHandler().dateToString(date: item.addedDate!) == dateString && item.deliveryTime == time {
                return true
            }
        }
       
        return false
    }
    
    func addItemToCart(tag:Int , time : Int){
        
        let item = Cart()
        item.addedDate = selectedDate
        if time == 0 {
        item.deliveryTime = "Lunch"
        } else if time == 1 {
        item.deliveryTime = "Dinner"
        }
        item.itemName = menuItems[tag].itemName
        item.itemQuantity = "1"
        if CartData().addItem(item: item) {
            self.navigationItem.rightBarButtonItems?.last?.addBadge(number: CartData().getItems().1)
            tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
            removeCarouselSubviews()
            //carousel.reloadData()
           // print("added123")
        }
        
        
    }
    
    
    func checkForItem(name : String , items : [Item]) -> Bool{
    
        for item in items {
            
            if item.itemName == name {
                return true
            }
        
        }
        
        return false
        
    }
    
    
    @IBAction func cartPRessed(_ sender: AnyObject) {
        
        self.tabBarController?.selectedIndex = 1
       
   
        
    }
    
    
    func removeCarouselSubviews() {
        let views = carousel.subviews
        for sv in views {
            carousel.willRemoveSubview(sv)
        }
    }
    
    
  
}
