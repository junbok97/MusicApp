//
//  SavedMusicCell.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit

final class SavedMusicCell: UITableViewCell, UITableViewCellReigster {
    
    static let cellId: String = "SavedMusicCell"
    static let isFromNib: Bool = false
    
    var saveButtonDelegate: ((MusicSaved) -> Void)?
    var updateButtonDelegate: ((MusicSaved) -> Void)?
    

    var musicSaved: MusicSaved? {
        didSet {
            configureUIWithData()
        }
    }

    
    private lazy var mainImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButtonView: UIView = {
        let view = UIView()
        view.addSubview(saveButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var savedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var commentMessegeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var updateButtonView: UIView = {
        let view = UIView()
        view.addSubview(updateButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [songNameLabel, artistNameLabel, albumNameLabel, releaseDateLabel, saveButtonView, savedDateLabel, commentMessegeLabel, updateButtonView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupMainImageViewConstraints()
        setupStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func saveButtonTapped() {
        guard let musicSaved = musicSaved else { return }
        saveButtonDelegate?(musicSaved)
    }
    
    @objc func updateButtonTapped() {
        guard let musicSaved = musicSaved else { return }
        updateButtonDelegate?(musicSaved)
    }
    
    func configureUIWithData() {
        guard let musicSaved = musicSaved else { return }
        loadImage(with: musicSaved.imageUrl)
        songNameLabel.text =  musicSaved.songName
        artistNameLabel.text = musicSaved.artistName
        albumNameLabel.text = musicSaved.albumName
        releaseDateLabel.text = musicSaved.releaseDate
        savedDateLabel.text = musicSaved.savedDateString
        commentMessegeLabel.text = musicSaved.myMessage
        
    }
    
    private func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
}


// MARK: - AutoLayout
extension SavedMusicCell {
    
    private func setupMainImageViewConstraints() {
        contentView.addSubview(mainImageView)
        
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            mainImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupStackViewConstraints() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            saveButtonView.heightAnchor.constraint(equalToConstant: 30),
            
            saveButton.trailingAnchor.constraint(equalTo: self.saveButtonView.trailingAnchor),
            saveButton.centerYAnchor.constraint(equalTo: self.saveButtonView.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            
            updateButtonView.heightAnchor.constraint(equalToConstant: 30),
            
            updateButton.leadingAnchor.constraint(equalTo: self.updateButtonView.leadingAnchor),
            updateButton.topAnchor.constraint(equalTo: self.updateButtonView.topAnchor),
            updateButton.widthAnchor.constraint(equalToConstant: 60),
            updateButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

