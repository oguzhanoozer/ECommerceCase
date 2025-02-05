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
        // Given
        let expectation = expectation(description: "Fetch products success")
        mockNetwork.shouldFail = false
        viewModel.delegate = self
        
        // When
        viewModel.fetchProducts()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.products.isEmpty)
        XCTAssertFalse(viewModel.headerProducts.isEmpty)
        XCTAssertEqual(viewModel.products.count, 2)  // Mock data'daki ürün sayısı
        XCTAssertEqual(viewModel.headerProducts.count, 2)
    }
    
    func test_fetchProducts_failure() {
        // Given
        let expectation = expectation(description: "Fetch products failure")
        mockNetwork.shouldFail = true
        viewModel.delegate = self
        
        // When
        viewModel.fetchProducts()
        
        // Then
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