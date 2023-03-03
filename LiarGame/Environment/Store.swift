//
//  Store.swift
//  LiarGame
//
//  Created by 김민성 on 2023/03/02.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

class Store: ObservableObject {
    @Published private(set) var isPurchased: Bool = false
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        updateListenerTask = listenForTransactions()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver products to the user.
                    Task {
                        do {
                            guard let product = try await Product.products(for: ["item01"]).first else { return }
                            await self.updateCustomerProductStatus(product: product)
                        } catch {
                            
                        }
                    }
                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus(product: Product) async {
        Task {
            guard let state = await product.currentEntitlement else { return }
            switch state {
            case .verified(_):
                self.isPurchased = true
            case .unverified(_, _):
                self.isPurchased = false
            }
        }
    }
    
    func purchase() async throws -> Transaction?  {
        
            do {
                guard let product = try await Product.products(for: ["item01"]).first else { return nil }
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    //Check whether the transaction is verified. If it isn't,
                    //this function rethrows the verification error.
                    let transaction = try checkVerified(verification)

                    //The transaction is verified. Deliver content to the user.
                    await updateCustomerProductStatus(product: product)

                    //Always finish a transaction.
                    await transaction.finish()

                    return transaction
                case .userCancelled, .pending:
                    return nil
                default:
                    return nil
                }
            } catch {
                return nil
            }
        }
    
}
