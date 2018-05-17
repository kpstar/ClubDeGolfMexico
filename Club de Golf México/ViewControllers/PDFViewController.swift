//
//  PDFViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MBProgressHUD

class PDFViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var pdfURL: String!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let request = URLRequest(url: URL(string: pdfURL)!)
        
        webView.delegate = self
        
        webView.scalesPageToFit = true
        
        self.webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PDFViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: self.webView, animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.webView, animated: true)
    }
}
