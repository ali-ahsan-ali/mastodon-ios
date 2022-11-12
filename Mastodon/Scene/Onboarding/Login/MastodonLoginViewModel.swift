//
//  MastodonLoginViewModel.swift
//  Mastodon
//
//  Created by Nathan Mattes on 11.11.22.
//

import Foundation
import MastodonSDK
import MastodonCore
import Combine

protocol MastodonLoginViewModelDelegate: AnyObject {
  func serversUpdated(_ viewModel: MastodonLoginViewModel)
}

class MastodonLoginViewModel {

  var serverList: [Mastodon.Entity.Server] = []
  var selectedServer: Mastodon.Entity.Server?

  weak var appContext: AppContext?
  weak var delegate: MastodonLoginViewModelDelegate?
  var disposeBag = Set<AnyCancellable>()

  init(appContext: AppContext) {
    self.appContext = appContext
  }

  func updateServers() {
    appContext?.apiService.servers().sink(receiveCompletion: { [weak self] completion in
      switch completion {
        case .finished:
          guard let self = self else { return }

          self.delegate?.serversUpdated(self)
        case .failure(let error):
          print(error)
      }
    }, receiveValue: { content in
      let servers = content.value
      self.serverList = servers
    }).store(in: &disposeBag)
  }
}
