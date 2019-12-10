//
//  ShoeSleuthTests.swift
//  ShoeSleuthTests
//
//  Created by Warren Glasner on 11/8/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import XCTest
import UIKit

class ShoeSleuthTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var galleryImage =  GalleryImage()
        galleryImage.name = "David's Shoes"
        galleryImage.favorited = true
        let testImage = UIImage(named: "pngtest1.png")
        galleryImage.photo=testImage

        
        XCTAssert(galleryImage.favorited == true)
        XCTAssert(galleryImage.name == "David's Shoes")
        XCTAssert(galleryImage.photo != nil)

    }
    
    func testImageClassificationViewController() {
        print("Cannot test the 'save' method because it requires information from the UI. Testing 'saveShoe' instead which is called in 'save'")
        
        var shoeTestImage = GalleryImage()
        shoeTestImage.name = "Shoe"
        shoeTestImage.favorited = false
        let image = UIImage(named: "pngtest1.png")
        shoeTestImage.photo = image
        
       var shoeTesting = ImageClassificationViewController()
        shoeTesting.saveShoe(image: shoeTestImage)
        
    }
    
    func testIdentifiedController() {
        print("Cannot test the 'save' method because it requires information from the UI. Testing 'saveShoe' instead which is called in 'save'")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
