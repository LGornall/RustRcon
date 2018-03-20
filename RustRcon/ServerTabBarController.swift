//
//  ServerTabBarController.swift
//  RustRcon
//
//  Created by Louis Gornall on 25/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import Foundation
import UIKit
import Starscream

class ServerTabBarContoller: UITabBarController, tabBarCon{

    
    override func viewDidLoad() {
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.maintabBarController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func connecting(){
        self.title = "Connecting"
    }
    func didConnect() {
        self.title = ""
    }
}





