//
//  TabViewController.swift
//  Notes
//
//  Created by Jag Stang on 24/08/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, TabViewProtocol {

    var presenter: TabPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func show(controllers: [UIViewController]) {
        for controller in controllers {
            var viewController = controller
            if let nc = controller as? UINavigationController {
                if let first = nc.viewControllers.first {
                    viewController = first
                }
            }

            if let _ = viewController as? NotesTableViewProtocol {
                controller.tabBarItem = UITabBarItem(title: "Заметки", image: UIImage(named: "list"), tag: 0)
            }
            if let _ = viewController as? GalleryViewProtocol {
                controller.tabBarItem = UITabBarItem(title: "Галерея", image: UIImage(named: "gallery"), tag: 1)
            }
        }
        
        self.setViewControllers(controllers, animated: false)
    }
}
