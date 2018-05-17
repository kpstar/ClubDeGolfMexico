//
//  CGMViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import KYDrawerController
import BBBadgeBarButtonItem

class CGMMainViewController: UIViewController {
    
    var golfItem: BBBadgeBarButtonItem!
    var financeItem: BBBadgeBarButtonItem!
    var restrauntItem: BBBadgeBarButtonItem!
    var galleryItem: BBBadgeBarButtonItem!
    var messageItem: BBBadgeBarButtonItem!
    
    var golfButton: UIButton!
    var financeButton: UIButton!
    var restrauntButton: UIButton!
    var galleryButton: UIButton!
    var messageButton: UIButton!

    var drawer: KYDrawerController? {
        get {
           return self.navigationController?.parent as? KYDrawerController
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.primary
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftMenuTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftItem
        
        golfButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        golfButton.setImage(UIImage(named: "tab-golf"), for: .normal)
        golfButton.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        golfItem = BBBadgeBarButtonItem(customUIButton: golfButton)
        golfItem.badgeOriginX = 25

        financeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        financeButton.setImage(UIImage(named: "tab-finance"), for: .normal)
        financeButton.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        financeItem = BBBadgeBarButtonItem(customUIButton: financeButton)
        financeItem.badgeOriginX = 25

        restrauntButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        restrauntButton.setImage(UIImage(named: "tab-restraunt"), for: .normal)
        restrauntButton.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        restrauntItem = BBBadgeBarButtonItem(customUIButton: restrauntButton)
        restrauntItem.badgeOriginX = 25

        galleryButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        galleryButton.setImage(UIImage(named: "tab-gallery"), for: .normal)
        galleryButton.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        galleryItem = BBBadgeBarButtonItem(customUIButton: galleryButton)
        galleryItem.badgeOriginX = 25

        messageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        messageButton.setImage(UIImage(named: "tab-message"), for: .normal)
        messageButton.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        messageItem = BBBadgeBarButtonItem(customUIButton: messageButton)
        messageItem.badgeOriginX = 25


        
        self.navigationItem.rightBarButtonItems = [messageItem, galleryItem, restrauntItem, financeItem, golfItem ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setBadgeCount), name: notificationNameReceiveNewMessage, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBadgeCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func setBadgeCount() {
        
        let golfCount = DBService.shared.mensajeDB.unreadCount(withAreas: [65, 70])
        
        let financeCount = DBService.shared.mensajeDB.unreadCount(withAreas: [66])
        
        let restrauntCount = DBService.shared.mensajeDB.unreadCount(withAreas: [67])
        
        let gallerytCount = DBService.shared.mensajeDB.unreadCount(withAreas: [68])
        
        let informationCount = DBService.shared.mensajeDB.unreadCount(withAreas: [69])
        
        golfItem.badgeValue = String(golfCount)
        
        financeItem.badgeValue = String(financeCount)
        
        restrauntItem.badgeValue = String(restrauntCount)
        
        galleryItem.badgeValue = String(gallerytCount)
        
        messageItem.badgeValue = String(informationCount)
        
        
        let totalCount = golfCount + financeCount + restrauntCount + gallerytCount + informationCount
        
        UIApplication.shared.applicationIconBadgeNumber = totalCount

    }
    
    @objc func itemTapped(_ sender: AnyObject?) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch sender as! UIButton {
        case golfButton:
            let controller = storyboard.instantiateViewController(withIdentifier: "golfVC")
            drawer?.navigationController?.pushViewController(controller, animated: true)
        case financeButton:
            let controller = storyboard.instantiateViewController(withIdentifier: "financeVC")
            drawer?.navigationController?.pushViewController(controller, animated: true)
        case restrauntButton:
            let controller = storyboard.instantiateViewController(withIdentifier: "restrauntVC")
            drawer?.navigationController?.pushViewController(controller, animated: true)
        case galleryButton:
            let controller = storyboard.instantiateViewController(withIdentifier: "galleryVC")
            drawer?.navigationController?.pushViewController(controller, animated: true)
        case messageButton:
            let controller = storyboard.instantiateViewController(withIdentifier: "messageVC") as! MessageViewController
            controller.areaTypes = [69]
            drawer?.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }

    }
    
    @objc func leftMenuTapped(_ sender: AnyObject?) {
        drawer?.setDrawerState(.opened, animated: true)        
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
