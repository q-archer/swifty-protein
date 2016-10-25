//
//  AuthorizeViewController.swift
//  swift proteins
//
//  Created by Melvin MOUSTAID on 10/20/16.
//  Copyright © 2016 Melvin MOUSTAID. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthorizeViewController: UIViewController {

    let context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        var error:NSError?
        
        guard context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            logInButton.hidden = true
            return
        }
        
    }
    
    @IBAction func simpleLogInAction(sender: UIButton) {
        
        context.evaluatePolicy(.DeviceOwnerAuthentication, localizedReason: "We need your authentification") {
            (success, error) in
            
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("authorizeSegue", sender: nil)
                })
            } else {
                
                // Check if there is an error
                if let error = error {
                    
                    let message = self.errorMessageForLAErrorCode(error.code)
                    self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                    
                }
                
            }
            
        }

    }

    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func logInAction(sender: UIButton) {
        
        context.evaluatePolicy(.DeviceOwnerAuthentication, localizedReason: "We need your authentification") {
            (success, error) in
            
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("authorizeSegue", sender: nil)
                })
            } else {
                
                // Check if there is an error
                if let error = error {
                    
                    let message = self.errorMessageForLAErrorCode(error.code)
                    self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                    
                }
                
            }
            
        }

    }
    
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle("Error", message: message)
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.AppCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.AuthenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.InvalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.PasscodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.SystemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.TouchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.TouchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.UserCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.UserFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }

}
