//
//  Comic.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 14/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

struct Comic: Codable, Equatable {
    
    init (comicId: UUID = UUID(), title: String, image: Data?, progressNumber: Int?, finishNumber: Int?, type: String, organizeBy: String, status: String, author: String?, artist: String?) {
        self.comicId = comicId
        self.title = title
        if let image = image {
            self.image = image
        }
        if let progressNumber = progressNumber {
            self.progressNumber = progressNumber
        }
        if let finishNumber = finishNumber {
            self.finishNumber = finishNumber
        }
        self.type = type
        self.organizeBy = organizeBy
        self.status = status
        if let author = author {
            self.author = author
        }
        if let artist = artist {
            self.artist = artist
        }
        lastEdit = getDate()
    }
    
    let comicId: UUID
    var title: String
    var image: Data?
    var progressNumber: Int?
    var finishNumber: Int?
    var type: String
    var organizeBy: String
    var status: String
    var author: String?
    var artist: String?
    var lastEdit: Date?
    
    func getDate() -> Date {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        
        let components = DateComponents(year: now.year, month: now.month, day: now.day, hour: now.hour, minute: now.minute, second: now.second)
        let date = Calendar.current.date(from: components)!
        return date
    }
}
