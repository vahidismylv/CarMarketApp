import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel
    private let makeLoginViewController: () -> UIViewController

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = AppColor.primaryText
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = AppColor.primaryText
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = AppColor.secondaryText
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(AppColor.background, for: .normal)
        btn.backgroundColor = AppColor.primaryText
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()

    private let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Logout", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.backgroundColor = AppColor.card
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppColor.stroke.cgColor
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()

    init(viewModel: ProfileViewModel, makeLoginViewController: @escaping () -> UIViewController) {
        self.viewModel = viewModel
        self.makeLoginViewController = makeLoginViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background

        bindViewModel()
        setupViews()
        setupLayout()
        setupActions()
        viewModel.loadProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadProfile()
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }
    }

    private func setupViews() {
        [avatarImageView, nameLabel, subtitleLabel, loginButton, logoutButton].forEach {
            view.addSubview($0)
        }
    }

    private func setupLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }

    @objc private func didTapLogin() {
        let vc = makeLoginViewController()
        if let loginViewController = vc as? LoginViewController {
            loginViewController.onLogin = { [weak self] _ in
                self?.viewModel.loadProfile()
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    @objc private func didTapLogout() {
        viewModel.logout()
    }

    private func updateUI() {
        nameLabel.text = viewModel.displayName
        subtitleLabel.text = viewModel.subtitle
        loginButton.isHidden = viewModel.isLoggedIn
        logoutButton.isHidden = !viewModel.isLoggedIn
    }
}
