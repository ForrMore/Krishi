//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageBox: UIView!
    var lastPerson : String?
    let db = Firestore.firestore()
    
    var messages : [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadMessages()
        
        viewUpdate()
        
    }
    func viewUpdate(){
        messageBox.layer.borderColor = UIColor.white.cgColor
        messageBox.layer.borderWidth = 2
        messageBox.backgroundColor = UIColor.init(named: K.BrandColor.lightGreen)
        messageBox.layer.cornerRadius = messageBox.bounds.height/2
        messageView.layer.shadowOpacity = 0.3
        messageView.layer.shadowOffset.height = -8
        
    }
    
    func loadMessages()  {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener {(querySnapshot,error) in
                self.messages = []
                if let e = error{
                    print("there is an error loading the data ,\(e)")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String,let messageBody = data[K.FStore.bodyField] as? String,let name = data[K.FStore.name] as? String,let date = data[K.FStore.dateField] as? String{
                                let newMessage = Messages(sender: messageSender, body: messageBody, name: name, date: date)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = UserData().getUserDefaults("Mobile") as? String ,let name = UserData().getUserDefaults("UserName") as? String{
            db.collection(K.FStore.collectionName).addDocument(
                data:[K.FStore.senderField : messageSender,
                      K.FStore.bodyField : messageBody,
                      K.FStore.dateField : DateTimeManager().currentDateTime,
                      K.FStore.name : name
                ]){(error) in
                if error != nil{
                    print("data not saved")
                }else{
                    print("data saved")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
}

extension ChatViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        //here cell is set as an MessageCell has its identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.lebel.text  = message.body
        if lastPerson == message.name{
            cell.nameLabel.isHidden = true
        }else{
            cell.nameLabel.isHidden = false
            cell.nameLabel.text = message.name
            lastPerson = message.name
        }
        cell.dateTimeLabel.text = message.date
        cell.cellViewUpdate(by: message)
      
        return cell
    }
}


