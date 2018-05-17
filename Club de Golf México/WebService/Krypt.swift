//
//  Krypt.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import CryptoSwift

class Krypt {
    
    static let shared = Krypt()
    
    private  let iv = "wep1a2t3r4y5c6k7";//Dummy iv (CHANGE IT!)
    private  let secretKey = "HR$2pIjHR$2pIj12";//Dummy secretKey (CHANGE IT!)
    
    func KR(_ text: String) -> String {
        
        do {
            
//            return try self.bytesToHex(self.encrypt(text.encodeUrl()))!
//            return try text.encodeUrl()!.padString().encrypt(cipher: AES(key: secretKey, iv: iv, padding: .zeroPadding))
            return try AES(key: secretKey, iv: iv, padding: .zeroPadding).encrypt(text.encodeUrl()!.padString().bytes).toHexString()
        } catch let error {
            
            return "ERROR: " + error.localizedDescription
            
        }
        
    }

    func DK(_ text: String)-> String {
        
        do {
            
            
            return try String(bytes: self.decrypt(text), encoding: String.Encoding.utf8) ?? ""
//                String(describing: AES(key: secretKey, iv: iv, padding: .zeroPadding).decrypt(text.bytes))
            
        } catch let error {
            
            return "ERROR: " + error.localizedDescription
            
        }
        
    }
    
    func encrypt(_ text: String?) throws -> [UInt8] {

        var encrypted: [UInt8]
        
        do {
            
            encrypted = try AES(key: secretKey, iv: iv, padding: .noPadding).encrypt(text!.padString().bytes)
            
        } catch let error {
            
            throw error
        }
//        try {
//
//        cipher.init(Cipher.ENCRYPT_MODE, keyspec, ivspec);
//
//        encrypted = cipher.doFinal(padString(text).getBytes());
//        } catch (Exception e)
//        {
//        throw new Exception("[encrypt] " + e.getMessage());
//        }
        
        return encrypted
    }
    
    func decrypt(_ text: String?) throws -> [UInt8] {

        var decrypted: [UInt8]

//        try {
//        cipher.init(Cipher.DECRYPT_MODE, keyspec, ivspec);
//
//        decrypted = cipher.doFinal(hexToBytes(code));
//        } catch (Exception e)
//        {
//        throw new Exception("[decrypt] " + e.getMessage());
//        }
        
        do {
            
            decrypted = try AES(key: secretKey, iv: iv, padding: .noPadding).decrypt(self.hexToBytes(text)!)
//            encrypted = try AES(key: secretKey, iv: iv, padding: .pkcs7).encrypt(text!.padString().bytes)
            
        } catch let error {
            
            throw error
        }
        
        return decrypted;
    }


    
    func bytesToHex(_ data: [UInt8]?) -> String?
    {
        if (data == nil) {
            return nil
        }
        
        var str = ""
        
        for c in data! {
            if ((c&0xFF)<16) {
                str = str + "0" + String(c&0xFF, radix: 16)
            } else {
                str = str + String(c&0xFF, radix: 16)
            }
        }
        return str
    }
    
    func hexToBytes(_ str: String?)->[UInt8]? {
        
        if (str == nil) {
            
            return nil
            
        } else if (str!.count < 2) {
            
            return nil
            
        } else {
            
            let len = Int(str!.count / 2)
            
            var buffer = [UInt8]()
            
            for i in 0..<len {
                
                let startIndex = str!.index(str!.startIndex, offsetBy: i*2)
                
                let endIndex = str!.index(startIndex, offsetBy: 2)
                
                let subStr = str![startIndex..<endIndex]

                buffer.append(UInt8(subStr, radix: 16)!)
                
            }
            
            return buffer;
        }
    }
    
     
}
