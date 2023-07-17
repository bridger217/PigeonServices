//
//  MemoryManager.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/12/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MemoryManager {
    static let shared = MemoryManager()
    private let db = Firestore.firestore()
    
    func getTodaysMemory(completion: @escaping (Memory?) -> Void) {
        db.collection("memories").whereField("status", isEqualTo: "current").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else if querySnapshot!.documents.count != 1 {
                completion(nil)
            } else {
                do {
                    var memory = try querySnapshot!.documents.first!.data(as: Memory.self)
                    memory.id = querySnapshot!.documents.first!.documentID
                    completion(memory)
                } catch let error as NSError {
                    print("Error parsing memory: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    func getPastMemories(completion: @escaping ([Memory]?) -> Void) {
        db.collection("memories").whereField("status", isEqualTo: "past").order(by: "seenDate").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                var memories: [Memory] = []
                for mem in querySnapshot!.documents {
                    do {
                        var memory = try mem.data(as: Memory.self)
                        memory.id = mem.documentID
                        memories.append(memory)
                    } catch let error as NSError {
                        print("Error parsing memory: \(error.localizedDescription)")
                        return completion(nil)
                    }
                }
                completion(memories)
            }
        }
    }
    
    func setMemorySeen(id: String, completion: @escaping (Bool) -> Void) {
        db.collection("memories").document(id).setData([
                "seen": true,
                "seenDate": Timestamp()
        ], merge: true) { err in
            if let err = err {
                print(err)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
