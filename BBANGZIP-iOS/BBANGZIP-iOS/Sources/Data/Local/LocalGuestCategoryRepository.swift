import Foundation

final class LocalGuestCategoryRepository: AddCategoryRepositoryProtocol,
                                          CategoryFetchRepository,
                                          CategoryUpdateRepository,
                                          CategoryDeleteRepository,
                                          CategoryOrderRepository,
                                          @unchecked Sendable {
    private let store: LocalGuestTodoStore

    init(store: LocalGuestTodoStore = .shared) {
        self.store = store
    }

    func addCategory(request: CategoryAddRequestDTO) async throws -> AddCategory {
        let category = try store.addCategory(
            name: request.name,
            color: CategoryColor.fromAPI(request.color)
        )

        return AddCategory(
            categoryId: category.id,
            name: category.name,
            color: category.colorType.apiValue,
            isStopped: category.isStopped
        )
    }

    func fetchCategories() async throws -> [Category] {
        store.categories()
    }

    func updateCategory(
        id: Int,
        name: String,
        color: String,
        isStopped: Bool
    ) async throws -> Category {
        let category = Category(
            id: id,
            name: name,
            colorType: CategoryColor.fromAPI(color),
            todos: [],
            isStopped: isStopped
        )
        try store.updateCategory(category)
        return try store.category(id: id)
    }

    func deleteCategory(id: Int) async throws {
        try store.deleteCategory(id: id)
    }

    func updateOrder(categoryIds: [Int]) async throws {
        try store.updateCategoryOrder(categoryIds: categoryIds)
    }
}
