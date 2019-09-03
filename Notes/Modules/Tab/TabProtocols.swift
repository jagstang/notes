//
//  TabProtocols.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit
import CoreData

protocol TabRouterProtocol {
    
    static func assemble(token: String?, context: NSManagedObjectContext) -> UIViewController
    func getViewControllers() -> [UIViewController]
}

protocol TabViewProtocol: class {
    
    func show(controllers: [UIViewController])
}

protocol TabPresenterProtocol {
    
    func viewDidLoad()
}
