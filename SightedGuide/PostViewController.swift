//
//  PostViewController.swift
//  SightedGuide
//
//  Created by Rauhmel Fox, CEO on 05/18/2019.
//  Copyright © 2019 WHOmentors.com, Inc. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var comment: UITextField!
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
        if let image = info[.originalImage] as? UIImage {
            self.imageToPost.contentMode = .scaleAspectFit
            imageToPost.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postImage(_ sender: Any) {
        
        if let image = imageToPost.image {
        
            let post = PFObject(className: "Post")
        
            post["message"] = comment.text
        
            post["userid"] = PFUser.current()?.objectId
        
            if let imageData = image.pngData() {
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activityIndicator.center = self.view.center
                
                activityIndicator.hidesWhenStopped = true
                
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                
                post["imageFile"] = imageFile
                
                post.saveInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if success {
                        
                        self.displayAlert(title: "Image Posted!", message: "Your image has been posted successfully")
                        
                        self.comment.text = ""
                        
                        self.imageToPost.image = nil
                        
                    } else {
                        
                        self.displayAlert(title: "Image Could Not Be Posted", message: "Please try again later")
                        
                    }
                    
                })
                
            }
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
