//
//  EstadosTableViewCell.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EstadosTableViewCell: UITableViewCell {

    @IBOutlet var fechaLabel: UILabel!
    @IBOutlet var periodoLabel: UILabel!
    @IBOutlet var importeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEstados(_ data: EstadosType) {
        fechaLabel.text = data.estado_fecha.dateFromISO8601?.shortDayString
        periodoLabel.text = data.estado_periodo
        importeLabel.text = data.estado_importe.currencyString
    }

}
