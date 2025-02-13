//
//  ProductDetailViewModelTests.swift
//  E-CommerceCaseTests
//
//  Created by oguzhan on 7.02.2025.
//

import XCTest
@testable import E_CommerceCase

final class ProductDetailViewModelTests: XCTestCase {
    var viewModel: ProductDetailViewModel!
    var mockNetwork: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager.shared
        viewModel = ProductDetailViewModel(productId: 1, networkManager: mockNetwork)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func test_fetchProductDetail_success() {
        let expectation = expectation(description: "Fetch product detail success")
        mockNetwork.shouldFail = false
        viewModel.delegate = self
        
        viewModel.fetchProductDetail()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.product)
        XCTAssertEqual(viewModel.product?.id, 1)
        XCTAssertEqual(viewModel.product?.title, "iPhone 13 Pro")
    }
    
    func test_fetchProductDetail_failure() {
        let expectation = expectation(description: "Fetch product detail failure")
        mockNetwork.shouldFail = true
        viewModel.delegate = self
        
        viewModel.fetchProductDetail()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(viewModel.product)
    }
}

extension ProductDetailViewModelTests: ProductListViewModelDelegate {
    func productsLoaded() {
        expectation(description: "Fetch product detail success").fulfill()
    }
    
    func showError(_ error: Error) {
        expectation(description: "Fetch product detail failure").fulfill()
    }
} 
