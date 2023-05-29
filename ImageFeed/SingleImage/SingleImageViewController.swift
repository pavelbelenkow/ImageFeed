import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    private var alertPresenter: AlertPresenterProtocol?
    
    var image: URL! {
        didSet {
            guard isViewLoaded else { return }
            setImage()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        alertPresenter = AlertPresenter(viewController: self)
        setImage()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton() {
        let activityController = UIActivityViewController(
            activityItems: [imageView.image as Any],
            applicationActivities: nil
        )
        present(activityController, animated: true)
    }
    
    @IBAction func didDoubleTapImage(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale < 1 {
            scrollView.zoom(
                to: zoomRectangle(center: sender.location(in: sender.view)),
                animated: true
            )
        } else {
            guard let image = imageView.image else { return }
            rescaleImageInScrollView(image: image)
        }
    }
    
    // MARK: - Methods
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: image) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let imageResult):
                self.rescaleImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = AlertWithTwoActionsModel(
            title: "Что-то пошло не так :(",
            message: "Не удалось загрузить картинку",
            primaryButtonText: "Попробовать ещё раз",
            secondaryButtonText: "Отменить"
        ) { [weak self] in
            guard let self else { return }
            self.setImage()
        }
        
        alertPresenter?.showAlertWithTwoActions(model: alert)
    }
    
    private func rescaleImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let widthScale = visibleRectSize.width / imageSize.width
        let heightScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(widthScale, heightScale)))
        scrollView.setZoomScale(scale, animated: true)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: true)
    }
    
    private func centerImageInScrollView() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }
    
    private func zoomRectangle(center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = scrollView.frame.size.height / 3.0
        zoomRect.size.width  = scrollView.frame.size.width  / 3.0
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    // MARK: - Delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageInScrollView()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale < 0.5 {
            guard let image = imageView.image else { return }
            rescaleImageInScrollView(image: image)
        }
    }
}
