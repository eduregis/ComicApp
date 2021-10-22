//
//  ShelfViewModel.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 30/03/21.
//  Copyright © 2021 Eduardo Oliveira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ShelfViewModel: NSObject {

    var comics = [ComicCD]()
    var handleTransition: (() -> Void)?
    let repository: CoreDataManager
    var status: StatusType {
        didSet {
            handleTransition?()
        }
    }

    init(status: StatusType, controller: NSFetchedResultsControllerDelegate) {
        self.status = status
        self.repository = CoreDataManager(controller: controller)
        repository.mock()
    }

    public var numberOfComics: Int {
        return repository.fetchBy(by: status.rawValue)?.count ?? 0
    }

    public func comicForRow(at index: IndexPath) -> ComicCD? {
        let comic = repository.fetchBy(by: status.rawValue)![index.row]
        return comic
    }

    public func deleteComic (comic: ComicCD) {
        _ = repository.delete(comic)
    }
    
    func didStateChanged(for index: Int) {
        switch index {
        case 0:
            self.status = .reading
        case 1:
            self.status = .read
        case 2:
            self.status = .wantToRead
        default:
            self.status = .reading
        }
    }
}
