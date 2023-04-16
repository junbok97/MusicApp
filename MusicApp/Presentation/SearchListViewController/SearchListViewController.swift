//
//  ViewController.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit

final class SearchListViewController: UIViewController {
    
    let musicManager = MusicManager.shared
    
    let searchController = UISearchController()
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        MusicCell.register(target: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatas("jazz")
        setupNavi()
        setupTableViewConstraints()
        setupSearchBar()
    }
    
    
}

extension SearchListViewController {
    
}


// MARK: - UI
private extension SearchListViewController {
    func setupDatas(_ text: String) {
        Task {
            await musicManager.fetchMusicArraysFromAPI(withTerm: text)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupNavi() {
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Musiuc Search"
        navigationItem.titleView?.tintColor = .systemBackground
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }

    
    func setupTableViewConstraints() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SearchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicManager.getMusicArraysFromAPI().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicCell.dequeueReusableCell(target: tableView, indexPath: nil)
        cell.music = musicManager.getMusicArraysFromAPI()[indexPath.row]
        cell.saveButtonDelegate = { [weak self] music in
            if music.isSaved {
                self?.makeRemoveCheckAlert(music: music)
            } else {
                self?.makeMessageAlert(music: music)
            }
        }
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension SearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - Alert
extension SearchListViewController {

    func makeMessageAlert(music: Music) {
        let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 문장을 입력하세요", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "저장하려는 메세지" }
        var savedText: String? = ""
        let ok = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else  { return }
            savedText = alert.textFields?[0].text
            self.musicManager.saveMusicDataToCoreData(with: music, message: savedText) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func makeRemoveCheckAlert(music: Music) {
        let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까 ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.musicManager.deleteMusicFromCoreData(with: music) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
        setupDatas(text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
    }
}

