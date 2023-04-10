import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Outlets
    
    private weak var userImageView: UIImageView?
    private weak var fullNameLabel: UILabel?
    private weak var loginNameLabel: UILabel?
    private weak var descriptionLabel: UILabel?
    private weak var logoutButton: UIButton?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        addUserImageView()
        addFullNameLabel()
        addLoginNameLabel()
        addDescriptionLabel()
        addLogoutButton()
    }
    
    // MARK: - Methods
    
    private func addUserImageView() {
        let image = UIImage(named: "UserPicStub")
        let userImageView = UIImageView(image: image)
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 35
        self.userImageView = userImageView

        userImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addFullNameLabel() {
        let fullNameLabel = UILabel()
        fullNameLabel.text = "First Name Last Name"
        fullNameLabel.textColor = UIColor(named: "white")
        fullNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        fullNameLabel.numberOfLines = 0
        self.fullNameLabel = fullNameLabel
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullNameLabel)
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: userImageView!.bottomAnchor, constant: 8),
            fullNameLabel.leadingAnchor.constraint(equalTo: userImageView!.leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func addLoginNameLabel() {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@username"
        loginNameLabel.textColor = UIColor(named: "gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        self.loginNameLabel = loginNameLabel
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: fullNameLabel!.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel!.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: fullNameLabel!.trailingAnchor)
        ])
    }
    
    private func addDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.textColor = UIColor(named: "white")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        self.descriptionLabel = descriptionLabel
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel!.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel!.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: fullNameLabel!.trailingAnchor)
        ])
    }
    
    private func addLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "LogOut") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        logoutButton.tintColor = UIColor(named: "red")
        self.logoutButton = logoutButton
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: userImageView!.centerYAnchor),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: userImageView!.trailingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Objective-C methods
    
    @objc
    private func didTapLogoutButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
