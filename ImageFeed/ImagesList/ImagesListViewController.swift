import UIKit
import ProgressHUD

// MARK: - Protocols

protocol ImagesListViewControllerProtocol: AnyObject {}

// MARK: - ImagesListViewController Class

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    private let showSingleImageSegueIdentifier = "PresentSingleImage"
    private var photos: [Photo] = []
    lazy var presenter: ImagesListPresenterProtocol = ImagesListPresenter(viewController: self)
    private var alertPresenter: AlertPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        alertPresenter = AlertPresenter(viewController: self)
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
        
        updateTableViewAnimated()
        presenter.presentPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath,
                  let fullImageStringURL = photos[indexPath.row].largeImageURL,
                  let fullImageURL = URL(string: fullImageStringURL)
            else { return }
            
            viewController.image = fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

private extension ImagesListViewController {
    func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            let oldCount = photos.count
            let newCount = presenter.photos.count
            photos = presenter.photos
            if oldCount != newCount {
                tableView.performBatchUpdates {
                    var indexPaths: [IndexPath] = []
                    (oldCount..<newCount).forEach { index in
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        presenter.presentChangeLikeResult(photo: photo) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.presenter.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure(let error):
                let alert = AlertModel(
                    title: "Что-то пошло не так :(",
                    message: error.localizedDescription,
                    buttonText: "Ок"
                ) { }
                
                alertPresenter?.showAlert(model: alert)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    // MARK: - TableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.configure(from: photos, in: tableView, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    // MARK: - TableViewDelegate methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            presenter.presentPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
