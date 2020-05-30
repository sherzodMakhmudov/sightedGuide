//
//  visualRecognitionViewController.swift
//  Lorem Ipsu
//
//  Created by Sherzod Makhmudov on 5/18/19.
//  Copyright © 2019 whomentors.com. All rights reserved.
//

import UIKit
import VisualRecognition
import AlamofireImage
import TextToSpeech
import AVFoundation

class visualRecognitionViewController: UIViewController {

    var previewImage:UIImage!
    let version = "2019-05-18"
    let apiKey = "XEcv5slSGqcQru8QLJAK4__a6DyufeImxXkah2pbfl5S"
    var imagge:UIImage?
    
    ///TextToSpeech
    var textToSpeechKey = "XEcv5slSGqcQru8QLJAK4__a6DyufeImxXkah2pbfl5S"
    var textToSpeech: TextToSpeech!
    var player: AVAudioPlayer?
    var voices: [String] = []
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var previewImageOutlet: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     previewImageOutlet.image = self.previewImage
     textToSpeech = TextToSpeech(apiKey: textToSpeechKey)

        
    }
    
    

    @IBAction func userBtnWasPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showUserTableView", sender: self)
    }
    
    
    
    @IBAction func getImage(_ sender: UIButton) {
        //let urll = URL(string:"https://source.unsplash.com/daily")
        // imageView.af_setImage(withURL: urll!)
       
       
        let vr = VisualRecognition(version: version, apiKey: apiKey)
        let scaledImage = scaleImageToSize(img: previewImage, size: CGSize(width: 100.0, height: 100.0))
        vr.classify(image: scaledImage) { (response, error) in
            if error == nil{
                print("printing response")
              
                let result = response?.result?.images.first
                if let accurateResult = result?.classifiers.first?.classes.first?.className{
                    DispatchQueue.main.async {
                        
                        self.titleName.text = accurateResult
                        
                    
                        self.textToSpeech.listVoices { (response, error) in
                            if let error = error {
                                print("converting text: ", error)
                                return
                            }
                            
                            guard let voices = response?.result?.voices else {
                                print("Failed to get voices")
                                return
                            }
                            
                            for voice in voices {
                                self.voices.append(voice.name)
                                self.textToSpeechFunc(text: self.titleName.text!, voice: voice.name)
                            }
                            
                        }

              
                    }
                    
                }else{
                    print("error")
                }
            }else{
                print(error!)
            }
        }
        // downloadImage(from: urll!)
        

        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func downloadImage(from url: URL){
        print("Download Started")
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
               self.imagge = UIImage(data: data)
                 let visualRecognition = VisualRecognition(version: self.version, apiKey: self.apiKey)
                visualRecognition.classify(image: self.imagge!) { (response, error) in
                    if error == nil{
                        print(response!)
                    }else{
                        print(error!)
                    }
                }
            }
        }
      
    }
    
    func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    

    func textToSpeechFunc(text: String, voice: String){
        
        
        
        textToSpeech.synthesize(text: text, voice: voice, accept: "audio/wav") { (response, error) in
            if let error = error {
                print(error)
            }
            
            guard let data = response?.result else {
                print("Failed to synthesize text")
                return
            }
            
            do {
                self.player = try AVAudioPlayer(data: data)
                self.player!.play()
            } catch {
                print("Failed to create audio player.")
            }
        }
    }
    
}


