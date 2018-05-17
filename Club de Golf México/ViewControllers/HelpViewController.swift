//
//  HelpViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import M13Checkbox
import Gradientable
import KYDrawerController
import Firebase
import MBProgressHUD

class HelpViewController: UIViewController {
    
    @IBOutlet var userNameText: SkyFloatingLabelTextField!
    @IBOutlet var userPasswordText: SkyFloatingLabelTextField!
    @IBOutlet var acceptCheckBox: M13Checkbox!
    @IBOutlet var loginButton: GradientableButton!
    
    @IBOutlet var errorView: GradientableView!
    @IBOutlet var errorViewHeight: NSLayoutConstraint!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        errorViewHeight.constant = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let loginButtonGradient = GradientableOptions(colors: [UIColor(red: 250/255.0, green: 227/255.0, blue: 209/255.0, alpha: 1), .colorAccent])
        loginButton.set(options: loginButtonGradient)
        
        let errorViewGradient = GradientableOptions(colors: [UIColor(red: 239/255.0, green: 83/255.0, blue: 80/255.0, alpha: 1), UIColor(red: 255/255.0, green: 134/255.0, blue: 124/255.0, alpha: 1), UIColor(red: 239/255.0, green: 83/255.0, blue: 80/255.0, alpha: 1)], locations: nil, direction: GradientableOptionsDirection.bottomLeftToTopRight)
        errorView.set(options: errorViewGradient)
                
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Club de Golf México"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorMessage(_ errorString: String) {
        
        errorLabel.text = errorString
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.errorViewHeight.constant = 60
            self.view.layoutIfNeeded()
            
        }, completion: { (_) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.errorViewHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
                
            })
            
        })
    }
    
    @IBAction func togglePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.userPasswordText.isSecureTextEntry = false
        } else {
            self.userPasswordText.isSecureTextEntry = true
        }
    }

    
    
    @IBAction func acceptButtonClick(_ sender: Any) {
        if self.acceptCheckBox.checkState == .checked {
            self.acceptCheckBox.setCheckState(.unchecked, animated: true)
        } else {
            self.acceptCheckBox.setCheckState(.checked, animated: true)
        }
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        
        var errorMessage = ""
        
        if acceptCheckBox.checkState != .checked {
            errorMessage = "Debe aceptar los términos y condiciones."
        }
        
        if userPasswordText.text == "" {
            errorMessage = "Debe colocar su contraseña."
        }
        
        if userNameText.text == "" {
            errorMessage = "Debe colocar su número de acción."
        }
        
        if errorMessage != "" {
            
            showErrorMessage(errorMessage)
            
            return
        }
        
        let params = [userNameText.text!, userPasswordText.text!, Messaging.messaging().fcmToken ?? ""]
        MBProgressHUD.showAdded(to: self.view, animated: true).label.text = "Verificando..."
        
        WebService.shared.sendRequest(codigo: 100, data: params) { (isSuccess, errorMessage, resultData) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if isSuccess {
                
                if Int((resultData?[1] ?? "0")) == 1 {
                    
                    DBService.shared.socioDB.truncate()
                    
                    let socio = SocioType(socio_id: Int(resultData?[2] ?? "0")!, socio_nombre: resultData?[3] ?? "", socio_nombre_app: resultData?[4] ?? "", socio_accion_num: resultData?[5] ?? "", socio_nacimiento: resultData?[6] ?? "", socio_correo: resultData?[7] ?? "", socio_facebook: resultData?[8] ?? "", socio_imagen: resultData?[9] ?? "")
                    
                    if DBService.shared.socioDB.insert(socio) {
                        
                        UserDefaults.standard.set(socio.socio_id, forKey: kUserID)
                        UserDefaults.standard.set(socio.socio_nombre, forKey: kUserName)
                        UserDefaults.standard.set(socio.socio_nombre_app, forKey: kUserApp)
                        UserDefaults.standard.set(socio.socio_correo, forKey: kUserEmail)
                        UserDefaults.standard.set(socio.socio_accion_num, forKey: kUserAccion)
                        
                        if socio.socio_accion_num.contains("-") {
                            UserDefaults.standard.set(true, forKey: kUserFamiliar)
                        } else {
                            UserDefaults.standard.set(false, forKey: kUserFamiliar)
                        }
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let drawerVC = storyboard.instantiateViewController(withIdentifier: "drawerNav") as! UINavigationController
                        appDelegate.window?.rootViewController = drawerVC
                        
                        
                    } else {
                        
                        self.showErrorMessage("ERROR al registrar los datos.")
                        UserDefaults.standard.set(0, forKey: kUserID)
                        UserDefaults.standard.set("SIN USUARIO", forKey: kUserName)
                        UserDefaults.standard.set("SIN USUARIO", forKey: kUserApp)
                        UserDefaults.standard.set("noimage.jpg", forKey: kUserImage)
                        UserDefaults.standard.set(false, forKey: kPaths)
                    }
                    
                } else {
                    self.showErrorMessage(resultData?[2] ?? "" )
                }
                
                
            } else {
                
                self.showErrorMessage(errorMessage ?? "")
                
            }
            
        }
        
        //    strMensaje = "No hay conexión a internet, se requiere para registrar el teléfono.";
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
