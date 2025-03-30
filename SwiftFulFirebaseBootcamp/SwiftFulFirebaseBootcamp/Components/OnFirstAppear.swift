//
//  OnFirstAppearViewModifier.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Jakub Trusina on 3/29/25.
//

import SwiftUI

/// A view modifier that runs an action only once when the view first appears.
struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Run the action only once, the first time the view appears
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    
    /// A view extension that executes the closure only the first time the view appears.
    /// - Parameter perform: The closure to execute once on first appearance.
    /// - Returns: A view that triggers the closure once.
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        self.modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
