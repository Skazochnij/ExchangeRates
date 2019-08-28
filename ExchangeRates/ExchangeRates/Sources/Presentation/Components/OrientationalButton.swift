//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

@IBDesignable class OrientationalButton: UIButton {
    @IBInspectable var isVertical: Bool = false {
        didSet {
            centerContent()
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if isVertical, let image = imageView?.image {
            var labelHeight: CGFloat = 0.0

            if let size = titleLabel?.sizeThatFits(CGSize(
                    width: self.contentRect(forBounds: self.bounds).width,
                    height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }

            return CGSize(width: size.width, height: image.size.height + labelHeight)
        }

        return size
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        if isVertical {
            return CGRect(x: 0, y: contentRect.height - rect.height + 5, width: contentRect.width, height: rect.height)
        } else {
            return rect
        }
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        if isVertical {
            let titleRect = self.titleRect(forContentRect: contentRect)

            return CGRect(x: contentRect.width/2.0 - rect.width/2.0,
                          y: (contentRect.height - titleRect.height)/2.0 - rect.height/2.0,
                          width: rect.width, height: rect.height)
        } else {
            return rect
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        centerContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerContent()
    }

    private func centerContent() {
        self.contentHorizontalAlignment = isVertical ? .center : .left
        self.titleLabel?.textAlignment = isVertical ? .center : .left
    }
}
