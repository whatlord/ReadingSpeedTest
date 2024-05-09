//
//  SettingsViewController.swift
//  ReadingSpeedTest
//
//  Created by Andrew Jenkins on 11/22/22.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var user = (UIApplication.shared.delegate as! AppDelegate).user
    var users = (UIApplication.shared.delegate as! AppDelegate).users

    @IBOutlet weak var CurrentUser: UITextField!
    @IBOutlet weak var DefaultSpeed: UITextField!
    @IBOutlet weak var StartDelay: UITextField!
    @IBOutlet weak var changeSpeed: UIStepper!
    @IBOutlet weak var changeDelay: UIStepper!
    @IBOutlet weak var message: UILabel!
    
    
    @IBAction func changeSpeed(_ sender: UIStepper) {
        DefaultSpeed.text! = String(Int(changeSpeed.value))
    }
    @IBAction func changeDelay(_ sender: UIStepper) {
        StartDelay.text! = String(Int(changeDelay.value))
    }
    @IBAction func typingSpeed(_ sender: UITextField) {
        if let num = Double(DefaultSpeed.text!){
            changeSpeed.value = num
        }
    }
    
    @IBAction func typingDelay(_ sender: UITextField) {
        if let num = Double(StartDelay.text!){
            changeDelay.value = num
        }
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        if(CurrentUser.text != user.username){
            if let nextUser = users.users.first(where: {$0.username == CurrentUser.text}){
                user = nextUser
                
            }else{
                let newUser = User(CurrentUser.text!)
                users.addUser(newUser)
                user = newUser
            }
            UserDefaults.standard.setValue(user.username, forKey: "username")
        }
        (UIApplication.shared.delegate as! AppDelegate).user = user
        (UIApplication.shared.delegate as! AppDelegate).users = users
        (UIApplication.shared.delegate as! AppDelegate).defSpeed = Int(changeSpeed.value)
        (UIApplication.shared.delegate as! AppDelegate).startDelay = Int(changeDelay.value)
        
        UserDefaults.standard.setValue(try? JSONEncoder().encode(user), forKey: "User")
        UserDefaults.standard.setValue(try? JSONEncoder().encode(users), forKey: "Users")
        UserDefaults.standard.setValue(Int(changeSpeed.value), forKey: "defSpeed")
        UserDefaults.standard.setValue(Int(changeDelay.value), forKey: "startDelay")
        
        message.text = "You successfully saved the settings."
        message.isHidden = false
        
    }
    
    @IBAction func clearSavedData(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "User")
        UserDefaults.standard.removeObject(forKey: "Users")
        UserDefaults.standard.setValue(60, forKey: "defSpeed")
        UserDefaults.standard.setValue(3, forKey: "startDelay")

        UserDefaults.standard.synchronize()
        
        (UIApplication.shared.delegate as! AppDelegate).user = User("Temp")
        (UIApplication.shared.delegate as! AppDelegate).users = UserDBModel()
        (UIApplication.shared.delegate as! AppDelegate).defSpeed = 60
        (UIApplication.shared.delegate as! AppDelegate).startDelay = 3
        message.text = "You successfully cleared the data."
        message.isHidden = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CurrentUser.resignFirstResponder()
        DefaultSpeed.resignFirstResponder()
        StartDelay.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DefaultSpeed.text! = String((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        StartDelay.text! = String((UIApplication.shared.delegate as! AppDelegate).startDelay)
        changeSpeed.value = Double((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        changeDelay.value = Double((UIApplication.shared.delegate as! AppDelegate).startDelay)
        CurrentUser.text! = user.username
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        message.isHidden = true
        users = (UIApplication.shared.delegate as! AppDelegate).users
        user = (UIApplication.shared.delegate as! AppDelegate).user
        DefaultSpeed.text! = String((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        StartDelay.text! = String((UIApplication.shared.delegate as! AppDelegate).startDelay)
        changeSpeed.value = Double((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        changeDelay.value = Double((UIApplication.shared.delegate as! AppDelegate).startDelay)
        CurrentUser.text! = user.username
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
