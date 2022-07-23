//
//  CurrencyConverterVC.swift
//  PayPay Demo
//
//  Created by Mahbubur Rashid on 21/7/22.
//

import UIKit
import Combine
import SnapKit
import NotificationBannerSwift
import SwiftUI

class CurrencyConverterVC: UIViewController {
    private lazy var amountTextFiled: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Amount"
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 5

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        textField.rightView = paddingView
        textField.rightViewMode = .always

        textField.addTarget(self, action: #selector(onChangeAmount), for: .editingChanged)

        return textField
    }()

    private lazy var currencySelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius =  5
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDown)))
        return view
    }()

    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        return label
    }()

    private lazy var downArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(systemName: "arrowtriangle.down.fill")
        imageView.tintColor = .black
        return imageView
    }()

    private lazy var currenciesTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.register(CurrencyValueTableViewCell.self, forCellReuseIdentifier: "CurrencyValueTableViewCell")
        return tableView
    }()

    private let dropDownView = DropDown()
    private var subscription = Set<AnyCancellable>()

    private let viewModel = CurrencyViewModel()

    override func viewDidAppear(_ animated: Bool) {
        title = "Currency converter"
        viewModel.fetchData()
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        setupUI()
    }
}

extension CurrencyConverterVC {
    private func setupUI() {
        view.addSubview(amountTextFiled)
        amountTextFiled.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.height.equalTo(45)
        }

        view.addSubview(currencySelectionView)
        currencySelectionView.snp.makeConstraints { make in
            make.top.equalTo(amountTextFiled.snp.top)
            make.leading.equalTo(amountTextFiled.snp.trailing).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.bottom.equalTo(amountTextFiled.snp.bottom)
        }

        currencySelectionView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }

        currencySelectionView.addSubview(downArrow)
        downArrow.snp.makeConstraints { make in
            make.centerY.equalTo(currencyLabel.snp.centerY)
            make.leading.equalTo(currencyLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }

        view.addSubview(currenciesTableView)
        currenciesTableView.snp.makeConstraints { make in
            make.top.equalTo(amountTextFiled.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        setupFunctionality()
        bindView()
    }
}

extension CurrencyConverterVC {
    private func setupFunctionality() {
        dropDownView.anchorView = currencySelectionView
        dropDownView.selectionAction = { [unowned self] (_, item) in
            currencyLabel.text = item.uppercased()
            viewModel.selectedCurrencyCode = item
            viewModel.updateCurrencyRate()
            dropDownView.hide()
            currenciesTableView.reloadData()
        }
    }
}

extension CurrencyConverterVC {
    private func bindView() {
        viewModel.$currencyRateList.sink { [unowned self] (data) in
            dropDownView.dataSource = data?.sorted { $0.key < $1.key }.map { $0.key } ?? []
            DispatchQueue.main.async {
                self.currenciesTableView.reloadData()
            }
        }.store(in: &subscription)
    }
}

extension CurrencyConverterVC {
    @objc private func showDropDown() {
        dropDownView.show()
    }

    @objc private func onChangeAmount() {
        currenciesTableView.reloadData()
    }
}

extension CurrencyConverterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyRateList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyValueTableViewCell", for: indexPath) as! CurrencyValueTableViewCell

        cell.populateCell(
            currencyCode: viewModel.sortedCurrencyCode?[indexPath.row],
            currencyDetails: viewModel.sortedCurrencyCodeDetails?[indexPath.row],
            amount: Double(amountTextFiled.text ?? "0.0") ?? 0.0,
            currencyValue: viewModel.currencyRateList?[viewModel.sortedCurrencyCode?[indexPath.row] ?? "USD"] ?? 0.0
        )
        return cell
    }
}
