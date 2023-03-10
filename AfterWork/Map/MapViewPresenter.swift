//
//  MapViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit

final class MapViewPresenter {
    
    static func goToMain() {
        
        let mainViewController = MainViewController()
        //mainViewController.modalPresentationStyle = .fullScreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController?.dismiss(animated: true)
        //sceneDelegate.window!.rootViewController?.present(mainViewController, animated: true)
        
    }
    
}
