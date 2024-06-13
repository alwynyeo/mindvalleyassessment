//
//  ChannelEntity+CoreDataClass.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import Foundation
import CoreData


public class ChannelEntity: NSManagedObject {
    // MARK: - Helpers

    func mapToChannel(decoder: JSONDecoder) -> Channel.Channel {
        let entity = self
        let id = String(entity.id)
        let mediaCount = Int(entity.mediaCount)
        let series = getDecodedChannelSeries(from: entity.series, decoder: decoder)
        let latestMedia = getLatestMedia(channelItems: entity.channelItems)
        let coverAsset = Channel.CoverAsset(url: entity.imageUrlString)

        let channel = Channel.Channel(
            title: title,
            series: series,
            mediaCount: mediaCount,
            latestMedia: latestMedia,
            id: id,
            iconAsset: nil,
            coverAsset: coverAsset
        )

        return channel
    }

    func set(channel: Channel.Channel, at index: Int, encoder: JSONEncoder, context: NSManagedObjectContext) {
        let entity = self
        let id = Int64(index)
        let title = channel.title
        let mediaCount = Int64(channel.mediaCount ?? 0)
        let imageUrlString = channel.coverAsset?.url
        let series = channel.series ?? []
        let latestMedia = channel.latestMedia ?? []

        entity.id = id
        entity.title = title
        entity.mediaCount = mediaCount
        entity.imageUrlString = imageUrlString
        entity.series = getEncodedChannelSeries(series: series, encoder: encoder)

        latestMedia.forEach { setChannelSubEntity(channelItem: $0, to: entity, context: context) }
    }

    private func setChannelSubEntity(channelItem: Channel.LatestMedia, to channelEntity: ChannelEntity, context: NSManagedObjectContext) {
        let channelSubEntity = ChannelSubEntity(context: context)
        channelSubEntity.set(channelItem: channelItem, to: channelEntity)
    }

    private func getEncodedChannelSeries(series: [Channel.Series], encoder: JSONEncoder) -> String? {
        let seriesIndices = series.enumerated().map { String($0.offset) }

        guard let data = try? encoder.encode(seriesIndices) else {
            print("channel series data is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return nil
        }

        let encodedSeries = String(data: data, encoding: String.Encoding.utf8)

        return encodedSeries
    }

    private func getDecodedChannelSeries(from encodedSeriesString: String?, decoder: JSONDecoder) -> [Channel.Series] {
        guard let encodedSeriesString = encodedSeriesString else { return [] }

        let data = Data(encodedSeriesString.utf8)

        do {
            let decodedSeriesStrings = try decoder.decode([String].self, from: data)
            let series = decodedSeriesStrings.map { _ -> Channel.Series in
                let coverAsset = Channel.CoverAsset(url: "")
                let series = Channel.Series(title: "", coverAsset: coverAsset)
                return series
            }
            return series
        } catch let error {
            print("Error: \(error.localizedDescription) happened while decoding data under \(#function) at line \(#line) in \(#fileID) file.")
            return []
        }
    }

    private func getLatestMedia(channelItems: NSOrderedSet?) -> [Channel.LatestMedia] {
        guard let channelItems = channelItems else { return [] }

        let latestMedia = channelItems.map { channelItem -> Channel.LatestMedia in
            let subEntity = channelItem as! ChannelSubEntity
            return subEntity.mapToChannelItem()
        }

        return latestMedia
    }
}
