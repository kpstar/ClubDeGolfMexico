//
//  PagosTableViewCell.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class PagosTableViewCell: UITableViewCell {

    @IBOutlet var fechaLabel: UILabel!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var amountLabel: UILabel!
    
    @IBOutlet var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPagos(_ data: PagosType) {
        fechaLabel.text = data.pago_fecha.dateFromISO8601?.shortDayString
        statusLabel.text = data.pago_status
        amountLabel.text = data.pago_importe.currencyString
        switch data.pago_origen_id {
        case 95: // Phone
            statusImage.image = UIImage(named: "icon_phone")
        case 96: // web
            statusImage.image = UIImage(named: "icon_laptop")
        case 97: // Oficina
            statusImage.image = UIImage(named: "icon_oficinas")
        case 103: // Banco
            statusImage.image = UIImage(named: "icon_bank")
        default:
            break
        }
    }


}
