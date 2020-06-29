//
//  GateViewController.swift
//  Project
//
//  Created by raz cohen on 11/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class GateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: actions

    
    
    @IBAction func logOut(_ sender: UIButton) {
         performSegue(withIdentifier: "logIn", sender: nil)
    }
    
}
