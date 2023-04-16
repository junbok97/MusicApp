//
//  SavedListViewController.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit

final class SavedListViewController: UIViewController {
    
    let musicManager = MusicManager.shared
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        SavedMusicCell.register(target: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTableViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupNavi() {
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationItem.title = "Saved Music List"
        navigationItem.titleView?.tintColor = .systemBackground
        
    }

}

// MARK: - AutoLayout
extension SavedListViewController {
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
extension SavedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicManager.getMusicSavedArraysFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SavedMusicCell.dequeueReusableCell(target: tableView, indexPath: indexPath)
        
        cell.musicSaved =  musicManager.getMusicSavedArraysFromCoreData()[indexPath.row]
        cell.saveButtonDelegate = { musicSaved in
            let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.musicManager.deleteMusicSavedFromCoreData(with: musicSaved) {
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
        
        cell.updateButtonDelegate =  { musicSaved in
            let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 문장을 입력하세요", preferredStyle: .alert)
            alert.addTextField {
                $0.text = musicSaved.myMessage ?? ""
            }
            
            let ok = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let self = self else { return }
                musicSaved.myMessage = alert.textFields?[0].text
                self.musicManager.updateMusicSavedToCoreData(with: musicSaved) {
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
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SavedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



