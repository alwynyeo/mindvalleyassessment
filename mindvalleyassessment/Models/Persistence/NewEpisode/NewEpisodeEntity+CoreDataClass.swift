//
//  NewEpisodeEntity+CoreDataClass.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import CoreData

public class NewEpisodeEntity: NSManagedObject {
    // MARK: - Helpers

    func set(media: NewEpisode.Media, at index: Int) {
        let entity = self
        let id = Int64(index)
        let title = media.title
        let imageUrlString = media.coverAsset?.url
        let channelTitle = media.channel?.title

        entity.id = id
        entity.title = title
        entity.imageUrlString = imageUrlString
        entity.channelTitle = channelTitle
    }

    func mapToNewEpisodeMedia() -> NewEpisode.Media {
        let entity = self
        let type: String? = nil
        let title = entity.title
        let imageUrlString = entity.imageUrlString
        let channelTitle = entity.channelTitle
        let coverAsset = NewEpisode.CoverAsset(url: imageUrlString)
        let channel = NewEpisode.Channel(title: channelTitle)
        let newEpisodeMedia = NewEpisode.Media(
            type: type,
            title: title,
            coverAsset: coverAsset,
            channel: channel
        )
        return newEpisodeMedia
    }
}
