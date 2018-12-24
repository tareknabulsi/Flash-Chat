import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    // Declare instance variables here
    var messageArray: [Message] = [Message]()
    
    // IBOutlets are linked here:
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set yourself as the delegate and datasource:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //Set yourself as the delegate of the text field:
        messageTextfield.delegate = self
        
        
        //Set the tapGesture:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //Register the MessageCell.xib file:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //Declare cellForRowAtIndexPath:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: messageArray[indexPath.row].avatar)
        cell.senderUsername.textColor = UIColor.cyan
        cell.avatarImageView.backgroundColor = UIColor.flatWhite()
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    
    //Declare numberOfRowsInSection:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //Declare tableViewTapped: Puts the keyboard down.
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //Declare configureTableView:
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    

    
    //Declare textFieldDidBeginEditing:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25){
            self.heightConstraint.constant = 350
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //Declare textFieldDidEndEditing:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true) //Put the keyboard down.
        
        //Send the message to Firebase and save it in our database.
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Message saved successfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }
    
    //Create the retrieveMessages method:
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            //Get Avatar from database
            let userDB = Database.database().reference().child("Users")
            let childName = sender.replacingOccurrences(of: ".", with: "")//Email path
            userDB.child(childName).observe(.value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                message.avatar = value?["Avatar"] as! String
                self.messageArray.append(message)
                self.configureTableView()
                self.messageTableView.reloadData()
            }
        })
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error, there was a problem signing out.")
        }
        
    }
    


}
