//
//  UIView+Animation+Extension.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/14/24.
//

import UIKit

extension UIView {

    /**
     Animates the view to shrink or revert to its original size with a spring effect.

     - Parameters:
     - scale: The scale factor by which the view should shrink. A value less than 1.0 will shrink the view.
     - isPressed: A Boolean value indicating whether the view is in the pressed state. If `true`, the view will shrink; if `false`, it will revert to its original size.

     This method uses a spring animation to provide a smooth scaling effect. It is useful for creating interactive animations such as button presses.

     - Note: The animation duration is set to 0.5 seconds, with a spring damping of 0.3 and an initial spring velocity of 4.0. The animation options allow user interaction and use a curve ease-in-out timing function.

     - Example:
     ```
     let button = UIButton()
     button.shrink(by: 0.95, isPressed: true)
     ```
     */
    func shrink(by scale: CGFloat, isPressed: Bool) {
        let view = self

        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 4.0,
            options: [
                UIView.AnimationOptions.allowUserInteraction,
                UIView.AnimationOptions.curveEaseInOut
            ]
        ) {
            let transform = isPressed ? CGAffineTransform(scaleX: scale, y: scale) : CGAffineTransform.identity
            view.transform = transform
        }
    }
}
