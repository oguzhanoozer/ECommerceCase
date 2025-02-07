//
//  ProductListViewModelTests.swift
//  E-CommerceCaseTests
//
//  Created by oguzhan on 7.02.2025.
//

import XCTest
@testable import E_CommerceCase

final class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var mockNetwork: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager.shared
        viewModel = ProductListViewModel(networkManager: mockNetwork)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func test_fetchProducts_success() {
        let expectation = expectation(description: "Fetch products success")
        mockNetwork.shouldFail = false
        viewModel.delegate = self
        
        viewModel.fetchProducts()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.products.isEmpty)
        XCTAssertFalse(viewModel.headerProducts.isEmpty)
        XCTAssertEqual(viewModel.products.count, 2)
        XCTAssertEqual(viewModel.headerProducts.count, 2)
    }
    
    func test_fetchProducts_failure() {
        let expectation = expectation(description: "Fetch products failure")
        mockNetwork.shouldFail = true
        viewModel.delegate = self
        
        viewModel.fetchProducts()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertTrue(viewModel.headerProducts.isEmpty)
    }
}

extension ProductListViewModelTests: ProductListViewModelDelegate {
    func productsLoaded() {
        expectation(description: "Fetch products success").fulfill()
    }
    
    func showError(_ error: Error) {
        expectation(description: "Fetch products failure").fulfill()
    }
} 
