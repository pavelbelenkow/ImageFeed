import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CardStub")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(named: "white(alpha 50)")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var dateGradientContainer: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 16
        container.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "3 марта 2023"
        label.textColor = UIColor(named: "white")
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LikeButtonNoActive"), for: .normal)
        button.addTarget(
            nil,
            action: #selector(likeButtonClicked),
            for: .touchUpInside
        )
        button.accessibilityIdentifier = "Like"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(named: "background(alpha 0)")?.cgColor as Any,
            UIColor(named: "background(alpha 20)")?.cgColor as Any
        ]
        gradient.locations = [0, 1]
        return gradient
    }()
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(named: "background")
        self.selectionStyle = .none
        addCellImage()
        addDateGradientContainer()
        addDateLabel()
        addLikeButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ImagesListCell {
    
    // MARK: - Methods
    
    override func layoutSublayers(of layer: CALayer) {
        gradient.frame = dateGradientContainer.bounds
        dateGradientContainer.layer.insertSublayer(gradient, at: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    private func addCellImage() {
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func addDateGradientContainer() {
        contentView.addSubview(dateGradientContainer)
        
        NSLayoutConstraint.activate([
            dateGradientContainer.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            dateGradientContainer.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            dateGradientContainer.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            dateGradientContainer.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func addDateLabel() {
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: dateGradientContainer.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: dateGradientContainer.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: dateGradientContainer.trailingAnchor, constant: -8)
        ])
    }
    
    private func addLikeButton() {
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func configure(from photos: [Photo], in tableView: UITableView, with indexPath: IndexPath) {
        cellImage.layer.addSublayer(
            CAGradientLayer.addGradientAnimation(
                width: tableView.bounds.width - 32,
                height: photos[indexPath.row].size.height * (tableView.bounds.width - 32),
                radius: 16
            )
        )
        
        guard
            let imagesListURL = photos[indexPath.row].thumbImageURL,
            let url = URL(string: imagesListURL),
            let date = photos[indexPath.row].createdAt
        else { return }
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "CardStub")
        ) { [weak self] _ in
            guard let self else { return }
            self.cellImage.kf.indicatorType = .none
            self.cellImage.contentMode = .scaleAspectFill
            self.cellImage.layer.sublayers?.removeAll()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        dateLabel.text = date.dateTimeString
        self.setIsLiked(photos[indexPath.row].isLiked)
    }
    
    func setIsLiked(_ state: Bool) {
        let likeImage = state ? UIImage(named: "LikeButtonActive") : UIImage(named: "LikeButtonNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    // MARK: - Objective-C methods
    
    @objc
    private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
