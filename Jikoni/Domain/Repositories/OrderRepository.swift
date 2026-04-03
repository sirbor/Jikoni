import Foundation

protocol OrderRepository {
    func placeOrder(_ order: Order) async throws
    func fetchOrders(userId: String) async throws -> [Order]
    func streamOrders(userId: String) -> AsyncStream<[Order]>
    func streamActiveOrder(userId: String) -> AsyncStream<Order?>
}
