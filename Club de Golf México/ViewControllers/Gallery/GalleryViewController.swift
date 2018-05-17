//
//  GalleryViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import HMSegmentedControl

class GalleryViewController: CGMViewController {

    @IBOutlet var tabContainer: UIView!
    
    @IBOutlet var galleryView: UIView!
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet var panelLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    let segmentedControl = HMSegmentedControl(sectionTitles: ["GALERIAS", "MENSAJES"])
    
    var galleryList = [GaleriasType]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Galerías"
        
        let galleryUnreadCount = DBService.shared.mensajeDB.unreadCount(withAreas: [68])

        self.segmentedControl?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        self.segmentedControl?.frame = tabContainer.bounds
        self.segmentedControl?.selectionIndicatorLocation = .down
        self.segmentedControl?.selectionIndicatorColor = UIColor.primary
        self.segmentedControl?.selectionIndicatorHeight = 3
        self.segmentedControl?.selectionStyle = .fullWidthStripe
        self.segmentedControl?.segmentWidthStyle = .fixed
        self.segmentedControl?.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
        self.segmentedControl?.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        tabContainer.addSubview(self.segmentedControl!)
        if galleryUnreadCount > 0 {
            self.segmentedControl?.selectedSegmentIndex = 1
        }
        segmentedControlChangedValue()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GalleryViewController.refreshData), name: notificationNameReceiveNewMessage, object: nil)

        self.refreshData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Galerías"

    }
    
    @objc func refreshData() {
        self.galleryList = DBService.shared.galeriasDB.all()
        self.tableView.reloadData()

    }

    @objc func segmentedControlChangedValue() {
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            panelLabel.text = "Galerías"
            galleryView.isHidden = false
            messageView.isHidden = true
        } else {
            panelLabel.text = "Mensajes"
            messageView.isHidden = false
            galleryView.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMessage" {
            let messageVC = segue.destination as! MessageViewController
            messageVC.areaTypes = [68]
        } else if segue.identifier == "segueDetail" {
            let detailVC = segue.destination as! GalleryDetailViewController
            detailVC.gallery = sender as! GaleriasType
        }
    }

}

extension GalleryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.galleryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell", for: indexPath)
        
        let gallery = self.galleryList[indexPath.row]
        
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = gallery.galeria_titulo + "\n(" + (gallery.galeria_realizado.dateFromISO8601?.shortDayString)! + ")"
        }
        
        if let imageView = cell.viewWithTag(200) as? UIImageView {
            
            let imageURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (gallery.timeStamp.dateFromISO8601?.yearMonthPath)! + "/" + gallery.galeria_image
            imageView.image = UIImage.placeHolder
            imageView.af_setImage(withURL: URL(string: imageURL)!)

        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let gallery = self.galleryList[indexPath.row]
        
        self.performSegue(withIdentifier: "segueDetail", sender: gallery)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
