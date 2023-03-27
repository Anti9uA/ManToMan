<img src="https://user-images.githubusercontent.com/52993882/219649239-959ac1a7-5094-4a23-8ccc-3ac28951c8ce.png" width="200"   height="200"/>


# ManToMan 번역기 앱  
필요한 번역만 쉽고 빠르게! 마주보며 소통하는 맨투맨 한손 번역기


[<img src="https://user-images.githubusercontent.com/52993882/219651102-a12adc2c-7913-439b-9bcb-b46c44d66a4b.png" width="260"   height="90"/>](https://apps.apple.com/app/%EB%A7%A8%ED%88%AC%EB%A7%A8/id1670119550)



# 목차 
- [ManToMan 번역기 앱](#mantoman-번역기-앱)
- [목차](#목차)
  - [소개](#소개)
  - [개발 환경](#개발-환경)
  - [사용 기술](#사용-기술)
  - [프로젝트 목적](#프로젝트-목적)
  - [화면 구성](#화면-구성)
  - [핵심 기능](#핵심-기능)
    - [실시간 번역](#실시간-번역)
    - [최근 기록 저장](#최근-기록-저장)
    - [다중 언어 지원](#다중-언어-지원)
    - [음성 인식](#음성-인식)
  - [UX 설계](#ux-설계)
  - [느낀점](#느낀점)
  - [Contacts](#contacts)


## 소개
**맨투맨**은 짧은 대화에 특화된 상호 대화형 번역기 입니다. <br> 
다른 번역기와는 다르게 한 화면에서 한손으로 빠르게 번역할수 있습니다!

## 개발 환경

![MacOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=apple&logoColor=white)&nbsp;![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)&nbsp;![VSCode](https://img.shields.io/badge/VSCode-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)&nbsp;![Github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)&nbsp;![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)
 - MacOS
 - Xcode
 - VSCode
 - Github
 - Figma

## 사용 기술 
![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white)&nbsp;  

![Python](https://img.shields.io/badge/Python-FFD43B?style=for-the-badge&logo=python&logoColor=blue)&nbsp;![FastAPI](https://img.shields.io/badge/fastapi-109989?style=for-the-badge&logo=FASTAPI&logoColor=white)&nbsp;


![cloudtype](https://img.shields.io/badge/cloudtype-gray?style=for-the-badge)

**Client**
 - Swift (SwiftUI)
  
**Backend**
  - Python
  - FastAPI 

**Infrastructure** 
-  Cloudtype

**라이브러리**
 - [Combine](https://developer.apple.com/documentation/combine)
 - [CoreData](https://developer.apple.com/documentation/coredata)
 - [Speech](https://developer.apple.com/documentation/speech)
 - [pyGoogleTrans](https://github.com/ssut/py-googletrans)
 - [lottie-ios](https://github.com/airbnb/lottie-ios)


## 프로젝트 목적
실제 여행중 겪었던 번역기의 불편함을 해결하고 싶었습니다.<br>
외국인에게 번역기를 사용하면서 생기는 작은 찰나의 순간 어색함을 줄이고 싶었고,<br>
그에 따라 마주보며 대화하는 짧은 대화에 특화된 번역기를 개발하는데 목표하고 있습니다.  


## 화면 구성
|![main](https://user-images.githubusercontent.com/52993882/219629941-3485c07b-6898-418c-b06b-80c0bc0b8832.jpg)|![langSelect](https://user-images.githubusercontent.com/52993882/219629922-778333fd-a123-4d34-82a9-6af105b581ab.jpg)| ![meRecord](https://user-images.githubusercontent.com/52993882/219629936-e7749077-e621-4551-b6c2-4c798dc0e2df.jpg)| ![uRecord](https://user-images.githubusercontent.com/52993882/219629940-c8e7c1dc-6b60-4f91-9a84-0396c75328a3.jpg) |
| :-----------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: |
|                                                      메인                                                      |                                                       언어 선택 페이지                                                        |                                                      사용자 녹음 창                                                       |                                                     상대방 녹음 창                                                      |
                        
<br>

## 핵심 기능
### 실시간 번역
- 텍스트 디바운싱을 통해 문장을 치는 동안 실시간으로 쿼리를 날려 번역결과를 보여줍니다.
<img src="https://user-images.githubusercontent.com/52993882/219642288-7d4838af-3888-4332-aeb3-d023d44476f9.gif" width="200"    height="450"/>
 </div>

### 최근 기록 저장
- UT 결과, 여행 중에는 자주 번역하는 문장이 정해져 있다는 것에서 영감을 얻어 최근 기록을 빠르게 불러와야하는 필요성을 느꼈습니다.
- 맨투맨은 최근 기록을 메인창에 구현했고, 빠르게 최근기록을 불러올수 있습니다.
<img src="https://user-images.githubusercontent.com/52993882/219642270-3e91f4e3-e596-4443-a7cd-6147ff76019c.gif" width="200"    height="450"/>
 </div>

### 다중 언어 지원
- 영어 뿐만 아니라 일본어, 중국어를 지원하고 있고 추후 스페인어, 불어 등 지원 언어를 늘려나갈 계획입니다.
<img src="https://user-images.githubusercontent.com/52993882/219645631-f6c50d63-1577-4024-b23b-f4f71b11ea4a.gif" width="200"    height="450"/>
 </div>

### 음성 인식
&ensp;&ensp;**사용자 음성인식**
- 앱 사용자의 음성인식을 통해 번역결과를 보여줍니다.
<img src="https://user-images.githubusercontent.com/52993882/219646153-56c13e70-dbfe-44b1-80ca-6428ce9e8b61.gif" width="200"    height="450"/>
 </div>

&ensp;&ensp;**상대방 음성인식**
- 마이크를 건네주는 메타포를 사용해 상대방 언어에 따른 음성인식 또한 지원합니다.
- 상대방 언어의 인식된 문장을 한글로 실시간으로 보여줍니다.
<img src="https://user-images.githubusercontent.com/52993882/219642283-cb5c9808-1382-43ce-8d94-0eee56d98c21.gif" width="200" height="450"/>
</div>

<br>

## UX 설계
[👉 자세히보기](https://abstracted-dolomite-d13.notion.site/IR-8b772337c60048d9be529b2e379d60ed)

<br>

## 느낀점
일본 여행중 겪었던 작은 불편함이 이렇게 제품출시까지 이루어진걸 보고 정말 뿌듯했습니다.
문제 제기부터 시작해서 개발, 출시까지 제품을 개발하는 온전한 프로세스를 밟아볼수 있었던 소중한 경험이었습니다.  

또한 앞으로 내가 생각한 아이디어나 문제점들이 실제로 솔루션으로 이어질수 있는걸 눈으로 확인했고, 자신감을 가질 수 있었습니다.  

'우리의 문제점 해결' 라는 사명감을 가지면서 공부라는 생각이 들지 않으면서 제 자신을 프로젝트 안에 몰입시켜나갈수 있었던 프로젝트였습니다. 마지막으로 함께했던 팀원 [@Anna](https://github.com/Eunbi-Cho)에게 정말 수고했고 감사하다는 말을 전하고 싶습니다.

<br>
 
## Contacts
- [✨Official Website](https://abstracted-dolomite-d13.notion.site/f952e5d6a2f2444589b223e29755311a) 
- [✨Official Instagram](https://instagram.com/mantoman_translator?igshid=YmMyMTA2M2Y=) 
- Anti9uA: didlaak6000@naver.com
- Anna: moomb70@gmail.com
