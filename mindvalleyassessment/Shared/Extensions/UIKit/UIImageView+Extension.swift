//
//  UIImageView+Extension.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/11/24.
//

import UIKit
import Kingfisher

extension UIImageView {

    /**
     Sets an image to the image view from the specified URL.

     - Parameters:
     - url: The URL from which to retrieve the image.
     - placeholder: An optional image to display while the image is being downloaded.

     - Important: The `url` parameter must contain a valid URL to an image.

     - Note: This method uses the Kingfisher library for image downloading and caching.

     - Example:
     ```swift
     let url = URL(string: "https://example.com/image.jpg")
     imageView.setImage(with: url, placeholder: UIImage(named: "placeholder"))
     ```

     - SeeAlso: [Kingfisher Library](https://github.com/onevcat/Kingfisher)
     */
    func setImage(with url: URL, placeholder: UIImage? = nil) {
        typealias ResultType = Result<RetrieveImageResult, KingfisherError>

        let imageView = self
        var kf = imageView.kf
        let cornerRadius = imageView.layer.cornerRadius
        let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        kf.indicatorType = IndicatorType.activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = Color.indicator
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                KingfisherOptionsInfoItem.processor(processor),
                KingfisherOptionsInfoItem.backgroundDecode,
                KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.3)),
                KingfisherOptionsInfoItem.waitForCache,
            ]
        ) { result in
            switch result {
                case ResultType.success(let value):
                    print("Kingfisher Task done for: \(value.source.url?.absoluteString ?? "")")
                case ResultType.failure(let error):
                    print("Kingfisher Job failed: \(error.localizedDescription)")
            }
        }
    }
}
