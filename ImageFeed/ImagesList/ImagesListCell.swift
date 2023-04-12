import UIKit

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
    
   func configure(image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        cellImage.contentMode = .scaleAspectFill
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "LikeButtonActive") : UIImage(named: "LikeButtonNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
}
