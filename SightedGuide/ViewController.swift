//
//  ViewController.swift
//  SightedGuide
//
//  Created by Rauhmel Fox, CEO on 05/18/2019.
//  Copyright © 2019 WHOmentors.com, Inc. All rights reserved.
//

import UIKit
import Parse
import AWSMobileClient

class ViewController: UIViewController {
    
    var signupModeActive = true
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert(title:"Error in form", message:"Please enter username and password")
            
            
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive) {
                
                print("Signing up....")
                
                let user = PFUser()
               
                user.username = username.text
                user.password = password.text
//                user.email = email.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        
                        self.displayAlert(title:"Could not sign you up", message:error.localizedDescription)
                        
                        // let errorString = error.userInfo["error"] as? NSString
                        // Show the errorString somewhere and let the user try again.
                        
                        print(error)
                        
                    } else {
                        
                        print("signed up!")
                        
                        self.performSegue(withIdentifier: "showCamera", sender: self)
                        
                    }
                    
                })
                
            } else {
                
                PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        print("Login successful")
                        
                        self.performSegue(withIdentifier: "showCamera", sender: self)
                        
                    } else {
                        
                        var errorText = "Unknown error: please try again"
                        
                        if let error = error {
                            
                            errorText = error.localizedDescription
                            
                        }
                        
                        self.displayAlert(title:"Could not sign you up", message:errorText)
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    
    @IBAction func switchLoginMode(_ sender: Any) {
        
        if (signupModeActive) {
            
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            switchLoginModeButton.setTitle("Sign Up", for: [])
            
        } else {
            
            signupModeActive = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            switchLoginModeButton.setTitle("Log In", for: [])
            
        }
        
    }
    
    @IBOutlet weak var switchLoginModeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        AWSMobileClient.sharedInstance().initialize { (userState, error) in
//            if let userState = userState {
//                switch(userState){
//                case .signedIn:
//                    DispatchQueue.main.async {
////                        self.signInStateLabel.text = "Logged In"
//                        print("User is already logged in.")
//                    }
//                case .signedOut:
//                    AWSMobileClient.sharedInstance().showSignIn(navigationController: self.navigationController!, { (userState, error) in
//                        if(error == nil){       //Successful signin
//                            DispatchQueue.main.async {
////                                self.signInStateLabel.text = "Logged In"
//                                print("New user sign in.")
//                            }
//                        }
//                    })
//                default:
//                    AWSMobileClient.sharedInstance().signOut()
//                }
//
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
        // Do any additional setup after loading the view, typically from a nib.
        
//        let gameScore = PFObject(className:"GameScore")
//        gameScore["score"] = 1993
//        gameScore["playerName"] = "Rauhmel Fox"
//        gameScore["cheatMode"] = false
//        gameScore.saveInBackground { (success, error) in
//            if (success) {
//                
//                print("Success!")
//                
//            } else {
//                
//                print("Failed")
//                
//            }
//        }
        
        // Twitter clone - Create a retrieve a tweet (any text you like!)
        

//         let tweet = PFObject(className: "Tweet")
//
//         tweet["content"] = "Good morning, Mister Fox!"
//
//         tweet.saveInBackground { (success, error) in
//              if (success) {
//                  print("Success!")
//              } else {
//                  print("Failed")
//              }
//         }
 
        
        let query = PFQuery(className: "Tweet")

        query.getObjectInBackground(withId: "PgQ0J1GktD") { (object, error) in

            if let tweet = object {

                print(tweet)

            } else {

                print("Retrieve failed")

            }

        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "showCamera", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

