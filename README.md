# コロナアプリ
コロナウイルスの国内感染状況を確認できるアプリ  
<img width="688" alt="スクリーンショット 2021-02-07 17 51 23" src="https://user-images.githubusercontent.com/41160560/107141590-20f1c780-696d-11eb-92e5-e63d24a8b54d.png">


## Kindle出版/ベストセラー獲得
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

### 入れたけど使用しなかったライブラリ
pod 'RxDataSources'  
pod 'SwiftyJSON'  
pod 'RealmSwift'  
pod 'Firebase/Analytics'  
pod 'Firebase/Auth'  
pod 'Firebase/Core'  
シンプルに必要なかった。RealmSwiftもシングルトンで代用すれば良い。

##CI
Bitrize  
pushしたらプルリク自動生成。マージは手動

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
・CD構築  
