//
//  DependencyInjectionContainer.swift
//  BulkBuddy
//
//  Created by Leon Weimann on 14.03.24.
//

import Foundation

// MARK: InjectionKey Protocol

/// Conforming to this protocol means that you are an `InjectionKey`.
///
/// Creating a new `InjectionKey` is easy. The following implementation creates a new `InjectionKey` for a data manager.
///
///     protocol DataManagerProtocol {
///         // Protocol definitions here
///     }
///
///     struct DataManagerInjectionKey: InjectionKey {
///         static var currentValue: DataManagerProtocol = ProductionDataManager()
///     }
///
/// When a new `InjectionKey` is created, it cannot be utilized. To use the key, it must be added to the `InjectedValues`
/// through an extension.
protocol InjectionKey {
    /// The associated type `Value` represents the value of the injected object.
    associatedtype Value
    
    /// This property is responsible for storing the current value of the injected object.
    static var currentValue: Self.Value { get set }
}

// MARK: InjectedValues Container

/// `InjectedValues` is comparable to a `DependencyInjectionContainer`, optimized for applying property wrappers
/// and utilizing syntax similar to `EnvironmentValues`.
///
/// Adding new `InjectedValues` to this container is easy. The following implementation adds a data manager to the container.
///
///     struct DataManagerInjectionKey: InjectionKey {
///         static var currentValue: DataManagerProtocol = ProductionDataManager()
///     }
///
///     extension InjectedValues {
///         var dataManager: DataManagerProtocol {
///             get { Self[DataManagerInjectionKey.self] }
///             set { Self[DataManagerInjectionKey.self] = newValue }
///         }
///     }
///
/// After creating the `InjectionKey` for the new `InjectedValue`, adding this key through extending the `InjectedValues`
/// and implementing code like in this example is very simple.
/// The simplicity of expanding the functionality of `InjectedValues` is comparable to the implementation of `EnvironmentValues`.
struct InjectedValues {
    /// The current `InjectedValues` container makes `InjectedValues` a singleton, only accessible through the subscripts.
    private static var current = InjectedValues()
    
    static subscript<K>(_ key: K.Type) -> K.Value where K: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

// MARK: Injected PropertyWrapper

/// This property wrapper makes access to `InjectedValues` more comfortable and convenient.
@propertyWrapper
struct Injected<T> {
    /// Initializes an `InjectedValue` with a `keyPath`.
    ///
    /// - Parameter keyPath: The `keyPath` for the injected value.
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
    
    /// This property holds the `keyPath` for the injected value.
    private let keyPath: WritableKeyPath<InjectedValues, T>
    
    /// The wrapped value of the property wrapper.
    /// This is the interface between the property wrapper and the DependencyInjectionContainer.
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
}
