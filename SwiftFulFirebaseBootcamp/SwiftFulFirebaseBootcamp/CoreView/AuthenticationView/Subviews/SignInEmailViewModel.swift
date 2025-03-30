//
//  SignInEmailViewModel.swift
//  SwiftFulFirebaseBootcamp
//
//  Created by Jakub Trusina on 3/26/25.
//
import Foundation
@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    func signUp() async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            print("❌ Email or password is empty.")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
 //       try await UserManager.shared.createNewUser(auth: authDataResult)            }
    
    func signIn() async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            print("❌ Email or password is empty.")
            return
        }
        try await AuthenticationManager.shared.signInUser(
                email: trimmedEmail,
                password: trimmedPassword
                
                
            )
       
            }
        }
// ←✅ This closing brace was missing!
