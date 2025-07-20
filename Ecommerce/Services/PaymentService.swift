//
//  PaymentService.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 20.07.2025.
//

import Foundation
import PassKit

class PaymentService: NSObject {

    var paymentController: PKPaymentAuthorizationController?
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var paymentCompletionHandler: ((Bool) -> Void)?
    

    func startPayment(productInCart: [ProductInCart], completion: @escaping (Bool) -> Void) {
        
        paymentCompletionHandler = completion
        
       // create payment summary items
        
        var paymentSummaryItems = [PKPaymentSummaryItem]()
        
        paymentSummaryItems = productInCart.map {
            PKPaymentSummaryItem(
                label: "XXX: \($0.product.title) x \($0.quantity)",
                amount: NSDecimalNumber(value: $0.quantity * $0.product.price),
                type: .final
            )
        }
        
        let totalPrice = productInCart.reduce(0) {
            $0 + ($1.quantity * $1.product.price)
        }
        
        //  Тип .final означает, что сумма окончательная.
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: totalPrice), type: .final)
        paymentSummaryItems.append(total)
        
        // create a payment request
        
        let paymentRequest = PKPaymentRequest()
        // Устанавливаем список товаров и сумму — это будет показано пользователю в Apple Pay UI.
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        
        //  Это Merchant ID, который ты создавал в Apple Developer Portal.
        // 🔸 Этот ID должен быть активирован, связан с App ID и добавлен в provisioning profile.
        // 🔸 Он подтверждает, что ты — доверенный продавец, и разрешено принимать Apple Pay.
        paymentRequest.merchantIdentifier = "merchant.com.dyaremenko.ecommerce"
        
        //  Указываются платёжные системы, которые ты принимаешь.
        paymentRequest.supportedNetworks = [.visa, .masterCard]
        
        // ✅ Способности продавца:
        // .threeDSecure: безопасная аутентификация (3D Secure)
        // .capabilityCredit, .capabilityDebit: поддержка кредитных/дебетовых карт
        // 🛡 Apple требует хотя бы .threeDSecure.
        paymentRequest.merchantCapabilities = .threeDSecure
        
        //  Страна магазина (не пользователя). Двухбуквенный ISO 3166-1 alpha-2 код страны.
        paymentRequest.countryCode = "US"
        
        //  Валюта, в которой указаны суммы товаров (ISO 4217 код):
        paymentRequest.currencyCode = "USD"
        
        let standardShipping = PKShippingMethod(label: "Standard Shipping", amount: 1.00)
        standardShipping.identifier = "standard"
        standardShipping.detail = "Delivers in 5–7 days"

        let expressShipping = PKShippingMethod(label: "Express Shipping", amount: 2.00)
        expressShipping.identifier = "express"
        expressShipping.detail = "Delivers in 1–2 days"

        paymentRequest.shippingMethods = [standardShipping, expressShipping]
        
        // Это подсказка для Apple Pay, чтобы она знала контекст того, что именно вы доставляете.
        // Это не влияет на логику или цену, но визуально и логически помогает Apple Pay UI выбрать правильный стиль отображения.
//            .shipping – обычная доставка (например, физический товар по почте)
//            .delivery – локальная доставка (например, еда, курьерская доставка)
//            .storePickup – самовывоз из магазина
//            .servicePickup – самовывоз услуги (например, стирка, химчистка)
        paymentRequest.shippingType = .delivery

        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        paymentRequest.shippingMethods = shippingMethodCalculator()
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        
        paymentController?.present { isPresented in
            if isPresented {
                print("Payment controller successfully presented!")
            } else {
                print("!!! Payment controller failed to show")
            }
        }
    }

    private func shippingMethodCalculator() -> [PKShippingMethod] {
        let today = Date()
        let calendar = Calendar.current
        
        let shipingStart = calendar.date(byAdding: .day, value: 5, to: today)
        let shippingEnd = calendar.date(byAdding: .day, value: 10, to: today)
        
        if let shippingStart = shipingStart,
           let shippingEnd = shippingEnd {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
            let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
            
            let freeShippingDelivery = PKShippingMethod(label: "Free Delivery", amount: NSDecimalNumber(value: 0.0))
            freeShippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
            freeShippingDelivery.detail = "Free delivery"
            freeShippingDelivery.identifier = "FREEDELIVERY"
            
            return [freeShippingDelivery]
        }
        
        return []
    }
}

extension PaymentService: PKPaymentAuthorizationControllerDelegate {

 
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.paymentCompletionHandler?(true)
                } else {
                    self.paymentCompletionHandler?(false)
                }
            }
          
        }
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let status = PKPaymentAuthorizationStatus.success
        paymentStatus = status
        let errors = [Error]()
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
}
