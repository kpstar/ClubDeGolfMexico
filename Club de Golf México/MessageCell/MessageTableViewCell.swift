//
//  MessageTableViewCell.swift
//  Club de Golf México
//
//  Created by admin on 2/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol MessageTableViewCellDelegate: class {
    func didSelectedMessageCell(_ message: MensajeType)
}

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var messageContainer: UIView!
    @IBOutlet var areaImageView: UIImageView!
    @IBOutlet var areaBackImageView: UIImageView!
    @IBOutlet var bottomBackImageView: UIImageView!
    @IBOutlet var leftBackImageView: UIImageView!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var messageBodyLabel: UILabel!
    
    @IBOutlet var typeImageView: UIImageView!
    
    weak var delegate: MessageTableViewCellDelegate?

    var messageData: MensajeType!;
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.messageBodyLabel.addGestureRecognizer(tapGesture)
        
        let tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedIcon(_:)))
        self.typeImageView.addGestureRecognizer(tapIconGesture)

        
    }

    @objc func tappedIcon(_ sender: UITapGestureRecognizer) {
        if self.messageData.mensaje_tipo_eid != 89 {
            return
        }
        self.delegate?.didSelectedMessageCell(self.messageData)
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.didSelectedMessageCell(self.messageData)
    }

    func setMessageData(_ message: MensajeType) {
        
        self.messageData = message
        
        setAreaType(message.mensaje_area_eid)
        
        setMessageType(message.mensaje_tipo_eid)
        
        if message.mensaje_fecha_limite != "" {
            timeLabel.text = message.mensaje_fecha_limite.dateFromISO8601?.timeString
        } else {
            timeLabel.text = message.mensaje_fecha_enviado.dateFromISO8601?.timeString
        }
        
        if self.messageData.mensaje_tipo_eid == 76 {
            self.checkMessageVideo()
        } else {
            if self.messageData.mensaje_image.count > 0 && message.mensaje_tipo_eid != 89 {
                self.checkMessageImage()
                
            } else {
                self.setMessageWithString()
            }
        }
        
        
        
    }
    
    private func setMessageWithString() {
        
        let mutableAttributedString = NSMutableAttributedString()
        let titleAttributedString = NSAttributedString(string: self.messageData.mensaje_titulo, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedStringKey.foregroundColor: UIColor.colorPrimaryDark])
        
        mutableAttributedString.append(titleAttributedString)
        mutableAttributedString.append(NSAttributedString(string: "\n"))
        
        
        let messageAttributedString = NSAttributedString(string: self.messageData.mensaje_contenido, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor.black])
        
        mutableAttributedString.append(messageAttributedString)
        
        self.messageBodyLabel.attributedText = mutableAttributedString
        
    }
    private func checkMessageImage() {
        let imageURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (self.messageData.mensaje_fecha_enviado.dateFromISO8601?.yearMonthPath)! + "/" + self.messageData.mensaje_image
        self.checkMessageImage(imageURL: imageURL)
    }
    
    private func checkMessageVideo() {
        let imageURL = "https://img.youtube.com/vi/\(self.messageData.mensaje_link)/default.jpg"
        self.checkMessageImage(imageURL: imageURL)
        
    }

    private func checkMessageImage(imageURL: String) {
        
        let urlRequest = URLRequest(url: URL(string: imageURL)!)
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        let imageCache = imageDownloader.imageCache
        
        // Use the image from the image cache if it exists
        if let image = imageCache?.image(for: urlRequest, withIdentifier: nil) {
            
            self.setMessageWithImage(image: image)
            
        } else {
            
            self.setMessageWithImage(image: UIImage.placeHolder!)

            imageDownloader.download(urlRequest, completion: { (response) in
                
                if let image = response.result.value {
                    
                    imageCache?.add(image, for: urlRequest, withIdentifier: nil)
                    
                    DispatchQueue.main.async {
                        if let tableView = self.superview as? UITableView {
                            tableView.reloadData()
                        }
                    }

                }
            })
            
        }
        
    }
    
    private func setMessageWithImage(image: UIImage) {
        
        let mutableAttributedString = NSMutableAttributedString()
        let titleAttributedString = NSAttributedString(string: self.messageData.mensaje_titulo, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedStringKey.foregroundColor: UIColor.colorPrimaryDark])
        
        mutableAttributedString.append(titleAttributedString)
        mutableAttributedString.append(NSAttributedString(string: "\n"))
        
        let imageAttachment = NSTextAttachment.init()
        
        if self.messageData.mensaje_tipo_eid == 76 {
            imageAttachment.image = image.resize(withWidth: self.messageContainer.bounds.width-60)?.addedYoutubeButton()
        } else {
            imageAttachment.image = image.resize(withWidth: self.messageContainer.bounds.width-60)
        }
        
        let imageAttributedString = NSAttributedString.init(attachment: imageAttachment)
        
        mutableAttributedString.append(imageAttributedString)
        
        mutableAttributedString.append(NSAttributedString(string: "\n"))
        
        let messageAttributedString = NSAttributedString(string: self.messageData.mensaje_contenido, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor.black])
        
        mutableAttributedString.append(messageAttributedString)
        
        self.messageBodyLabel.attributedText = mutableAttributedString
    }
    
    
    private func setAreaType(_ areaType: Int) {
        
        self.leftBackImageView.isHidden = true
        self.bottomBackImageView.isHidden = true
        self.leftBackImageView.backgroundColor = UIColor(patternImage: UIImage(named: "small_pared")!.resize(withWidth: 40)!)
        
        switch areaType {
        case 65: // Golf
            areaImageView.image = UIImage(named: "tab-golf")
            areaBackImageView.image = UIImage(named: "small_golf")
            messageContainer.backgroundColor = UIColor.colorGolf
            
        case 70:  // Golf Alert
            areaImageView.image = UIImage(named: "icon_golfalert")
            areaBackImageView.image = UIImage(named: "small_golf_alert")
            messageContainer.backgroundColor = UIColor.colorGolfAlert

        case 66: // Finanzas
            areaImageView.image = UIImage(named: "tab-finance")
            areaBackImageView.image = UIImage(named: "small_finanzas")
            messageContainer.backgroundColor = UIColor.colorFinanzas

            break;
        case 67: // Restaurante
            areaImageView.image = UIImage(named: "tab-restraunt")
            areaBackImageView.image = UIImage(named: "small_restaurante")
            messageContainer.backgroundColor = UIColor.colorRestaurante

            break;
        case 68: // Galeria
            areaImageView.image = UIImage(named: "tab-gallery")
            areaBackImageView.image = UIImage(named: "small_galeria")
            messageContainer.backgroundColor = UIColor.colorGaleria
            self.bottomBackImageView.backgroundColor = UIColor(patternImage: UIImage(named: "small_piso")!.resize(withHeight: 23)!)
            self.leftBackImageView.isHidden = false
            self.bottomBackImageView.isHidden = false

            break;
        case 69: // Mensajes
            areaImageView.image = UIImage(named: "tab-message")
            areaBackImageView.image = UIImage(named: "small_mensajes")
            messageContainer.backgroundColor = UIColor.colorMensajes
            self.bottomBackImageView.backgroundColor = UIColor(patternImage: UIImage(named: "small_pasto")!.resize(withHeight: 23)!)
            self.bottomBackImageView.isHidden = false

            break;
        default:
            break
        }
    }
    
    private func setMessageType(_ type: Int) {
        typeImageView.isHidden = false
        switch type {
        case 73:
            typeImageView.isHidden = true
        case 74:
            typeImageView.image = UIImage(named: "type-camera")
        case 75:
            typeImageView.image = UIImage(named: "type-external-link")
        case 76:
            typeImageView.image = UIImage(named: "type-youtube")
        case 89:
            typeImageView.image = UIImage(named: "type-pdf")
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
