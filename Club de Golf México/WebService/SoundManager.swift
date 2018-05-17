//
//  SoundManager.swift
//  Easy Math
//
//  Created by admin on 5/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static let sharedInstance : SoundManager = {
        let instance = SoundManager()
        return instance
    }()
    
    
    fileprivate var audioPlayer : AVAudioPlayer!


    func playWith(file: String )
    {
        
        let path = Bundle.main.path(forResource: file, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            
            if audioPlayer != nil{
                
                audioPlayer.stop()
                
                audioPlayer = nil
                
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer.play()
            
        }catch{
            
        }
        
        
    }
    
    
}
