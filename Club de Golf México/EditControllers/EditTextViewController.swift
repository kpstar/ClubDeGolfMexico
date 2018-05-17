//
//  EditTextViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol EditTextViewDelegate: class {
    func didEditedText(_ editedText: String)
}

class EditTextViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var editText: UITextField!
    
    var titleText = ""
    var editTextValue = ""
    
    weak var delegate: EditTextViewDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = titleText
        editText.text = editTextValue
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        editText.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonClick(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didEditedText(self.editText.text!)
        }
    }
    @IBAction func cancelButtonClick(_ sender: Any) {
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
