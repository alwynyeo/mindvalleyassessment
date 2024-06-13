//
//  PersistenceService.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/12/24.
//

import UIKit
import CoreData

final class PersistenceService {
    // MARK: - Declarations

    static let shared = PersistenceService()

    private let context: NSManagedObjectContext

    private let encoder: JSONEncoder

    private let decoder: JSONDecoder

    // MARK: - Object Lifecycle

    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        self.context = context
        self.encoder = encoder
        self.decoder = decoder
    }

    // MARK: - Public Methods

    func persist(newEpisode: NewEpisode) {
        let entities = getNewEpisodeEntities()
        delete(newEpisodeEntities: entities)
        save(newEpisode: newEpisode)
    }

    func persist(channel: Channel) {
        let entities = getChannelEntities()
        delete(channelEntities: entities)
        save(channel: channel)
    }

    func persist(category: Category) {
        let entities = getCategoryEntities()
        delete(categoryEntities: entities)
        save(category: category)
    }

    func deleteAll() {
        let newEpisodeEntities = getNewEpisodeEntities()
        let channelEntities = getChannelEntities()
        let categoryEntities = getCategoryEntities()

        delete(newEpisodeEntities: newEpisodeEntities)
        delete(channelEntities: channelEntities)
        delete(categoryEntities: categoryEntities)

        saveContext()
    }

    // MARK: - Helpers

    private func constructNewEpisode() -> NewEpisode {
        let entities = getNewEpisodeEntities()
        print("core data new episodes:", entities.count)
        let media = entities.map { $0.mapToNewEpisodeMedia() }
        let data = NewEpisode.Data(media: media)
        let newEpisode = NewEpisode(data: data)
        return newEpisode
    }

    private func constructChannel() -> Channel {
        let entities = getChannelEntities()
        print("core data channels:", entities.count)
        let channels = entities.map { $0.mapToChannel(decoder: decoder) }
        let data = Channel.Data(channels: channels)
        let channel = Channel(data: data)
        return channel
    }

    private func constructCategory() -> Category {
        let entities = getCategoryEntities()
        print("core data categories:", entities.count)
        let categories = entities.map { $0.mapToCategory() }
        let data = Category.Data(categories: categories)
        let category = Category(data: data)
        return category
    }

    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription) happened while saving context under \(#function) at line \(#line) in \(#fileID) file.")
        }
    }
}

// MARK: - ListChannelServiceProtocol
extension PersistenceService: ListChannelServiceProtocol {
    func getNewEpisodes(completion: @escaping (NewEpisodeResultType) -> Void) {
        let newEpisode = constructNewEpisode()
        completion(NewEpisodeResultType.success(newEpisode))
    }

    func getChannels(completion: @escaping (ChannelResultType) -> Void) {
        let channel = constructChannel()
        completion(ChannelResultType.success(channel))
    }

    func getCategories(completion: @escaping (CategoryResultType) -> Void) {
        let category = constructCategory()
        completion(CategoryResultType.success(category))
    }
}

// MARK: - NewEpisode Related Private Helpers
private extension PersistenceService {
    func getNewEpisodeEntityFetchRequest() -> NSFetchRequest<NewEpisodeEntity> {
        let request = NewEpisodeEntity.fetchRequest()
        let idKey = "id"
        let sortById = NSSortDescriptor(key: idKey, ascending: true)
        let sortDescriptors = [
            sortById
        ]

        request.sortDescriptors = sortDescriptors

        return request
    }

    func getNewEpisodeEntities() -> [NewEpisodeEntity] {
        let request = getNewEpisodeEntityFetchRequest()

        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            print("Error: \(error.localizedDescription) happened while fetching NewEpisodeEntities under \(#function) at line \(#line) in \(#fileID) file.")
            return []
        }
    }

    func save(newEpisode: NewEpisode) {
        guard let data = newEpisode.data else {
            print("new episode data is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        guard let media = data.media else {
            print("new episode media is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        media.enumerated().forEach { saveNewEpisodeEntity(media: $0.element, at: $0.offset) }

        saveContext()
    }


    func saveNewEpisodeEntity(media: NewEpisode.Media, at index: Int) {
        let newEpisodeEntity = NewEpisodeEntity(context: context)
        newEpisodeEntity.set(media: media, at: index)
    }

    func delete(newEpisodeEntities: [NewEpisodeEntity]) {
        newEpisodeEntities.forEach { context.delete($0) }
    }
}

// MARK: - Channel Related Private Helpers
private extension PersistenceService {
    func getChannelEntityFetchRequest() -> NSFetchRequest<ChannelEntity> {
        let request = ChannelEntity.fetchRequest()
        let idKey = "id"
        let sortById = NSSortDescriptor(key: idKey, ascending: true)
        let sortDescriptors = [
            sortById
        ]

        request.sortDescriptors = sortDescriptors

        return request
    }

    func getChannelEntities() -> [ChannelEntity] {
        let request = getChannelEntityFetchRequest()

        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            print("Error: \(error.localizedDescription) happened while fetching ChannelEntities under \(#function) at line \(#line) in \(#fileID) file.")
            return []
        }
    }

    func save(channel: Channel) {
        guard let data = channel.data else {
            print("channel data is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        guard let channels = data.channels else {
            print("channels is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        channels.enumerated().forEach { saveChannelEntity(channel: $0.element, at: $0.offset) }

        saveContext()
    }

    func saveChannelEntity(channel: Channel.Channel, at index: Int) {
        let channelEntity = ChannelEntity(context: context)
        channelEntity.set(
            channel: channel,
            at: index,
            encoder: encoder,
            context: context
        )
    }

    func delete(channelEntities: [ChannelEntity]) {
        channelEntities.forEach { context.delete($0) }
    }
}

// MARK: - Category Related Private Helpers
private extension PersistenceService {
    func getCategoryEntityFetchRequest() -> NSFetchRequest<CategoryEntity> {
        let request = CategoryEntity.fetchRequest()
        let idKey = "id"
        let sortById = NSSortDescriptor(key: idKey, ascending: true)
        let sortDescriptors = [
            sortById
        ]

        request.sortDescriptors = sortDescriptors

        return request
    }

    func getCategoryEntities() -> [CategoryEntity] {
        let request = getCategoryEntityFetchRequest()

        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            print("Error: \(error.localizedDescription) happened while fetching CategoryEntities under \(#function) at line \(#line) in \(#fileID) file.")
            return []
        }
    }

    func save(category: Category) {
        guard let data = category.data else {
            print("category data is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        guard let categories = data.categories else {
            print("categories is nil under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        categories.enumerated().forEach { saveCategoryEntity(category: $0.element, at: $0.offset) }

        saveContext()
    }

    func saveCategoryEntity(category: Category.Category, at index: Int) {
        let categoryEntity = CategoryEntity(context: context)
        categoryEntity.set(category: category, at: index)
    }

    func delete(categoryEntities: [CategoryEntity]) {
        categoryEntities.forEach { context.delete($0) }
    }
}
