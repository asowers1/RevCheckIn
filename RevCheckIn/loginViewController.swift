//
//  loginViewController.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import QuartzCore
class loginViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet weak var newAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var imgView: UIImageView!
    
    var usernameString:String=""
    var passwordString:String=""
    
    var existingItem: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.hidden = true
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName :UIFont(name: "AppleSDGothicNeo-Thin", size: 28.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.title = "Rev Check-in"
        
        username.delegate = self
        password.delegate = self
        
        
        self.newAccountButton.layer.borderWidth = 2.0
        self.loginButton.layer.borderWidth = 2.0
        self.newAccountButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        username.layer.borderWidth = 2.0
        password.layer.borderWidth = 2.0
        username.layer.borderColor = UIColor.whiteColor().CGColor
        password.layer.borderColor = UIColor.whiteColor().CGColor

    }
    
    override func viewDidAppear(animated: Bool) {
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        let freq = NSFetchRequest(entityName: "Active_user")
        
        myList = context2.executeFetchRequest(freq, error: nil)!
        if (myList.count > 0){
            
            var selectedItem: NSManagedObject = myList[0] as NSManagedObject
            var user: String = selectedItem.valueForKeyPath("username") as String
            
            if user != "-1" {
                println("login successful: \(user)")
                
                
                self.performSegueWithIdentifier("login", sender: self)
            }
            else{
                println("login unsuccessful")
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if(textField == username){
            password.becomeFirstResponder()
        }else if(textField == password){
            password.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func startEditingLogin(sender: AnyObject) {
        println("Started Editing username")
        
    }

    func loginLogic() {
        var helper: HTTPHelper = HTTPHelper()
        helper.login(username.text, password: password.text)
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        let freq = NSFetchRequest(entityName: "Active_user")
        
        println("login logic")
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
        println("got context")
        var selectedItem: NSManagedObject = myList[0] as NSManagedObject
        if let user: String = selectedItem.valueForKeyPath("username") as? String {
            if user != "-1" {
                println("login successful")
                //record user device
                
                //var helper: HTTPHelper = HTTPHelper()
                
                //let device = helper.getDeviceContext()
                
                //var coreDataHelper: CoreDataHelper = CoreDataHelper()
                //let network: HTTPBackground = HTTPBackground()
                //network.linkUserToDevice(user, device)
                
                //println("user:\(user): device:\(device): LINKED")
            
                self.performSegueWithIdentifier("login", sender: self)
            }
            else{
                
                println("login unsuccessful")
                let networkIssue = UIAlertController(title: "Login unsuccessful", message: "Your username or password is incorrect", preferredStyle: UIAlertControllerStyle.Alert)
                networkIssue.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(networkIssue, animated: true, completion: nil)
            }
        }else{
            println("login unsuccessful!")
            let networkIssue = UIAlertController(title: "Network Issue", message: "Could not log in", preferredStyle: UIAlertControllerStyle.Alert)
            networkIssue.addAction(UIAlertAction(title: "Try Later", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(networkIssue, animated: true, completion: nil)
            var helper:HTTPHelper = HTTPHelper()
            helper.setUserContext("-1")
        }
    }
    
    @IBAction func cancelLogin(sender: AnyObject) {
        self.leadingConstraint.constant = 0
        self.trailingConstraint.constant = 0
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var myList: Array<AnyObject> = []

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        if (self.username.text != "" && self.password.text != ""){
            self.loginLogic()
        } else {
            var field = "username"
            if (self.password.text == "" && self.username.text != ""){
                field = "password"
            }
            let incomplete: UIAlertController = UIAlertController(title: "incomplete login", message: "\(field) field cannot be blank", preferredStyle: UIAlertControllerStyle.Alert)
            incomplete.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(incomplete, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func showLogin(sender: AnyObject) {
        println(self.leadingConstraint.constant)
        self.leadingConstraint.constant = self.view.frame.origin.x - (self.newAccountButton.frame.size.width + 20)
        self.trailingConstraint.constant = -1 * (self.newAccountButton.frame.size.width + 20)
        println(self.leadingConstraint.constant)
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
        

    }

    @IBAction func register(sender: AnyObject) {
        Crashlytics.setObjectValue("register", forKey: "loginAction")
            self.performSegueWithIdentifier("register", sender: self)
    }
    
    @IBAction func sendToWeb(sender: AnyObject) {
        let viewWeb : UIAlertController = UIAlertController(title: "learn more", message:"visit Push on the web", preferredStyle: UIAlertControllerStyle.ActionSheet)
        viewWeb.addAction(UIAlertAction(title:"cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        viewWeb.addAction(UIAlertAction(title: "view", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in println("Foo")
            UIApplication.sharedApplication().openURL(NSURL.URLWithString("http://www.experiencepush.com"))
        }))
        
        self.presentViewController(viewWeb, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "register" {
                println("segue")
        }
    }


}
