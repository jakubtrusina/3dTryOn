import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var showEditProfileSheet = false
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil

    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]

    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }

    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")

                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                }

                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }

                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(string) {
                                if preferenceIsSelected(text: string) {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceIsSelected(text: string) ? .green : .red)
                        }
                    }
                }

                Button {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                } label: {
                    Text("Favorite Movie: \((user.favoriteMovie?.title ?? ""))")
                }

                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                }

                if let urlString = viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }

                if viewModel.user?.profileImagePath != nil {
                    Button("Delete image") {
                        viewModel.deleteProfileImage()
                    }
                }

                Button("Edit Profile Details") {
                    showEditProfileSheet = true
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onChange(of: selectedItem) { newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
        .sheet(isPresented: $showEditProfileSheet) {
            EditProfileForm(viewModel: viewModel)
        }
    }
}

struct EditProfileForm: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Name", text: $viewModel.name)

                    Picker("Gender", selection: $viewModel.gender) {
                        ForEach(["", "Male", "Female", "Non-binary", "Other"], id: \.self) {
                            Text($0)
                        }
                    }

                    DatePicker("Birthdate", selection: $viewModel.birthDate, displayedComponents: .date)

                    Picker("Marital Status", selection: $viewModel.maritalStatus) {
                        ForEach(["", "Single", "Married", "Divorced", "Widowed"], id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section(header: Text("Family")) {
                    Toggle("Has Children", isOn: $viewModel.hasChildren)

                    if viewModel.hasChildren {
                        Stepper("Children: \(viewModel.numberOfChildren)", value: $viewModel.numberOfChildren, in: 0...10)
                    }
                }

                Section(header: Text("Body Metrics")) {
                    TextField("Height (cm)", text: $viewModel.heightCm)
                        .keyboardType(.numberPad)
                    TextField("Weight (kg)", text: $viewModel.weightKg)
                        .keyboardType(.numberPad)
                    TextField("Body Type", text: $viewModel.bodyType)
                    TextField("Skin Tone", text: $viewModel.skinTone)
                    TextField("Shoe Size (EU)", text: $viewModel.shoeSize)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Clothing Sizes")) {
                    TextField("Top Size", text: $viewModel.topSize)
                    TextField("Bottom Size", text: $viewModel.bottomSize)
                    TextField("Dress Size", text: $viewModel.dressSize)
                }

                Section(header: Text("Style Preferences")) {
                    TextField("Favorite Colors", text: $viewModel.favoriteColors)
                    TextField("Preferred Styles", text: $viewModel.stylePreferences)
                    TextField("Fashion Goals", text: $viewModel.fashionGoals)
                }

                Section(header: Text("Other")) {
                    TextField("Location", text: $viewModel.location)
                    TextField("Language", text: $viewModel.language)
                }

                Section {
                    Button("Save Changes") {
                        viewModel.saveProfile()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(showSignInView: .constant(false))
        }
    }
}
