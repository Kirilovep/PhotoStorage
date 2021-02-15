//
//  SceneDelegate.swift
//  DZ12-TableView
//
//  Created by shizo on 18.01.2021.
//

import UIKit
import KeychainSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var password: String?
    let keychain = KeychainSwift()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
  
    
    func showNotCorrectAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if title == "Wrong password!" {
                self.correctAlert()
            } else {
                self.addAlert()
            }
           
        }
        alert.addAction(okAction)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func getPassword() {
        let newPassword = keychain.get("password")
        
        password = newPassword
    }

    func savePassword(_ password: String) {
        keychain.set(password, forKey: "password")
    }
    
    func correctAlert() {
        let alert = UIAlertController(title: "Enter your password", message: "", preferredStyle: .alert)
        alert.addTextField { (passwordTextField) in
            passwordTextField.font = .systemFont(ofSize: 17)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                guard let textField = passwordTextField.text else { return }
                if textField == self.password {
                } else {
                    self.showNotCorrectAlert("Wrong password!")
                }
            }
            alert.addAction(okAction)
        }
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func addAlert() {
        let alert = UIAlertController(title: "Add new password", message: "", preferredStyle: .alert)
        alert.addTextField { (passwordTextField) in
            passwordTextField.font = .systemFont(ofSize: 17)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                guard let textField = passwordTextField.text else { return }
                if (passwordTextField.text!.isEmpty)  {
                    self.showNotCorrectAlert("password is empty")
                } else {
                    self.savePassword(textField)
                }
            }
            alert.addAction(okAction)
        }
        window?.rootViewController?.present(alert, animated: true, completion: nil)
       
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        //UserDefaults.standard.removeObject(forKey: "password")
        getPassword()
        if password == nil {
            addAlert()
        } else {
            correctAlert()
        }
        
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

