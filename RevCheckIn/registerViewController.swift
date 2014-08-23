//
//  registerViewController.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
class registerViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTestField: UITextField!
    @IBOutlet var nameTextField:     UITextField!
    @IBOutlet var emailTextField:    UITextField!
    @IBOutlet var phone:             UITextField!
    @IBOutlet var role:              UITextField!
    @IBOutlet var registrationCode:  UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate     = self
        passwordTestField.delegate     = self
        nameTextField.delegate         = self
        emailTextField.delegate        = self
        role.delegate                  = self
        phone.delegate                 = self
        registrationCode.delegate      = self
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if(textField == usernameTextField){
            passwordTestField.becomeFirstResponder()
        }else if(textField == passwordTestField){
            nameTextField.becomeFirstResponder()
        }else if(textField == nameTextField){
            emailTextField.becomeFirstResponder()
        }else if(textField == emailTextField){
            role.becomeFirstResponder()
        }else if(textField == role){
            phone.becomeFirstResponder()
        }else if(textField == phone){
            registrationCode.becomeFirstResponder()
        }else if(textField == registrationCode){
            registrationCode.resignFirstResponder()
            self.registerLogic()
        }
        
        return true
    }
    
    func registerLogic(){
        if usernameTextField.text != "" && passwordTestField.text != "" && nameTextField.text != "" && emailTextField.text != "" && registrationCode.text != "" && phone.text != "" && role.text != "" {
            var helper: HTTPHelper = HTTPHelper() as HTTPHelper
            helper.register(usernameTextField.text, password: passwordTestField.text, name: nameTextField.text, email: emailTextField.text, registrationCode: registrationCode.text, role: role.text, phone: phone.text)
            var myList: Array<AnyObject> = []
            var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context2: NSManagedObjectContext = appDel2.managedObjectContext!
            let freq = NSFetchRequest(entityName: "Active_user")
            
            while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)}
            var selectedItem: NSManagedObject = myList[0] as NSManagedObject
            var user: String = selectedItem.valueForKeyPath("username") as String
            println("active user: \(user)")
            if user != "-1" {
                println("login successful")
                
                
                self.performSegueWithIdentifier("go", sender: self)
            }
            else{
                println("login unsuccessful")
                //let alert = UIAlertController(title: "We're sorry", message: "That username, name or email has already been registered or the connection failed", preferredStyle: UIAlertControllerStyle.Alert)
                //alert.addAction(UIAlertAction(title: "I'll try again", style: UIAlertActionStyle.Default, handler: nil))
                //self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(sender: AnyObject) {
        self.registerLogic()
    }

    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
