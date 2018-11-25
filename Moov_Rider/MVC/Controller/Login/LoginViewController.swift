//
//  LoginViewController.swift
//  Moov_Rider
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
//import GoogleSignIn
import SDWebImage
//import FBSDKLoginKit

let kScreenWidth    = UIScreen.main.bounds.width
let kScreenHeight   = UIScreen.main.bounds.height
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUsername            : UITextField!
    @IBOutlet weak var textFieldPassword            : UITextField!
    @IBOutlet weak var buttonSignin                 : UIButton!
    @IBOutlet var forgetPassWordView                : ForgetPassWordView!
    var deviceToken                                 : String!
    var appDelegate                                 : AppDelegate!
    var activeTextfiled                             : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)

        self.addDoneButtonOnKeyboard()
        buttonSignin.layer.cornerRadius = 8.0
        buttonSignin.layer.masksToBounds = true
        paddingTextFields()

        UIHelper.addGradient(view: self.view)

        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
    }

    func paddingTextFields()  {
//        textFieldUsername.leftViewMode = .always
//        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.image = #imageLiteral(resourceName: "user")
//        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
//        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldUsername.frame.height))
//       // paddingView.backgroundColor = UIColor(red: 245/255, green: 241/255, blue: 242/255, alpha: 1.0)
//        imageView.center = paddingView.center
//        paddingView.addSubview(imageView)
//        imageView.contentMode = .scaleAspectFit
//        paddingViewV.addSubview(paddingView)
//        paddingViewV.backgroundColor = UIColor.clear
//        textFieldUsername.leftView = paddingViewV
//        textFieldPassword.leftViewMode = .always
//        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView1.image = #imageLiteral(resourceName: "pass-1")
//        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
//        let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
//       // paddingView1.backgroundColor = UIColor(red: 245/255, green: 241/255, blue: 242/255, alpha: 1.0)
//        imageView1.center = paddingView1.center
//        paddingView1.addSubview(imageView1)
//        imageView1.contentMode = .scaleAspectFit
//        paddingViewW.addSubview(paddingView1)
//        paddingViewW.backgroundColor = UIColor.clear
//        textFieldPassword.leftView = paddingViewW
    }

//MARK Button Actions
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func buttonSigninAction(_ sender: UIButton) {
        if textFieldUsername.text?.isEmpty == false{
            if textFieldPassword.text?.isEmpty == false{
                self.loginWithEmail()
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter your password")
            }
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter your username")
        }
    }
    @IBAction func buttonForgetPasswordAction(_ sender: UIButton) {
        
        self.addResetView(self.forgetPassWordView, frame: self.forgetPassWordView.frame)
        self.forgetPassWordView.rDelegate = self
        forgetPassWordView.textFieldEmail.text = ""
        
    }
    @IBAction func buttonSignUpAction(_ sender: UIButton) {
        let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationTableViewController") as! RegistrationTableViewController
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    //MARK: ForgetPassWordUIView
    func addResetView(_ view : UIView , frame : CGRect) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect                    = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView                = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame              = self.view.bounds
            blurEffectView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(blurEffectView)
        } else {
            self.view.backgroundColor = UIColor.white
        }
        view.frame = frame
        view.center = self.view.center
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        self.view.addSubview(view)
        view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (sucess) in
        }
    }
    
    func removeBlurView() {
        for view in (self.view.subviews) {
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- API Login with email
    func loginWithEmail()  {
        let hud = GenericFunctions.showJHud(target: self)
        /*if UserDefaults.value(forKey: "deviceToken") as? String != nil{
         deviceToken = UserDefaults.value(forKey: "deviceToken") as! String
         }else{
         deviceToken =
         }*/
        let params : NSDictionary!
        if appDelegate.deviceTokenStr != nil{
            params = ["email":self.textFieldUsername.text!,"password": self.textFieldPassword.text!,"device_type":"iOS","device_id":appDelegate.deviceTokenStr!,"push_token": appDelegate.deviceTokenStr!,"app_version":"1.2"]
        }else{
            params = ["email":self.textFieldUsername.text!,"password": self.textFieldPassword.text!,"device_type":"iOS","device_id":"","push_token": "","app_version":"1.2"]
        }
        
        
        AlamofireSubclass.parseLinkUsingPostMethod("auth/login/email", with: params, completion: { (success, response, error) in
            
            GenericFunctions.hideJHud(hudView: hud)
            if success  == true {
                if response!["message"] as! String == "login success"
                {
                    let userDict = response!["data"] as! NSDictionary
                    User.current.initWithDictionary(dictionary: userDict)
                    User.saveLoggedUserdetails(dictDetails: userDict)
                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "EnterDestinationViewController")
                        as! EnterDestinationViewController
                    let navVC = UINavigationController(rootViewController: homePage)
                    let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
                    let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
                    UIApplication.shared.keyWindow?.rootViewController = mfContainer
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter a valid username and password")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        })
    }
    
    //MARK:- Add Done Button
    
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar  = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle        = UIBarStyle.default
        let flexSpace               = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        var items           = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items   = items
        doneToolbar.sizeToFit()
        textFieldUsername.inputAccessoryView = doneToolbar
        textFieldPassword.inputAccessoryView = doneToolbar
       
    }
    @objc func doneButtonAction() {
        
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
    }
    
    @objc func keyboardHide()  {
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
    
    //MARK:- Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfiled = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if activeTextfiled.tag == 1{
            textFieldPassword.becomeFirstResponder()
        }else{
            activeTextfiled.resignFirstResponder()
        }
        
        
        return true
    }
   
}


extension UIView {
    
    func setTopRoundedCorners() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight],cornerRadii: CGSize(width: kScreenWidth/20, height: 20.0)).cgPath
        maskLayer.strokeColor = UIColor.lightGray.cgColor
        self.layer.mask = maskLayer
    }
    
    func setBottomRoundedCorners() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight],cornerRadii: CGSize(width: kScreenWidth/20, height: 50.0)).cgPath
        maskLayer.strokeColor = UIColor.lightGray.cgColor

        self.layer.mask = maskLayer
    }
}
//MARK:- forgetPassWordDelegate
extension LoginViewController : forgetPassWordDelegate {
    func didPasswordSubmitPressed(_ values: NSDictionary) {
        if values["email"] as! NSString != ""{
            forgetPassWord(email: (values["email"] as! NSString) as String)
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter a valid email id")
        }
     }
    
    func didPasswordClosePressed() {
        self.forgetPassWordView.removeFromSuperview()
        self.removeBlurView()
    }
    
    func forgetPassWord(email: String)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("auth/forgot", with: ["email": email]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "A new password will be send to you if mail exist in our server!"
                {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "A new password will be send to you if mail exist in our server!")
                    self.forgetPassWordView.removeFromSuperview()
                    self.removeBlurView()
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
}
