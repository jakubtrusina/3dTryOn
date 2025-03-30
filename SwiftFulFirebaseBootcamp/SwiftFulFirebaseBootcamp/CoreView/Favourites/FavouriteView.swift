import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id) { item in
                HStack(alignment: .top, spacing: 12) {
                    // Product Image
                    AsyncImage(url: URL(string: item.thumbnail)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 70, height: 70)
                    .cornerRadius(8)
                    
                    // Product Info
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text("Price: $\(item.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 6)
                .contextMenu {
                    Button("Remove from favorites") {
                        viewModel.removeFromFavorites(favoriteProductId: item.id)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.addListenerForFavorites()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteView()
        }
    }
}
