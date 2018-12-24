//  This is the View Controller which registers new users with Firebase

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    // IBOutlets are linked here:

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    var buttons: [UIButton] = []
    var avatar: String = "marth"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
        buttons.append(button5)
        buttons.append(button6)
        selectButton(buttonName: button1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        if (emailTextfield.text == "" || passwordTextfield.text == ""){
            return
        }
        SVProgressHUD.show()
        let childName = emailTextfield.text!.replacingOccurrences(of: ".", with: "")
        let usersDB = Database.database().reference().child("Users").child(childName)
        let usersDictionary = ["Email": emailTextfield.text!, "Avatar": avatar]
        usersDB.setValue(usersDictionary){
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("User created successfully!")
            }
        }
        
        //Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful!")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
    @IBAction func chooseAvatar(_ sender: UIButton) {
        let tagNum = sender.tag
        var button: UIButton?
        switch tagNum {
            case 0:
                button = button1
                avatar = "marth"
            case 1:
                button = button2
                avatar = "falcon"
            case 2:
                button = button3
                avatar = "chief"
            case 3:
                button = button4
                avatar = "arbiter"
            case 4:
                button = button5
                avatar = "master"
            case 5:
                button = button6
                avatar = "zealot"
            default:
                print("No button pressed")
        }
        selectButton(buttonName: button!)
    }
    
    func selectButton(buttonName: UIButton){
        for i in 0..<buttons.count {
            let button = buttons[i]
            button.layer.borderColor = .none
            button.layer.shadowColor = .none
            button.layer.borderWidth = 4
            button.layer.shadowOpacity = 0.8
            button.layer.shadowRadius = 12
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
        let c1YellowColor = UIColor(red:0.84, green:0.88, blue:0.00, alpha:1.0)
        buttonName.layer.borderColor = c1YellowColor.cgColor
        buttonName.layer.shadowColor = c1YellowColor.cgColor
    }
}
