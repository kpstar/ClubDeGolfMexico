//
//  ImageViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var message: MensajeType!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let imageURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (self.message.mensaje_fecha_enviado.dateFromISO8601?.yearMonthPath)! + "/" + self.message.mensaje_image
        
        imageView.af_setImage(withURL: URL(string: imageURL)!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
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
