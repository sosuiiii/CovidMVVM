# コロナアプリ
コロナウイルスの国内感染状況を確認できるアプリ  
<img width="688" alt="スクリーンショット 2021-02-07 17 51 23" src="https://user-images.githubusercontent.com/41160560/107141590-20f1c780-696d-11eb-92e5-e63d24a8b54d.png">


## Kindle出版/40冊ほど販売
【Swift5】 つくって学ぼ iOSアプリ開発  
https://t.co/qR6Bsx3Itz?amp=1  


## 使用したライブラリ
pod 'FSCalendar'  
pod 'CalculateCalendarLogic'  
pod 'Charts'  
pod 'Firebase/Firestore'  
pod 'FirebaseFirestoreSwift'  
pod 'MessageKit'  
pod 'MessageInputBar'  
pod 'PKHUD'  
pod 'Moya/RxSwift', '~> 14.0'  
pod 'RxSwift'  
pod 'RxCocoa'  
pod 'Instantiate'  
pod 'InstantiateStandard'
pod 'Quick'
pod 'Nimble'

## 使い方
>Pod install  

## 意識したこと
### ・Flux
まず、このアプリではAPIが二本しか使われていない為、Fluxを使う利点は大きくない。  
が、ちょっとしたアピールのために盛り込んだ。  
Fluxを使うことで処理をきれいにまとめることができる。

### ・Instantiate
storyboardを1つにまとめると重すぎる為、  
Instantiateライブラリを使い、1storyboard1画面で構築した。  

### ・配色
配色は特に拘った。メインカラーを決め、アクセントは控えめに。  
コントラストを強くしないことで、目に優しい色とした。  
カラーホイールの同一円周上のカラーを使うことで、色のまばら感が出ないようにした。  

### ・アーキテクチャ
MVVM + Flux  
FatViewControllerにならないようMVVMで実装し、
さらにViewModelでのAPI周りの処理を綺麗にするためFluxを用いた。
小規模のためFluxは必要ないが、あえて利用している。
ViewModelのインターフェースはKickstarterのデザインパターンを採用している。

### テストコード
健康診断ロジックをテストしている。

### その他
このアプリを使うユーザーは、「感染状況が知りたい」  
という想いが一番強い想定なので、ログイン機能は入れずに  
トップ画面は感染状況を真ん中に太字で表示した。  

## これからすること
・リリース  
・CI/CD構築  
