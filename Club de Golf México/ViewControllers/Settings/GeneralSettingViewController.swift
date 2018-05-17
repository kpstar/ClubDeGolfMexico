//
//  GeneralSettingViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class GeneralSettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var displayName = "John Smith"
    var addFriendsOption = AddFriendsMessagesOptions.always
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuración"

        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "settingCell")
        self.tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueEditName" {
            let editVC = segue.destination as! EditTextViewController
            editVC.titleText = "Display Name"
            editVC.editTextValue = displayName
            editVC.delegate = self
        } else if segue.identifier == "segueSelectOption" {
            let selectOptionVC = segue.destination as! SelectOptionViewController
            selectOptionVC.optionList = AddFriendsMessagesOptions.allString
            selectOptionVC.selectedOption = self.addFriendsOption.rawValue
            selectOptionVC.titleString = "Add friends to messages"
            selectOptionVC.delegate = self
        }
        
    }

}

extension GeneralSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        switch indexPath.row {
        case 0:
            cell.isSwitch = true
            cell.titleText = "Enable social recommendations"
            cell.descText = "Recommendations for people to contact based on your message history"
        case 1:
            cell.isSwitch = false
            cell.titleText = "Display name"
            cell.descText = displayName

        case 2:
            cell.isSwitch = false
            cell.titleText = "Add friends to messages"
            cell.descText = addFriendsOption.rawValue
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "segueEditName", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "segueSelectOption", sender: nil)
        default:
            break
        }
    }
    
}

extension GeneralSettingViewController: EditTextViewDelegate {
    func didEditedText(_ editedText: String) {
        displayName = editedText
        self.tableView.reloadData()        
    }
}

extension GeneralSettingViewController: SelectOptionViewDelegate {
    func didSelectedOption(_ optionString: String) {
        self.addFriendsOption = AddFriendsMessagesOptions(rawValue: optionString)!
        self.tableView.reloadData()
    }
}
