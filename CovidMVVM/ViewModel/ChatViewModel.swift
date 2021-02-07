//
//  ChatViewModel.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa
import Charts
import FirebaseFirestore

protocol ChatViewModelInput {
    var sendFirestore: AnyObserver<FirestoreData> {get}
    var setFirestoreData: AnyObserver<Void> {get}
}

protocol ChatViewModelOutPut {
    var firestoreData: Observable<[FirestoreData]>{get}
}

protocol ChatViewModelType {
    var inputs: ChatViewModelInput {get}
    var outputs: ChatViewModelOutPut {get}
}

class ChatViewModel: ChatViewModelInput, ChatViewModelOutPut {
    
    //MARK: Input
    var sendFirestore: AnyObserver<FirestoreData>
    var setFirestoreData: AnyObserver<Void>
    //MARK: Output
    var firestoreData: Observable<[FirestoreData]>
    
    init() {
        
        let _firestoreData = PublishRelay<[FirestoreData]>()
        self.firestoreData = _firestoreData.asObservable()
        
        self.sendFirestore = AnyObserver<FirestoreData>() { data in
            guard let data = data.element else {return}
            Firestore.firestore().collection("Messages").document().setData([
                "date": data.date!,
                "senderId": data.senderId!,
                "text": data.text!,
                "userName": data.userName!
            ],merge: false) { err in
                if let err = err {
                    print(err)
                }
            }
        }
        
        self.setFirestoreData = AnyObserver<Void>() { _ in
            Firestore.firestore().collection("Messages").getDocuments(completion: {
                (document, error) in
                if error != nil {
                    print("ChatViewController:Line(\(#line)):error:\(error!)")
                } else {
                    if let document = document {
                        var data:[FirestoreData] = []
                        for i in 0..<document.count {
                            var storeData = FirestoreData()
                            storeData.date = (document.documents[i].get("date")! as! Timestamp).dateValue()
                            storeData.senderId = document.documents[i].get("senderId")! as? String
                            storeData.text = document.documents[i].get("text")! as? String
                            storeData.userName = document.documents[i].get("userName")! as? String
                            data.append(storeData)
                        }
                        _firestoreData.accept(data)
                    }
                }
            })
        }
        
    }
}

extension ChatViewModel: ChatViewModelType {
    var inputs: ChatViewModelInput {return self}
    var outputs: ChatViewModelOutPut {return self}
}
