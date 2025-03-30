import SwiftUI


struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack(spacing: 16) {
            // Email TextField
            TextField("Email...", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            // Password SecureField
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            // Sign In Button
            Button {
                Task{
                    do {
                        try await  viewModel.signUp()
                        showSignInView =   false
                        print("✅ Sign-up successful!")
                        return
                        
                    } catch{
                        print("❌ Sign-in failed: \(error.localizedDescription)")
                    }
                    
                    do {
                        try await  viewModel.signIn()
                        showSignInView =   false
                        print("✅ Sign-in successful!")
                        return
                        
                    } catch{
                        print("❌ Sign-in failed: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
