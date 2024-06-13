//
//  UIView+Extension.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/14/24.
//

import UIKit

extension UIView {

    /// Structure to define associated keys for the activity indicator view.
    private struct AssociatedKeys {
        static var activityIndicatorView = "UIView.activityIndicatorView"
    }

    /// The activity indicator view associated with the view.
    private var activityIndicatorView: UIActivityIndicatorView? {
        get {
            withUnsafePointer(to: &AssociatedKeys.activityIndicatorView) {
                return objc_getAssociatedObject(self, $0) as? UIActivityIndicatorView
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.activityIndicatorView) {
                objc_setAssociatedObject(
                    self,
                    $0,
                    newValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    /// Starts the loading animation by adding an activity indicator view to the view.
    ///
    /// The activity indicator view is added as a subview and centered within the view using Auto Layout constraints.
    func startLoading() {
        guard activityIndicatorView == nil else {
            return
        }

        let activityIndicatorView = createActivityIndicatorView()
        activityIndicatorView.startAnimating()

        addSubview(activityIndicatorView)

        let constraints = [
            activityIndicatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        self.activityIndicatorView = activityIndicatorView
    }

    /// Stops the loading animation by removing the activity indicator view from the view.
    ///
    /// The activity indicator view is removed from the view hierarchy and deallocated.
    func stopLoading() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
    }

    /// Creates and configures a UIActivityIndicatorView with a medium style.
    ///
    /// - Returns: A configured UIActivityIndicatorView.
    private func createActivityIndicatorView() -> UIActivityIndicatorView {
        let style = UIActivityIndicatorView.Style.medium
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        activityIndicatorView.color = Color.indicator
        activityIndicatorView.frame = bounds
        activityIndicatorView.backgroundColor = Color.screenBackgroundColor
        activityIndicatorView.alpha = 1
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }
}
