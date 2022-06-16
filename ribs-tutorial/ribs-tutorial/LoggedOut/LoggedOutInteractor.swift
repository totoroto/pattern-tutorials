//
//  LoggedOutInteractor.swift
//  ribs-tutorial
//
//  Created by summer on 2022/06/13.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LoggedOutListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable, LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: LoggedOutPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - LoggedOutPresentableListener
    func login(player1Name: String?, player2Name: String?) {
        let player1Name = playerName(player1Name, defaultName: "Player 1")
        let player2Name = playerName(player2Name, defaultName: "Player 2")
        
        print("\(player1Name) vs \(player2Name)")
    }
    
    private func playerName(_ name: String?, defaultName: String) -> String {
        guard let name = name else {
            return defaultName
        }
        return name.isEmpty ? defaultName : name
    }
}
