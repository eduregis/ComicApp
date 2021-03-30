//
//  ShelfViewModel.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 30/03/21.
//  Copyright © 2021 Eduardo Oliveira. All rights reserved.
//

import Foundation
import CoreData

class ShelfViewModel {

    var albuns = [ComicCD]()
    var handleTransition: (() -> Void)?
    let repository: CoreDataManager
    var status: String {
        didSet {
            handleTransition?()
        }
    }
    init(status: String, controller: NSFetchedResultsControllerDelegate) {
        self.status = status
        self.repository = CoreDataManager(controller: controller)
    }
}

extension ShelfViewModel {
    
    public var numberOfComics: Int {
        return repository.fetchBy(by: status)?.count ?? 0
    }

    public func comicForRow(at index: IndexPath) -> ComicCD? {
        let album = repository.fetchBy(by: status)![index.row]
        return album
    }

    public func deleteComic (comic: ComicCD) {
        _ = repository.delete(comic)
    }

}
