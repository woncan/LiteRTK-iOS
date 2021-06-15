//
//  UILabel+Extension.swift
//
//
//  Created by iband on 2018/12/29.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    /// 创建UILabel
    ///
    /// - Parameters:
    ///   - text: 标题
    ///   - textColor: 文字颜色
    ///   - fontSize: 字体大小
    ///   - textAlignment: 居中、左对齐、y右对齐  默认居中
    ///   - e.g: UILabel(text: "kobe", textColor: UIColor.black, fontSize: 16, textAlignment: .center)
    public convenience init(text: String?, textColor: UIColor?, fontSize: CGFloat, textAlignment: NSTextAlignment = NSTextAlignment.center) {
        self.init(text: text, textColor: textColor, font: UIFont.systemFont(ofSize: fontSize), textAlignment: textAlignment)
    }
    
    public convenience init(text: String?, textColor: UIColor?, mediumFontSize: CGFloat, textAlignment: NSTextAlignment = NSTextAlignment.center) {
        self.init(text: text, textColor: textColor, font: UIFont.systemFont(ofSize: mediumFontSize, weight: .medium), textAlignment: textAlignment)
    }
    
    public convenience init(text: String?, textColor: UIColor?, boldFontSize: CGFloat, textAlignment: NSTextAlignment = NSTextAlignment.center) {
        self.init(text: text, textColor: textColor, font: UIFont.boldSystemFont(ofSize: boldFontSize), textAlignment: textAlignment)
    }
    
    private convenience init(text: String?, textColor: UIColor?, font: UIFont, textAlignment: NSTextAlignment = NSTextAlignment.center) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
    }
    
    public func setLineSpacing(lineSpacing: CGFloat) {
        if lineSpacing <= 0 {
            return
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = self.textAlignment
        let attributes = [NSAttributedString.Key.font: self.font,
                          NSAttributedString.Key.paragraphStyle: style]
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes as [NSAttributedString.Key : Any])
        ///设置了attributedText时候，lineBreakMode = NSLineBreakByTruncatingTail就会失效，所以要重新再设置一下
        self.lineBreakMode = .byTruncatingTail
    }
}


