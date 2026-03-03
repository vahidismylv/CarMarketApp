//
//  LoginViewController.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 12.02.26.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    var onLogin: ((UserSession) -> Void)?

    private let viewModel: LoginViewModel
    
    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AutoMarket🏎️"
        lbl.textColor = AppColor.primaryText
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 40, weight: .bold)
        return lbl
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign in"
        lbl.font = .systemFont(ofSize: 22, weight: .semibold)
        lbl.textColor = AppColor.primaryText
        lbl.numberOfLines = 1
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome! Please sign in to continue."
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = AppColor.secondaryText
        lbl.numberOfLines = 2
        return lbl
    }()

    private let emailField: AuthTextField = {
        let icon = UIImage(systemName: "envelope")
        return AuthTextField(icon: icon, placeholder: "Email")
    }()

    private let passwordField: AuthTextField = {
        let icon = UIImage(systemName: "lock")
        return AuthTextField(icon: icon, placeholder: "Password", isSecure: true)
    }()

    private lazy var signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign in", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = AppColor.accent
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return btn
    }()

    private lazy var appleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "applelogo"), for: .normal)
        btn.setTitle("  Continue with Apple", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.setTitleColor(AppColor.primaryText, for: .normal)
        btn.backgroundColor = AppColor.card
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppColor.stroke.cgColor
        btn.tintColor = AppColor.primaryText
        btn.addTarget(self, action: #selector(didTapApple), for: .touchUpInside)
        return btn
    }()

    private let contentStack: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 14
        return st
    }()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
    }


    private func setupUI() {
        view.backgroundColor = AppColor.background

        [topLabel,titleLabel,subtitleLabel,contentStack,signInButton,appleButton].forEach { view.addSubview($0) }

        contentStack.addArrangedSubview(emailField)
        contentStack.addArrangedSubview(passwordField)


        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(contentStack.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }

        appleButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        emailField.textField.autocapitalizationType = .none
        emailField.textField.autocorrectionType = .no

        passwordField.textField.autocapitalizationType = .none
        passwordField.textField.autocorrectionType = .no
    }
    
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] session in
            self?.onLogin?(session)

            guard let self else { return }
            if let nav = self.navigationController, nav.viewControllers.count > 1 {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }

        viewModel.onError = { [weak self] message in
            self?.emailField.setErrorState()
            self?.passwordField.setErrorState()
            self?.showError(message)
        }
    }

    @objc private func didTapSignIn() {
        let email = (emailField.textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = (passwordField.textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        emailField.setNormalState()
        passwordField.setNormalState()
        viewModel.signIn(email: email, password: pass)
    }

    @objc private func didTapApple() {
        let alert = UIAlertController(
            title: "Not available yet",
            message: "Apple sign-in is planned for a future update.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

