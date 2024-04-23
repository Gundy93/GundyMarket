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

![MVVM](https://github.com/Gundy93/GundyMarket/assets/106914201/0875ec71-4084-4f9b-bcdb-f355e0728ba4)

Cocoa MVC보다 테스터블한 코드를 만들고자 했기 때문에 뷰와 로직을 완전히 분리시킬 수 있는 MVVM을 선택하였습니다. 이 프로젝트에서 ViewController는 뷰로 간주합니다.

### Clean Architecture

![CleanArchitecture](https://github.com/Gundy93/GundyMarket/assets/106914201/5ad8bd83-bd25-4aa6-8e48-60ddfb02a1e1)

레이어를 나누고 의존성 방향의 규칙을 지키는 선에서 Clean Architecture를 적용하면 테스터블함은 물론이고 OCP 등의 객체 지향 원칙들을 더욱 잘 준수할 수 있으리라 생각해 적용하기로 하였습니다.

### Network

![NetwrokManager](https://github.com/Gundy93/GundyMarket/assets/106914201/b85f3e5a-ac29-4b46-ac3d-ce596fa2342d)

네트워크 레이어에서 외부의 레이어와 소통하는 것은 NetworkManager 객체입니다. 이 NetworkManager는 특정 타입에 대해 의존하지 않도록 의존성을 프로토콜로 추상화시켜 각종 객체 지향 원칙을 지키도록 하였습니다.

### Cache

![Cache](https://github.com/Gundy93/GundyMarket/assets/106914201/ba0cecd0-72ca-4b2b-99c7-56e39a71587c)

네트워크 레이어와 마찬가지로 특정 타입에 의존하지 않도록 프로토콜을 활용하였습니다. `Cache`는 `CacheProtocol`을 채택합니다.

![ImageDataCacheManager](https://github.com/Gundy93/GundyMarket/assets/106914201/7bddd9a4-6ef5-4c3f-a4cb-de5c869707cb)

이미지에 대해서는 On-disk와 In-memory 방식으로 캐싱할 수 있도록 `ImageDataCacheManager`를 구성했습니다. 캐시에 데이터가 존재하지 않을 경우 세션을 통해 이미지를 받아오고 캐시에 저장하는 과정까지 `ImageDataCacheManager`가 담당합니다. 이번 프로젝트에서는 memory 캐시의 `CacheStorage`는 `NSCache`를 사용하였습니다.
하지만 disk 캐시는 사용하지 않는데, 현재 프로젝트의 특성상 디스크로 캐시할 필요가 없다고 느꼈기 때문입니다. 캐시를 유지하기 위해 불필요한 비용이 발생한다고 여겨 이번에는 메모리 캐시만 사용하기로 결정하였습니다.

### Unit Test

POP, 그리고 MVVM에서 얻을 수 있는 장점으로는 역시 testability를 꼽고 싶습니다. 이번 프로젝트의 아키텍처 선정 사유중 가장 중요한 부분이 테스터블함이기 때문입니다. 테스트는 실제로 인터넷 연결이 되지 않은 상황에서도 가능해야 하므로 네트워크에 대해서는 테스트 더블을 활용하였습니다.

[⬆️ 목차로 돌아가기](#-목차)

## 📱 실행 화면

### 기능 관련

|이미지 캐싱|||
|:-:|:-:|:-:|
||||

### UI 관련

|글쓰기 버튼 클릭시 색상 변환|||
|:-:|:-:|:-:|
||||

[⬆️ 목차로 돌아가기](#-목차)

## ❤️‍🩹 트러블 슈팅

### DecodingError.typeMismatch

네트워크 레이어 설계를 마친 김에 상품 목록을 받아오는 작업을 수행했습니다. 예상과는 다르게 다음과 같은 에러가 반환되었습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/e6c5e97a-7e64-4ee1-b745-3a7cbaa5b05b)

에러를 반환하는 여러 지점에 브레이크 포인트를 만들어서 확인한 결과 `JSONDecoder`의 `decode` 메서드가 에러를 반환하는 것이었습니다.

LLDB를 통해 정확한 에러를 확인할 수 있었습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/ed2ffdaf-be07-42ef-ba6c-60b46b996b2d)

`created_at`에 해당하는 값이 잘못 들어오는가 싶어 정확히 데이터가 어떻게 들어오는지도 확인해보았습니다. 알고보니 API 안내 페이지에 명시된 `Date` 타입의 값이 아닌 `String` 값이 들어오는 것이었습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/eafc879a-7825-4f37-8911-abd1eab4029b)

|기존|수정|
|:--:|:--:|
|![image](https://github.com/Gundy93/GundyMarket/assets/106914201/cc0d45d0-c90d-4e74-953d-59c0e682c068)|![image](https://github.com/Gundy93/GundyMarket/assets/106914201/0932d742-b8cf-4ac1-b9b6-4d726e516508)|

해당 프로퍼티들을 `String` 타입으로 변경하는 것으로 문제가 해결되었습니다.

이로 인해 단순히 JSON 데이터를 디코딩하기 위한 객체도 테스트를 진행하는 것이 옳다고 생각하게 돼, 바로 테스트를 작성하게 되었습니다.

### Date 관련 테스트 실패

날짜를 표현하는 `String` 값과 `Date`를 비교하여 `TimeInterval`을 반환하는 메서드를 테스트하였습니다. 2001년 1월 1일을 의미하는 `ReferenceDate`를 기준으로 하여 `"2001-01-02T00:00:00"`를 비교하면 딱 하루 차이가 나기 때문에 하루를 초단위로 환산한 `86400.0`이 반환될 것이라 예상했습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/287023df-e7e8-46f4-993e-bb262e7d2826)

하지만 테스트 결과 반환되는 값은 `86400.0`이 아닌 `54,000.0`이었습니다. `Date(timeIntervalSinceReferenceDate:)`에 값을 전달하면서 'UTC'라는 단어를 본 기억이 나 다시 문서를 확인했습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/337c7185-ae35-48d8-8391-fa265d027324)

2001년 1월 1일인 것은 맞지만, UTC가 기준이었습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/9f25a98d-48fe-4112-860c-a8a6eb8bb8fd)

하지만 `DateFormatter`의 인스턴스는 `timeZone` 프로퍼티를 따로 설정하지 않으면 시스템 시간대가 적용되므로 이러한 오류가 발생하는 것이었습니다.

```swift
formatter.timeZone = TimeZone(abbreviation: "UTC")
```

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/ba4ccd8e-17b1-4ed5-ac57-e48e051ffbb6)

`DateFormatter` 인스턴스를 설정할 때 `timeZone` 프로퍼티도 같이 설정하여 문제를 해결하였습니다.

### 셀의 높이가 44로 고정되는 현상

리스트 형태의 레이아웃을 사용하고, 셀간의 `separator`의 크기를 조절하기 위해 `UICollectionViewListCell`을 상속하는 커스텀 셀을 구현했습니다. 이 셀에서 이미지가 포함된 스택뷰의 `topAnchor`와 `bottomAnchor`를 `contentView`에 대해 오토레이아웃 제약 조건을 설정하고, 이미지의 높이와 너비를 120으로 설정하였습니다. 그런데 다음과 같은 오토레이아웃 제약 조건 에러가 발생했습니다.

```
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002134ff0 V:|-(16)-[UIStackView:0x106414d30]   (active, names: '|':_UICollectionViewListCellContentView:0x10642e6f0 )>",
    "<NSLayoutConstraint:0x600002134d20 UIStackView:0x106414d30.bottom == _UICollectionViewListCellContentView:0x10642e6f0.bottom - 16   (active)>",
    "<NSLayoutConstraint:0x600002134f50 UIImageView:0x10642d200.width == 120   (active)>",
    "<NSLayoutConstraint:0x600002134050 UIImageView:0x10642d200.height == UIImageView:0x10642d200.width   (active)>",
    "<NSLayoutConstraint:0x6000021355e0 'UICollectionViewListCell-bottom-contentView-constraint' V:[_UICollectionViewListCellContentView:0x10642e6f0]-(0)-|   (active, names: '|':GundyMarket.ProductListCell:0x106417710 )>",
    "<NSLayoutConstraint:0x600002135540 'UICollectionViewListCell-top-contentView-constraint' V:|-(0)-[_UICollectionViewListCellContentView:0x10642e6f0]   (active, names: '|':GundyMarket.ProductListCell:0x106417710 )>",
    "<NSLayoutConstraint:0x6000021363a0 'UISV-canvas-connection' UIStackView:0x106414d30.top == UIImageView:0x10642d200.top   (active)>",
    "<NSLayoutConstraint:0x600002136620 'UISV-canvas-connection' V:[_UILayoutSpacer:0x600003d01b30'UISV-alignment-spanner']-(0)-|   (active, names: '|':UIStackView:0x106414d30 )>",
    "<NSLayoutConstraint:0x6000021364e0 'UISV-spanning-boundary' _UILayoutSpacer:0x600003d01b30'UISV-alignment-spanner'.bottom >= UIImageView:0x10642d200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002136990 'UIView-Encapsulated-Layout-Height' GundyMarket.ProductListCell:0x106417710.height == 44   (active)>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600002134050 UIImageView:0x10642d200.height == UIImageView:0x10642d200.width   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
```

`UICollectionViewListCell`의 `height`는 44로 고정되는 제약 조건이 내부적으로 걸려있던 것입니다.

같은 우선도를 가진 조건이 충돌해 발생한 것으로, 해당 제약 조건은 `required`로 설정되어 있는 것으로 확인되었습니다.

몇 가지 확인 절차를 거쳤습니다.

1. `UICollectionViewListCell`의 문제인가?

    해당 셀이 상속하는 타입을 `UICollectionViewCell`로 변경해도 같은 문제가 발생했습니다.

2. `UICollectionLayoutListConfiguration`와 `UICollectionViewCompositionalLayout.list`의 문제인가?

    컬렉션뷰의 레이아웃을 통상적인 `UICollectionViewCompositionalLayout`으로 변경하니 해당 에러가 발생하지 않았습니다. 즉, 레이아웃에서 발생하는 제약인 것으로 확인했습니다.

문제를 정확히 파악하고 나서 레이아웃을 교체할지 고민을 했습니다. 하지만 레이아웃을 교체하는 대신 다음과 같은 방법으로 문제를 해결했습니다.

```swift
let ratioConstraint = thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        
ratioConstraint.priority = .defaultHigh
ratioConstraint.isActive = true
```

제약 우선순위를 `defaultHigh`로 낮춰 제약 조건이 충돌되지 않으면서도 셀 사이즈를 유지할 수 있게 하였습니다.

이 방법을 선택한 이유는 리스트를 구성하는 데 있어서 `UICollectionViewCompositionalLayout.list`를 사용하는 편이 훨씬 코드가 간단 명료하다. 즉, 해당 기능을 아는 사람이 본다면 바로 이해할 수 있을 정도로 가독성이 좋아진다는 것입니다. 또한 유지보수 측면에 있어서도 휴먼 에러가 발생할 여지가 더 적은 리스트 레이아웃을 사용하는 것이 좋다고 생각했습니다.

### 정확한 시각을 기록하지 않는 서버

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/bdebc54e-1717-4b9c-84a1-1c845fad8d46)

2시간 전에 올린 상품이 22시간 전으로 나타나는 현상을 발견했습니다. 처음에는 시간 차이를 계산하는 로직이 잘못되었다고 생각했습니다.

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/b1f9aaad-836a-4f50-8f5d-16fea5066b9d)

하지만 서버의 응답으로 제공되는 모든 데이터의 시간 값이 "yyyy-MM-dd'T'00:00:00"의 형태로 제공되는 것이었습니다.그래서 항상 자정까지의 시간차이를 계산하고 있었습니다.

모바일 상에서 업로드 된 시간을 알아낼 방법이 없으므로 시간 이하의 값은 보여주지 않는 것으로 코드를 변경했습니다.

```swift
// 변경 전

func string() -> String {
    if year > 0 {
        return String(year) + "년"
    } else if month > 0 {
        return String(month) + "달"
    } else if day > 0 {
        return String(day) + "일"
    } else if hour > 0 {
        return String(hour) + "시간"
    } else if minute > 0 {
        return String(minute) + "분"
    } else {
        return String(second) + "초"
    }
}

// 변경 후

func string() -> String {
    if year > 0 {
        return String(year) + "년"
    } else if month > 0 {
        return String(month) + "달"
    } else if day > 0 {
        return String(day) + "일"
    } else {
        return "방금"
    }
}
```

![image](https://github.com/Gundy93/GundyMarket/assets/106914201/2e06d2a1-051d-483e-a499-2dc68dacfdc3)

[⬆️ 목차로 돌아가기](#-목차)

## 💭 이유 있는 코드

### 비슷한 JSON 데이터에 대응하는 DTO

|상품 리스트 조회 Response|상품 상세 조회 Response|
|:--:|:--:
|![image](https://github.com/Gundy93/GundyMarket/assets/106914201/d63bd18a-36f8-4ac9-927c-d255eb7fde7a)|![image](https://github.com/Gundy93/GundyMarket/assets/106914201/54d9b419-e8ac-4917-8fd2-d14414731a08)|

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
