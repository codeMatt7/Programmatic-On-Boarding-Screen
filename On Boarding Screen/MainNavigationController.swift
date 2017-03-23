//
//  MainNavigationController.swift
//  On Boarding Screen
//
//  Created by Matt Houston on 10/4/16.
//  Copyright © 2016 On Boarding Screen. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if isLoggedIn() {
            //assume user is logged in
            let homeController = HomeController()
            self.viewControllers = [homeController]  //viewControllers is property on UINavigation //array of all controllers in nav stack.
            
        } else {
            //not logged in
            
            //has to be shown after the window is loaded. thats why its separated
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
        
    }
    
    fileprivate func isLoggedIn() -> Bool {
        
    //gives you the value of the key. if there is no value you get a default value of FALSE
        return UserDefaults.standard.isLoggedIn()
        
    }
    
    func showLoginController() {
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: {
            //perhaps do something later
        })
    }
}

