//
//  CountriesListViewController.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-02.
//

import Foundation
import UIKit
import Alamofire

class CountriesListViewController: UITableViewController {
    private var countryService: CountryService?
    
    private var countries: [CountryDetail]?
    private var onError = false
    private let errorLoading = "😩 An error has occurred! Please try again."
    private var request: DataRequest?
    
    init(countryService: CountryService?) {
        super.init(nibName: nil, bundle: nil)
        self.countryService = countryService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ErrorCell")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(startRefreshData(_:)), for: .valueChanged)
        
        super.viewDidLoad()
        buildView()
        loadCountries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        request?.cancel()
    }
    
    private func loadCountries() {
        guard let countryService = countryService else { return }
        request = countryService.fetchCountries() { [weak self] response in
            MainActor.assumeIsolated {
                guard let this = self else { return }
                switch response {
                case .success(let countries):
                    this.onError = false
                    this.countries = countries
                    this.tableView.reloadData()
                    this.endRefreshData()
                    
                case .failure(_):
                    this.onError = true
                    this.tableView.reloadData()
                    this.endRefreshData()
                }
            }
        }
    }
    
    @objc private func startRefreshData(_ sender: Any) {
        request?.cancel()
        countries = [];
        tableView.reloadData()
        loadCountries()
    }
    
    @objc private func endRefreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func buildView() {
        view.backgroundColor = .white
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onError ? 1 : countries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !onError else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath)
            cell.textLabel?.text =  errorLoading
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textAlignment = .center
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = countries?[indexPath.row].name?.common ?? ""
        cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayDetail(for: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Liste des pays"
    }
    
    private func displayDetail(for indexCountry: Int) {
        let newViewController = CountryDetailViewController(country: countries?[indexCountry], countryService: try? AppContainer.shared.resolve())
        navigationController?.pushViewController(newViewController, animated: true)
    }
}
