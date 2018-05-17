//
//  RestrauntViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class RestrauntViewController: CGMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Restaurante"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMessage" {
            let messageVC = segue.destination as! MessageViewController
            messageVC.areaTypes = [67]
        }
    }

}
