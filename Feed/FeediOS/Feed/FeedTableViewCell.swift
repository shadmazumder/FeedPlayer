//
//  FeedTableViewCell.swift
//  FeediOS
//
//  Created by Shad Mazumder on 24/1/22.
//

import UIKit
import AVFoundation

public class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak public private(set) var feedTitle: UILabel!
    @IBOutlet weak public private(set) var feedDescription: UILabel!
    
    @IBOutlet weak var playerView: PlayerView!

    @IBAction func like(_ sender: Any) {}
    
    @IBAction func moreInfo(_ sender: Any) {}
    
    @IBAction func share(_ sender: Any) {}
    
    func configure(with feed: FeedViewModel){
        feedTitle.text = feed.title
        feedDescription.text = feed.description
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        feedTitle.text = nil
        feedDescription.text = nil
    }
    
    func play(on player: AVPlayer?,for source: String?){
        guard let source = source, let url = URL(string: source) else {
            return
        }
        playerView.player = player
        playerView.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
        playerView.player?.playImmediately(atRate: 1.0)
    }
    
    func stop(){
        playerView.player?.pause()
        playerView.player = nil
    }
}
