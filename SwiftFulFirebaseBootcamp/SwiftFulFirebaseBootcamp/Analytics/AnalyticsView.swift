//
//  AnalyticsView.swift
//  SwiftFulFirebaseBootcamp
//
//  Created by Jakub Trusina on 3/28/25.
//

import SwiftUI
import FirebaseAnalytics

// MARK: - Analytics Manager

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private init() {}

    /// Logs a Firebase event with optional parameters and a timestamp.
    func logEvent(name: String, params: [String: Any]? = nil) {
        var finalParams = params ?? [:]
        finalParams["timestamp"] = Date().timeIntervalSince1970
        Analytics.logEvent(name, parameters: finalParams)
    }

    /// Sets a unique user ID for tracking.
    func setUserId(_ userId: String) {
        Analytics.setUserID(userId)
    }

    /// Assigns user-specific properties (e.g. premium status).
    func setUserProperty(_ value: String?, for property: String) {
        Analytics.setUserProperty(value, forName: property)
    }

    /// Automatically logs screen tracking and duration
    func logScreenView(name: String, startTime: Date?, endTime: Date) {
        guard let start = startTime else { return }
        let duration = endTime.timeIntervalSince(start)
        logEvent(name: AnalyticsEvent.screenDuration, params: [
            "screen_name": name,
            "duration_seconds": duration
        ])
    }
}

// MARK: - Analytics Constants

struct AnalyticsEvent {
    static let primaryButtonClick = "analytics_primary_button_click"
    static let secondaryButtonClick = "analytics_secondary_button_click"
    static let screenAppear = "analytics_view_appear"
    static let screenDisappear = "analytics_view_disappear"
    static let screenDuration = "analytics_screen_duration"
    static let screenName = "AnalyticsView"
}

struct AnalyticsProperty {
    static let isPremiumUser = "user_is_premium"
}

// MARK: - View

struct AnalyticsView: View {
    @State private var appearTime: Date?
    
    var body: some View {
        VStack(spacing: 24) {
            Button("Primary Action") {
                AnalyticsManager.shared.logEvent(name: AnalyticsEvent.primaryButtonClick)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Secondary Action") {
                AnalyticsManager.shared.logEvent(
                    name: AnalyticsEvent.secondaryButtonClick,
                    params: ["screen_title": AnalyticsEvent.screenName]
                )
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Analytics Test")
        .analyticsScreen(name: AnalyticsEvent.screenName)
        .onAppear {
            appearTime = Date()
            AnalyticsManager.shared.logEvent(name: AnalyticsEvent.screenAppear)
        }
        .onDisappear {
            AnalyticsManager.shared.logEvent(name: AnalyticsEvent.screenDisappear)
            AnalyticsManager.shared.logScreenView(name: AnalyticsEvent.screenName, startTime: appearTime, endTime: Date())
            AnalyticsManager.shared.setUserId("ABC123") // Ideally, pull real user ID
            AnalyticsManager.shared.setUserProperty("true", for: AnalyticsProperty.isPremiumUser)
        }
    }
}

// MARK: - Preview

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AnalyticsView()
        }
    }
}
