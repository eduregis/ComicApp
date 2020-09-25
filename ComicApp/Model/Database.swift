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
        
        print(read)
        //Caso os arquivos não existam, eles são criados no init
        if !(FileManager.default.fileExists(atPath: wantToRead.path)) {
            saveData(from: emptyArray, to: .wantToRead)
        }
        if !(FileManager.default.fileExists(atPath: reading.path)) {
            saveData(from: emptyArray, to: .reading)
        }
        if !(FileManager.default.fileExists(atPath: read.path)) {
            saveData(from: emptyArray, to: .read)
        }
    }
    
    func mocking () {
        
        deleteAllListComics(from: .read)
        var readComics: [Comic] = []
        readComics.append(Comic(title: "Bleach", image: nil, progressNumber: 74, finishNumber: 74, type: "Quadrinho", organizeBy: "Volume", status: "Lido", author: "Tite Kubo", artist: "Tite Kubo"))
        readComics.append(Comic(title: "Nijigahara Holograph", image: nil, progressNumber: 1, finishNumber: 1, type: "Quadrinho", organizeBy: "Volume", status: "Lido", author: "Inio Asano", artist: "Inio Asano"))
        readComics.append(Comic(title: "Solanin", image: nil, progressNumber: 2, finishNumber: 2, type: "Quadrinho", organizeBy: "Volume", status: "Lido", author: "Inio Asano", artist: "Inio Asano"))

        saveData(from: readComics, to: .read)

        deleteAllListComics(from: .reading)
        var readingComics: [Comic] = []
        readingComics.append(Comic(title: "Miss Marvel", image: nil, progressNumber: 1, finishNumber: nil, type: "Quadrinho", organizeBy: "Volume", status: "Lendo", author: "Gerry Conwan", artist: "John Buscema"))
        readingComics.append(Comic(title: "Assassination Classroom", image: nil, progressNumber: 12, finishNumber: 21, type: "Quadrinho", organizeBy: "Volume", status: "Lendo", author: "Yuusei Matsui", artist: "Yuusei Matsui"))
        readingComics.append(Comic(title: "O Rei do Inverno", image: nil, progressNumber: 137, finishNumber: 544, type: "Livro", organizeBy: "Página", status: "Lendo", author: "Bernard Cornwell", artist: nil))
        saveData(from: readingComics, to: .reading)

        deleteAllListComics(from: .wantToRead)
        var wantToReadComics: [Comic] = []
        wantToReadComics.append(Comic(title: "Spider-Man: Miles Morales", image: nil, progressNumber: 0, finishNumber: nil, type: "Quadrinho", organizeBy: "Volume", status: "Quero Ler", author: nil, artist: nil))
        wantToReadComics.append(Comic(title: "Slam Dunk", image: nil, progressNumber: 0, finishNumber: 22, type: "Quadrinho", organizeBy: "Volume", status: "Quero Ler", author: "Takehiko Inoue", artist: "Takehiko Inoue"))
        wantToReadComics.append(Comic(title: "Sandman", image: nil, progressNumber: 0, finishNumber: 1, type: "Quadrinho", organizeBy: "Volume", status: "Quero Ler", author: "Neil Gaiman", artist: nil))
        saveData(from: wantToReadComics, to: .wantToRead)
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
    
    func loadRecentComics(limit: Int) -> [Comic] {
        let wantToReadList: [Comic]? = loadData(from: .wantToRead)
        let readingList: [Comic]? = loadData(from: .reading)
        let readList: [Comic]? = loadData(from: .read)
        
        var list: [Comic] = []
        list.append(contentsOf: wantToReadList ?? [])
        list.append(contentsOf: readingList ?? [])
        list.append(contentsOf: readList ?? [])
        
        list = list.sorted(by: { $0.lastEdit! > $1.lastEdit! })
        
        var limitedList: [Comic] = []
        let limitNumber = min(limit, list.count)
        for index in 0 ..< limitNumber {
            limitedList.append(list[index])
        }
        return limitedList
    }
    
    func addData(comic: Comic, statusType: StatusType) {
        var list = Database.shared.loadData(from: statusType)
        list?.append(comic)
        Database.shared.saveData(from: list!, to: statusType)
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
    
    func deleteAllComicLists () {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    func statusProgress(statusFrom: StatusType) -> Double {
        let statusRead = Double(loadData(from: .read)!.count)
        let statusReading = Double(loadData(from: .reading)!.count)
        let statusWantReading = Double(loadData(from: .wantToRead)!.count)
        let finalStatusProgress: Double
        switch statusFrom {
        case .read:
            finalStatusProgress = ((statusRead+statusReading) / (statusRead+statusReading+statusWantReading))
        case .reading:
            finalStatusProgress = statusReading / (statusRead+statusReading+statusWantReading)
        case .wantToRead:
            finalStatusProgress = 1
        }
        return finalStatusProgress
    }
}
