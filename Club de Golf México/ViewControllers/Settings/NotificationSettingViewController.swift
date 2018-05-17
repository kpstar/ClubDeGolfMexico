//
//  NotificationSettingViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MBProgressHUD

let kNotification = "kNotification"
let kNotificationTone = "kNotificationTone"
let kNotificationVibration = "kNotificationVibration"

class NotificationSettingViewController: CGMViewController {

    @IBOutlet var tableView: UITableView!
    
    var toneOption = ToneOptions.bolaGolf
    
    var recordOption = RecordActivityOptions.fiveMin
    
    var currentSelectOption = 0 // 0: tone option, 1: record option
    
    var notificationState = true
    
    var vibrationState = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuración"
        let cellNib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "settingCell")
        self.tableView.tableFooterView = UIView()
        notificationState = UserDefaults.standard.bool(forKey: kNotification)
        vibrationState = UserDefaults.standard.bool(forKey: kNotificationVibration)
        toneOption = ToneOptions(rawValue: UserDefaults.standard.string(forKey: kNotificationTone)!)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueSelectOption" {
            currentSelectOption = sender as! Int
            let selectOptionVC = segue.destination as! SelectOptionViewController
            selectOptionVC.delegate = self
            
            if currentSelectOption == 0 {
                selectOptionVC.optionList = ToneOptions.allString
                selectOptionVC.selectedOption = self.toneOption.rawValue
                selectOptionVC.titleString = "Tono de notificación"

            } else {
                selectOptionVC.optionList = RecordActivityOptions.allString
                selectOptionVC.selectedOption = self.recordOption.rawValue
                selectOptionVC.titleString = "Recordar actividades"
            }
            
        }
        
    }

}

extension NotificationSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        switch section {
        case 0:
            rowCount = 2
        case 1:
            rowCount = 1
        default:
            break
        }
        return rowCount
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "settingHeaderCell")
        let label = headerView?.viewWithTag(100) as! UILabel
        var titleString = ""
        if section == 0 {
            titleString = "NOTIFICACIONES"
        } else {
            titleString = "RECORDATORIOS"
        }
        label.text = titleString
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 20))
        footerView.backgroundColor = UIColor.white
        return footerView
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.isEnabled = true
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.isSwitch = true
                cell.titleText = "Notificaciones"
                cell.descText = ""
                cell.switchIsToggled = notificationState
            case 1:
                cell.isSwitch = false
                cell.titleText = "Tono de notificación"
                cell.descText = toneOption.rawValue
                cell.isEnabled = notificationState
                
//            case 2:
//                cell.isSwitch = true
//                cell.titleText = "Vibración"
//                cell.descText = ""
//                cell.isEnabled = notificationState
//                cell.switchIsToggled = vibrationState
            default:
                break
            }

        } else {
            cell.isSwitch = false
            cell.titleText = "Recordar actividades"
            cell.descText = recordOption.rawValue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.cellForRow(at: indexPath) as! SettingTableViewCell
                notificationState = cell.switchIsToggled
                UserDefaults.standard.set(notificationState, forKey: kNotification)
                if notificationState == false {
                    let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
                    
                    let params = [user_id, "no_sound"]
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    WebService.shared.sendRequest(codigo: 110, data: params) { (isSuccess, errorMessage, resultData) in
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        if isSuccess {
                            
                            if Int((resultData?[1] ?? "0")) == 1 {
                                
                            } else {
                                self.showErrorMessage(resultData?[2] ?? "" )
                            }
                            
                            
                        } else {
                            
                            self.showErrorMessage(errorMessage ?? "")
                            
                        }
                        
                    }

                } else {
                    let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
                    
                    let temp = ToneOptions(rawValue: UserDefaults.standard.string(forKey: kNotificationTone)!)!
                    
                    var soundName = "default"
                    
                    switch temp {
                        
                    case .swingDrive:
                        soundName = "golf_swing"
                        
                    case .swingMadera:
                        soundName = "golf_wood"
                        
                    case .fore:
                        soundName = "golf_fore"
                        
                    case .golf:
                        soundName = "golf_girl"
                        
                    case .bolaGolf:
                        soundName = "golf_bounce"
                    }
                    
                    let params = [user_id, soundName]
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    WebService.shared.sendRequest(codigo: 110, data: params) { (isSuccess, errorMessage, resultData) in
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        if isSuccess {
                            
                            if Int((resultData?[1] ?? "0")) == 1 {
                                
                            } else {
                                self.showErrorMessage(resultData?[2] ?? "" )
                            }
                            
                            
                        } else {
                            
                            self.showErrorMessage(errorMessage ?? "")
                            
                        }
                        
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    tableView.reloadData()
                }
            case 1:
                self.performSegue(withIdentifier: "segueSelectOption", sender: 0)
            case 2:
                let cell = tableView.cellForRow(at: indexPath) as! SettingTableViewCell
                vibrationState = cell.switchIsToggled
                UserDefaults.standard.set(vibrationState, forKey: kNotificationVibration)
                if vibrationState == false {
                    
                } else {
                    
                }
                
            default:
                break
            }
        } else {
            self.performSegue(withIdentifier: "segueSelectOption", sender: 1)
        }
    }
    
}

extension NotificationSettingViewController: SelectOptionViewDelegate {
    
    func didSelectedOption(_ optionString: String) {
        
        if self.currentSelectOption == 0 {
            
            self.toneOption = ToneOptions(rawValue: optionString)!
            
            UserDefaults.standard.setValue(optionString, forKey: kNotificationTone)
            
            var soundName = "default"

            switch self.toneOption {
                
                case .swingDrive:
                    soundName = "golf_swing"
                
                case .swingMadera:
                    soundName = "golf_wood"
                
                case .fore:
                    soundName = "golf_fore"
                
                case .golf:
                    soundName = "golf_girl"
                
                case .bolaGolf:
                    soundName = "golf_bounce"
            }

            let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
            
            //UserDefaults.standard.set(soundName, forKey: kNotificationTone)
            
            let params = [user_id, soundName]
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            WebService.shared.sendRequest(codigo: 110, data: params) { (isSuccess, errorMessage, resultData) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if isSuccess {
                    
                    if Int((resultData?[1] ?? "0")) == 1 {
                        
                    } else {
                        self.showErrorMessage(resultData?[2] ?? "" )
                    }
                    
                    
                } else {
                    
                    self.showErrorMessage(errorMessage ?? "")
                    
                }
                
            }

            
            
        } else {
            self.recordOption = RecordActivityOptions(rawValue: optionString)!
        }
        
        self.tableView.reloadData()
        
    }
}

