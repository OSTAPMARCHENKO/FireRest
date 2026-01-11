# FireRest 🔥

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Unified Network & Storage Transport for Swift.**

FireRest is a protocol-oriented abstraction layer that allows you to seamlessly switch between **REST API** (URLSession) and **Firebase** (Firestore & Storage) without changing your business logic.

## 💡 Why FireRest?

Starting a project with Firebase is fast, but migrating away from it later is painful. FireRest solves this by decoupling your app's logic from the specific backend implementation.

* **Zero Hard Dependencies:** The core package is lightweight. You only add the Firebase SDK if you actually use the Firebase implementation.
* **Unified Storage:** Upload and download files using a common interface, whether you use Firebase Storage or a custom file server.
* **Type-Safe:** Built-in support for generic `Codable` responses and typed errors.
* **Async/Await:** Built purely for modern Swift concurrency.

---

## 🛠 How to Use

FireRest 🔥 separates the **Core Protocols** (installed via SPM) from the **Network Logic** (which you choose).

### 1. Choose a Transport
You need an implementation to send requests.
* **Ready-made:** Copy files from the **[Implementations folder](Implementations)** (REST or Firebase).
* **Custom:** Create your own class conforming to `NetworkTransport` (e.g., for Alamofire or Mocks).

### 2. See Examples
For setup, request definitions, and usage:
👉 **[Check the Examples folder](Examples)**

---

## 📦 Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/OSTAPMARCHENKO/FireRest.git", from: "2.2.0")
]
