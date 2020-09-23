//
//  DatabaseTests.swift
//  ComicAppTests
//
//  Created by Ronaldo Gomes on 23/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import XCTest
@testable import ComicApp

class DatabaseTests: XCTestCase {
    
    func deleteAllCommic() {
        Database.shared.deleteAllComicLists()
    }
    
    override func setUp() {
        Database.shared.mocking()
    }
    
    override func tearDownWithError() throws {
        deleteAllCommic()
    }
    
    /*
    func test_init_createAllFiles() {
        
        //Given
        deleteAllCommic()
        let sut = Database.shared
        
        //When
        let readFileExits = FileManager.default.fileExists(atPath: Database.shared.read.path)
        let readingFileExits = FileManager.default.fileExists(atPath: Database.shared.reading.path)
        let wantReadFileExits = FileManager.default.fileExists(atPath: Database.shared.wantToRead.path)
        
        let arrayOfFilesExits = [readFileExits, readingFileExits, wantReadFileExits]
        
        //Then
        XCTAssertEqual(arrayOfFilesExits, [true, true, true])
        
    }
    */
    
    func test_loadData_statusRead_countNotBeEqualZero() {
        
        //Given
        let sut = Database.shared
        
        //When
        let comicData = sut.loadData(from: .read)
        
        //Then
        XCTAssertNotEqual(comicData?.count, 0)
    }
    
    func test_loadData_statusReading_returnsNil() {
        
        //Given
        let sut = Database.shared
        deleteAllCommic()
        
        //When
        let comicData = sut.loadData(from: .reading)
        
        //Then
        XCTAssertNil(comicData)
    }
    
    func test_loadRecentComics_limitFive_comicsCountShouldBeLessThenSix() {
        
        //Given
        let sut = Database.shared
        
        //When
        let recentComics = sut.loadRecentComics(limit: 5)
        
        //Then
        XCTAssertLessThan(recentComics.count, 6)
    }
    
    func test_addData_statusReading_returnsTrue() {
        
        //Given
        let sut = Database.shared
        let comic = Comic(title: "", imageURL: nil, progressNumber: nil, finishNumber: nil, type: "", organizeBy: "", status: "", author: nil, artist: nil)
        
        //When
        let addDataResult = sut.addData(comic: comic, statusType: .reading)
        
        //Then
        XCTAssertTrue(addDataResult)
    }
    
    func test_saveData_comicWantRead_returnsTrue() {
        
        //Given
        let sut = Database.shared
        
        //When
        let comic = Comic(title: "", imageURL: nil, progressNumber: nil, finishNumber: nil, type: "", organizeBy: "", status: "", author: nil, artist: nil)
        let saveResult = sut.saveData(from: [comic], to: .wantToRead)
        
        //Then
        XCTAssertTrue(saveResult)
    }
    
    func test_deleteData_statusReadAtIndexZero_returnsNotNil() {
        
        //Given
        let sut = Database.shared
        
        //When
        let dataResult = sut.deleteData(from: .read, at: 0)
        
        //Then
        XCTAssertNotNil(dataResult)
    }
    
    func test_deleteData_dataNotExists_returnsNil() {
        
        //Given
        let sut = Database.shared
        deleteAllCommic()
        
        //When
        let dataResult = sut.deleteData(from: .reading, at: 0)
        
        //Then
        XCTAssertNil(dataResult)
    }
    
    func test_deleteAllListComics_statusTypeReading_returnsTrue() {
        
        //Given
        let sut = Database.shared
        
        //When
        let dataResult = sut.deleteAllListComics(from: .reading)
        
        //Then
        XCTAssertTrue(dataResult)
    }
    
    func test_deleteAllListComics_fileNotExists_returnsFalse() {
        
        //Given
        let sut = Database.shared
        deleteAllCommic()
        
        //When
        let dataResult = sut.deleteAllListComics(from: .reading)
        
        //Then
        XCTAssertFalse(dataResult)
    }
    
    func test_statusProgress_statusWantRead_returnsOne() {
        
        //Given
        let sut = Database.shared
        
        //When
        let progressResult = sut.statusProgress(statusFrom: .wantToRead)
        
        //Then
        XCTAssertEqual(progressResult, 1)
    }
    
    func test_statusProgress_statusReading_returnsZeroCommaThree() {
        
        //Given
        let sut = Database.shared
        
        //When
        let progressResult = sut.statusProgress(statusFrom: .reading)
        
        //Then
        XCTAssertEqual(progressResult, 0.3333333333333333)
    }
    
    func test_statusProgress_statusRead_returnsZeroCommaSix() {
        
        //Given
        let sut = Database.shared
        
        //When
        let progressResult = sut.statusProgress(statusFrom: .read)
        
        //Then
        XCTAssertEqual(progressResult, 0.6666666666666666)
    }
}
