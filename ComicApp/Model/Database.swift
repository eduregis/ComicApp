//
//  Database.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 14/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

enum StatusType {
    case wantToRead
    case reading
    case read
}

class Database {
    
    var wantToRead: URL
    var reading: URL
    var read: URL
    
    var emptyArray = [Comic]()
    
    //Singleton: Access by using Database.shared.<function-name>
    static let shared = Database()
    
    private init() {
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let wantToReadFileName = "wantToRead.json"
        let readingFileName = "reading.json"
        let readFileName = "read.json"

        wantToRead = documentsFolder.appendingPathComponent(wantToReadFileName)
        reading = documentsFolder.appendingPathComponent(readingFileName)
        read = documentsFolder.appendingPathComponent(readFileName)
        
        //Caso os arquivos não existam, eles são criados no init
        if !(FileManager.default.fileExists(atPath: wantToRead.path)) {
            saveData(from: emptyArray, to: .wantToRead)
        }
        if !(FileManager.default.fileExists(atPath: reading.path)) {
            saveData(from: emptyArray, to: .reading)
        }
        if !(FileManager.default.fileExists(atPath: reading.path)) {
            saveData(from: emptyArray, to: .read)
        }
    }
    
    func loadData(from list: StatusType) -> [Comic]? {
        
        var type: URL
        var loadedArray: [Comic] = []
        
        switch list {
        case .wantToRead:
            type = wantToRead
        case .reading:
            type = reading
        case .read:
            type = read
        }
    
        do {
            let file = try Data(contentsOf: type)
            loadedArray = try JSONDecoder().decode([Comic].self, from: file)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return loadedArray
    }
    
    @discardableResult func saveData(from array: [Comic], to list: StatusType) -> Bool {
        
        var type: URL
        
        switch list {
        case .wantToRead:
            type = wantToRead
        case .reading:
            type = reading
        case .read:
            type = read
        }
        
        do {
            let jsonData = try JSONEncoder().encode(array)
            try jsonData.write(to: type)
        } catch {
            print("Impossível escrever no arquivo.")
            return false
        }
        return true
    }
    
    @discardableResult func deleteData(from list: StatusType, at index: Int) -> Comic? {

        guard var loadedArray = loadData(from: list) else {
            return nil
        }
        let removedElement = loadedArray.remove(at: index)
        saveData(from: loadedArray, to: list)
        
        return removedElement
        
    }
    
    @discardableResult func deleteAllListComics(from list: StatusType) -> Bool {
        
        guard var loadedArray = loadData(from: list) else {
            return false
        }
        loadedArray.removeAll()
        
        saveData(from: loadedArray, to: list)
        return true
        
    }
}
