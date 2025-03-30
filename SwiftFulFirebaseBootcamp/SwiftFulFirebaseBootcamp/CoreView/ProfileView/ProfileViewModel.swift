import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published private(set) var user: DBUser? = nil

    // Form Fields
    @Published var name: String = ""
    @Published var gender: String = ""
    @Published var birthDate: Date = Date()
    @Published var maritalStatus: String = ""
    @Published var hasChildren: Bool = false
    @Published var numberOfChildren: Int = 0
    @Published var heightCm: String = ""
    @Published var weightKg: String = ""
    @Published var bodyType: String = ""
    @Published var skinTone: String = ""
    @Published var shoeSize: String = ""
    @Published var topSize: String = ""
    @Published var bottomSize: String = ""
    @Published var dressSize: String = ""
    @Published var favoriteColors: String = ""
    @Published var stylePreferences: String = ""
    @Published var fashionGoals: String = ""
    @Published var location: String = ""
    @Published var language: String = ""

    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let dbUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
        self.user = dbUser

        // Pre-fill form
        self.name = dbUser.name ?? ""
        self.gender = dbUser.gender ?? ""
        self.birthDate = dbUser.birthDate ?? Date()
        self.maritalStatus = dbUser.maritalStatus ?? ""
        self.hasChildren = dbUser.hasChildren ?? false
        self.numberOfChildren = dbUser.numberOfChildren ?? 0
        self.heightCm = dbUser.heightCm.map { String($0) } ?? ""
        self.weightKg = dbUser.weightKg.map { String($0) } ?? ""
        self.bodyType = dbUser.bodyType ?? ""
        self.skinTone = dbUser.skinTone ?? ""
        self.shoeSize = dbUser.shoeSize.map { String($0) } ?? ""
        self.topSize = dbUser.clothingSizes?["top"] ?? ""
        self.bottomSize = dbUser.clothingSizes?["bottom"] ?? ""
        self.dressSize = dbUser.clothingSizes?["dress"] ?? ""
        self.favoriteColors = dbUser.favoriteColors?.joined(separator: ", ") ?? ""
        self.stylePreferences = dbUser.stylePreferences?.joined(separator: ", ") ?? ""
        self.fashionGoals = dbUser.fashionGoals?.joined(separator: ", ") ?? ""
        self.location = dbUser.location ?? ""
        self.language = dbUser.language ?? ""
    }

    func saveProfile() {
        guard let userId = user?.userId else { return }
        Task {
            try await UserManager.shared.updateUserProfileDetails(
                userId: userId,
                name: name,
                gender: gender,
                birthDate: birthDate,
                maritalStatus: maritalStatus,
                hasChildren: hasChildren,
                numberOfChildren: numberOfChildren,
                heightCm: Int(heightCm),
                weightKg: Int(weightKg),
                bodyType: bodyType,
                skinTone: skinTone,
                shoeSize: Int(shoeSize),
                clothingSizes: [
                    "top": topSize,
                    "bottom": bottomSize,
                    "dress": dressSize
                ],
                favoriteColors: favoriteColors.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) },
                stylePreferences: stylePreferences.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) },
                fashionGoals: fashionGoals.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) },
                location: location,
                language: language
            )

            self.user = try await UserManager.shared.getUser(userId: userId)
        }
    }

    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func addUserPreference(text: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.addUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func removeUserPreference(text: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func addFavoriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "1", title: "Avatar 2", isPopular: true)
        Task {
            try await UserManager.shared.addFavoriteMovie(userId: user.userId, movie: movie)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func removeFavoriteMovie() {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeFavoriteMovie(userId: user.userId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }

    func saveProfileImage(item: PhotosPickerItem) {
        guard let user else { return }
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else { return }
                let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
                let url = try await StorageManager.shared.getUrlForImage(path: path)
                try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("❌ Upload failed:", error)
            }
        }
    }

    func deleteProfileImage() {
        guard let user, let path = user.profileImagePath else { return }
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
}
