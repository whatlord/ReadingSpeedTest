//
//  ViewController.swift
//  ReadingSpeedTest
//
//  Created by Andrew Jenkins on 11/22/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var paragraphs: Array<String> = []
    var paragraph: Array<String> = []
    var timer = Timer()
    var user = (UIApplication.shared.delegate as! AppDelegate).user
    var counter = (UIApplication.shared.delegate as! AppDelegate).startDelay
    
    
    @IBOutlet weak var word: UILabel!
    
    @IBOutlet weak var newUserView: UIView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var speed: UITextField!
    @IBOutlet weak var changeSpeed: UIStepper!
    
    
    @IBAction func changeSpeed(_ sender: UIStepper) {
        speed.text! = String(Int(changeSpeed.value))
        
    }
    
    @IBAction func typingSpeed(_ sender: UITextField) {
        if let num = Double(speed.text!){
            changeSpeed.value = num
        }
    }
    
    @IBAction func makeNewUser(_ sender: UIButton) {
        if let newUsername = newUsername.text{
            user = User(newUsername)
            username.text = "Username: " + user.username
            (UIApplication.shared.delegate as! AppDelegate).user = user
            newUserView.isHidden = true
            UserDefaults.standard.setValue(try? JSONEncoder().encode(user), forKey: "User")
            (UIApplication.shared.delegate as! AppDelegate).users.addUser(user)
            let users = (UIApplication.shared.delegate as! AppDelegate).users
            UserDefaults.standard.setValue(try? JSONEncoder().encode(users), forKey: "Users")
            
        }
    }
    
    
    @objc func changeWord(){
        if let nextWord = paragraph.first {
            let range = NSRange(location: Int(floor(Double((nextWord.count-1)/2))),length:1)
            let attributedString = NSMutableAttributedString(string: nextWord, attributes: [NSAttributedString.Key.font:UIFont(name: "Thonburi", size: 23.0)!])
             // here you change the character to red color
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: range)
             word.attributedText = attributedString
            paragraph.removeFirst()
        }else{
            timer.invalidate()
            word.text = ""
        }
        
    }
    
    @IBAction func start(_ sender: UIButton) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateCountDown), userInfo: nil, repeats: true)
        paragraph = paragraphs[Int.random(in: 1..<paragraphs.count)].components(separatedBy: " ")
        user.addTry(Int(speed.text!) ?? (UIApplication.shared.delegate as! AppDelegate).defSpeed)
        let users = (UIApplication.shared.delegate as! AppDelegate).users
        UserDefaults.standard.setValue(try? JSONEncoder().encode(users), forKey: "Users")
    }
    
    @objc func updateCountDown() {
        word.text = String(counter)
        counter-=1
        if(counter < 0){
            timer.invalidate()
            counter = (UIApplication.shared.delegate as! AppDelegate).startDelay
            timer = Timer.scheduledTimer(timeInterval: (60/(Double(speed.text!) ?? Double((UIApplication.shared.delegate as! AppDelegate).defSpeed))), target: self, selector: #selector(ViewController.changeWord), userInfo: nil, repeats: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        speed.resignFirstResponder()
        newUsername.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.object(forKey: "User") as? Data,
           let storedUser = try? JSONDecoder().decode(User.self, from: data) {
            (UIApplication.shared.delegate as! AppDelegate).user = storedUser
            user = storedUser
        }
        if let data = UserDefaults.standard.object(forKey: "Users") as? Data,
           let storedUsers = try? JSONDecoder().decode(UserDBModel.self, from: data) {
            (UIApplication.shared.delegate as! AppDelegate).users = storedUsers
        }
        self.speed.delegate = self
        self.newUsername.delegate = self
        if(user.username == "Temp"){
            newUserView.isHidden = false
        }
        username.text = "Username: " + user.username
        changeSpeed.value = Double((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        speed.text! = String((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        if let path = Bundle.main.path(forResource: "BundleParagraphs", ofType: "txt"){
            paragraphs = try! String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: "\n\n")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        user = (UIApplication.shared.delegate as! AppDelegate).user
        username.text = "Username: " + user.username
        changeSpeed.value = Double((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        speed.text! = String((UIApplication.shared.delegate as! AppDelegate).defSpeed)
        counter = (UIApplication.shared.delegate as! AppDelegate).startDelay
        timer.invalidate()
        word.text! = ""
    }
    


}

