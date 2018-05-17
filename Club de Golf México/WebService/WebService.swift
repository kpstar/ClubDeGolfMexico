//
//  WebService.swift
//  Club de Golf México
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Alamofire

class WebService {
    
    static let shared = WebService()
    
    let separador = "■"

    let serverURL =  "http://golf.websgroup.org/"
    
    let serverPath = "views/common/remote/request.php?"
    
    let serverFiles = "views/files/"
    
    var urlPath: String {
        return serverURL + serverPath
        
    }
    
    let weatherURL="https://query.yahooapis.com/v1/public/yql?q=select+%2A+from+weather.forecast+where+woeid+%3D+24553281+and+u%3D%27c%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
    
    func requestAdd(_ strData: String) -> String {
        return strData + separador;
    }
    
    private func makeRequest(codigo: Int, data: [String])-> String {
        
        var strRequestKR = ""
        var strRequest = ""
        
        strRequest = requestAdd(String(codigo))
        
        for str in data {
            strRequest += requestAdd(str)
        }
        
        
        
        strRequestKR = Krypt.shared.KR(strRequest)
        
        let randRequest = arc4random_uniform(99999 - 10000) + 10000
        
        let randRequest2 = Date().timeIntervalSince1970 * 1000

        
        strRequestKR += "&r=" + String(randRequest2) + String(randRequest)
        
        strRequestKR = serverURL + serverPath + "d=" + strRequestKR
        
        return strRequestKR
        
    }
    
    func sendRequest(codigo: Int, data: [String], completion: @escaping (_ isSuccess: Bool, _ errorMessage: String?, _ resultData: [String]?) -> Void) {
        
        let requestURL = self.makeRequest(codigo: codigo, data: data)
        print(requestURL);
        Alamofire.request(requestURL).responseString { (response) in
            
            if let responseString = response.result.value {
                
                let strRequestKR = responseString.trimmingCharacters(in: .whitespacesAndNewlines)
                var strRequest = Krypt.shared.DK(strRequestKR);
                
                strRequest =  strRequest.decodeUrl()!
                
                if strRequest.hasPrefix(self.requestAdd(String(codigo))) {
                
                    let responseData = strRequest.components(separatedBy: self.separador)
                    
                    completion(true, nil, responseData)
                    
                } else {
                    completion(false, strRequest, nil)
                }
                
            } else {
                completion(false, "Error de enlace a internet, intente nuevamente", nil)
            }
        }
        
    }
    
    func getWeather(completion: @escaping (_ isSuccess: Bool, _ errorMessage: String?, _ resultData: [String: Any]?) -> Void) {
        
        Alamofire.request(self.weatherURL).responseString { (response) in
            
            if let responseString = response.result.value {
                
                if responseString.hasPrefix("{\"query\"") {
                    
                    do {
                        
                        guard let json = try JSONSerialization.jsonObject(with: responseString.data(using: String.Encoding.utf8)!, options: []) as? [String: Any] else {
                            
                            return completion(false, "Error", nil)
                            
                        }

                        completion(true, nil, json)
                        
                    } catch let error {
                        
                        completion(false, error.localizedDescription, nil)
                        
                    }
                    
                } else {
                    completion(false, responseString, nil)
                }
                
            } else {
                completion(false, "Error de enlace a internet, se intentara mas tarde", nil)
            }

            
        }
    }
    
}
