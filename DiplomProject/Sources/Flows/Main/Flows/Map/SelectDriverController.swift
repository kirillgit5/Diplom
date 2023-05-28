import UIKit
import Services

final class SelectDriverController: UIViewController {

    var onDriverSelect: ((CompanionFindResponse) -> Void)?

    private let vStack = UIStackView()

    private let drivers: [CompanionFindResponse]

    init(drivers: [CompanionFindResponse]) {
        self.drivers = drivers

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        vStack.spacing = 12

        drivers.forEach { driver in
            let view = DriverView(driver: driver)
            let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:")
//            view.a
            vStack.addArrangedSubview(view)
        }
    }

    @objc private func onTap() {
                onDriverSelect?(drivers.first)
    }

    private func setup() {
        let title = UILabel()
        title.text = "Выберите водителя"

        view.addSubview(title)

        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(32)
            $0.bottom.leading.trailing.equalToSuperview().inset(16)
        }

        vStack.axis = .vertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DriverView: UIView {
    private let driver: CompanionFindResponse

    private let hStack = UIStackView()

    init(driver: CompanionFindResponse) {
        self.driver = driver

        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        hStack.axis = .vertical
        let infoTitle = UILabel()
        infoTitle.textColor = UIColor(hex: 0x9A9B9D)
        infoTitle.text = "Информация"

        let timeTitle = UILabel()
        timeTitle.textColor = UIColor(hex: 0x9A9B9D)
        timeTitle.text = "Время ожидания"

        let percentTitle = UILabel()
        percentTitle.textColor = UIColor(hex: 0x9A9B9D)
        percentTitle.text = "Процент покрытия"

        let info = UILabel()
        info.text = driver.name ?? ""

        let time = UILabel()
        time.text = driver.time?.description ?? ""

        let percent = UILabel()
        percent.text = driver.percent?.description ?? ""

        let infoView = UIView()

        infoView.addSubview(infoTitle)
        infoView.addSubview(info)

        infoTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        info.snp.makeConstraints {
            $0.top.equalTo(infoTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }

        let timeView = UIView()

        timeView.addSubview(timeTitle)
        timeView.addSubview(time)

        timeTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        time.snp.makeConstraints {
            $0.top.equalTo(timeTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }

        let percentView = UIView()

        percentView.addSubview(percentTitle)
        percentView.addSubview(percent)

        percentTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        percent.snp.makeConstraints {
            $0.top.equalTo(percentTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }

        hStack.addArrangedSubview(infoView)
        hStack.addArrangedSubview(timeView)
        hStack.addArrangedSubview(percentView)
    }
}
