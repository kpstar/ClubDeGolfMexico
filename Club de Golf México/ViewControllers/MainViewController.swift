//
//  MainViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MBProgressHUD
import AlamofireImage
import Gradientable
import XCDYouTubeKit
import RIGImageGallery

let kWeatherUpdate = "WeatherUpdate"
let kClimaCode = "ClimaCode"
let kClimaActual = "ClimaActual"
let kClimaMin = "ClimaMin"
let kClimaMax = "ClimaMax"
let kClimaHumedad = "ClimaHumedad"
let kClimaVisibilidad = "ClimaVisibilidad"
let kClimaViento = "ClimaViento"
let kClimaDireccion = "ClimaDireccion"
let kUpdateCards = "UpdateCards"

extension Date {
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}

class MainViewController: CGMMainViewController {
    
    fileprivate let imageSession = URLSession(configuration: .default)

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var imgClimaEstadoImageView: UIImageView!    
    @IBOutlet var imgCompass: UIImageView!
    
    @IBOutlet var climaEstadoLabel: UILabel!
    @IBOutlet var climaActualLabel: UILabel!
    @IBOutlet var climaMinLabel: UILabel!
    @IBOutlet var climaMaxLabel: UILabel!
    
    @IBOutlet var climaHumedadLabel: UILabel!
    @IBOutlet var climaVisibilidadLabel: UILabel!
    @IBOutlet var climaVientoLabel: UILabel!
    @IBOutlet var climaDireccionLabel: UILabel!
    @IBOutlet weak var floatGolfLink: UIButton!
    
    @IBOutlet var headerGradient: GradientableView!
    @IBOutlet var tableView: UITableView!
    var eventList = [[MensajeType]]()
    var eventDayList = [String]()
    var weatherTimer: Timer!
    var image: UIImage = UIImage()

    @IBOutlet var headerTop: NSLayoutConstraint!
    
    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = UserDefaults.standard.string(forKey: kUserName)
        
        self.floatGolfLink.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        profileImageView.addGestureRecognizer(tapGesture)

        if let avatarData = UserDefaults.standard.value(forKey: kUserPhoto) as? Data {
            profileImageView.image = UIImage(data: avatarData)
        } else {
            profileImageView.image = UIImage(named: "noimage")
        }

        
        
        let cellNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "messageCell")
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.refreshEventData), name: notificationNameReceiveNewMessage, object: nil)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeUp))
        swipeUp.direction = .up
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeDown))
        swipeDown.direction = .down
        
        self.headerView.addGestureRecognizer(swipeUp)
        self.headerView.addGestureRecognizer(swipeDown)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func swipeUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.headerTop.constant = -self.headerGradient.bounds.height
            self.view.layoutIfNeeded()
        })

    }
    
    @objc func swipeDown() {
        UIView.animate(withDuration: 0.5, animations: {
            self.headerTop.constant = 0
            self.view.layoutIfNeeded()
        })
    }


    @objc func refreshEventData() {
        
        self.eventDayList.removeAll()
        
        self.eventList.removeAll()
        
        let golfLink = UserDefaults.standard.string(forKey: "floatingGolflink")
        if golfLink != "" && golfLink != nil {
            floatGolfLink.isHidden = false
        } else {
            floatGolfLink.isHidden = true
        }
        
        let list = DBService.shared.mensajeDB.eventList()
        
        let templist = list.map {
            return ($0.mensaje_fecha_limite.dateFromISO8601?.dayString)!
        }
        
        self.eventDayList = Array(Set(templist)).sorted{ $0 < $1}
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        let todayStr = dateFormatter.string(from: today)
        var tomorrowStr = ""
        
        if let tomorrow = today.tomorrow {
            tomorrowStr = dateFormatter.string(from: tomorrow)
        }
        
        print(todayStr + "/" + tomorrowStr)
        
        for day in self.eventDayList {
            if day != todayStr && day != tomorrowStr {
                continue
            }
            let pList = list.filter {
                ($0.mensaje_fecha_limite.dateFromISO8601?.dayString.hasPrefix(day))!
            }
            self.eventList.append(pList)
        }
        
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileImageView.setCircle()
        let logoGradient = GradientableOptions(colors: [UIColor.primary, UIColor.colorAccent, UIColor.primary], locations: nil, direction: GradientableOptionsDirection.bottomRightToTopLeft)
        headerGradient.set(options: logoGradient)
        
        checkWeatherUpdate()
        weatherTimer =  Timer.scheduledTimer(timeInterval: 360, target: self, selector: #selector(self.checkWeatherUpdate), userInfo: nil, repeats: true)
        
        self.refreshEventData()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        weatherTimer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let optionMenu = UIAlertController(title: "", message: "Cambiar fotografía", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "Seleccionar imágen", style: .default) { (_ UIAlertAction) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            optionMenu.addAction(libraryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Tomar fotografía", style: .default) { (_ UIAlertAction) in
                let camera = UIImagePickerController()
                camera.sourceType  = .camera
                camera.allowsEditing = true
                camera.cameraCaptureMode = .photo
                camera.modalPresentationStyle = .fullScreen
                camera.delegate = self
                self.present(camera, animated: true, completion: nil)
            }
            optionMenu.addAction(cameraAction)
        }
        optionMenu.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    @IBAction func clickGolfButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "GolfLinkVC")
        
        drawer?.navigationController?.pushViewController(controller, animated: true)

    }
    
    @objc func checkWeatherUpdate() {
        
        let hourString = Date().hourString

        if (UserDefaults.standard.string(forKey: kWeatherUpdate) != hourString) {
            
            MBProgressHUD.showAdded(to: self.view, animated: true).label.text = "Actualizando datos del clima"
            
            WebService.shared.getWeather(completion: { (isSuccess, errorMessage, resultData) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
//                JSONObject data =  new JSONObject(estado).optJSONObject("query").optJSONObject("results").optJSONObject("channel"
                guard let query = resultData?["query"] as? [String: Any] else { return }
                
                guard let results = query["results"] as? [String: Any] else { return }
                
                guard let channel = results["channel"] as? [String: Any] else { return }
                
                guard let atmosphere = channel["atmosphere"] as? [String: Any] else { return }
                
                guard let wind = channel["wind"] as? [String: Any] else { return }
                
                guard let item = channel["item"] as? [String: Any] else { return }
                
                guard let condition = item["condition"] as? [String: Any] else { return }
                
                let intCode = Int(condition["code"] as? String ?? "0")
                
                self.setEstado(intCode ?? 0)
                    
                self.climaActualLabel.text = condition["temp"] as! String + "°C"
                
                guard let forecast = item["forecast"] as? [[String: Any]] else { return }
                
                let today = forecast[0]

                self.climaMinLabel.text = today["low"] as! String + "°"
                self.climaMaxLabel.text = today["high"] as! String + "°"
                
                self.climaHumedadLabel.text = "Humedad " + (atmosphere["humidity"] as! String) + "%"
                
                self.climaVisibilidadLabel.text = "Visibilidad " + (atmosphere["visibility"] as! String) + "km"
                
                self.climaVientoLabel.text = "Viento " + (wind["speed"] as! String) + "km/h"
                
                let intDireccion = Int(wind["direction"] as? String ?? "0")!
                self.climaDireccionLabel.text = "Dirección " + self.getDireccion(intDireccion)
                

                UserDefaults.standard.setValue(self.climaActualLabel.text, forKey: kClimaActual)
                UserDefaults.standard.setValue(intCode, forKey: kClimaCode)
                UserDefaults.standard.setValue(self.climaMinLabel.text, forKey: kClimaMin)
                UserDefaults.standard.setValue(self.climaMaxLabel.text, forKey: kClimaMax)
                UserDefaults.standard.setValue(self.climaHumedadLabel.text, forKey: kClimaHumedad)
                UserDefaults.standard.setValue(self.climaVisibilidadLabel.text, forKey: kClimaVisibilidad)
                UserDefaults.standard.setValue(self.climaVientoLabel.text, forKey: kClimaViento)
                UserDefaults.standard.setValue(intDireccion, forKey: kClimaDireccion)
                
                UserDefaults.standard.setValue(hourString, forKey: kWeatherUpdate)
                
            })
            
        } else {
            
            let intCode = UserDefaults.standard.value(forKey: kClimaCode) as? Int ?? 0
            
            self.setEstado(intCode)
            
            climaActualLabel.text = UserDefaults.standard.string(forKey: kClimaActual)
            climaMinLabel.text = UserDefaults.standard.string(forKey: kClimaMin)
            climaMaxLabel.text = UserDefaults.standard.string(forKey: kClimaMax)
            climaHumedadLabel.text = UserDefaults.standard.string(forKey: kClimaHumedad)
            climaVisibilidadLabel.text = UserDefaults.standard.string(forKey: kClimaVisibilidad)
            climaVientoLabel.text = UserDefaults.standard.string(forKey: kClimaViento)
            
            let intDireccion = UserDefaults.standard.value(forKey: kClimaDireccion) as? Int ?? 0
            self.climaDireccionLabel.text = "Dirección " + self.getDireccion(intDireccion)

        }
    }

    func getDireccion(_ direccion: Int) -> String{
        var strResult = ""
        if(direccion>=337||direccion<22) { strResult = "E" }
        if(direccion>=22&&direccion<67) { strResult = "SE" }
        if(direccion>=67||direccion<112) { strResult = "S" }
        if(direccion>=112||direccion<157) { strResult = "SO" }
        if(direccion>=157||direccion<202) { strResult = "O" }
        if(direccion>=202||direccion<247) { strResult = "NO" }
        if(direccion>=247||direccion<292) { strResult = "N" }
        if(direccion>=292||direccion<337) { strResult = "NE" }
        imgCompass.transform = CGAffineTransform.identity
        imgCompass.transform = imgCompass.transform.rotated(by: CGFloat(Float(direccion) * Float.pi/Float(180)))
        return strResult + " " + String(direccion) + "°"
        
    }
    
    
    func setEstado(_ code: Int) {
        switch code {
        case 1:
            self.climaEstadoLabel.text = "Tormenta tropical"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 2:
            self.climaEstadoLabel.text = "Huracan"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 3:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 4:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 37:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 38:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 39:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 40:
            self.climaEstadoLabel.text = "Tormentas dispersas"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
            break;
        case 42:
            self.climaEstadoLabel.text = "Grados intermitentes"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 45:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        case 47:
            self.climaEstadoLabel.text = "Tormenta eléctrica"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_truenos")
        break;
    
        //lluvia
        case 6:
            self.climaEstadoLabel.text = "Lluvia y aguanieve"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 7:
            self.climaEstadoLabel.text = "Lluvia y aguanieve"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 8:
            self.climaEstadoLabel.text = "Llovizna congelante"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 9:
            self.climaEstadoLabel.text = "Llovizna"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 10:
            self.climaEstadoLabel.text = "Lluvia congelante"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 11:
            self.climaEstadoLabel.text = "Lluvia debil"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 12:
            self.climaEstadoLabel.text = "Lluvia debil"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 17:
            self.climaEstadoLabel.text = "Granizo"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 18:
            self.climaEstadoLabel.text = "Aguanieve"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        case 35:
            self.climaEstadoLabel.text = "Lluvia y granizo"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_lluvia")
        //muy nublado
        case 20:
            self.climaEstadoLabel.text = "Niebla"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 21:
            self.climaEstadoLabel.text = "Niebla"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 22:
            self.climaEstadoLabel.text = "Niebla"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 23:
            self.climaEstadoLabel.text = "Niebla"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 24:
            self.climaEstadoLabel.text = "Ventoso"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 25:
            self.climaEstadoLabel.text = "Frio"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 26:
            self.climaEstadoLabel.text = "Nublado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 27:
            self.climaEstadoLabel.text = "Nublado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        case 28:
            self.climaEstadoLabel.text = "Nublado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_muy_nublado")
        //nublado
        case 29:
            self.climaEstadoLabel.text = "Parcialmente nublado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_nublado")
        case 30:
            self.climaEstadoLabel.text = "Parcialmente nublado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_nublado")
        case 19:
            self.climaEstadoLabel.text = "Polvo"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_nublado")
        //claro
        case 31:
            self.climaEstadoLabel.text = "Claro"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_soleado")
        case 32:
            self.climaEstadoLabel.text = "Soleado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_soleado")
        case 33:
            self.climaEstadoLabel.text = "Despejado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_soleado")
        case 34:
            self.climaEstadoLabel.text = "Despejado"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_soleado")
        case 36:
            self.climaEstadoLabel.text = "Calor"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_soleado")
        //mieve
        case 46,13,14,15,16,43,5,41:
            self.climaEstadoLabel.text = "Nieve"
            self.imgClimaEstadoImageView.image = UIImage(named: "clima_nieve")
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "seguePDF" {
            let pdfVC = segue.destination as! PDFViewController
            pdfVC.pdfURL = sender as! String
        }
        
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageHeader")
        
        if let titleLabel = cell?.viewWithTag(100) as? UILabel {
            titleLabel.text = self.eventDayList[section].dateFromDayString?.longDayString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        cell.setMessageData(self.eventList[indexPath.section][indexPath.row])
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.eventList[indexPath.section][indexPath.row].mensaje_visto == 0 {
            self.eventList[indexPath.section][indexPath.row].mensaje_visto = 1
            _ = DBService.shared.mensajeDB.update(self.eventList[indexPath.section][indexPath.row])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.headerTop.constant += abs(scrollView.contentOffset.y)
            if self.headerTop.constant > 0 {
                self.headerTop.constant = 0
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.headerTop.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        } else if scrollView.contentOffset.y > 0 && self.headerTop.constant <= 0 {
            self.headerTop.constant -= scrollView.contentOffset.y/100
            if self.headerTop.constant < -self.headerGradient.bounds.height {
                self.headerTop.constant = -headerGradient.bounds.height
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.headerTop.constant = -self.headerGradient.bounds.height
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let photo = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.profileImageView.image = photo
                if let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.5) {
                    UserDefaults.standard.setValue(imageData, forKey: kUserPhoto)
                }
            }
        }
    }
}

extension MainViewController: MessageTableViewCellDelegate {
    
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

private extension MainViewController {
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


