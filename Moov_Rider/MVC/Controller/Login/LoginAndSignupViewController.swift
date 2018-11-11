//
//  LoginAndSignupViewController.swift
//  Moov_Rider
//
//  Created by Taiwo on 11/11/2018.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class LoginAndSignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        print ("amin aseda \(index)")
    }
}
