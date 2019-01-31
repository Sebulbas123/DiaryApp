//
//  EntryCell.swift
//  DiaryApp
//
//  Created by Sebastian Karlsson on 2018-09-24.
//  Copyright © 2018 com.Sebastian Karlsson. All rights reserved.
//


import UIKit

class EntryCell: UITableViewCell {
  static let reuseIdentifier = String(describing: EntryCell.self)
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var emoticonImage: UIImageView!
  @IBOutlet weak var photoImageView: UIImageView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    photoImageView.layer.masksToBounds = true
    photoImageView.layer.cornerRadius = 40
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configureCell(entry: Entry) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    let stringDate: String = dateFormatter.string(from: entry.creationDate)
    
    self.dateLabel.text = stringDate
    self.contentTextView.text = entry.contentText
    
    switch entry.emoticonStatus {
    case .bad:
      self.emoticonImage.image = #imageLiteral(resourceName: "icn_bad")
    case .average:
      self.emoticonImage.image = #imageLiteral(resourceName: "icn_average")
    case .happy:
      self.emoticonImage.image = #imageLiteral(resourceName: "icn_happy")
    }
    
    self.photoImageView.image = entry.image
    self.locationLabel.text = entry.locationName ?? "Not present"
  }
  
}

