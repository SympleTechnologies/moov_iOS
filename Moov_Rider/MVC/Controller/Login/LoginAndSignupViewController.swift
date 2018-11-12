//
//  LoginAndSignupViewController.swift
//  Moov_Rider
//
//  Created by Taiwo on 11/11/2018.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

enum LoginSignupTabBarDisplayedScreen: Int {
    case signIn = 0
    case signUp = 1
}

class LoginAndSignupViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var containerTabBarController: UITabBarController!
    var screenToShow: LoginSignupTabBarDisplayedScreen?

    override func viewDidLoad() {
        super.viewDidLoad()

        containerTabBarController.tabBar.isHidden = true

        if let screen = screenToShow {
            containerTabBarController.selectedIndex = screen.rawValue
            segmentedControl.selectedSegmentIndex = screen.rawValue
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        containerTabBarController = segue.destination as? UITabBarController
        containerTabBarController.view.translatesAutoresizingMaskIntoConstraints = false
    }

    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        containerTabBarController.selectedIndex = index
    }
}
