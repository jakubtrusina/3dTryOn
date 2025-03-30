//
//  ProductsViewModel.swift
//  SwiftfulFirebaseBootcamp
//
//

import Foundation
import SwiftUI
import FirebaseFirestore


@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var categories: [String] = []
    @Published var selectedCategory: String? = nil
    private var lastDocument: DocumentSnapshot? = nil

    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    func extractCategoriesFromProducts() {
        let categorySet = Set(products.compactMap { $0.category })
        self.categories = ["All"] + Array(categorySet).sorted()
    }
    
    func fetchProducts() async {
        do {
            let (fetchedProducts, _) = try await ProductsManager.shared.getAllProducts(
                priceDescending: nil,
                forCategory: nil,
                count: 20,
                lastDocument: nil
            )
            self.products = fetchedProducts
            self.extractCategoriesFromProducts()
        } catch {
            print("❌ Failed to fetch products: \(error.localizedDescription)")
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    
    func categorySelected(category: String?) async {
        self.selectedCategory = category
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory, count: 10, lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func addUserFavoriteProduct(product: Product) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, product: product)
        }
    }

//    func getProductsCount() {
//        Task {
//            let count = try await ProductsManager.shared.getAllProductsCount()
//            print("ALL PRODUCT COUNT: \(count)")
//        }
//    }
    
//    func getProductsByRating() {
//        Task {
////            let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating)
//
//            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument)
//            self.products.append(contentsOf: newProducts)
//            self.lastDocument = lastDocument
//        }
//    }
}
