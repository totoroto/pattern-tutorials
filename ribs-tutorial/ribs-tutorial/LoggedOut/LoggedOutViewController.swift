//
//  LoggedOutViewController.swift
//  ribs-tutorial
//
//  Created by summer on 2022/06/13.
//

import RIBs
import RxSwift
import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func login(player1Name: String?, player2Name: String?)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    weak var listener: LoggedOutPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        let playerFields = buildPlayerFields()
        buildLoginButton(withPlayer1Field: playerFields.player1Field, player2Field: playerFields.player2Field)
    }

    // MARK: - Private

    private var player1Field: UITextField = {
        let player1Field = UITextField()
        player1Field.translatesAutoresizingMaskIntoConstraints = false
        player1Field.borderStyle = UITextField.BorderStyle.line
        player1Field.placeholder = "Player 1 name"
        return player1Field
    }()
    private var player2Field: UITextField = {
        let player2Field = UITextField()
        player2Field.translatesAutoresizingMaskIntoConstraints = false
        player2Field.borderStyle = UITextField.BorderStyle.line
        player2Field.placeholder = "Player 2 name"
        return player2Field
    }()

    private func buildPlayerFields() -> (player1Field: UITextField, player2Field: UITextField) {
        view.addSubview(player1Field)
        view.addSubview(player2Field)
        
        NSLayoutConstraint.activate([
            player1Field.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            player1Field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            player1Field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            player1Field.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            player2Field.topAnchor.constraint(equalTo: player1Field.bottomAnchor, constant: 20),
            player2Field.leadingAnchor.constraint(equalTo: player1Field.leadingAnchor),
            player2Field.trailingAnchor.constraint(equalTo: player1Field.trailingAnchor),
            player2Field.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return (player1Field, player2Field)
    }

    private func buildLoginButton(withPlayer1Field player1Field: UITextField, player2Field: UITextField) {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: player2Field.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: player1Field.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: player1Field.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.black
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }

    @objc private func didTapLoginButton() {
        listener?.login(player1Name: player1Field.text, player2Name: player2Field.text)
    }
}
