//
//  rootViewController.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit

class rootViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredStatusBarStyle()
        
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
