//
//  ProfilePage.swift
//  UNITED KITCHEN
//
//  Created by VIDYA SAGAR on 12/04/17.
//  Copyright © 2017 SSappS. All rights reserved.
//

import UIKit
import DCAnimationKit
import SCLAlertView
import Backendless

class ProfilePage: UIViewController {
    
    let backendless = Backendless.shared
    let indicator = UIActivityIndicatorView()
    var initialNumberGrabberTF : UITextField?
    var initialGoButton : UIButton?
    var passwordTF : UITextField?
    var nameTF : UITextField?
    var emailTF : UITextField?
    var addressTV : UITextView?
    var createAccountButton : UIButton?
    var removeProfileButton : UIButton?
    var navbarIndicator = UIActivityIndicatorView()
    
    var phoneLabel : UITextField?
    var nameLabel : UITextField?
    var emailLabel : UITextField?
    var addressTV1 : UITextView?
    var passwordLabel : UITextField?
    var forgotPasswordButton : UIButton?
    var loginButton : UIButton?
    var email_intr : String?
    var prof_intr : Profile?
    
    var isProfileEditing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        navbarIndicator.hidesWhenStopped = true
        navbarIndicator.color = UIColor.red
        navbarIndicator.frame.origin.x = 100
        navbarIndicator.frame.origin.y = 30
        let right = self.navigationItem.rightBarButtonItem
        let spinner = UIBarButtonItem(customView: navbarIndicator)
        self.navigationItem.setRightBarButton(nil, animated: true)
        self.navigationItem.setRightBarButtonItems([right!,spinner], animated: true)
        
        
        let count = ProfileData().profileCount()
        if count.1 {
            
            if count.0 == 0 {
                // When no profile is present
                initalNumberGrab()
            } else {
                let getProfile = ProfileData().getProfile()
                if getProfile.1 {
                    displayProfileDetails(profile: getProfile.0)
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        
        
      isProfileEditing = false
        
        // Setting number badges
        
        
        if CartData().getItems().1 != 0 {
            
            if ProfileData().profileCount().0 != 0 {
                if ProfileData().getProfile().0.accountType == "admin" {
                    
                } else {
                   
                    tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
                }
            } else {
              
                tabBarController?.tabBar.items?[1].badgeValue = "\(CartData().getItems().1)"
            }
        } else {
            
            tabBarController?.tabBar.items?[1].badgeValue = nil
        }
    }
    
    
    func initalNumberGrab() {
        
        initialNumberGrabberTF = UITextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height/2 - 20, width: UIScreen.main.bounds.width - 20, height: 40))
        initialNumberGrabberTF?.keyboardType = .phonePad
        setTextFieldAttribuetes(view: initialNumberGrabberTF!, placeHolderText: "  Enter your mobile number")
        self.view.addSubview(initialNumberGrabberTF!)
        
        initialGoButton = UIButton(frame: CGRect(x: (3 * UIScreen.main.bounds.width)/4 - 30, y: (initialNumberGrabberTF?.frame.origin.y)! + 55, width: UIScreen.main.bounds.width/4, height: 40))
        initialGoButton?.layer.cornerRadius = 8
        initialGoButton?.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        initialGoButton?.setTitle("GO", for: .normal)
        initialGoButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        initialGoButton?.addTarget(self, action: #selector(initialGoButtopnPressed(sender:)), for: .touchDown)
        self.view.addSubview(initialGoButton!)
        

        
        
       
    }
    
    @objc func initialGoButtopnPressed(sender : UIButton) {
        if initialNumberGrabberTF?.text?.characters.count == 0 {
            initialNumberGrabberTF?.tada(nil)
        } else {
            initialGoButton?.isEnabled = false
            initialGoButton?.setTitle("", for: .disabled)
            indicator.frame.origin.x = (initialGoButton?.bounds.width)!/2
            indicator.frame.origin.y = (initialGoButton?.bounds.height)!/2
            indicator.hidesWhenStopped = true
            indicator.color = UIColor.white
            indicator.contentMode = .center
            indicator.startAnimating()
            initialGoButton?.addSubview(indicator)
            checkForRegistration()
            
        }
    }
    
    func checkForRegistration(){
        
        let phoneNumber = initialNumberGrabberTF?.text
        let whereclause = "phoneNumber = "+phoneNumber!
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setWhereClause(whereClause: whereclause)
        
        backendless.data.of(Profile.self).find(queryBuilder: queryBuilder, responseHandler: { (data) in
            //Recieved Data
            if data.count == 0 {
                // No profile registered with that number
                // Display registration paramenters
                self.navigateToRegister()
                
            } else {
                if let obj = data[0] as? Profile {
                    self.askForLogin(profile: obj)
                }
                
            }
        }, errorHandler: { (fault) in
            print(fault)
                let warningImage = UIImage(named: "warning.png")
                SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
                    //Do nothing
                }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
              self.initialGoButton?.isEnabled = true
              self.indicator.stopAnimating()
              self.initialGoButton?.setTitle("GO", for: .normal)
                
        })
        
    }
    
    func askForLogin(profile : Profile) {
        
                UIView.animate(withDuration: 2, animations: {
                    self.initialGoButton?.center = CGPoint(x: (self.initialGoButton?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.initialGoButton?.center.y)!)
                    self.initialNumberGrabberTF?.frame = CGRect(x: (self.initialNumberGrabberTF?.frame.origin.x)!, y: UIScreen.main.bounds.height/7, width: (self.initialNumberGrabberTF?.bounds.width)!, height: (self.initialNumberGrabberTF?.bounds.height)!)
                }) { (done) in
                   self.passwordLabel = UITextField(frame: CGRect(x: 10, y: (self.initialNumberGrabberTF?.frame.origin.y)! + 60, width: UIScreen.main.bounds.width - 20, height: 40))
                    self.passwordLabel?.isSecureTextEntry = true
                    self.setTextFieldAttribuetes(view: self.passwordLabel!, placeHolderText: "  Enter your password")
                    self.view.addSubview(self.passwordLabel!)
                    
                    self.loginButton = UIButton(frame: CGRect(x: 10, y: (self.passwordLabel?.frame.origin.y)! + 60, width: UIScreen.main.bounds.width - 20, height: 40))
                    self.loginButton?.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
                    self.loginButton?.setTitle("LOGIN", for: .normal)
                    self.loginButton?.setTitleColor(UIColor.white, for: .normal)
                    self.prof_intr = profile
                    self.loginButton?.addTarget(self, action: #selector(self.backendlesslogin(sender:)), for: .touchDown)
                    self.view.addSubview(self.loginButton!)
                    
                    self.forgotPasswordButton = UIButton(frame: CGRect(x: 10, y: (self.loginButton?.frame.origin.y)! + 40, width: UIScreen.main.bounds.width - 10, height: 40))
                    self.forgotPasswordButton?.backgroundColor = UIColor.white.withAlphaComponent(1)
                    self.forgotPasswordButton?.setTitle("Forgot password?", for: .normal)
                    self.forgotPasswordButton?.setTitleColor(UIColor.black, for: .normal)
                    self.forgotPasswordButton?.addTarget(self, action: #selector(self.forgotpasswordPressed(sender:)), for: .touchDown)
                    self.view.addSubview(self.forgotPasswordButton!)
                    
                    self.passwordLabel?.pulse(nil)
                    self.loginButton?.pulse(nil)
                    self.forgotPasswordButton?.pulse(nil)
                    
                }
        

    
    }
    
    @objc func forgotpasswordPressed(sender : UIButton) {
        let warningImage = UIImage(named: "warning.png")
        forgotPasswordButton?.isEnabled = true
        forgotPasswordButton?.setTitle("", for: .normal)
        indicator.startAnimating()
        indicator.color = UIColor.black
        indicator.frame.origin.x = (forgotPasswordButton?.bounds.width)!/2
        indicator.frame.origin.y = (forgotPasswordButton?.bounds.height)!/2
        forgotPasswordButton?.addSubview(indicator)
        
        
        backendless.userService.restorePassword(identity: prof_intr!.emailAddress!, responseHandler: {
             self.indicator.stopAnimating()
                       
                       SCLAlertView().showInfo("Password Recovery", subTitle: "Please check your email \(Misc().emailModify(data: (self.prof_intr?.emailAddress)!)) to reset your password", closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
                           //Do nothing
                       }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage, animationStyle: .topToBottom)
        }) { (fault) in
            BackendlessErrorHandler().backendlessPasswordRecoveryErrorhandler(code: "\(fault.faultCode)")
            self.indicator.stopAnimating()
            self.forgotPasswordButton?.isEnabled = true
            self.forgotPasswordButton?.setTitle("Forgot password?", for: .normal)
        }
    }
        
        
//        backendless.userService.restorePassword(identity: prof_intr!.emailAddress!, responseHandler: { (response) in
//            self.indicator.stopAnimating()
//
//            SCLAlertView().showInfo("Password Recovery", subTitle: "Please check your email \(Misc().emailModify(data: (self.prof_intr?.emailAddress)!)) to reset your password", closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
//                //Do nothing
//            }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage, animationStyle: .topToBottom)
//
//        }, errorHandler: { (fault) in
//                BackendlessErrorHandler().backendlessPasswordRecoveryErrorhandler(code: (fault?.faultCode)!)
//                self.indicator.stopAnimating()
//                self.forgotPasswordButton?.isEnabled = true
//                self.forgotPasswordButton?.setTitle("Forgot password?", for: .normal)
//
//
//
//        })
        
        
//    }
//
    @objc func backendlesslogin(sender : UIButton){
        
        if passwordLabel?.text?.characters.count == 0 {
            passwordLabel?.tada(nil)
        } else {
        
        indicator.startAnimating()
        indicator.frame.origin.x = (loginButton?.frame.width)!/2
        indicator.frame.origin.y = (loginButton?.frame.height)!/2
        loginButton?.isEnabled = false
        loginButton?.setTitle("", for: .disabled)
        loginButton?.addSubview(indicator)
        
            backendless.userService.login(identity: prof_intr!.emailAddress!, password: passwordLabel!.text!, responseHandler: { (user) in
                
                
                self.navigationItem.leftBarButtonItem?.image = UIImage(named: "edit.png")
                
                if ProfileData().removeProfiles(){
                    if ProfileData().addProfile(profile: self.prof_intr!) {
                        UIView.animate(withDuration: 2, animations: {
                            self.initialNumberGrabberTF?.center = CGPoint(x: (self.initialNumberGrabberTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.initialNumberGrabberTF?.center.y)!)
                            self.passwordLabel?.center = CGPoint(x: (self.passwordLabel?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.passwordLabel?.center.y)!)
                            self.loginButton?.center = CGPoint(x: (self.loginButton?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.loginButton?.center.y)!)
                            self.forgotPasswordButton?.center = CGPoint(x: (self.forgotPasswordButton?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.forgotPasswordButton?.center.y)!)
                        }, completion: { (done) in
                            self.displayProfileDetails(profile: self.prof_intr!)
                            if self.prof_intr?.accountType == "normal" {
                                self.registerForPushNotifications(channel: "C"+(self.prof_intr?.phoneNumber!)!)
                            }else if self.prof_intr?.accountType == "admin" {
                                
                                self.registerForPushNotifications(channel: "admin")
                            }
                        })
                    }
                }
                
                
                
                
                
            }, errorHandler: { (error) in
               
                
                BackendlessErrorHandler().backendlessLoginErrorHandler(code: "\(error.faultCode)")
                self.loginButton?.isEnabled = true
                self.indicator.stopAnimating()
                self.loginButton?.setTitle("LOGIN", for: .normal)
        })
            
            
        }
        
    }
    
    
    func navigateToRegister(){
        
        UIView.animate(withDuration: 2, animations: {
            self.initialGoButton?.center = CGPoint(x: (self.initialGoButton?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.initialGoButton?.center.y)!)
            self.initialNumberGrabberTF?.frame = CGRect(x: (self.initialNumberGrabberTF?.frame.origin.x)!, y: UIScreen.main.bounds.height/7, width: (self.initialNumberGrabberTF?.bounds.width)!, height: (self.initialNumberGrabberTF?.bounds.height)!)
            
            }) { (done) in
                self.createRegistrationFields()
        }
        
    }
    
    
    func createRegistrationFields(){
        
        
        passwordTF = UITextField(frame: CGRect(x: 10, y: 2 * UIScreen.main.bounds.height/8, width: UIScreen.main.bounds.width - 20, height: 40))
        setTextFieldAttribuetes(view: passwordTF!, placeHolderText: "  Enter your password")
        passwordTF?.isSecureTextEntry = true
        
        nameTF = UITextField(frame: CGRect(x: 10, y: 3 * UIScreen.main.bounds.height/8, width: UIScreen.main.bounds.width - 20, height: 40))
        setTextFieldAttribuetes(view: nameTF!, placeHolderText: "  Enter your name")
        
        emailTF = UITextField(frame: CGRect(x: 10, y: 4 * UIScreen.main.bounds.height/8, width: UIScreen.main.bounds.width - 20, height: 40))
        setTextFieldAttribuetes(view: emailTF!, placeHolderText: "  Enter you email address")
        emailTF?.keyboardType = .emailAddress
        
        addressTV = UITextView(frame: CGRect(x: 10, y: 5 * UIScreen.main.bounds.height/8, width: UIScreen.main.bounds.width - 20, height: 70))
        addressTV?.layer.borderWidth = 2
        addressTV?.layer.cornerRadius = 0.5
        addressTV?.layer.borderColor = UIColor.blue.withAlphaComponent(1).cgColor
        //addressTV?.placeholderText = "  Please enter your address"
        addressTV?.textAlignment = .center
        addressTV?.textColor = UIColor.blue
        addressTV?.backgroundColor = UIColor.white
        addressTV?.placeholder = "Please enter your address"
        
        
        createAccountButton = UIButton(frame: CGRect(x: 10, y: (addressTV?.frame.origin.y)! + 90, width: UIScreen.main.bounds.width - 20, height: 40))
        createAccountButton?.layer.cornerRadius = 8
        createAccountButton?.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 0.5)
        createAccountButton?.setTitle("Create my account", for: .normal)
        createAccountButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        createAccountButton?.addTarget(self, action: #selector(createAccountButtonPressed(sender:)), for: .touchDown)
        
        self.view.addSubview(passwordTF!)
        self.view.addSubview(nameTF!)
        self.view.addSubview(emailTF!)
        self.view.addSubview(addressTV!)
        self.view.addSubview(createAccountButton!)
        passwordTF?.pulse(nil)
        nameTF?.pulse(nil)
        emailTF?.pulse(nil)
        addressTV?.pulse(nil)
        createAccountButton?.pulse(nil)
        
    }
    
    @objc func createAccountButtonPressed(sender : UIButton) {
        
        if passwordTF?.text?.characters.count != 0 {
            if nameTF?.text?.characters.count != 0 {
                if (emailTF?.text?.characters.count)! != 0 && Misc().isValidEmail(testStr: (emailTF?.text!)!){
                    if addressTV?.text.characters.count != 0 {
                                indicator.startAnimating()
                                indicator.frame.origin.x = (createAccountButton?.bounds.width)!/2
                                indicator.frame.origin.y = (createAccountButton?.bounds.height)!/2
                                createAccountButton?.addSubview(indicator)
                                createAccountButton?.isEnabled = false
                                createAccountButton?.setTitle("", for: .disabled)
                                self.createBackendAccount()
                    }else {
                        addressTV?.tada(nil)
                    }
                }else {
                    emailTF?.tada(nil)
                }
            }else {
                nameTF?.tada(nil)
            }
        } else {
            passwordTF?.tada(nil)
        }
        

        
    }
    
    func createBackendAccount(){
        print("account creation initialised")
        let newUser = BackendlessUser()
        newUser.email = emailTF?.text as NSString! as String?
        newUser.password = passwordTF?.text as NSString! as String?
        
//        backendless.userService.register(newUser, response: { (user) in
//
//            let profile = Profile()
//            profile.accountType = "normal"
//            profile.address = self.addressTV?.text
//            profile.emailAddress = self.emailTF?.text
//            profile.orderCount = "0"
//            profile.personName = self.nameTF?.text
//            profile.phoneNumber = self.initialNumberGrabberTF?.text
//            self.backendless?.data.of(Profile.ofClass()).save(profile, response: { (data) in
//
//                let obj = data as! Profile
//                if ProfileData().removeProfiles() {
//
//                    if ProfileData().addProfile(profile: obj) {
//
//                        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "edit.png")
//                        //register for push notificatiosn channel
//
//                       self.registerForPushNotifications(channel: "C"+obj.phoneNumber!)
//                        // Remove TextFields
//                    UIView.animate(withDuration: 1, animations: {
//                        self.initialNumberGrabberTF?.center = CGPoint(x: (self.initialNumberGrabberTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.initialNumberGrabberTF?.center.y)!)
//                        self.passwordTF?.center = CGPoint(x: (self.passwordTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.passwordTF?.center.y)!)
//                        self.nameTF?.center = CGPoint(x: (self.nameTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.nameTF?.center.y)!)
//                        self.emailTF?.center = CGPoint(x: (self.emailTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.emailTF?.center.y)!)
//                        self.addressTV?.center = CGPoint(x: (self.addressTV?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.addressTV?.center.y)!)
//                        self.createAccountButton?.center = CGPoint(x: (self.createAccountButton?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.createAccountButton?.center.y)!)
//                        }, completion: { (done) in
//
//                            //Bring in the labels
//                            let getProfile = ProfileData().getProfile()
//                            if  getProfile.1 {
//                                self.displayProfileDetails(profile: getProfile.0)
//                            }
//
//                    })
//                    }
//                }
//                }, error: { (fault) in
//            let warningImage = UIImage(named: "warning.png")
//                    SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
//                        //Do nothing
//                    }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
//            // Here account is registered but profile is not saved. So it will be taken to first screen
//            self.viewDidLoad()
//            })
//            }, error: { (fault) in
//                let code = fault?.faultCode
//                BackendlessErrorHandler().backendUserRegistrationErrorHandler(code: code!)
//                self.indicator.stopAnimating()
//                self.createAccountButton?.isEnabled = true
//                self.createAccountButton?.setTitle("Create my account", for: .normal)
//        })
        
        backendless.userService.registerUser(user: newUser, responseHandler: { (user) in
            print("user registered")
            print(user)
              let profile = Profile()
                         profile.accountType = "normal"
                         profile.address = self.addressTV?.text
                         profile.emailAddress = self.emailTF?.text
                         profile.orderCount = "0"
                         profile.personName = self.nameTF?.text
                         profile.phoneNumber = self.initialNumberGrabberTF?.text
           // profile.objectId = self.initialNumberGrabberTF?.text
            print("save started")
            self.backendless.data.of(Profile.self).save(entity: profile, responseHandler: { (data) in
                print("profile saved")
                let obj = data as! Profile
                if ProfileData().removeProfiles() {
                    
                    if ProfileData().addProfile(profile: obj) {
                        
                        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "edit.png")
                        //register for push notificatiosn channel
                        
                        self.registerForPushNotifications(channel: "C"+obj.phoneNumber!)
                        // Remove TextFields
                        UIView.animate(withDuration: 1, animations: {
                            self.initialNumberGrabberTF?.center = CGPoint(x: (self.initialNumberGrabberTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.initialNumberGrabberTF?.center.y)!)
                            self.passwordTF?.center = CGPoint(x: (self.passwordTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.passwordTF?.center.y)!)
                            self.nameTF?.center = CGPoint(x: (self.nameTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.nameTF?.center.y)!)
                            self.emailTF?.center = CGPoint(x: (self.emailTF?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.emailTF?.center.y)!)
                            self.addressTV?.center = CGPoint(x: (self.addressTV?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.addressTV?.center.y)!)
                            self.createAccountButton?.center = CGPoint(x: (self.createAccountButton?.center.x)! - (2 * UIScreen.main.bounds.width) , y: (self.createAccountButton?.center.y)!)
                        }, completion: { (done) in
                            
                            //Bring in the labels
                            let getProfile = ProfileData().getProfile()
                            if  getProfile.1 {
                                self.displayProfileDetails(profile: getProfile.0)
                            }
                            
                        })
                    }
                }
            }, errorHandler: { (fault) in
                print("profile save error")
                print(fault)
                         let warningImage = UIImage(named: "warning.png")
                                 SCLAlertView().showTitle("Error", subTitle: "Please check your internet connection and try again", style: .info, closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
                                     //Do nothing
                                 }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
                         // Here account is registered but profile is not saved. So it will be taken to first screen
                         self.viewDidLoad()
                         })
        }) { (fault) in
            print("register user error")
            print(fault)
            let code = fault.faultCode
            //BackendlessErrorHandler().backendUserRegistrationErrorHandler(code: code)
            BackendlessErrorHandler().backendlessLoginErrorHandler(code: "\(code)")
            self.indicator.stopAnimating()
            self.createAccountButton?.isEnabled = true
            self.createAccountButton?.setTitle("Create my account", for: .normal)
        }
    }
    
    func displayProfileDetails(profile : Profile) {
        
        
        phoneLabel = UITextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width - 20, height: 40))
        phoneLabel?.text = profile.phoneNumber
        phoneLabel?.textColor = UIColor.blue
        phoneLabel?.textAlignment = .center
        phoneLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.7)
      
        phoneLabel?.font = UIFont.systemFont(ofSize: 20)
        phoneLabel?.isEnabled = false
        self.view.addSubview(phoneLabel!)

        nameLabel = UITextField(frame: CGRect(x: 10, y: 2 * UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width - 20, height: 40))
        nameLabel?.text = profile.personName
        nameLabel?.textColor = UIColor.blue
        nameLabel?.textAlignment = .center
        nameLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        nameLabel?.font = UIFont.systemFont(ofSize: 20)
        nameLabel?.isEnabled = false
        self.view.addSubview(nameLabel!)
        
        emailLabel = UITextField(frame: CGRect(x: 10, y: 3 * UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width - 20, height: 40))
        emailLabel?.textAlignment = .center
        emailLabel?.textColor = UIColor.blue
        emailLabel?.text = profile.emailAddress
        emailLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        emailLabel?.font = UIFont.systemFont(ofSize: 20)
        emailLabel?.isEnabled = false
        self.view.addSubview(emailLabel!)
        
        addressTV1 = UITextView(frame: CGRect(x: 10, y: 4 * UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width - 20, height: 120))
        addressTV1?.text = profile.address
        addressTV1?.textColor = UIColor.blue
        addressTV1?.textAlignment = .center
        addressTV1?.isEditable = false
        addressTV1?.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        addressTV1?.font = UIFont.systemFont(ofSize: 20)
        addressTV1?.isEditable = false
        self.view.addSubview(addressTV1!)
        
        phoneLabel?.pulse(nil)
        nameLabel?.pulse(nil)
        emailLabel?.pulse(nil)
        addressTV1?.pulse(nil)
    }
    

    
    func setTextFieldAttribuetes( view : UITextField , placeHolderText : String) {
        
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 0.5
        view.layer.borderColor = UIColor.blue.withAlphaComponent(1).cgColor
        view.placeholder = placeHolderText
        view.textAlignment = .center
        view.textColor = UIColor.blue
        view.backgroundColor = UIColor.white
    
    }
    


    
    func removeLabels() {
    let subs = self.view.subviews
        for sub in subs {
            if sub is UITextField {
                sub.removeFromSuperview()
            } else if sub is UITextView {
                sub.removeFromSuperview()
            }
        }
    }
    
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        let left = self.navigationItem.leftBarButtonItem
        if ProfileData().profileCount().0 != 0 {
        let warningImage = UIImage(named: "warning.png")
        navbarIndicator.startAnimating()
        left?.isEnabled = false
//            backendless.userService.logout(responseHandler: { (done) in
//                left?.isEnabled = true
//                //unregister from notification channels
//                self.unregisterForPushNotifications()
//                self.navbarIndicator.stopAnimating()
//                if ProfileData().removeProfiles() && OrderData().deleteOrders() {
//                    self.removeLabels()
//                    self.viewDidLoad()
//                }
//
//            }, errorHandler: { (fault) in
//                left?.isEnabled = true
//                self.navbarIndicator.stopAnimating()
//                SCLAlertView().showTitle("Error", subTitle: " Please check your internet connectiona nd try again", style: .info, closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
//                    //Do nothing
//                }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
//        })
            
            backendless.userService.logout(responseHandler: {
                left?.isEnabled = true
                //unregister from notification channels
                self.unregisterForPushNotifications()
                self.navbarIndicator.stopAnimating()
                if ProfileData().removeProfiles() && OrderData().deleteOrders() {
                    self.removeLabels()
                    self.viewDidLoad()
                }
            }) { (fault) in
                left?.isEnabled = true
                self.navbarIndicator.stopAnimating()
                SCLAlertView().showTitle("Error", subTitle: " Please check your internet connectiona nd try again", style: .info, closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
                    //Do nothing
                }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
            }
        
        }
       
    }
    
    
    
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        
        if ProfileData().profileCount().0 != 0 {
        
        
        let warningImage = UIImage(named: "warning.png")
        let left = self.navigationItem.leftBarButtonItem
        let right = self.navigationItem.rightBarButtonItem
        if !isProfileEditing {
            
            isProfileEditing = true
            
            nameLabel?.isEnabled = true
            nameLabel?.layer.borderWidth = 3
            nameLabel?.layer.cornerRadius = 3
            nameLabel?.layer.borderColor = UIColor.blue.cgColor
            
            addressTV1?.isEditable = true
            addressTV1?.layer.borderColor = UIColor.blue.cgColor
            addressTV1?.layer.borderWidth = 3
            addressTV1?.layer.cornerRadius = 3
            
            
            left?.image = UIImage(named: "done.png")
            right?.isEnabled = false
            
            
        } else {
            
            let profile = ProfileData().getProfile()
            if profile.1 {
                profile.0.address = addressTV1?.text
                profile.0.personName = nameLabel?.text
                nameLabel?.isEnabled = false
                addressTV1?.isEditable = false
                navbarIndicator.startAnimating()
                backendless.data.of(Profile.self).save(entity: profile.0, responseHandler: { (data) in
                    let obj = data as! Profile
                    if ProfileData().removeProfiles() {
                        if ProfileData().addProfile(profile: obj) {
                            self.navbarIndicator.stopAnimating()
                            self.nameLabel?.layer.borderWidth = 0
                            self.addressTV1?.layer.borderWidth = 0
                            left?.image = UIImage(named: "edit.png")
                            right?.isEnabled = true
                        }
                    }
                }, errorHandler: { (fault) in
                        SCLAlertView().showTitle("Error", subTitle: " Please check your internet connectiona nd try again", style: .info, closeButtonTitle: "OK", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 30, timeoutAction: {
                            //Do nothing
                        }), colorStyle: 0xCC9900, colorTextButton: 0xFFFFFF, circleIconImage: warningImage , animationStyle: .bottomToTop)
                        self.navbarIndicator.stopAnimating()
                        self.addressTV1?.isEditable = true
                        self.nameLabel?.isEnabled = true
                })
            }
            
        }
    
        
        }
    
    
    }
    
    func registerForPushNotifications(channel : String) {
        backendless.messaging.getDeviceRegistrations(responseHandler: { (responses) in
            var is_registered_for_req_channel = false
            var device_token = ""
            for response in responses {
                if((response.channels?.contains(channel))!){
                    is_registered_for_req_channel =  true
                    device_token = response.deviceToken!
                    break
                }
            }
            if(!is_registered_for_req_channel){
                self.backendless.messaging.registerDevice(deviceToken: Data(device_token.utf8), channels: [channel], responseHandler: { (response) in
                    
                }) { (fault) in
                            
                }
            }
        }) { (fault) in
            
        }
    }
       
//        backendless?.messaging.registerDevice(deviceToken: [channel], responseHandler: { (response) in
//
//        }, errorHandler: { (fault) in
//
//        })
        
//        backendless.messaging.unregisterDevice(channels: [channel], responseHandler: { (response) in
//
//        }) { (fault) in
//
//        }
//
//    }
    
    func unregisterForPushNotifications() {
//        backendless.messaging.unregisterDeviceAsync({ (response) in
//
//            }, error: { (fault) in
//
//        })
        backendless.messaging.unregisterDevice(responseHandler: { (response) in
            
        }) { (fault) in
            
        }
    }
    
    
}
