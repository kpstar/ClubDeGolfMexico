//
//  ProfileViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Gradientable
import SkyFloatingLabelTextField
import MBProgressHUD
class ProfileViewController: CGMMainViewController {

    @IBOutlet var logoView: GradientableView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var updateButton: GradientableButton!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameText: SkyFloatingLabelTextField!
    @IBOutlet var fatherName: SkyFloatingLabelTextField!
    @IBOutlet var motherName: SkyFloatingLabelTextField!
    @IBOutlet var appNameText: SkyFloatingLabelTextField!
    @IBOutlet var emailText: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = UserDefaults.standard.string(forKey: kUserName)
        emailText.text = UserDefaults.standard.string(forKey: kUserEmail)
        appNameText.text = UserDefaults.standard.string(forKey: kamaterno)
        nameText.text = UserDefaults.standard.string(forKey: ktitulo)
        fatherName.text = UserDefaults.standard.string(forKey: knombre)
        motherName.text = UserDefaults.standard.string(forKey: kapaterno)
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        profileImageView.addGestureRecognizer(tapGesture)

        if let avatarData = UserDefaults.standard.value(forKey: kUserPhoto) as? Data {
            profileImageView.image = UIImage(data: avatarData)
        } else {
            profileImageView.image = UIImage(named: "noimage")
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        let params = [ UserDefaults.standard.string(forKey: "UserId") ?? "0",   nameText.text!, fatherName.text!, motherName.text!, appNameText.text!, emailText.text! ]
        MBProgressHUD.showAdded(to: self.view, animated: true).label.text = "Verificando..."
        WebService.shared.sendRequest(codigo: 120, data: params) { (isSuccess, errorMessage, resultData) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if isSuccess {
                if Int((resultData?[1] ?? "0")) == 1 {
                    UserDefaults.standard.set(resultData![2], forKey: ktitulo)
                    UserDefaults.standard.set(resultData![3], forKey: knombre)
                    UserDefaults.standard.set(resultData![4], forKey: kapaterno)
                    UserDefaults.standard.set(resultData![5], forKey: kamaterno)
                    UserDefaults.standard.set(resultData![6], forKey: kUserEmail)
                    UserDefaults.standard.set(resultData![2]+" "+resultData![4], forKey: kUserName)
                    return
                } else {
                    self.displayMyAlertMessage(titleMsg: "Error", alertMsg: resultData![2])
                }
            }
        }
    }
    
    private func displayMyAlertMessage( titleMsg: String, alertMsg: String) {
        let alertdialog = UIAlertController(title: titleMsg, message: alertMsg , preferredStyle: UIAlertControllerStyle.alert)
        alertdialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
        })
        self.present(alertdialog,animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let logoGradient = GradientableOptions(colors: [UIColor.primary, UIColor.colorAccent, UIColor.primary], locations: nil, direction: GradientableOptionsDirection.bottomRightToTopLeft)
        logoView.set(options: logoGradient)
        
        let updateButtonGradient = GradientableOptions(colors: [UIColor(red: 250/255.0, green: 227/255.0, blue: 209/255.0, alpha: 1), .colorAccent])
        updateButton.set(options: updateButtonGradient)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

