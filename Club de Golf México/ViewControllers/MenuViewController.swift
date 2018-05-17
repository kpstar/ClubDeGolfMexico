//
//  MenuViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Gradientable
import KYDrawerController

class MenuViewController: UIViewController {

    @IBOutlet var logoView: GradientableView!
    @IBOutlet var tableView: UITableView!
    var menuList = [MenuType]()
    
    var drawer: KYDrawerController? {
        get {
            return self.parent as? KYDrawerController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoGradient = GradientableOptions(colors: [UIColor.primary, UIColor.colorAccent, UIColor.primary], locations: nil, direction: GradientableOptionsDirection.bottomRightToTopLeft)
        logoView.set(options: logoGradient)
        
        menuList.append(MenuType(name: "Club de Golf México", image: UIImage(named: "menu_main")))
        menuList.append(MenuType(name: "Datos del socio", image: UIImage(named: "menu_profile")))
        menuList.append(MenuType(name: "Configuración", image: UIImage(named: "menu_config")))
        menuList.append(MenuType(name: "Aviso de privacidad", image: UIImage(named: "privacy")))
        menuList.append(MenuType(name: "Términos y Condiciones", image: UIImage(named: "terms")))
        menuList.append(MenuType(name: "Salir", image: UIImage(named: "menu_logout")))
        //menuList.append(MenuType(name: "Acceso", image: UIImage(named: "menu_access")))
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
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

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let menuItem = menuList[indexPath.row]
        
        if let titleLabel = menuCell.viewWithTag(100) as? UILabel {
            titleLabel.text = menuItem.name
        }
        
        if let imageView = menuCell.viewWithTag(200) as? UIImageView {
            imageView.image = menuItem.image
        }
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            drawer?.performSegue(withIdentifier: "segueMain", sender: nil)
            drawer?.setDrawerState(.closed, animated: true)
        case 1:
            drawer?.performSegue(withIdentifier: "segueProfile", sender: nil)
            drawer?.setDrawerState(.closed, animated: true)
        case 2:
            drawer?.setDrawerState(.closed, animated: true)
            drawer?.performSegue(withIdentifier: "segueSettings", sender: nil)
        case 3:
            drawer?.setDrawerState(.closed, animated: true)
            drawer?.performSegue(withIdentifier: "seguePrivacy", sender: nil)
        case 4:
            drawer?.setDrawerState(.closed, animated: true)
            drawer?.performSegue(withIdentifier: "segueTerms", sender: nil)
        case 5:
            exit(0)
        case 6:
            
            UserDefaults.standard.removeObject(forKey: kUserID)
            UserDefaults.standard.removeObject(forKey: kUserName)
            UserDefaults.standard.removeObject(forKey: kUserApp)
            UserDefaults.standard.removeObject(forKey: kUserImage)
            UserDefaults.standard.removeObject(forKey: kPaths)

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
            appDelegate.window?.rootViewController = loginVC

        default:
            break
        }
        
    }
}

struct MenuType {
    var name: String
    var image: UIImage?
    init(name: String, image: UIImage?) {
        self.name = name
        self.image = image
    }
}


