import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
}

extension ImagesListCell {
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configure(from photos: [Photo], in tableView: UITableView, with indexPath: IndexPath) {
        guard
            let imagesListURL = photos[indexPath.row].thumbImageURL,
            let url = URL(string: imagesListURL),
            let date = photos[indexPath.row].createdAt,
            let isLiked = photos[indexPath.row].isLiked
        else { return }
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "CardStub")
        ) { [weak self] _ in
            guard let self else { return }
            self.cellImage.kf.indicatorType = .none
            self.cellImage.contentMode = .scaleAspectFill
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        dateLabel.text = date.dateTimeString
        
        let likeImage = isLiked ? UIImage(named: "LikeButtonActive") : UIImage(named: "LikeButtonNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
}
