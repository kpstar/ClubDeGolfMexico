//
//  SettingsViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SettingsViewController: CGMViewController {

    @IBOutlet var tableView: UITableView!
    var menuList = [MenuType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuList.append(MenuType(name: "Parámetros generales", image: UIImage(named: "info")!))
        menuList.append(MenuType(name: "Notificaciones y recordatorios", image: UIImage(named: "notification")!))
        menuList.append(MenuType(name: "Imágenes y videos", image: UIImage(named: "camera")!))

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Configuración"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
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

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
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
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "segueGeneral", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "segueNotification", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "segueImage", sender: nil)
        default:
            break
        }
        
    }
}
