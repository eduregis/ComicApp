//
//  Comic.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 14/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

struct Comic: Codable, Equatable {
    
    init (comicId: UUID = UUID(), title: String, image: Data?, progressNumber: Int?, finishNumber: Int?, type: DataType, organizeBy: OrganizationType, status: StatusType, author: String?, artist: String?) {
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
        color = getColor()
    }
    
    let comicId: UUID
    var title: String
    var image: Data?
    var progressNumber: Int?
    var finishNumber: Int?
    var type: DataType
    var organizeBy: OrganizationType
    var status: StatusType
    var author: String?
    var artist: String?
    var lastEdit: Date?
    var color: String?
    
    func getDate() -> Date {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        
        let components = DateComponents(year: now.year, month: now.month, day: now.day, hour: now.hour, minute: now.minute, second: now.second)
        let date = Calendar.current.date(from: components)!
        return date
    }
    
    func getColor() -> String {
        let colors: [String] = ["Pink", "Teal", "Indigo", "Purple", "Orange"]
        return colors.randomElement()!
    }
    
}

public enum StatusType: String, EnumCollection {
    case wantToRead = "Quero ler"
    case reading = "Lendo"
    case read = "Lido"
    
    static var allStringValues: [String] {
        var array: [String] = []
        StatusType.allCases.forEach {
            array.append($0.rawValue)
        }
        return array
    }
}

public enum DataType: String, EnumCollection {
    case comic = "Quadrinho"
    case book = "Livro"
    
    static var allStringValues: [String] {
        var array: [String] = []
        DataType.allCases.forEach {
            array.append($0.rawValue)
        }
        return array
    }
}

public enum OrganizationType: String, EnumCollection {
    case page = "Página"
    case cap = "Capítulo"
    case vol = "Volume"
    
    static var allStringValues: [String] {
        var array: [String] = []
        OrganizationType.allCases.forEach {
            array.append($0.rawValue)
        }
        return array
    }
}

protocol EnumCollection: CaseIterable, Codable, Equatable, RawRepresentable {}
