//
//  DraggableInteger.swift
//  DragDrop
//
//  Created by Deveesh on 21/10/19.
//  Copyright © 2019 MindfireSolutions. All rights reserved.
//

import Foundation
import MobileCoreServices


/// This class's object can be dragged and dropped. It wraps an Integer data inside it
final class DraggableInteger: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading{
    var integerValue : Int?
    
    init(value val: Int) {
        self.integerValue = val
    }
    
    static var readableTypeIdentifiersForItemProvider: [String]{
        return [(kUTTypeData) as String]
    }
    
    static var writableTypeIdentifiersForItemProvider: [String]{
        return [(kUTTypeData) as String]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
           do {
               let encoder = JSONEncoder()
               encoder.outputFormatting = .prettyPrinted
               let data = try encoder.encode(self)
               progress.completedUnitCount = 100
               completionHandler(data, nil)
           } catch {
        
               completionHandler(nil, error)
           }
           return progress
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        do {
            let myJSON = try decoder.decode(DraggableInteger.self, from: data)
            return myJSON as! Self
        } catch {
            fatalError("Err")
        }
    }
}
