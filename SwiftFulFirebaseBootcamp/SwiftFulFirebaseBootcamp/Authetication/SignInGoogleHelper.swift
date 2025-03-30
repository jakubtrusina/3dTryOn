//
//  SignInGoogleHelper.swift
//  SwiftfulFirebaseBootcamp
//
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let email: String?
    let name: String?
}

final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        let user = signInResult.user

        guard let idToken = user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken = user.accessToken.tokenString
        let email = user.profile?.email
        let name = user.profile?.name

        return GoogleSignInResultModel(
            idToken: idToken,
            accessToken: accessToken,
            email: email,
            name: name
        )
    }
}
