//
//  GuestProfileNavigationController.swift
//  scenested-experiment
//
//  Created by Xie kesong on 7/31/16.
//  Copyright © 2016 ___Scenested___. All rights reserved.
//

import UIKit

class GuestProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationBar.titleTextAttributes = StyleSchemeConstant.navigationBarStyle.titleTextAttributes
        self.navigationBar.translucent = false


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}