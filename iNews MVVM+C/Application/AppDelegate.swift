//
//  AppDelegate.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationCon)
        appCoordinator?.start()
        window?.rootViewController = navigationCon
        window?.makeKeyAndVisible()
        return true
    }

//    // MARK: - Core Data stack
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "ModelCoreData")
//        container.loadPersistentStores { discription, error in
//            if let error {
//                print(error.localizedDescription)
//            } else {
//                print("DB url - ", discription.url?.absoluteString)
//            }
//        }
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unre solved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }


}

