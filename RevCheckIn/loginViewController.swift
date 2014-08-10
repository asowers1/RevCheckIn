//
//  loginViewController.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
class loginViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    var usernameString:String=""
    var passwordString:String=""
    
    var existingItem: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName :UIFont(name: "AppleSDGothicNeo-Thin", size: 28.0)]
        self.navigationController.navigationBar.titleTextAttributes = titleDict
        self.title = "Rev Check-in"
        
        navigationController.navigationBar.barTintColor = UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 1.0)
        username.delegate = self
        password.delegate = self

    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if(textField == username){
            password.becomeFirstResponder()
        }else if(textField == password){
            if username.text != "" && password.text != "" {
                password.resignFirstResponder()
                self.loginLogic()
            }
        }
        return true
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
    
    
    override func viewWillAppear(animated: Bool) {
        var myList: Array<AnyObject> = []

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        if username.text != "" && password.text != "" {
            self.loginLogic()
        }
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
