# 🏞️ Pictar (픽차)
> ### Unsplash API 기반의 고해상도 사진 검색 & 컬렉션 앱

<br />

## 📱 프로젝트 소개
> **개발 기간**: 2024.7.22 ~ 2024.7.28  
> **개발 인원**: 1인 (기획/디자인/개발)

<div align="center">
  <img width="24%" src="https://github.com/user-attachments/assets/18e4923b-6b7b-4a28-9834-680718323084" />
  <img width="24%" src="https://github.com/user-attachments/assets/3ab7e16e-2ed6-4460-8341-4fca9d4ca8ab" />
  <img width="24%" src="https://github.com/user-attachments/assets/68928e3c-2b7c-4a8c-b81f-286fbdfde638" />
  <img width="24%" src="https://github.com/user-attachments/assets/559ef1bd-e941-4626-ab68-30110bed8a52" />
</div>

<br />

## 🛠 기술 스택

### iOS
- **Language**: Swift 5.10
- **Framework**: UIKit
- **Minimum Target**: iOS 15.0

### 아키텍처 & 디자인 패턴
- **Architecture**: MVC
- **Design Pattern**: Singleton, Observer Pattern, Repository Pattern

### 데이터베이스 & 네트워킹
- **Local Storage**: Realm + FileManager
- **Network**: Alamofire
- **Image Caching**: Kingfisher

### 외부 라이브러리
- **UI/Layout**: SnapKit, Then
- **Utility**: Toast

## 📋 주요 기능

### Unsplash API 기반 사진 검색 시스템
- 최신순/관련순 정렬 기능 구현
- 12가지 컬러 필터를 통한 검색 결과 필터링
- 실시간 검색어 처리 및 결과 표시

### 오프셋 기반 페이지네이션 구현
- UICollectionViewDataSourcePrefetching 프로토콜 활용
- 페이지 번호 기반 오프셋 페이지네이션 구현
- 스크롤 위치 기반 자동 데이터 로딩
- 정렬 옵션 변경 시 페이지 초기화 처리


### 좋아요 기능과 이미지 관리
- Realm과 FileManager를 활용한 데이터 영구 저장
- DispatchGroup을 통한 비동기 이미지 처리
- 실시간 좋아요 상태 관리 및 UI 업데이트

## 🔧 시행착오

### 1. 오프셋 기반 페이지네이션 데이터 관리
#### 문제 상황
- 페이지 번호 관리 및 데이터 중복 문제
- 정렬 옵션 변경 시 페이지 초기화 필요
- 스크롤 시 데이터 로딩 시점 제어 필요

#### 해결 방안
```swift
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == searchList.results.count-1 && page < searchList.total_pages {
                page += 1
                toggleCall()
            }
        }
    }
}

func toggleCall() {
    if toggleButton.isSelected {
        callAPI(query: query, order_by: "latest")
    } else {
        callAPI(query: query, order_by: "relevant")
    }
}
```
- prefetchItemsAt을 통한 다음 페이지 로드 시점 제어
- page 변수로 중복 호출 방지
- 정렬 변경 시 page 초기화로 데이터 정합성 유지

### 2. 이미지 저장 및 관리
#### 문제 상황
- 대용량 이미지 파일의 효율적 관리 필요
- Realm과 FileManager 간 데이터 동기화 이슈
- 이미지 삭제 시 저장소 정리 문제

#### 해결 방안
```swift
func saveImageToDocument(image: UIImage, filename: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
    guard let data = image.jpegData(compressionQuality: 0.5) else { return }
    do {
        try data.write(to: fileURL)
    } catch {
        print("file save error", error)
    }
}

func removeImageFromDocument(filename: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("file remove error", error)
        }
    }
}
```
- 이미지 압축을 통한 저장소 공간 최적화
- 파일 존재 여부 확인으로 안정성 확보
- 에러 처리를 통한 예외 상황 관리

### 3. 좋아요 기능 구현
#### 문제 상황
- 좋아요 상태 변경 시 UI 업데이트 지연
- 이미지 저장과 Realm 데이터 동기화 필요
- 다중 화면에서의 상태 관리 이슈

#### 해결 방안
```swift
@objc func likeButtonPressed(sender: UIButton) {
    let index = searchList.results[sender.tag]
    let imageID = index.id

    if let existingLike = realmList.first(where: { $0.id == imageID }) {
        try! realm.write {
            existingLike.isLike.toggle()
            if !existingLike.isLike {
                removeImageFromDocument(filename: imageID)
                removeImageFromDocument(filename: imageID + "_user")
            }
            sender.isSelected = existingLike.isLike
        }
        self.view.makeToast("좋아요 목록에서 제거됐어요!")
    } else {
        // 새로운 좋아요 항목 추가
        let newLikeData = LikeList(
            id: imageID,
            date: Date(),
            // ...초기화
        )
        try! realm.write {
            realm.add(newLikeData)
        }
        self.view.makeToast("좋아요 목록에 추가됐어요!")
    }
}
```
- Realm 트랜잭션 내에서 상태 변경 처리
- FileManager 연동으로 이미지 자동 관리
- Toast 메시지로 즉각적인 사용자 피드백 제공

## 📝 회고

### 잘한 점
- FileManager와 Realm을 연동한 하이브리드 저장소 설계
- UICollectionViewDataSourcePrefetching을 활용한 효율적인 페이지네이션
- 컬러 필터링을 위한 열거형 기반 타입 안전성 확보

### 아쉬운 점
- 다중 필터 적용 시 검색 성능 최적화
- 이미지 저장소 자동 정리 정책 수립
- 좋아요 상태 변경 시 동시성 처리 개선

### 시도할 점
- 이미지 메타데이터 캐싱 전략 재설계
- 컬러 기반 이미지 분류 알고리즘 개선
- FileManager 저장소 관리 자동화
