![image](https://github.com/user-attachments/assets/4b8dde5c-c1ec-4de8-80ab-7449302fa8ba)

# 🥐 제 과제 빵점
### 제 과제 빵점 사장님은 이번 학기 백점 💯
```
저희 학교에 제과제빵학과는 없는데, 왜 제 과제는 빵점일까요?
시험 직전, 미리 미리 공부하지 않은 지난 날을 후회하는 대학생들.
밈을 활용해 고통스러운 시험기간을 재치있게 승화시키는 모습에서 영감을 얻은,
미룬이 대학생을 위한 스터디 플래너 ‘제 과제 빵점'입니다.
```

## 🧑‍🍳 iOS Developers
| <img src="https://github.com/user-attachments/assets/4f259728-3f7d-44f6-b7bb-316459a65a23" width="200"> | <img src="https://github.com/user-attachments/assets/5f24f426-1c69-4a23-897d-de90ea482cca" width="200"> | <img src="https://github.com/user-attachments/assets/4a323edc-fdaa-4dd8-b108-38a8f56c7e9b" width="200"> | <img src="https://github.com/user-attachments/assets/82c439dd-1fd8-4bd3-af96-0eaec6a3cb70" width="200"> |
| :---: | :---: | :---: | :---: |
| **🥖 송여경** | **🥖 조성민** | **🥖 최유빈** | **🥖 김송희** |
| [@0gonge](https://github.com/0gonge) | [@SungMinCho-Kor](https://github.com/SungMinCho-Kor) | [@choiyoubin](https://github.com/choiyoubin) | [@hongseekim](https://github.com/hongseekim) |



# 🥯 Demonstration
| 온보딩 | 타이머 | 마이페이지 | 
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/87aced47-b68b-44ee-8aa2-cdcf4e564fba" width="250"> | <img src="https://github.com/user-attachments/assets/f44e2168-0ba9-4638-966c-a0c29fcc5016" width="250"> | <img src="https://github.com/user-attachments/assets/2bca19af-02d5-481d-b29c-fec329a46c0e" width="250"> | 
| 투두 생성 | 투두 관리 | 카테고리 관리 | 
| <img src="https://github.com/user-attachments/assets/74c85a14-1b07-4ee9-bd37-12afee2d8227" width="250"> | <img src="https://github.com/user-attachments/assets/12fca138-d780-4eb5-8b7e-b98ab3bfe0d1" width="250"> | <img src="https://github.com/user-attachments/assets/13c0506d-fd1b-4a1f-84dc-ce95b613f920" width="250"> | 
<br>


# 🥖 Dependency
|Library|Description|Version|
|:---:|:---:|:---:|
|**Alamofire**|추상화된 네트워크 레이어 사용|```5.10.2```|
|**KakaoOpenSDK**|카카오톡 간편로그인 연동|```2.23.0```|
|**Kingfisher**|이미지 처리|```2.23.0```|
<div>
  <img src="https://img.shields.io/badge/Xcode-16.0-007ACC?style=for-the-badge&logo=Xcode&logoColor=white" style="display:inline-block;">
  <img src="https://img.shields.io/badge/swift-6.0-F54A2A?style=for-the-badge&logo=swift&logoColor=white" style="display:inline-block;">
  <img src="https://img.shields.io/badge/Tuist-4.38.2-E34F26?style=for-the-badge&logo=Tuist&logoColor=white" style="display:inline-block;">
</div>
</br>

# 🥨 Architecture
MVVM + CleanArchitecture
```
< Runtime Flow >
Presentation → Domain → Data

< Dependency Rule >
Presentation → Domain ← Data
```

# 🍞 Foldering Strategy
```
├── 🥐 Project
│   ├── 🥯 Tuist
│   │   ├── 🥖 Project.swift
│   │   ├── 🥖 Tuist.swift
│   │   └── 🥖 Tuist/
│   │       ├── 🧁 Package.swift
│   │       ├── 🧁 Package.resolved
│   │       └── 🧁 ProjectDescriptionHelpers/
│   │           └── Project+Templates.swift
│   │
│   ├── 🥯 App Source (BBANGZIP-iOS/)
│   │   ├── 🥨 Resources
│   │   │   ├── 🥖 Assets.xcassets
│   │   │   ├── 🥖 Font
│   │   │   ├── 🥖 Preview Content
│   │   │   └── 🥖 Config
│   │   │       └── Secrets.xcconfig
│   │   │
│   │   ├── 🥨 Sources
│   │   │   ├── 🥖 App
│   │   │   │   ├── BBANGZIPIOSApp.swift
│   │   │   │   └── ContentView.swift
│   │   │   │
│   │   │   ├── 🥖 Data
│   │   │   │   └── 🍞 Network
│   │   │   │       ├── 🧁 Environment
│   │   │   │       ├── 🧁 Router
│   │   │   │       └── 🧁 Service
│   │   │   │
│   │   │   ├── 🥖 Domain
│   │   │   │   ├── 🍞 Entities
│   │   │   │   ├── 🍞 Enum
│   │   │   │   ├── 🍞 Repositories
│   │   │   │   └── 🍞 UseCase
│   │   │   │
│   │   │   ├── 🥖 Presentation
│   │   │   │   ├── 🍞 Component
│   │   │   │   ├── 🍞 Login
│   │   │   │   ├── 🍞 Onboarding
│   │   │   │   ├── 🍞 MyPage
│   │   │   │   ├── 🍞 Timer
│   │   │   │   └── 🍞 ToDo
│   │   │   │
│   │   │   ├── 🥖 Extension
│   │   │   ├── 🥖 Utilities
│   │   │   └── 🥖 Design (Font / Color)
│   │   │       └── CustomFont.swift / CutomColor.swift
│   │   │
│   │   └── 🥨 Tests
│   │       └── BBANGZIPIOSTests.swift
│
└── 🥐 Generated (Git Ignore)
    └── 🥯 Derived/
```

</br>

# 🍞 Git Flow
[우아한형제들 Git-flow](https://techblog.woowahan.com/2553/)를 기반으로 합니다.</br>
이슈명은 [Unit] 작업 내용 형식으로 작성합니다. (예시: [Feature] 컴포넌트 제작)
1. Project board에서 issue를 생성합니다.
2. develop 브랜치에서 새로운 브랜치로 checkout 합니다.
3. 해당 브랜치에서 작업을 진행하고, 작업을 나누어 commit합니다.
4. 작업 완료 후 빌드가 되는지 확인 후 push합니다.
5. PR을 작성합니다.
6. 모든 팀원들의 approve를 받은 후 merge합니다.
</br>

# 🥯 Branch Strategy
브랜치명은 해당하는 브랜치에 이슈번호를 붙여서 작성합니다. (예시: feature/#1)
|branch|description|
|:---:|:---:|
|**main**|완성된 버전의 코드를 저장하는 브랜치|
|**develop**|개발이 진행되는 동안 완성된 코드를 저장하는 브랜치|
|**feature**|작은 단위의 작업이 진행되는 브랜치|
|**hotfix**|긴급한 오류를 해결하는 브랜치|
|**release**|QA, Test, 앱 심사를 진행하는 브랜치|
</br>

# 🍞 Coding Convention
[스타일쉐어 Swift 가이드](https://github.com/StyleShare/swift-style-guide)를 기반으로 합니다.</br>
</br>

# 🥪 Commit Message
아래의 예시와 같이 작성합니다.
```
feat: 기능 구현 (#이슈번호)
fix: 기능 수정 (#이슈번호)
refactor: 리팩토링 (#이슈번호)
docs: 문서 수정 (문서 추가, 수정, 삭제, README) (#이슈번호)
test: 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음) (#이슈번호)
chore: 기타 변경사항 (빌드 스크립트 수정, assets, 패키지 매니저 등) (#이슈번호)
remove: 파일을 삭제하는 작업만 수행한 경우, 키워드 삭제 등등! (#이슈번호)
init: 초기 생성 (#이슈번호)
```
</br>

