import Foundation
import SwiftUI
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()

    /// Start listening to real-time favorites updates.
    func addListenerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            print("User not signed in. Cannot listen for favorites.")
            return
        }
        
        UserManager.shared
            .addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to load favorites: \(error)")
                case .finished:
                    // The publisher will keep streaming, so .finished rarely occurs
                    break
                }
            } receiveValue: { [weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancellables)
    }
    
    /// One-time fetch (non-listening). Useful if you just want a snapshot rather than real-time updates.
    func getFavorites() {
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                let favorites = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
                self.userFavoriteProducts = favorites
            } catch {
                print("Failed to fetch favorites: \(error)")
            }
        }
    }
    
    /// Remove from favorites
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                try await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid,
                                                                       favoriteProductId: favoriteProductId)
            } catch {
                print("Failed to remove favorite: \(error)")
            }
        }
    }
}
