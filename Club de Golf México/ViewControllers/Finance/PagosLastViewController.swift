//
//  PagosLastViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PagosLastViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var titleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Formas de pago"
        
        var strMensaje = "Puede realizar su pago de las siguientes formas:"
        strMensaje += "\n\nEn el Club de Golf"
        strMensaje += "\n\nEn el banco o por transferencia \n\n"
        strMensaje += UserDefaults.standard.string(forKey: kFloatingCuentas)!
//        strMensaje += "\n    Cuenta Banamex\n     No. 999 999999999 999"
//        strMensaje += "\n    Cuenta BBVA Bancomer\n     No. 999 999999999 999"
        contentLabel.text = strMensaje
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
