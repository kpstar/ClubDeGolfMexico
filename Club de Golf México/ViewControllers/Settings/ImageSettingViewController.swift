//
//  ImageSettingViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ImageSettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuración"
        let cellNib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "settingCell")
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
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

extension ImageSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "settingHeaderCell")
        let label = headerView?.viewWithTag(100) as! UILabel
        var titleString = ""
        if section == 0 {
            titleString = "IMAGENES"
        } else {
            titleString = "VIDEOS"
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
        
        if indexPath.section == 0 {
            cell.isSwitch = true
            cell.titleText = "Descargar imagenes"
            cell.onDescText = "Se descarga la imagen al recibir la notificación y se alamcena en su teléfono."
            cell.offDescText = "Cada vez que vea una imagen se estara descargando desde internet, esto puede consumir su plan de datos."
        } else {
            cell.isSwitch = true
            cell.titleText = "Ver videos"
            cell.onDescText = "En todo momento, esto puede consumir su plan de datos solo cuando vea el video."
            cell.offDescText = "Solo cuando me encuentre en una red WiFi."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            tableView.reloadData()
        }
    }
    
}
