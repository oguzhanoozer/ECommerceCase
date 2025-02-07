# E-Commerce iOS App Case Study
A Android application sample developed using MVVM architecture, Dependency Injection, and clean code principles.


# 📁 Project Structure
```
E-CommerceCase/
├── Application/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Constants/
│   ├── AppColors.swift      // UI renk tanımlamaları
│   ├── AppConstants.swift   // Genel sabitler
│   ├── AppSizes.swift      // UI boyut tanımlamaları
│   └── TextStyle.swift     // Text stilleri
├── Models/
│   └── Product.swift       // Ürün modeli
├── Network/
│   └── NetworkManager.swift // Network işlemleri
├── ViewModels/
│   ├── ProductListViewModel.swift
│   └── ProductDetailViewModel.swift
├── Views/
│   ├── Common/
│   │   ├── ActivityIndicatorView.swift
│   │   ├── BaseCardView.swift
│   │   ├── BaseLabel.swift
│   │   ├── BaseView.swift
│   │   ├── ProductImageView.swift
│   │   └── RatingView.swift
│   ├── Cells/
│   │   ├── HeaderCell.swift
│   │   └── ProductCell.swift
│   ├── ProductListViewController.swift
│   ├── ProductDetailViewController.swift
│   └── HeaderView.swift
└── Mock/
    ├── MockData.swift
    └── MockNetworkManager.swift
```

# Tech Stack & Architecture
- Language: Swift 5.0+
- Minimum iOS: 13.0+
- Architecture: MVVM (Model-View-ViewModel)
- UI: Programmatic UI (No Storyboard/XIB)
- Network: Protocol-Oriented Network Layer with URLSession
- Test: Unit Tests with XCTest

# Key Features
- [x] Product list (grid layout)
- [x] Featured products carousel
- [x] Product detail page
- [x] Lazy image loading
- [x] Error handling & loading states
- [x] Unit tests
- [x] Mock data support
- [x] Reusable UI components


# Getting Started
Requirements:
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

# Installation
<ul>
  <li>
  Clone the repository
  
  ```  
    git clone https://github.com/oguzhanoozer/ECommerceCase.git
  ```
  </li>

   <li> 
Open project with Xcode

```
open E-CommerceCase.xcodeproj
```
Build & Run & Running Tests
<li>

```
xcodebuild test -scheme E-CommerceCase -destination 'platform=iOS Simulator,name=iPhone 14'
```
</li>

## API
<ul>
<li>The project uses Fake Store API:</li>
<li>Base URL: https://fakestoreapi.com</li>
<li>Endpoints:</li>
<li>/products - Product list</li>
<li>/products/{id} - Product detail</li>
</ul>

## Note About API Security
- For this case study, API paths and endpoints are exposed in the codebase.

## Features
- Product listing with pagination
- Product detail view
- Slider for featured products

## Tech Stack & Architecture
- 100% Swift
- MVVM Architecture
- Programmatic UI (No Storyboard/XIB)
- Custom NetworkManager
- Unit Testing with XCTest

## Why Programmatic UI?
Programmatic UI approach was chosen over Storyboards/XIB for several reasons:
- Better version control and conflict resolution
- Improved code review process
- Runtime performance benefits
- More control over UI components
- Easier reusability of components
- Better testability of UI elements

## Testing Strategy
The project emphasizes thorough testing:
- Comprehensive unit tests
- Mock data implementation
- Mock network service
- UI testing capabilities
- Test coverage for business logic

## Architecture Overview
- Application: App lifecycle management
- Constants: Centralized configuration
- Models: Data structures
- Network: API handling
- ViewModels: Business logic
- Views: UI components
- Mock: Testing infrastructure

## Implementation Details
Built focusing on:
- Clean architecture
- Custom NetworkManager
- Pagination implementation
- Constants management
- Mock Service structure
- Unit test coverage

## Future Improvements
- Enhanced caching mechanism
- Advanced loading states
- Improved pagination
- Better error handling
- Enhanced UI/UX states 
