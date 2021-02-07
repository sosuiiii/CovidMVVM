//
//  ChatViewController.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//
import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

class ChatViewController: MessagesViewController, MessagesDataSource, MessageCellDelegate,
                          MessagesLayoutDelegate, MessagesDisplayDelegate, StoryboardInstantiatable {
    
    struct Dependency {
        let viewModel: ChatViewModelType!
    }
    func inject(_ dependency: ChatViewController.Dependency) {
        viewModel = dependency.viewModel
    }
    var viewModel: ChatViewModelType!
    
    private var userId = ""
    private var firestoreData:[FirestoreData] = []
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Output
        let _ = viewModel.outputs.firestoreData
            .subscribe(onNext: { [weak self] data in
                guard let self = self else {return}
                self.firestoreData.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.messages = self.getMessages()
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            })
        
        //MARK: Input
        viewModel.inputs.setFirestoreData.onNext(Void())
        setView()
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            userId = uuid
            print(userId)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func backButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: MessagesViewController
    func currentSender() -> SenderType {
        return Sender(senderId: userId, displayName: "MyName")
    }
    func otherSender() -> SenderType {
        return Sender(senderId: "-1", displayName: "OtherName")
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        print(messages.count)
        return messages.count
    }
    //messagesにメッセージを代入するためにデータを整頓している
    func getMessages() -> [Message] {
        var messageArray:[Message] = []
        for i in 0..<firestoreData.count {
            messageArray.append(createMessage(text: firestoreData[i].text!, date: firestoreData[i].date!, firestoreData[i].senderId!))
        }
        messageArray.sort(by: {
            a, b -> Bool in
            return a.sentDate < b.sentDate
        })
        return messageArray
    }
    
    func createMessage(text: String, date: Date, _ senderId: String) -> Message {
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.white])
        let sender = (senderId == userId) ? currentSender() : otherSender()
        return Message(attributedText: attributedText, sender: sender as! Sender, messageId: UUID().uuidString, date: date)
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? Colors.blueGreen : Colors.redOrange
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
       let avatar: Avatar
        avatar = Avatar(image: UIImage(named: isFromCurrentSender(message: message) ? "me": "doctor"))
       avatarView.set(avatar: avatar)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.white])
                let message = Message(attributedText: attributedText, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messages.append(message)
                messagesCollectionView.insertSections([messages.count - 1])
                
                viewModel.inputs.sendFirestore.onNext(FirestoreData(date: Date(), senderId: userId, text: text, userName: userId))
            }
        }
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToLastItem()
    }
}

//MARK: ビュー
extension ChatViewController {
    
    func setView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.contentInset.top = 70
        
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        view.addSubview(uiView)
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = Colors.white
        label.text = "Doctor"
        label.frame = CGRect(x: 0 , y: 20, width: 100, height: 40)
        label.center.x = view.center.x
        label.textAlignment = .center
        uiView.addSubview(label)
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = Colors.white
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        uiView.addSubview(backButton)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        gradientLayer.colors = [Colors.bluePurple.cgColor,Colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        uiView.layer.insertSublayer(gradientLayer, at:0)
    }
    func setFirestore() {
    }
}
