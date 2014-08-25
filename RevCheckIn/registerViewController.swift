//
//  registerViewController.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
class registerViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var passwordTestField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var nameTextField:     UITextField!
    @IBOutlet var emailTextField:    UITextField!
    @IBOutlet var phone:             UITextField!
    @IBOutlet var role:              UITextField!
    @IBOutlet var registrationCode:  UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollViewBottomSpace: NSLayoutConstraint!
    var standConst: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController.navigationBar.hidden = true;
        
        if (UIDevice.currentDevice().model != "iPad"){
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardOpen:", name:UIKeyboardDidShowNotification, object: nil)
            
            let numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.scrollView.frame.size.width, 50))
            numberToolbar.barStyle = UIBarStyle.Default
            numberToolbar.items = NSArray(objects: UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: "toolbarPressDone:"))
            passwordTestField.inputAccessoryView = numberToolbar;
            confirmPasswordTextField.inputAccessoryView = numberToolbar;
            nameTextField.inputAccessoryView = numberToolbar;
            emailTextField.inputAccessoryView = numberToolbar;
            role.inputAccessoryView = numberToolbar;
            phone.inputAccessoryView = numberToolbar;
            registrationCode.inputAccessoryView = numberToolbar;
        }
        
        //self.scrollView.contentSize = self.containerView.bounds.size
        
        passwordTestField.delegate     = self
        confirmPasswordTextField.delegate = self
        nameTextField.delegate         = self
        emailTextField.delegate        = self
        role.delegate                  = self
        phone.delegate                 = self
        registrationCode.delegate      = self

        self.emailTextField.layer.borderWidth = 2.0
        self.emailTextField.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        self.passwordTestField.layer.borderWidth = 2.0
        self.passwordTestField.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        self.confirmPasswordTextField.layer.borderWidth = 2.0
        self.confirmPasswordTextField.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        self.nameTextField.layer.borderWidth = 2.0
        self.nameTextField.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        self.phone.layer.borderWidth = 2.0
        self.phone.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        self.role.layer.borderWidth = 2.0
        self.role.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        self.registrationCode.layer.borderWidth = 2.0
        self.registrationCode.layer.borderColor = UIColor(red: (251/255.0), green: (109/255.0), blue: (9/255.0), alpha: 1).CGColor
        
        standConst = scrollViewBottomSpace.constant
    }
    
    func keyboardOpen(notification: NSNotification){
        let userInfo = notification.userInfo!
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        scrollViewBottomSpace.constant = keyboardScreenEndFrame.size.height - 108
       
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardClose:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardClose(notification: NSNotification){
        
        scrollViewBottomSpace.constant = standConst
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardOpen:", name:UIKeyboardDidShowNotification, object: nil)
        
    }
    
    func toolbarPressDone(sender: AnyObject){
        nameTextField.resignFirstResponder()
        passwordTestField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phone.resignFirstResponder()
        role.resignFirstResponder()
        registrationCode.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if (textField == self.emailTextField){
            self.nameTextField.becomeFirstResponder()
        } else if(textField == nameTextField){
            self.passwordTestField.becomeFirstResponder()
        } else if(textField == passwordTestField){
            self.confirmPasswordTextField.becomeFirstResponder()
        } else if (textField == self.confirmPasswordTextField){
            self.phone.becomeFirstResponder()
        }else if(textField == role){
            registrationCode.becomeFirstResponder()
        }else if(textField == phone){
            role.becomeFirstResponder()
        }else if(textField == registrationCode){
            registrationCode.resignFirstResponder()
        }
        
        return true
    }
    
    func registerLogic(){
        if passwordTestField.text != "" && nameTextField.text != "" && emailTextField.text != "" && registrationCode.text != "" && phone.text != "" && role.text != "" && passwordTestField.text == confirmPasswordTextField.text {
            var helper: HTTPHelper = HTTPHelper() as HTTPHelper
            helper.register(emailTextField.text, password: passwordTestField.text, name: nameTextField.text, email: emailTextField.text, registrationCode: registrationCode.text, role: role.text, phone: phone.text)
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
