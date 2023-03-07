//
//  MainViewPresenter.swift
//  Tinkoff Travel
//
//  Created by Евгений Парфененков on 02.03.2023.
//

import Foundation
import UIKit


protocol MainViewPresenterDelegate: AnyObject {
    func mainViewPresenter(_ reposViewModel: MainViewPresenter,
                            isLoading: Bool)
    func mainViewPresenter(_ reposViewModel: MainViewPresenter,
                            didReceiveRepos repos: [MainViewPresenter])
    func mainViewPresenter(_ reposViewModel: MainViewPresenter,
                            didSelectId id: Int)
}


final class MainViewPresenter {
    weak var delegate: MainViewPresenterDelegate?
    
    func ready() {
        delegate?.mainViewPresenter(self, isLoading: true)
    }
    
    
}
