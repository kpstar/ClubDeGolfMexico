//
//  GolfLinkViewController.swift
//  Club de Golf México
//
//  Created by KpStar on 4/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class GolfLinkViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: UserDefaults.standard.string(forKey: kFloatingGolflink)!)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
