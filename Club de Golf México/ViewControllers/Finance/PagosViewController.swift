//
//  PagosViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PagosViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    
    var pagosList = [PagosType]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PagosViewController.refreshData), name: notificationNameReceiveNewMessage, object: nil)
        
        self.refreshData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshData() {
        pagosList = DBService.shared.pagosDB.all()
        self.tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetail" {
            
            let detailVC = segue.destination as! PagosDetailViewController
            
            detailVC.pagos = sender as! PagosType
            
            detailVC.delegate = self
            
        } else if segue.identifier == "seguePDF" {
            
            let pdfVC = segue.destination as! PDFViewController
            
            pdfVC.pdfURL = sender as! String
            
        }
    }

}

extension PagosViewController: PagosDetailViewDelegate {
    func didSelectedRecibo(_ pagos: PagosType) {
        
        
        let pdfURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (pagos.pago_fecha.dateFromISO8601?.yearMonthPath)! + "/" + pagos.pago_recibo

        self.performSegue(withIdentifier: "seguePDF", sender: pdfURL)
        

    }
    
    func didSelectedFactura(_ pagos: PagosType) {

        let pdfURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (pagos.pago_fecha.dateFromISO8601?.yearMonthPath)! + "/" + pagos.pago_factura

        self.performSegue(withIdentifier: "seguePDF", sender: pdfURL)

    }
}

extension PagosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pagosCell", for: indexPath) as! PagosTableViewCell
        
        let pagos = self.pagosList[indexPath.row]
        
        cell.setPagos(pagos)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let pagos = self.pagosList[indexPath.row]
        
        self.performSegue(withIdentifier: "segueDetail", sender: pagos)
        
    }
    
}
