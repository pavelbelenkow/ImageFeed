import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Actions
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

extension ImagesListCell {
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
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
}
