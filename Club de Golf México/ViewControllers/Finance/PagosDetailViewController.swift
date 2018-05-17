//
//  PagosDetailViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
protocol PagosDetailViewDelegate: class {
    func didSelectedFactura(_ pagos: PagosType)
    func didSelectedRecibo(_ pagos: PagosType)

}

class PagosDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    
    @IBOutlet var facturaButton: UIButton!
    
    @IBOutlet var reciboButton: UIButton!
    
    var pagos: PagosType!
    
    weak var delegate: PagosDetailViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        facturaButton.isHidden = true
        reciboButton.isHidden = true
        
        var strMensaje = ""
        switch pagos.pago_origen_id {
        case 95:
            strMensaje = "Pago en APP Movil"
        case 96:
            strMensaje = "Pago en Portal WEB"
        case 97:
            strMensaje = "Pago en Oficinas"
        case 103:
            strMensaje = "Pago por transferencia"
        default:
            break
        }
        
        if pagos.pago_confirmado.count > 0 {
            
            if pagos.pago_card.count > 0 {
                strMensaje += "\nTarjeta: " + pagos.pago_card
            }
            strMensaje += "\nFecha: " + (pagos.pago_fecha.dateFromISO8601?.shortDateTimeString)!
            strMensaje += "\nReferencia: " + pagos.pago_referencia
            strMensaje += "\nImporte: " + pagos.pago_amount
            
            if pagos.pago_codigo_aut.count > 0 {
                strMensaje += "\nAutorización: " + pagos.pago_codigo_aut
            }
            strMensaje += "\n\nPAGO CONFIRMADO";
            strMensaje += "\nFecha: " +  (pagos.pago_confirmado.dateFromISO8601?.shortDateTimeString)!
            
            if pagos.pago_comentarios.count > 0 {
                strMensaje += "\n" + pagos.pago_comentarios
            }
            
            switch pagos.pago_origen_id {
            case 95: // Phone
                statusImageView.image = UIImage(named: "icon_phone")
            case 96: // web
                statusImageView.image = UIImage(named: "icon_laptop")
            case 97: // Oficina
                statusImageView.image = UIImage(named: "icon_oficinas")
            case 103: // Banco
                statusImageView.image = UIImage(named: "icon_bank")
            default:
                break
            }
            
            titleLabel.text = pagos.pago_status

            contentLabel.text = strMensaje
            
            if pagos.pago_factura.count > 0 {
                facturaButton.isHidden = false
            }
            
            if pagos.pago_recibo.count > 0 {
                reciboButton.isHidden = false
            }
        } else {
            if pagos.pago_status == "CARGADO" {
                
                strMensaje += "\nTarjeta: " + pagos.pago_card
                strMensaje += "\nFecha: " +  (pagos.pago_fecha.dateFromISO8601?.shortDateTimeString)!
                strMensaje += "\nReferencia: " + pagos.pago_referencia
                strMensaje += "\nImporte: " + pagos.pago_amount
                strMensaje += "\nAutorización: " + pagos.pago_codigo_aut
                
                if pagos.pago_kerror.count > 0 {
                    strMensaje += "\n" + pagos.pago_kerror
                }
                
                titleLabel.text = "Cargo generado"
                statusImageView.image = UIImage(named: "icon_pago_ok")
                contentLabel.text = strMensaje
                
            } else {
                strMensaje += "Tarjeta: " + pagos.pago_card
                strMensaje += "\n" + pagos.pago_kerror
                strMensaje += "\nFecha: " + (pagos.pago_fecha.dateFromISO8601?.shortDateTimeString)!
                strMensaje += "\nReferencia: " + pagos.pago_referencia
                strMensaje += "\nImporte: " + pagos.pago_amount
                strMensaje += "\nRechazo: " + pagos.pago_codigo_aut

                titleLabel.text = pagos.pago_status
                
                statusImageView.image = UIImage(named: "icon_pago_err")
                contentLabel.text = strMensaje
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facturaButtonClick(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectedFactura(self.pagos)
        }
    }
    
    @IBAction func reciboButtonClick(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectedRecibo(self.pagos)
        }
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
