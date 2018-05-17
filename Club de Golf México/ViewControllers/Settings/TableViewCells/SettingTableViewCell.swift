//
//  SettingTableViewCell.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var toggleSwitch: UISwitch!
    
    
    var isSwitch: Bool = true {
        didSet {
            toggleSwitch.isHidden = !isSwitch
        }
    }
    
    var switchIsToggled: Bool = false {
        didSet {
            toggleSwitch.setOn(switchIsToggled, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                
                if self.toggleSwitch.isOn {
                    
                    if self.onDescText != nil {
                        self.descText = self.onDescText!
                    }
                    
                    self.toggleSwitch.thumbTintColor = UIColor.primary
                    self.toggleSwitch.onTintColor = UIColor.colorAccent
                    
                }else{
                    
                    if self.offDescText != nil {
                        self.descText = self.offDescText!
                    }
                    
                    self.toggleSwitch.thumbTintColor = UIColor.lightGray
                    self.toggleSwitch.backgroundColor = UIColor.gray
                    self.toggleSwitch.layer.cornerRadius = 16.0;
                    
                }
            }
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                titleLabel.textColor = UIColor.black
                descLabel.textColor = UIColor.gray
            } else {
                titleLabel.textColor = UIColor.lightGray
                descLabel.textColor = UIColor.lightGray
            }
        }
    }
    var onDescText: String? {
        didSet {
            if switchIsToggled && onDescText != nil{
                descText = onDescText!
            }
        }
    }
    
    var offDescText: String? {
        didSet {
            if !switchIsToggled && offDescText != nil{
                descText = offDescText!
            }
        }
    }
    
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var descText: String = "" {
        didSet {
            descLabel.text = descText
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.switchIsToggled = false
        self.isEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tapGesture)
        // Initialization code
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        
        if !self.isEnabled {
            return
        }
        

        if self.isSwitch {
            self.switchIsToggled = !self.switchIsToggled
        }
        self.setSelected(true, animated: true)
        self.setSelected(false, animated: true)
        if let tableView = self.superview as? UITableView {
            tableView.delegate?.tableView!(tableView, didSelectRowAt: tableView.indexPath(for: self)!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
