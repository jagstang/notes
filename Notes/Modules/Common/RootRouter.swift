//
//  RootWireframe.swift
//  Notes
//
//  Created by Jag Stang on 23/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

class RootRouter {
    
    static func present(in window: UIWindow, with context: NSManagedObjectContext) {
        window.makeKeyAndVisible()
        window.rootViewController = AuthRouter.assemble(context: context)
    }
}
