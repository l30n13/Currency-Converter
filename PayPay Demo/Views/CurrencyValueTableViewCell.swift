//
//  CurrencyValueTableViewCell.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid Leon on 23/7/22.
//

import UIKit
import SnapKit

class CurrencyValueTableViewCell: UITableViewCell {
    private lazy var currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private lazy var currencyDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()

    private lazy var currencyRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrencyValueTableViewCell {
    private func setupUI() {
        let vStack = UIStackView()
        vStack.distribution = .fillEqually
        vStack.spacing = 5
        vStack.axis = .vertical
        vStack.addArrangedSubview(currencyCodeLabel)
        vStack.addArrangedSubview(currencyDetailsLabel)

        addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        addSubview(currencyRateLabel)
        currencyRateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(vStack.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(vStack.snp.bottom)
        }
    }
}

extension CurrencyValueTableViewCell {
    func populateCell(currencyCode: String?, currencyDetails: String?, amount: Double, baseValue: Double, convertInto: Double) {
        currencyCodeLabel.text = currencyCode
        currencyDetailsLabel.text = currencyDetails

        currencyRateLabel.text = String(format: "%.2f", amount * baseValue * convertInto)
    }
}
