//
//  UserManager.swift
//  SwiftfulFirebaseBootcamp
//
//

import Foundation
import FirebaseFirestore

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    let name: String?
    let gender: String?
    let birthDate: Date?
    let maritalStatus: String?
    let hasChildren: Bool?
    let numberOfChildren: Int?
    let heightCm: Int?
    let weightKg: Int?
    let bodyType: String?
    let skinTone: String?
    let shoeSize: Int?
    let clothingSizes: [String: String]?
    let favoriteColors: [String]?
    let stylePreferences: [String]?
    let fashionGoals: [String]?

    let location: String?
    let language: String?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil

        // NEW profile fields - default to nil
        self.name = nil
        self.gender = nil
        self.birthDate = nil
        self.maritalStatus = nil
        self.hasChildren = nil
        self.numberOfChildren = nil
        self.heightCm = nil
        self.weightKg = nil
        self.bodyType = nil
        self.skinTone = nil
        self.shoeSize = nil
        self.clothingSizes = nil
        self.favoriteColors = nil
        self.stylePreferences = nil
        self.fashionGoals = nil
        self.location = nil
        self.language = nil
    }

    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoriteMovie: Movie? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil,
        
        // NEW fields
        name: String? = nil,
        gender: String? = nil,
        birthDate: Date? = nil,
        maritalStatus: String? = nil,
        hasChildren: Bool? = nil,
        numberOfChildren: Int? = nil,
        heightCm: Int? = nil,
        weightKg: Int? = nil,
        bodyType: String? = nil,
        skinTone: String? = nil,
        shoeSize: Int? = nil,
        clothingSizes: [String: String]? = nil,
        favoriteColors: [String]? = nil,
        stylePreferences: [String]? = nil,
        fashionGoals: [String]? = nil,
        location: String? = nil,
        language: String? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl

        self.name = name
        self.gender = gender
        self.birthDate = birthDate
        self.maritalStatus = maritalStatus
        self.hasChildren = hasChildren
        self.numberOfChildren = numberOfChildren
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.bodyType = bodyType
        self.skinTone = skinTone
        self.shoeSize = shoeSize
        self.clothingSizes = clothingSizes
        self.favoriteColors = favoriteColors
        self.stylePreferences = stylePreferences
        self.fashionGoals = fashionGoals
        self.location = location
        self.language = language
    }

    
//    func togglePremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//        return DBUser(
//            userId: userId,
//            isAnonymous: isAnonymous,
//            email: email,
//            photoUrl: photoUrl,
//            dateCreated: dateCreated,
//            isPremium: !currentValue)
//    }
    
//    mutating func togglePremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
        case name
         case gender
         case birthDate
         case maritalStatus
         case hasChildren
         case numberOfChildren
         case heightCm
         case weightKg
         case bodyType
         case skinTone
         case shoeSize
         case clothingSizes
         case favoriteColors
         case stylePreferences
         case fashionGoals
         case location
         case language
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)

        // ⬇️ Insert the new decoding lines right here:
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.birthDate = try container.decodeIfPresent(Date.self, forKey: .birthDate)
        self.maritalStatus = try container.decodeIfPresent(String.self, forKey: .maritalStatus)

        self.hasChildren = try container.decodeIfPresent(Bool.self, forKey: .hasChildren)
        self.numberOfChildren = try container.decodeIfPresent(Int.self, forKey: .numberOfChildren)

        self.heightCm = try container.decodeIfPresent(Int.self, forKey: .heightCm)
        self.weightKg = try container.decodeIfPresent(Int.self, forKey: .weightKg)
        self.bodyType = try container.decodeIfPresent(String.self, forKey: .bodyType)
        self.skinTone = try container.decodeIfPresent(String.self, forKey: .skinTone)
        self.shoeSize = try container.decodeIfPresent(Int.self, forKey: .shoeSize)

        self.clothingSizes = try container.decodeIfPresent([String: String].self, forKey: .clothingSizes)
        self.favoriteColors = try container.decodeIfPresent([String].self, forKey: .favoriteColors)
        self.stylePreferences = try container.decodeIfPresent([String].self, forKey: .stylePreferences)
        self.fashionGoals = try container.decodeIfPresent([String].self, forKey: .fashionGoals)

        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(birthDate, forKey: .birthDate)
        try container.encodeIfPresent(maritalStatus, forKey: .maritalStatus)

        try container.encodeIfPresent(hasChildren, forKey: .hasChildren)
        try container.encodeIfPresent(numberOfChildren, forKey: .numberOfChildren)

        try container.encodeIfPresent(heightCm, forKey: .heightCm)
        try container.encodeIfPresent(weightKg, forKey: .weightKg)
        try container.encodeIfPresent(bodyType, forKey: .bodyType)
        try container.encodeIfPresent(skinTone, forKey: .skinTone)
        try container.encodeIfPresent(shoeSize, forKey: .shoeSize)

        try container.encodeIfPresent(clothingSizes, forKey: .clothingSizes)
        try container.encodeIfPresent(favoriteColors, forKey: .favoriteColors)
        try container.encodeIfPresent(stylePreferences, forKey: .stylePreferences)
        try container.encodeIfPresent(fashionGoals, forKey: .fashionGoals)

        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(language, forKey: .language)

    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String:Any] = [
//            "user_id" : auth.uid,
//            "is_anonymous" : auth.isAnonymous,
//            "date_created" : Timestamp(),
//        ]
//        if let email = auth.email {
//            userData["email"] = email
//        }
//        if let photoUrl = auth.photoUrl {
//            userData["photo_url"] = photoUrl
//        }
//
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
//    func getUser(userId: String) async throws -> DBUser {
//        let snapshot = try await userDocument(userId: userId).getDocument()
//
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let dateCreated = data["date_created"] as? Date
//
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
//    }
    
//    func updateUserPremiumStatus(user: DBUser) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium,
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url,
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    func updateUserProfileDetails(
        userId: String,
        name: String?,
        gender: String?,
        birthDate: Date?,
        maritalStatus: String?,
        hasChildren: Bool?,
        numberOfChildren: Int?,
        heightCm: Int?,
        weightKg: Int?,
        bodyType: String?,
        skinTone: String?,
        shoeSize: Int?,
        clothingSizes: [String: String]?,
        favoriteColors: [String]?,
        stylePreferences: [String]?,
        fashionGoals: [String]?,
        location: String?,
        language: String?
    ) async throws {
        var data: [String: Any] = [:]

        data[DBUser.CodingKeys.name.rawValue] = name
        data[DBUser.CodingKeys.gender.rawValue] = gender
        data[DBUser.CodingKeys.birthDate.rawValue] = birthDate
        data[DBUser.CodingKeys.maritalStatus.rawValue] = maritalStatus
        data[DBUser.CodingKeys.hasChildren.rawValue] = hasChildren
        data[DBUser.CodingKeys.numberOfChildren.rawValue] = numberOfChildren
        data[DBUser.CodingKeys.heightCm.rawValue] = heightCm
        data[DBUser.CodingKeys.weightKg.rawValue] = weightKg
        data[DBUser.CodingKeys.bodyType.rawValue] = bodyType
        data[DBUser.CodingKeys.skinTone.rawValue] = skinTone
        data[DBUser.CodingKeys.shoeSize.rawValue] = shoeSize
        data[DBUser.CodingKeys.clothingSizes.rawValue] = clothingSizes
        data[DBUser.CodingKeys.favoriteColors.rawValue] = favoriteColors
        data[DBUser.CodingKeys.stylePreferences.rawValue] = stylePreferences
        data[DBUser.CodingKeys.fashionGoals.rawValue] = fashionGoals
        data[DBUser.CodingKeys.location.rawValue] = location
        data[DBUser.CodingKeys.language.rawValue] = language

        try await userDocument(userId: userId).updateData(data)
    }

    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else {
            throw URLError(.badURL)
        }
        
        let dict: [String:Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : data
        ]

        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeFavoriteMovie(userId: String) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue : nil
        ]

        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    
    func addUserFavoriteProduct(userId: String, product: Product) async throws {
        let document = userFavoriteProductCollection(userId: userId).document()
        let documentId = document.documentID

        let data: [String: Any] = [
            "id": documentId,
            "product_id": product.id,
            "title": product.title,
            "thumbnail": product.thumbnail,
            "price": product.price,
            "date_created": Timestamp()
        ]

        try await document.setData(data, merge: false)
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
    
    func getAllUserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New products: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified products: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed products: \(diff.document.data())")
                }
            }
        }
    }
    
//    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
//        let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
//
//        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//
//            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
//            publisher.send(products)
//        }
//
//        return publisher.eraseToAnyPublisher()
//    }
    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
        let (publisher, listener) = userFavoriteProductCollection(userId: userId)
            .addSnapshotListener(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductsListener = listener
        return publisher
    }
    
}
import Combine

struct UserFavoriteProduct: Codable {
    let id: String
    let productId: Int
    let title: String
    let thumbnail: String
    let price: Double
    let dateCreated: Date

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case title
        case thumbnail
        case price
        case dateCreated = "date_created"
    }
}


