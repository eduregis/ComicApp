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
        if !(FileManager.default.fileExists(atPath: read.path)) {
            saveData(from: emptyArray, to: .read)
        }
    }
    
    func mocking () {
        
        deleteAllListComics(from: .read)
        var readComics: [Comic] = []
        readComics.append(Comic(title: "Bleach", imageURL: "bleach_73_cover", progressNumber: 74, finishedNumber: 74, type: "Quadrinho", organizeBy: "Volume", status: "Lido", author: "Tite Kubo", artist: "Tite Kubo"))
        readComics.append(Comic(title: "Nijigahara Holograph", imageURL: "nijigahara_holograph_cover", progressNumber: 1, finishedNumber: 1, type: "Quadrinho", organizeBy: "Volume", status: "Lido", author: "Inio Asano", artist: "Inio Asano"))
        readComics.append(Comic(title: "Solanin", imageURL: "solanin_cover", progressNumber: 2, finishedNumber: 2, type: "Quadrinho", organizeBy: "Volume", status: "Lido", author: "Inio Asano", artist: "Inio Asano"))
        saveData(from: readComics, to: .read)
        
        deleteAllListComics(from: .reading)
        var readingComics: [Comic] = []
        readingComics.append(Comic(title: "Miss Marvel", imageURL: "miss_marvel_1_cover", progressNumber: 1, finishedNumber: nil, type: "Quadrinho", organizeBy: "Volume", status: "Lendo", author: "Gerry Conwan", artist: "John Buscema"))
        readingComics.append(Comic(title: "Assassination Classroom", imageURL: "assassination_classroom_1_cover", progressNumber: 12, finishedNumber: 21, type: "Quadrinho", organizeBy: "Volume", status: "Lendo", author: "Yuusei Matsui", artist: "Yuusei Matsui"))
        readingComics.append(Comic(title: "O Rei do Inverno", imageURL: "o_rei_do_inverno_cover", progressNumber: 137, finishedNumber: 544, type: "Livro", organizeBy: "Página", status: "Lendo", author: "Bernard Cornwell", artist: nil))
        saveData(from: readingComics, to: .reading)
        
        deleteAllListComics(from: .wantToRead)
        var wantToReadComics: [Comic] = []
        wantToReadComics.append(Comic(title: "Spider-Man: Miles Morales", imageURL: "spider_man_miles_morales_1_cover", progressNumber: 0, finishedNumber: nil, type: "Quadrinho", organizeBy: "Volume", status: "Quero Ler", author: nil, artist: nil))
        wantToReadComics.append(Comic(title: "Slam Dunk", imageURL: "slam_dunk_5_cover", progressNumber: 0, finishedNumber: 22, type: "Quadrinho", organizeBy: "Volume", status: "Quero Ler", author: "Takehiko Inoue", artist: "Takehiko Inoue"))
        wantToReadComics.append(Comic(title: "Sandman", imageURL: "sandman_cover", progressNumber: 0, finishedNumber: 1, type: "Quadrinho", organizeBy: "Volume", status: "Quero Ler", author: "Neil Gaiman", artist: nil))
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
