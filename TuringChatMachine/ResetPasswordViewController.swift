//
//  ResetPasswordViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Spring
class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var panle: SpringView!
    override func viewWillAppear(animated: Bool) {
         resetPasswordPanleShowAnimation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        panle.clipsToBounds = true
  
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func resetPasswordPanleShowAnimation(){
        panle.animation = "fadeInUp"
        panle.autostart = false
        panle.curve = "easeOut"
        panle.duration = 1.0
        panle.damping = 0.6
        panle.velocity = 0.0
        panle.force = 1.0
        panle.animate()
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
