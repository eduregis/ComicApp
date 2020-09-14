//
//  Comic.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 14/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

struct Comic: Codable, Equatable {
    var title: String
    var progressNumber: Int?
    var finishNumber: Int?
    var type: String
    var organizeBy: String
    var status: String
    var author: String?
    var artist: String?
}
