//
//  ComicTests.swift
//  ComicAppTests
//
//  Created by Ronaldo Gomes on 22/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import XCTest
@testable import ComicApp

class ComicTests: XCTestCase {

    func test_init_batmanTitle_returnsBatman() {
        
        //Given
        let sut = Comic(title: "Batman", imageURL: nil, progressNumber: nil, finishNumber: nil, type: "", organizeBy: "", status: "", author: nil, artist: nil)
        
        //When
        let title = sut.title
        
        //Then
        XCTAssertEqual(title, "Batman")
    }
    
    func test_init_noImageURL_shouldBeNil() {
        
        //Given
        let sut = Comic(title: "", imageURL: nil, progressNumber: nil, finishNumber: nil, type: "", organizeBy: "", status: "", author: nil, artist: nil)
        
        //When
        let imageUrl = sut.imageURL
        
        //Then
        XCTAssertNil(imageUrl)
    }
    
    func test_init_finishNumberFive_returnsNotNil() {
        
        //Given
        let sut = Comic(title: "", imageURL: nil, progressNumber: nil, finishNumber: 5, type: "", organizeBy: "", status: "", author: nil, artist: nil)
        
        //When
        let finishNumber = sut.finishNumber
        
        //Then
        XCTAssertNotNil(finishNumber)
    }
    
    func test_getData_retunsNowData() {
        
        //Given
        let sut = Comic(title: "", imageURL: nil, progressNumber: nil, finishNumber: nil, type: "", organizeBy: "", status: "", author: nil, artist: nil)
        
        //When
        let data = sut.getDate()
        let dataNow = sut.lastEdit
        
        //Then
        XCTAssertEqual(data, dataNow)
    }

}
