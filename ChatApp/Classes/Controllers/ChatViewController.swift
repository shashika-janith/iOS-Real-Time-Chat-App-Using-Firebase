//
//  ViewController.swift
//  ChatApp
//
//  Created by Sashika on 2/27/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class ChatViewController: UIViewController {
    
    enum messageType {
        case text
        case image
    }
    
    var channel: Channel?
    static let collectionPath: String = "channels"
    static let collectionTitle: String = "thread"
    
    private var messages: [Message] = []
    
    private var db: Firestore  = Firestore.firestore()
    private var storageRef: StorageReference = Storage.storage().reference()
    
    private var reference: CollectionReference?
    private var listener: ListenerRegistration?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var containerTxtViewMessage: UIView!
    
    private var imagePicker: UIImagePickerController?
    
    private var imagePath: String?
    
    deinit {
        listener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        guard let id = channel?.id else {
            return
        }
        
        reference = db.collection([ChatViewController.collectionPath, id, ChatViewController.collectionTitle].joined(separator: "/"))
        
        listener = reference?.addSnapshotListener({documentSnapshot, error in
            guard let document = documentSnapshot else {
                debugPrint("Error listening for chanel updates.")
                return
            }
            
            document.documentChanges.forEach({ [weak self] change in
                self?.handleChange(change: change)
            })
        })
    }
    
    private func setupUI() {
        containerTxtViewMessage.roundCorners(cornerRadius: 15.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.title = channel?.name
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        listener?.remove()
//    }
    
    private func handleChange(change: DocumentChange) {
        switch change.type {
        case .added:
            insertMessage(message: Message(document: change.document))
        case .modified:
            updateMessage(message: Message(document: change.document))
        case .removed:
            deleteMessage(message: Message(document: change.document))
        }
    }
    
    private func insertMessage(message: Message?) {
        guard let message = message else {
            return
        }
        if !messages.contains(message) {
            messages.append(message)
            messages.sort()
//            tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .fade)
            tableView.reloadData()
        }
    }
    
    private func updateMessage(message: Message?) {
        guard let message = message else {
            return
        }
        
        guard let index = messages.firstIndex(of: message) else {
            return
        }
        messages[index] = message
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    private func deleteMessage(message: Message?) {
        guard let message = message else {
            return
        }
        
        guard let index = messages.firstIndex(of: message) else {
            return
        }
        messages.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        
        deleteMessage(message: message)
    }
    
    private func sendMessage(type: messageType, content: String) {
        let messageToSend: Message?
        
        guard
            let senderName = UserData.getUsername(value: UserData.key.username.rawValue),
            let senderID = UserData.getUserID(value: UserData.key.userID.rawValue) else {
            return
        }
        
        switch type {
        case .text:
            guard !(content.isEmpty) else {
                return
            }
            
            messageToSend = Message(message: content, senderID: senderID, senderName: senderName)
        case .image:
            messageToSend = Message(imageURL: content, senderID: senderID, senderName: senderName)
        }
        
        debugPrint("Message to be sent \(messageToSend!.representation)")
        
        var docRef: DocumentReference? = nil
        docRef = reference?.addDocument(data: messageToSend!.representation, completion: { error in
            if let error = error {
                debugPrint("Error adding document: \(error)")
                Alerts.showErrorAlert(message: Strings.Messages.errorCreatingChannel)
            } else {
                debugPrint("Document added with ID: \(docRef?.documentID ?? "")")
            }
        })
    }
    
    private func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let channelID = channel?.id else {
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let ref: StorageReference = storageRef.child(channelID)
        ref.putData(data, metadata: metadata) { [weak self] meta, error in
            if let error = error {
                debugPrint("Failed to upload the image \(error)")
            } else {
                ref.downloadURL(completion: {url, error in
                    if let url = url {
                        debugPrint("Image URL \(url)")
                        self?.sendMessage(type: .image, content: "\(url)")
                    } else {
                        debugPrint("Error \(error!)")
                    }
                })
                
            }
        }
    }
    
    // MARK: - take picture from gallery
    func takePicture() {
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.allowsEditing = false
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker!.sourceType = .camera
        } else {
            imagePicker!.sourceType = .photoLibrary
            imagePicker!.modalPresentationStyle = .fullScreen
        }
        
        present(alert, animated: true)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker!.sourceType = UIImagePickerController.SourceType.camera
            imagePicker!.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker!.allowsEditing = true
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func onSendBtnTapped(_ sender: UIButton) {
        guard !txtViewMessage.text.isEmpty else {
           return
        }
        
        sendMessage(type: .text, content: txtViewMessage.text)
        txtViewMessage.resignFirstResponder()
    }
    
    @IBAction func onImageBtnTapped(_ sender: UIButton) {
        takePicture()
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if message.senderID == UserData.getUserID(value: UserData.key.userID.rawValue)! {
            if message.content != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatSentTableViewCell.cellId(), for: indexPath) as! ChatSentTableViewCell
                cell.setData(message: message)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SentImageTableViewCell.cellId(), for: indexPath) as! SentImageTableViewCell
                cell.setData(message: message)
                return cell
            }
        } else {
            if message.content != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatReceivedTableViewCell.cellId(), for: indexPath) as! ChatReceivedTableViewCell
                cell.setData(message: messages[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedImageTableViewCell.cellId(), for: indexPath) as! ReceivedImageTableViewCell
                cell.setData(message: messages[indexPath.row])
                return cell
            }
        }
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
          print("Info did not have the required UIImage for the Original Image")
          dismiss(animated: true)
            
          return
        }
        
        dismiss(animated: true, completion: { [weak self] in
            self?.uploadImage(image: image,
                              completion: { url in
                 debugPrint("Image URL \(url)") }
            )
        })
    }
}
