# 건디마켓

실제 서버와 REST API 통신을 하는 물건 거래 앱으로, [iOS 오픈마켓](https://github.com/Gundy93/ios-open-market)의 리팩토링 프로젝트입니다.

## 📚 목차

- [🔑 **키워드**](#-키워드)
- [🏗️ **앱 구조**](#-앱-구조)
- [📱 **실행 화면**](#-실행-화면)
- [❤️‍🩹 **트러블 슈팅**](#-트러블-슈팅)
- [💭 **이유 있는 코드**](#-이유-있는-코드)

## 🔑 키워드

- **P**rotocol **O**riented **P**rogramming
- **MVVM**
- **Clean Architecture**
- **Network**
- **Cache**
- **Unit Test**

[⬆️ 목차로 돌아가기](#-목차)

## 🏗️ 앱 구조

### 개발방법론: Protocol Oriented Programming

프로토콜과 값 타입을 사용해 프로토콜 지향으로 개발을 하면 클래스를 사용한 객체 지향보다 여러 성능적인 이점을 얻을 수 있습니다. 이번 프로젝트에서는 애플에서 적극 권장하는 POP를 토대로 개발을 진행하는 것을 목표로 합니다. 그러나 이는 값 타입을 사용할 뿐이고, 타입의 구현은 SOLID 등의 기본적인 객체지향 원칙을 지키는 방향으로 설계했습니다.

### 아키텍쳐: MVVM

![MVVM](https://hackmd.io/_uploads/HJlSHhfpT.png)

Cocoa MVC보다 테스터블한 코드를 만들고자 했기 때문에 뷰와 로직을 완전히 분리시킬 수 있는 MVVM을 선택하였습니다. 이 프로젝트에서 ViewController는 뷰로 간주합니다.

### Clean Architecture

![CleanArchitecture](https://hackmd.io/_uploads/SkWCBaMTa.png)

레이어를 나누고 의존성 방향의 규칙을 지키는 선에서 Clean Architecture를 적용하면 테스터블함은 물론이고 OCP 등의 객체 지향 원칙들을 더욱 잘 준수할 수 있으리라 생각해 적용하기로 하였습니다.

### Network

![NetwrokManager](https://hackmd.io/_uploads/rkpfJAGpa.png)

네트워크 레이어에서 외부의 레이어와 소통하는 것은 NetworkManager 객체입니다. 이 NetworkManager는 특정 타입에 대해 의존하지 않도록 의존성을 프로토콜로 추상화시켜 각종 객체 지향 원칙을 지키도록 하였습니다.

### Cache

이미지에 대해서는 On-disk와 In-memory 방식으로 캐싱을 진행합니다. 네트워크 레이어와 마찬가지로 특정 타입에 의존하지 않도록 프로토콜을 활용하였습니다.

### Unit Test

POP, 그리고 MVVM에서 얻을 수 있는 장점으로는 역시 testability를 꼽고 싶습니다. 이번 프로젝트의 아키텍처 선정 사유중 가장 중요한 부분이 테스터블함이기 때문에 모든 기능에 대해 Unit Test를 실시하는 것을 목표로 하였습니다. 테스트는 실제로 인터넷 연결이 되지 않은 상황에서도 가능해야 하므로 네트워크에 대해서는 테스트 더블을 활용하였습니다.

[⬆️ 목차로 돌아가기](#-목차)

## 📱 실행 화면

// 실행 화면

[⬆️ 목차로 돌아가기](#-목차)

## ❤️‍🩹 트러블 슈팅

### DecodingError.typeMismatch

네트워크 레이어 설계를 마친 김에 상품 목록을 받아오는 작업을 수행했습니다. 예상과는 다르게 다음과 같은 에러가 반환되었습니다.

![스크린샷 2024-03-02 오전 4.33.14](https://hackmd.io/_uploads/By8YpiJaa.png)

에러를 반환하는 여러 지점에 브레이크 포인트를 만들어서 확인한 결과 `JSONDecoder`의 `decode` 메서드가 에러를 반환하는 것이었습니다.

LLDB를 통해 정확한 에러를 확인할 수 있었습니다.

![스크린샷 2024-03-02 오전 4.35.32](https://hackmd.io/_uploads/rJGzAsJ6T.png)

`created_at`에 해당하는 값이 잘못 들어오는가 싶어 정확히 데이터가 어떻게 들어오는지도 확인해보았습니다. 알고보니 API 안내 페이지에 명시된 `Date` 타입의 값이 아닌 `String` 값이 들어오는 것이었습니다.

![스크린샷 2024-03-02 오전 4.38.42](https://hackmd.io/_uploads/HyApRok6a.png)

|기존|수정|
|:--:|:--:|
|![스크린샷 2024-03-02 오전 4.40.00](https://hackmd.io/_uploads/HyRzynk6p.png)|![스크린샷 2024-03-02 오전 4.40.34](https://hackmd.io/_uploads/Bk6Ekn16T.png)|

해당 프로퍼티들을 `String` 타입으로 변경하는 것으로 문제가 해결되었습니다.

이로 인해 단순히 JSON 데이터를 디코딩하기 위한 객체도 테스트를 진행하는 것이 옳다고 생각하게 돼, 바로 테스트를 작성하게 되었습니다.

### Date 관련 테스트 실패

날짜를 표현하는 `String` 값과 `Date`를 비교하여 `TimeInterval`을 반환하는 메서드를 테스트하였습니다. 2001년 1월 1일을 의미하는 `ReferenceDate`를 기준으로 하여 `"2001-01-02T00:00:00"`를 비교하면 딱 하루 차이가 나기 때문에 하루를 초단위로 환산한 `86400.0`이 반환될 것이라 예상했습니다.

![스크린샷 2024-03-05 오후 7.34.35](https://hackmd.io/_uploads/rJPBS_Ep6.png)

하지만 테스트 결과 반환되는 값은 `86400.0`이 아닌 `54,000.0`이었습니다. `Date(timeIntervalSinceReferenceDate:)`에 값을 전달하면서 'UTC'라는 단어를 본 기억이 나 다시 문서를 확인했습니다.

![스크린샷 2024-03-05 오후 7.39.14](https://hackmd.io/_uploads/HJWwUOEaT.png)

2001년 1월 1일인 것은 맞지만, UTC가 기준이었습니다.

![스크린샷 2024-03-05 오후 7.41.55](https://hackmd.io/_uploads/BJeWw_Eaa.png)

하지만 `DateFormatter`의 인스턴스는 `timeZone` 프로퍼티를 따로 설정하지 않으면 시스템 시간대가 적용되므로 이러한 오류가 발생하는 것이었습니다.

```swift
formatter.timeZone = TimeZone(abbreviation: "UTC")
```

![스크린샷 2024-03-05 오후 7.45.15](https://hackmd.io/_uploads/rJFTw_46a.png)

`DateFormatter` 인스턴스를 설정할 때 `timeZone` 프로퍼티도 같이 설정하여 문제를 해결하였습니다.

[⬆️ 목차로 돌아가기](#-목차)

## 💭 이유 있는 코드

### 비슷한 JSON 데이터에 대응하는 DTO

|상품 리스트 조회 Response|상품 상세 조회 Response|
|:--:|:--:
|![스크린샷 2024-02-29 오후 3.09.40](https://hackmd.io/_uploads/H1tPMjT3a.png)|![스크린샷 2024-02-29 오후 3.09.28](https://hackmd.io/_uploads/ByMuGip3T.png)|

두 Response의 값은 대체로 비슷합니다. `images`를 제외하면 큰 차이가 없다고 할 수 있습니다. 이 두 종류의 Response에 대응할 수 있도록 중복되는 프로퍼티를 묶고, 필요한 프로퍼티만 남기도록 했습니다. 또한 상세 조회에만 제공되는 `images`와 `vendors`는 옵셔널로 선언하는 것으로 하나의 `DTO` 타입으로 두 조회 모두에서 사용할 수 있도록 하였습니다.

```swift
struct ProductDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnailURL: String
    let currency: Currency
    let price: Int
    let createdAt: String
    let issuedAt: String
    let images: [ProductImage]?
    let vendor: Vendor?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, currency, images
        case thumbnailURL = "thumbnail"
        case price = "bargain_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case vendor = "vendors"
    }
}
```

### NetworkManager

매니저라는 이름에 걸맞도록 범용적인 네트워크 작업을 수행할 수 있도록 네트워크 레이어를 설계했습니다. 또한 특정 타입에 의존하지 않도록 프로토콜을 통해 추상화하여 DIP를 준수할 수 있도록 하였습니다.

`URLRequest`를 적절히 만들고, 응답에 대한 처리를 할 수 있는 `NetworkBuilderProtocol`을 매개변수로 전달받아 네트워킹을 진행하는 `NetworkSessionProtocol`을 통해 작업을 수행합니다.

```swift
final class NetworkManager {
    private let session: NetworkSessionProtocol
    
    init(session: NetworkSessionProtocol) {
        self.session = session
    }
    
    func request<Builder: NetworkBuilderProtocol>(
        _ builder: Builder,
        completion: @escaping (Result<Builder.Response, Error>) -> Void
    ) {
        ...
        session.dataTask(with: request) { result in
            ...
        }
        ...
    }
}

protocol NetworkSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

protocol NetworkBuilderProtocol {
    associatedtype Response: Decodable

    var baseURL: String { get }
    var path: String { get }
    var queryItems: [String : String] { get }
    var headers: [String : String] { get }
    var parameters: [String : Any] { get }
    var httpMethod: String { get }
    var serializer: NetworkSerializable? { get }
    var deserializer: NetworkDeserializable { get }
}
```

`NetworkBuilderProtocol`가 `httpMethod`를 프로퍼티로 갖도록 하여 `NetworkManager`의 `request` 메서드 하나로 `GET`, `POST`, `PATCH`, `DELETE` 등 다양한 HTTPMethod를 처리할 수 있도록 하였습니다.

또한 `NetworkSessionProtocol`의 경우는 프로토콜로 추상화되었기 때문에 인터넷 연결이 되지 않은 상황에서도 테스트할 수 있는 Test Double을 목표로 하였습니다. 단순히 매개변수를 채우기 위한 `MockNetworkBuilder`와 지정된 값을 반환하는 `StubNetworkSession`을 만들어 테스트를 진행하였습니다.

[⬆️ 목차로 돌아가기](#-목차)
