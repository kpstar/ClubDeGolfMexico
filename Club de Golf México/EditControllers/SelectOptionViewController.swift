//
//  SelectOptionViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import M13Checkbox

protocol SelectOptionViewDelegate: class {
    func didSelectedOption(_ optionString: String)
}

class SelectOptionViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var containerHeight: NSLayoutConstraint!
    
    var optionList = [String]()
    var selectedOption = ""
    var titleString = ""
    
    weak var delegate: SelectOptionViewDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel.text = titleString
        
        var height = self.optionList.count * 50 + 40
        
        if height > 400 {
            height = 400
        }
        
        self.containerHeight.constant = CGFloat(height)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
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

extension SelectOptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        let option = self.optionList[indexPath.row]
        
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = option
        }
        
        if let radio = cell.viewWithTag(200) as? M13Checkbox {
            
            if option == self.selectedOption {
                radio.checkState = .checked
            } else {
                radio.checkState = .unchecked
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = self.optionList[indexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.didSelectedOption(option)
        }
    }
    
}

extension SelectOptionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.tableView))! {
            return false
        }
        return true
    }
}

