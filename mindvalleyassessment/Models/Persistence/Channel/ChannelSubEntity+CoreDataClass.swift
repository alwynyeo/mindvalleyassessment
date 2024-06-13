//
//  ChannelSubEntity+CoreDataClass.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import Foundation
import CoreData


public class ChannelSubEntity: NSManagedObject {
    // MARK: - Helpers

    func mapToChannelItem() -> Channel.LatestMedia {
        let entity = self
        let title = entity.title
        let coverAsset = Channel.CoverAsset(url: entity.imageUrlString)
        let media = Channel.LatestMedia(
            type: nil,
            title: title,
            coverAsset: coverAsset
        )
        return media
    }

    func set(channelItem: Channel.LatestMedia, to parentEntity: ChannelEntity) {
        let entity = self
        let title = channelItem.title
        let imageUrlString = channelItem.coverAsset?.url

        entity.title = title
        entity.imageUrlString = imageUrlString

        parentEntity.addToChannelItems(entity)
    }
}
