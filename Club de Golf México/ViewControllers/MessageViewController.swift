//
//  MessageViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import RIGImageGallery
import MBProgressHUD
class MessageViewController: CGMViewController {

    @IBOutlet var tableView: UITableView!
    
    var messageList = [[MensajeType]]()
    var dayList = [String]()
    var areaTypes: [Int]?
    fileprivate let imageSession = URLSession(configuration: .default)
    var image: UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mensajes Nuevos"
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "messageCell")
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.refreshData), name: notificationNameReceiveNewMessage, object: nil)

        self.refreshData()
    }

    @objc func refreshData() {
        
        self.dayList.removeAll()
        
        self.messageList.removeAll()
        
        let list = DBService.shared.unReadMessage(withAreas: self.areaTypes)
        
        let templist = list.map {
            return ($0.mensaje_fecha_enviado.dateFromISO8601?.dayString)!
        }
        
        self.dayList = Array(Set(templist)).sorted{ $0 > $1}
        
        for day in self.dayList {
            let pList = list.filter {
                ($0.mensaje_fecha_enviado.dateFromISO8601?.dayString.hasPrefix(day))!
            }
            self.messageList.append(pList)
        }
        
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "segueImage" {
              let imageVC = segue.destination as! ImageViewController
              imageVC.message = sender as! MensajeType
        } else if segue.identifier == "seguePDF" {
            let pdfVC = segue.destination as! PDFViewController
            pdfVC.pdfURL = sender as! String
        }
        
    }
    
}

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageHeader")
        
        if let titleLabel = cell?.viewWithTag(100) as? UILabel {
            titleLabel.text = self.dayList[section].dateFromDayString?.longDayString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell

        cell.setMessageData(self.messageList[indexPath.section][indexPath.row])
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//                    self.messageList[indexPath.row].mensaje_visto = 0
//                    _ = DBService.shared.mensajeDB.update(self.messageList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let message = self.messageList[indexPath.section][indexPath.row]
        
            if message.mensaje_visto != 0 {
                return
            }
            
            let currentDateandTime = Date().iso8601
            
            let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
            
            let params = [String(indexPath.row), String(message.mensaje_id ?? 0), String(message.mensaje_web_id), user_id, currentDateandTime]
        
        
            WebService.shared.sendRequest(codigo: 201, data: params) { (isSuccess, errorMessage, resultData) in

                if !isSuccess {
                    return
                }
                
                if Int((resultData?[1] ?? "0")) != 1 {
                    return
                }
                
                if Int((resultData?[0] ?? "0")) != 201 {
                    return
                }
                
                let mensaje_id = Int(resultData?[3] ?? "0") ?? 0
                
                guard var mensaje = DBService.shared.mensajeDB.select(withID: mensaje_id) else {
                    return
                }
                
                mensaje.mensaje_visto = 1
                
                _ = DBService.shared.mensajeDB.update(mensaje)
                
            }

    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "BORRAR") { (action, indexPath) in
            
            
            let message = self.messageList[indexPath.section][indexPath.row]
        
            let currentDateandTime = Date().iso8601
            
            let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
            
            let params = [String(indexPath.row), String(message.mensaje_id ?? 0), String(message.mensaje_web_id), user_id, currentDateandTime]
            
            MBProgressHUD.showAdded(to: self.view, animated: true)

            WebService.shared.sendRequest(codigo: 202, data: params) { (isSuccess, errorMessage, resultData) in

                MBProgressHUD.hide(for: self.view, animated: true)

                if !isSuccess {
                    return
                }
                
                if Int((resultData?[1] ?? "0")) != 1 {
                    return
                }
                
                if Int((resultData?[0] ?? "0")) != 202 {
                    return
                }
                
                let mensaje_id = Int(resultData?[3] ?? "0") ?? 0
                
                guard var mensaje = DBService.shared.mensajeDB.select(withID: mensaje_id) else {
                    return
                }
                
                mensaje.delete_flag = true

                if DBService.shared.mensajeDB.update(mensaje) {
                    self.messageList[indexPath.section].remove(at: indexPath.row)
                    self.refreshData()
                }

            }
            
            
        }
        return [delete]
    }

}

extension MessageViewController: MessageTableViewCellDelegate {
    
    func didSelectedMessageCell(_ message: MensajeType) {
        
        switch message.mensaje_tipo_eid {
        case 74:
            
            let imageURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (message.mensaje_fecha_enviado.dateFromISO8601?.yearMonthPath)! + "/" + message.mensaje_image
            let urlImage: URL = URL(string: imageURL)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                let imagedata = NSData(contentsOf: urlImage)
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: imagedata! as Data)!
                }
            }
            let photoViewController = prepareRemoteGallery(imageURL)
            photoViewController.dismissHandler = dismissPhotoViewer
            photoViewController.actionButtonHandler = actionButtonHandler
            photoViewController.actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
            photoViewController.traitCollectionChangeHandler = traitCollectionChangeHandler
            photoViewController.setCurrentImage(0, animated: false)
            
            let navigationController = navBarWrappedViewController(photoViewController)
            present(navigationController, animated: true, completion: nil)

            break
        case 75:
            guard let url = URL(string: message.mensaje_link) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case 76:
            let youtubePlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: message.mensaje_link)
            self.present(youtubePlayer, animated: true, completion: nil)
        case 89:
            let pdfURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (message.mensaje_fecha_enviado.dateFromISO8601?.yearMonthPath)! + "/" + message.mensaje_image
            self.performSegue(withIdentifier: "seguePDF", sender: pdfURL)
        default:
            break
        }

    }
    
}

private extension MessageViewController {
    func dismissPhotoViewer(_ :RIGImageGalleryViewController) {
        dismiss(animated: true, completion: nil)
    }
    func traitCollectionChangeHandler(_ photoView: RIGImageGalleryViewController) {
        let isPhone = UITraitCollection(userInterfaceIdiom: .phone)
        let isCompact = UITraitCollection(verticalSizeClass: .compact)
        let allTraits = UITraitCollection(traitsFrom: [isPhone, isCompact])
        photoView.doneButton = photoView.traitCollection.containsTraits(in: allTraits) ? nil : UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    }
    
    func navBarWrappedViewController(_ viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barStyle = .blackTranslucent
        navigationController.navigationBar.tintColor = .white
        navigationController.toolbar.barStyle = .blackTranslucent
        navigationController.toolbar.tintColor = .white
        return navigationController
    }
    
    func actionButtonHandler(rigVC :RIGImageGalleryViewController, galleryItem: RIGImageGalleryItem) {
        // set up activity view controller
        let imageToShare = [ self.image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        //activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        rigVC.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func prepareRemoteGallery(_ url: String) -> RIGImageGalleryViewController {
        
        let urls = [url].flatMap(URL.init(string:))
        
        let rigItems: [RIGImageGalleryItem] = urls.map { url in
            
            RIGImageGalleryItem(placeholderImage: nil,
                                title: url.pathComponents.last ?? "",
                                isLoading: true)
        }
        
        let rigController = RIGImageGalleryViewController(images: rigItems)
        
        for (index, URL) in  urls.enumerated() {
            let completion = rigController.handleImageLoadAtIndex(index)
            let request = imageSession.dataTask(with: URLRequest(url: URL),
                                                completionHandler: completion)
            request.resume()
        }
        
        return rigController
    }
    
    
}

