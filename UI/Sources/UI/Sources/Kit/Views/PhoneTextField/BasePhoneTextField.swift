import PhoneNumberKit
import UIKit

final class BasePhoneTextField: PhoneNumberTextField {

    private var _defaultRegion: String?

    private var tintStyle: UIColor?
    private var textStyle: UIColor?
    private var countryCodePlaceholderStyle: UIColor?
    private var numberPlaceholderStyle: UIColor?

    override var defaultRegion: String {
        get { _defaultRegion ?? ""}
        set { self.partialFormatter.defaultRegion = newValue }
    }

    init(
        defaultRegion: String,
        tintStyle: UIColor?,
        textStyle: UIColor?,
        countryCodePlaceholderStyle: UIColor,
        numberPlaceholderStyle: UIColor?
    ) {
        _defaultRegion = defaultRegion
        self.tintStyle = tintStyle
        self.textStyle = textStyle
        self.countryCodePlaceholderStyle = countryCodePlaceholderStyle
        self.numberPlaceholderStyle = numberPlaceholderStyle
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

        func setup() {
        backgroundColor = .clear
        tintStyle.flatMap { tintStyle = $0 }
        textStyle.flatMap { textStyle = $0 }
        countryCodePlaceholderStyle.flatMap { countryCodePlaceholderStyle = $0 }
    }
}
