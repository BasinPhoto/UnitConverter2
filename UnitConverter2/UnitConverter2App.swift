//
//  UnitConverter2App.swift
//  UnitConverter2
//
//  Created by Sergey Basin on 30.11.2020.
//

import SwiftUI

@main
struct UnitConverter2App: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                if let type = QuickActions.selectedAction?.userInfo?["type"] as? String,
                   let castedType = UnitType(name: type) {
                    viewModel.unitType = castedType
                }
            case .background:
                viewModel.setupQuickActions()
            case .inactive:
                print("I")
            @unknown default:
                print("??")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let selectedAction = options.shortcutItem {
            QuickActions.selectedAction = selectedAction
        }
        
        let sceneConfig = UISceneConfiguration(name: "CustomConfiguration",
                                               sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = CustomSceneDelegate.self
        return sceneConfig
    }
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        QuickActions.selectedAction = shortcutItem
    }
}
