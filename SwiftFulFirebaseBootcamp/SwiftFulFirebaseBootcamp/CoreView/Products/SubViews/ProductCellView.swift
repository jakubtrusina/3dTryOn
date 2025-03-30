import SwiftUI

struct ProductCellView: View {
    let product: Product

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            
            // MARK: Image Slider
            if let images = product.images, !images.isEmpty {
                TabView {
                    ForEach(images.prefix(5), id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .clipped()
                    }
                }
                .frame(width: 100, height: 100)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }

            // MARK: Text Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "Untitled")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                Text("Price: CZK \(product.price)")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Text("Rating: \(product.rating)")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Text("Category: \(product.category ?? "Unknown")")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)

                Text("Brand: \(product.brand ?? "Unknown")")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 2)
    }
}
