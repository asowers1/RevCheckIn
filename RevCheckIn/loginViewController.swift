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
        
        self.navigationController.navigationBar.hidden = true
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName :UIFont(name: "AppleSDGothicNeo-Thin", size: 28.0)]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.title = "Rev Check-in"
        
        navigationController.navigationBar.barTintColor = UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 1.0)
        username.delegate = self
        password.delegate = self
        
        println("testing image upload...")
        var httpImage = HTTPImage()
        var value = httpImage.setUserPicture("test","asow92")
        println("return: \(value)")
        
        
        self.newAccountButton.layer.borderWidth = 2.0
        self.loginButton.layer.borderWidth = 2.0
        self.newAccountButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        username.layer.borderWidth = 2.0
        password.layer.borderWidth = 2.0
        username.layer.borderColor = UIColor.whiteColor().CGColor
        password.layer.borderColor = UIColor.whiteColor().CGColor


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
        
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)}
        var selectedItem: NSManagedObject = myList[0] as NSManagedObject
        var user: String = selectedItem.valueForKeyPath("username") as String
        
        if user != "-1" {
            println("login successful")
             self.performSegueWithIdentifier("login", sender: self)
        }
        else{
            println("login unsuccessful")
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
        var myList: Array<AnyObject> = []

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        if (self.username.text != "" && self.password.text != ""){
            self.loginLogic()
        }
    }
    
    
    @IBAction func showLogin(sender: AnyObject) {
        self.leadingConstraint.constant = self.view.frame.origin.x - (self.newAccountButton.frame.size.width + 20)
        self.trailingConstraint.constant = -1 * (self.newAccountButton.frame.size.width + 20)
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
        

    }

    @IBAction func register(sender: AnyObject) {
            self.performSegueWithIdentifier("register", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "register" {
                println("segue")
        }
    }


}
