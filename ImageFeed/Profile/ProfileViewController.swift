import UIKit
import WebKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var token = OAuth2TokenStorage.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UserPicStub")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name Last Name"
        label.textColor = UIColor(named: "white")
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@username"
        label.textColor = UIColor(named: "gray")
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "LogOut") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton)
        )
        button.tintColor = UIColor(named: "red")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        alertPresenter = AlertPresenter(viewController: self)
        addAnimationLayers()
        
        addUserImageView()
        addFullNameLabel()
        addLoginNameLabel()
        addDescriptionLabel()
        addLogoutButton()
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateUserImage()
            }
        updateUserImage()
    }
    
    // MARK: - Methods
    
    private func addUserImageView() {
        view.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addFullNameLabel() {
        view.addSubview(fullNameLabel)
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8),
            fullNameLabel.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func addLoginNameLabel() {
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor)
        ])
    }
    
    private func addDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor)
        ])
    }
    
    private func addLogoutButton() {
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: userImageView.trailingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func updateProfileDetails(profile: Profile) {
        fullNameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        removeAnimationLayers()
    }
    
    private func updateUserImage() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        userImageView.kf.setImage(with: url,placeholder: UIImage(named: "UserPicStub")) { [weak self] _ in
            guard let self else { return }
            self.userImageView.layer.sublayers?.removeAll()
        }
    }
    
    private func addAnimationLayers() {
        userImageView.layer.addSublayer(CAGradientLayer.addGradientAnimation(width: 70, height: 70, radius: 35))
        fullNameLabel.layer.addSublayer(CAGradientLayer.addGradientAnimation(width: 223, height: 27, radius: 14))
        loginNameLabel.layer.addSublayer(CAGradientLayer.addGradientAnimation(width: 89, height: 18, radius: 9))
        descriptionLabel.layer.addSublayer(CAGradientLayer.addGradientAnimation(width: 67, height: 18, radius: 9))
    }
    
    private func removeAnimationLayers() {
        fullNameLabel.layer.sublayers?.removeAll()
        loginNameLabel.layer.sublayers?.removeAll()
        descriptionLabel.layer.sublayers?.removeAll()
    }
    
    private func logout() {
        token.removeToken()
        WKWebView.clean()
        
        guard let window = UIApplication.shared.windows.first else { return }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
    
    // MARK: - Objective-C methods
    
    @objc
    private func didTapLogoutButton() {
        let alert = AlertWithTwoActionsModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            primaryButtonText: "Да",
            secondaryButtonText: "Нет"
        ) { [weak self] in
            guard let self else { return }
            self.logout()
        }
        
        alertPresenter?.showAlertWithTwoActions(model: alert)
    }
}
