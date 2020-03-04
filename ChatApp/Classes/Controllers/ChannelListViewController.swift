//
//  ChannelListViewController.swift
//  ChatApp
//
//  Created by Sashika on 2/27/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChannelListViewController: UIViewController {
    
    static let collectionPath: String = "channels"
    
    private var channels: [Channel] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var channelRef: CollectionReference {
        return db.collection(ChannelListViewController.collectionPath)
    }
    
    deinit {
        listener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        listener = channelRef.addSnapshotListener({documentSnapshot, error in
            guard let document = documentSnapshot else {
                debugPrint("Error listening for chanel updates.")
                return
            }
            
            document.documentChanges.forEach({ [weak self] change in
                debugPrint("\(change.document), \(change.type.self)")
                
                self?.handleChange(change: change)
            })
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let index = self.tableView.indexPathForSelectedRow else {
            return
        }
        tableView.deselectRow(at: index, animated: true)
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
    
    private func handleChange(change: DocumentChange) {
        switch change.type {
        case .added:
            addChannel(channel: Channel(document: change.document))
        case .modified:
            modifyChannel(channel: Channel(document: change.document))
        case .removed:
            removeChannel(channel: Channel(document: change.document))
        }
    }
    
    private func addChannel(channel: Channel?) {
        guard let channel = channel else {
            return
        }
        
        if !channels.contains(channel) {
            channels.append(channel)
            tableView.insertRows(at: [IndexPath(row: channels.count - 1, section: 0)], with: .fade)
        }
    }
    
    // Signing out
    @IBAction func signout(_ sender: Any) {
        if AuthService.signout() {
            UserData.clearUserData()
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            delegate.show()
        }
    }
    
    private func modifyChannel(channel: Channel?) {
        
    }
    
    private func removeChannel(channel: Channel?) {

    }
    
    @IBAction func onAddChannelBtnTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Strings.NewChannelAlert.title, message: Strings.NewChannelAlert.message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: Strings.AlertActions.create, style: .default, handler: {[weak self] action in
            let channelName = alert.textFields?[0].text
            self?.createChannel(channelName: channelName)
        }))
        
        alert.addAction(UIAlertAction(title: Strings.AlertActions.cancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createChannel(channelName: String?) {
        guard let name = channelName, !name.isEmpty else {
            Alerts.showErrorAlert(message: Strings.Validations.emptyChannelName)
            return
        }
        
        debugPrint("Channel name: \(name)")
        var docRef: DocumentReference?
        docRef = channelRef.addDocument(data: Channel(name: name).representation) { error in
            if let error = error {
                debugPrint("Error adding document: \(error)")
                Alerts.showErrorAlert(message: Strings.Messages.errorCreatingChannel)
            } else {
                debugPrint("Document added with ID: \(docRef?.documentID)")
            }
        }
        
    }
    
}

extension ChannelListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("Cell #: \(ChannelTableViewCell.cellId())")
        let cell: ChannelTableViewCell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.cellId(), for: indexPath) as! ChannelTableViewCell

        cell.setData(channel: channels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController.instantiateFromAppStoryboard(appStoryBoard: .Chat)
        vc.channel = channels[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
