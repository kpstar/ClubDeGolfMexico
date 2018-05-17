//
//  EstadosViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EstadosViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var estadosList = [EstadosType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()

        NotificationCenter.default.addObserver(self, selector: #selector(EstadosViewController.refreshData), name: notificationNameReceiveNewMessage, object: nil)
        self.refreshData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshData() {
        estadosList = DBService.shared.estadosDB.all()
        self.tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetail" {
            
            let detailVC = segue.destination as! EstadosDetailViewController
            
            detailVC.estados = sender as! EstadosType
            
            detailVC.delegate = self
            
        } else if segue.identifier == "seguePDF" {
            
            let pdfVC = segue.destination as! PDFViewController
            
            pdfVC.pdfURL = sender as! String
            
        }
    }

}

extension EstadosViewController: EstadosDetailViewDelegate {
    func didSelectedVewPDF(_ estados: EstadosType) {
        
        let pdfURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (estados.estado_fecha.dateFromISO8601?.yearMonthPath)! + "/" + estados.estado_archivo
        
        self.performSegue(withIdentifier: "seguePDF", sender: pdfURL)
        
    }
}

extension EstadosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estadosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "estadosCell", for: indexPath) as! EstadosTableViewCell
        
        let estados = self.estadosList[indexPath.row]
        
        cell.setEstados(estados)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        let estados = self.estadosList[indexPath.row]

        self.performSegue(withIdentifier: "segueDetail", sender: estados)

    }
    
}
