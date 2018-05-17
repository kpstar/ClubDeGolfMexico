//
//  FinanceViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import HMSegmentedControl

class FinanceViewController: CGMViewController {

    @IBOutlet var tabContainer: UIView!
    
    @IBOutlet var panelLabel: UILabel!
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet var estadosView: UIView!
    
    @IBOutlet var pagosView: UIView!
    
    let segmentedControl = HMSegmentedControl(sectionTitles: ["ESTADOS DE \n CUENTA", "PAGOS \n REALIZADOS", "MENSAJES"])

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Finanzas"
        
        let financeCount = DBService.shared.mensajeDB.unreadCount(withAreas: [66])
        self.segmentedControl?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        self.segmentedControl?.frame = tabContainer.bounds
        self.segmentedControl?.selectionIndicatorLocation = .down
        self.segmentedControl?.selectionIndicatorColor = UIColor.primary
        self.segmentedControl?.selectionIndicatorHeight = 3
        self.segmentedControl?.selectionStyle = .fullWidthStripe
        self.segmentedControl?.segmentWidthStyle = .fixed
        self.segmentedControl?.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        self.segmentedControl?.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        tabContainer.addSubview(self.segmentedControl!)
        
        if financeCount > 0 {
            self.segmentedControl?.selectedSegmentIndex = 2
        }
        
        segmentedControlChangedValue()

    }

    @objc func segmentedControlChangedValue() {
        
        switch self.segmentedControl!.selectedSegmentIndex {
        case 0:
            panelLabel.text = "Estados de cuenta"
            estadosView.isHidden = false
            messageView.isHidden = true
            pagosView.isHidden = true
        case 1:
            panelLabel.text = "Pagos realizados"
            pagosView.isHidden = false
            estadosView.isHidden = true
            messageView.isHidden = true
        case 2:
            panelLabel.text = "Mensajes"
            messageView.isHidden = false
            pagosView.isHidden = true
            estadosView.isHidden = true
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMessage" {
            let messageVC = segue.destination as! MessageViewController
            messageVC.areaTypes = [66]
        }
    }


}
