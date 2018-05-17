//
//  EstadosDetailViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol EstadosDetailViewDelegate: class {
    func didSelectedVewPDF(_ estados: EstadosType)
}

class EstadosDetailViewController: UIViewController {

    @IBOutlet var periodLabel: UILabel!
    
    @IBOutlet var amountLabel: UILabel!
    
    var estados: EstadosType!
    
    weak var delegate: EstadosDetailViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        periodLabel.text = estados.estado_periodo
        amountLabel.text = "$ " + estados.estado_importe.currencyString

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func vewDocButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.delegate?.didSelectedVewPDF(self.estados)
        }
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
