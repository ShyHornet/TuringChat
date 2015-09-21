//
//  SignUpViewController.swift
//  TuringChatMachine
//
//
//
//                                          ___                        ___
//     ___                                 /  /\          ___         /  /\
//    /  /\                               /  /::\        /__/\       /  /:/_
//   /  /:/               ___     ___    /  /:/\:\       \  \:\     /  /:/ /\
//  /__/::\              /__/\   /  /\  /  /:/  \:\       \  \:\   /  /:/ /:/_
//  \__\/\:\__           \  \:\ /  /:/ /__/:/ \__\:\  ___  \__\:\ /__/:/ /:/ /\
//     \  \:\/\           \  \:\  /:/  \  \:\ /  /:/ /__/\ |  |:| \  \:\/:/ /:/
//      \__\::/            \  \:\/:/    \  \:\  /:/  \  \:\|  |:|  \  \::/ /:/
//      /__/:/              \  \::/      \  \:\/:/    \  \:\__|:|   \  \:\/:/
//      \__\/                \__\/        \  \::/      \__\::::/     \  \::/
//                                         \__\/           ~~~~       \__\/
//       ___          _____          ___                       ___           ___           ___
//      /  /\        /  /::\        /  /\        ___          /  /\         /__/\         /  /\
//     /  /::\      /  /:/\:\      /  /::\      /  /\        /  /::\        \  \:\       /  /::\
//    /  /:/\:\    /  /:/  \:\    /  /:/\:\    /  /:/       /  /:/\:\        \  \:\     /  /:/\:\
//   /  /:/~/::\  /__/:/ \__\:|  /  /:/~/:/   /__/::\      /  /:/~/::\   _____\__\:\   /  /:/~/::\
//  /__/:/ /:/\:\ \  \:\ /  /:/ /__/:/ /:/___ \__\/\:\__  /__/:/ /:/\:\ /__/::::::::\ /__/:/ /:/\:\
//  \  \:\/:/__\/  \  \:\  /:/  \  \:\/:::::/    \  \:\/\ \  \:\/:/__\/ \  \:\~~\~~\/ \  \:\/:/__\/
//   \  \::/        \  \:\/:/    \  \::/~~~~      \__\::/  \  \::/       \  \:\  ~~~   \  \::/
//    \  \:\         \  \::/      \  \:\          /__/:/    \  \:\        \  \:\        \  \:\
//     \  \:\         \__\/        \  \:\         \__\/      \  \:\        \  \:\        \  \:\
//      \__\/                       \__\/                     \__\/         \__\/         \__\/
//
//
//
//
//
//  Created by Huangjunwei on 15/9/11.
//  Copyright (c) 2015年 codeGlider. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class SignUpViewController: PFSignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
self.signUpView?.logo = UIImageView(image: UIImage(named: "logo"))
        
        // Do any additional setup after loading the view.
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
