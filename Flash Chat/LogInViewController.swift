//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    // IBOutlets are linked here:
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        
        //Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!){
            (user, error) in
            
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Login Failed",
                                              message:"The email and/or password is invalid",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                print("Log in successful!")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
    


    
}  
