//
//  AuthService.swift
//  AfterWork
//
//  Created by Евгений Парфененков on 14.03.2023.
//

import Foundation
import TinkoffID

class AuthService {
  static var tinkoffId: ITinkoffID = {
    let clientId = "tid_afterwork-mb"
    let callbackUrl = "afterwork://"

    let factory = TinkoffIDFactory(
      clientId: clientId,
      callbackUrl: callbackUrl
    )

    // handleCallback(url: handle_url)

    return factory.build()
  }()

  static var debugTinkoffId: ITinkoffID = {
    let callbackUrl = "afterwork://"

    let configuration = DebugConfiguration(
      canRefreshTokens: true,
      canLogout: true
    )

    let factory = DebugTinkoffIDFactory(
      callbackUrl: callbackUrl,
      configuration: configuration
    )

    return factory.build()
  }()

  // static var credentials: TinkoffTokenPayload!

  func TinkoffIDAuth(handler: @escaping SignInCompletion) {
    if AuthService.tinkoffId.isTinkoffAuthAvailable {
      AuthService.tinkoffId.startTinkoffAuth(handler)
    } else {
      AuthService.debugTinkoffId.startTinkoffAuth(handler)
    }
  }
}
