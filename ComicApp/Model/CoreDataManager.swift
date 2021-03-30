//
//  CoreDataManager.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 29/03/21.
//  Copyright © 2021 Eduardo Oliveira. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager {
        
    let persistentStore: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        guard let persistentContainer = container else { fatalError() }
        return persistentContainer
    }()
    
    weak var fetchController: NSFetchedResultsControllerDelegate?
    
    init(controller: NSFetchedResultsControllerDelegate) {
        self.fetchController = controller
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<ComicCD> = {
        let fetchRequest = NSFetchRequest<ComicCD>(entityName: "Comic")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentStore.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self.fetchController
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        return controller
    }()
    
    func fetch() -> [ComicCD]? {
        return self.fetchedResultsController.fetchedObjects
    }

    func fetchBy(by status: String) -> [ComicCD]? {
        let objects = self.fetchedResultsController.fetchedObjects
        var selectedObjects: [ComicCD] = []
        selectedObjects = (objects?.filter({$0.status == status}))!
        return selectedObjects
     }
    
    @discardableResult func saveNew(from dto: ComicDTO) -> Bool {
        let comic = ComicCD(context: persistentStore.viewContext)
        comic.title = dto.title
        comic.image = dto.image
        comic.progressNumber = dto.progressNumber
        comic.finishNumber = dto.finishNumber
        comic.type = dto.type
        comic.organizeBy = dto.organizeBy
        comic.status = dto.status
        comic.author = dto.author
        comic.artist = dto.artist
        comic.lastEdit = dto.lastEdit
        
        do {
            try persistentStore.viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult func saveEdit(from dto: ComicDTO, to comic: ComicCD) -> Bool {
        comic.title = dto.title
        comic.image = dto.image
        comic.progressNumber = dto.progressNumber
        comic.finishNumber = dto.finishNumber
        comic.type = dto.type
        comic.organizeBy = dto.organizeBy
        comic.status = dto.status
        comic.author = dto.author
        comic.artist = dto.artist
        comic.lastEdit = dto.lastEdit
        
        do {
            try persistentStore.viewContext.save()
            return true
        } catch {
            return false
        }
    }
        
    func delete(_ comic: ComicCD) -> Bool {
        let context = persistentStore.viewContext
        context.delete(comic)
        do {
            try persistentStore.viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func statusProgress(status: StatusType) -> Double {
        let result = self.fetchedResultsController.fetchedObjects
        let lendo = result?.filter({ $0.status == "Lendo"}).count ?? 0
        let lido = result?.filter({ $0.status == "Lido"}).count ?? 0
        let ler = result?.filter({ $0.status == "Quero Ler"}).count ?? 0
        var finalStatusProgress: Double
        switch status {
        case .read:
            finalStatusProgress = Double(((lido+lendo) / (lido+lendo+ler)))
        case .reading:
            finalStatusProgress = Double(lendo/(lido+lendo+ler))
        case .wantToRead:
            finalStatusProgress = 1
        }
        return finalStatusProgress
    }
    
    func loadRecentComics(limit: Int) -> [ComicCD] {
        let wantToReadList = fetchBy(by: "wantToRead")
        let readingList = fetchBy(by: "reading")
        let readList = fetchBy(by: "read")
        
        var list = [ComicCD]()
        list.append(contentsOf: wantToReadList ?? [])
        list.append(contentsOf: readingList ?? [])
        list.append(contentsOf: readList ?? [])
        
        list = list.sorted(by: { $0.lastEdit! > $1.lastEdit! })
        
        var limitedList: [ComicCD] = []
        let limitNumber = min(limit, list.count)
        for index in 0 ..< limitNumber {
            limitedList.append(list[index])
        }
        return limitedList
    }
}

struct ComicDTO {
    
    public var title: String?
    public var image: Data?
    public var progressNumber: Int64
    public var finishNumber: Int64
    public var type: String?
    public var organizeBy: String?
    public var status: String?
    public var author: String?
    public var artist: String?
    public var lastEdit: Date?
    public var color: String?
    
}
