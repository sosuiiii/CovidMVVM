# コロナアプリ
コロナウイルスの国内感染状況を確認できるアプリ  

## Kindle出版/ベストセラー獲得
【Swift5】 つくって学ぼ iOSアプリ開発  
https://t.co/qR6Bsx3Itz?amp=1  


## 使用したライブラリ
pod 'FSCalendar'  
pod 'CalculateCalendarLogic'  
pod 'Charts'  
pod 'Firebase/Analytics'  
pod 'Firebase/Auth'  
pod 'Firebase/Core'  
pod 'Firebase/Firestore'  
pod 'FirebaseFirestoreSwift'  
pod 'MessageKit'  
pod 'MessageInputBar'  
pod 'PKHUD'  
pod 'SwiftyJSON'  
pod 'Moya/RxSwift', '~> 14.0'  
pod 'RxSwift'  
pod 'RxDataSources'  
pod 'RxCocoa'  
pod 'RealmSwift'  
pod 'Instantiate'  
pod 'InstantiateStandard'  
  
## 使い方
>Pod install  

## 意識したこと
### ・Flux
まず、このアプリではAPIが二本しか使われていない為、Fluxを使う利点は大きくない。  
が、ちょっとしたアピールのために盛り込んだ。  
Fluxを使うことで処理がまとまるのが好き。  

### ・Instantiate
storyboardを1つにまとめると重すぎる為、  
Instantiateライブラリを使い、1storyboard1画面で構築した。  

### ・配色
配色は特に拘った。メインカラーを決め、アクセントは控えめに。  
コントラストを強くしないことで、目に優しい色とした。  
カラーホイールの同一円周上のカラーを使うことで、色のまばら感が出ないようにした。  

### ・アーキテクチャ
MVVM + Flux  
アーキテクチャにはMVVMを採用したが、自分の設計力では綺麗なMVVMに届かなかった。  
ViewConrtollerでは、なるべく"表示のための値を見るだけ"とし、ViewModelからの  
outputを監視した。  
特に、トップ画面のPKHUDやチャート画面のサーチ結果を監視する部分など。  

### その他
このアプリを使うユーザーは、「感染状況が知りたい」  
という想いが一番強い想定なので、ログイン機能は入れずに  
トップ画面は感染状況を真ん中に太字で表示した。  

アイデア実装だが、チャット画面では医者とチャットで相談でき、  
健康診断画面では重症度が判定されカレンダーに記録されるようにした。  
自分なりにUIUXを拘ったアプリ。  

## これからすること
・リリース  
・CI/CD構築  


## アプリスクショ
![IMG_4495](https://user-images.githubusercontent.com/41160560/107110414-f0d1f800-688a-11eb-8332-42a6380bd4d9.PNG)
![Simulator Screen Shot - iPhone 8 - 2021-01-25 at 15 55 38](https://user-images.githubusercontent.com/41160560/107109486-4b1b8a80-6884-11eb-84c9-8624d675d8d9.png)
![Simulator Screen Shot - iPhone 8 - 2021-01-25 at 15 59 29](https://user-images.githubusercontent.com/41160560/107109490-4fe03e80-6884-11eb-8308-8044d57e92b8.png)
![Simulator Screen Shot - iPhone 8 - 2021-01-25 at 15 59 39](https://user-images.githubusercontent.com/41160560/107109491-5078d500-6884-11eb-8b7f-c6dc8d06724e.png)
![Simulator Screen Shot - iPhone 8 - 2021-01-25 at 16 00 20](https://user-images.githubusercontent.com/41160560/107109492-51116b80-6884-11eb-8796-d40547f8ad4a.png)
![Simulator Screen Shot - iPhone 8 - 2021-01-25 at 16 00 31](https://user-images.githubusercontent.com/41160560/107109494-51aa0200-6884-11eb-8782-05246b053df8.png)
