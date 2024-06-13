//
//  UIFont+Extension.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/14/24.
//

import UIKit

extension UIFont {
    @objc class func robotoBlackSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.black, size: size)!
    }

    @objc class func robotoBlackItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.blackItalic, size: size)!
    }

    @objc class func robotoBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.bold, size: size)!
    }

    @objc class func robotoBoldItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.boldItalic, size: size)!
    }

    @objc class func robotoItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.italic, size: size)!
    }

    @objc class func robotoLightSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.light, size: size)!
    }

    @objc class func robotoLightItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.lightItalic, size: size)!
    }

    @objc class func robotoMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.medium, size: size)!
    }

    @objc class func robotoMediumItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.mediumItalic, size: size)!
    }

    @objc class func robotoRegularSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.regular, size: size)!
    }

    @objc class func robotoThinSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.thin, size: size)!
    }

    @objc class func robotoThinItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Font.thinItalic, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
        var fontName = ""
        switch fontAttribute {
            case "CTFontBlackUsage", "CTFontHeavyUsage":
                fontName = Font.black
            case "CTFontRegularUsage":
                fontName = Font.regular
            case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                fontName = Font.bold
            case "CTFontMediumUsage", "CTFontDemiUsage":
                fontName = Font.medium
            case "CTFontObliqueUsage":
                fontName = Font.italic
            case "CTFontLightUsage":
                fontName = Font.light
            case "CTFontThinUsage", "CTFontUltraLightUsage":
                fontName = Font.thin
            default:
                fontName = Font.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideInitialize() {
        guard self == UIFont.self else { return }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(robotoLightSystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(robotoBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(robotoItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
