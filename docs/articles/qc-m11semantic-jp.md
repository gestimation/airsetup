# M11 SEMANTIC QC 技術リファレンス

M11 SEMANTIC
QCは、プロトコール、SAP、CRF、データ定義書など複数の臨床試験資料から、解析上重要な意味情報を根拠とともに整理するスキルです。

このスキルはICH
M11への準拠性を認定するものではありません。M11とE9(R1)の考え方を、臨床試験の意味情報を整理するための参照枠として使用します。

[QCスキルガイドに戻る](https://gestimation.github.io/airsetup/articles/qc-skills-jp.md)

[English
version](https://gestimation.github.io/airsetup/articles/qc-m11semantic.md)

## 目的と適用範囲

M11 SEMANTIC
QCの目的は、複数資料に分散した解析上重要な意味情報を、**文書によって支持された内容、根拠位置、状態、矛盾、R実装への影響**へ分解することです。

出力は意味情報を整理するsemantic mapと、その利用可能性を評価するQC
summaryに分けます。前者には文書上の事実を、後者にはQC判断、Issue、意思決定事項、AI仮定リスクを記録します。

このスキルは、プロトコール作成、電子交換パッケージ、統制用語パッケージ、規制提出物、正式なSAPレビューを生成するものではありません。

## 開始条件

複数文書間の意味情報の整理が必要であること、またはM11／電子プロトコールに関連する意味情報レビューが要求されていることが開始条件です。単純な変数一覧または単一のデータ定義からR実装可能性を確認する場合はCONTEXT
QCを使用します。

| 入力               | 役割                                       |
|--------------------|--------------------------------------------|
| プロトコール       | 目的、デザイン、治療、評価項目の主要な根拠 |
| SAP                | 統計手法、解析対象集団、欠測、多重性の根拠 |
| CRF・データ定義    | 評価項目と収集項目・変数の対応             |
| 解析データ仕様     | 解析変数、導出、フラグの対応               |
| 研究者指示・既存QC | 文書外の決定と未解決事項の識別             |

必要資料がない項目は、一般的な臨床試験慣行から補完せず、状態値によって明示します。

## 使用を推奨する場合

- 重要な情報が複数文書に分散している
- 文書間の不一致を確認したい
- 主要目的とestimandの関係を整理したい
- intercurrent eventとstrategyを整理したい
- 評価項目と元変数を対応させたい
- SAP作成前に試験の意味情報を整理したい
- Rコード作成前に解析上重要な定義を追跡可能にしたい

単純なデータセット、変数一覧、Rコード作成依頼であれば、通常は[CONTEXT
QC](https://gestimation.github.io/airsetup/articles/qc-context-jp.md)で十分です。

## 確認に使用する資料

- プロトコールと改訂履歴
- SAPまたはSAPドラフト
- CRF、eCRF completion guideline
- データ定義書、変数一覧、コードリスト
- 解析用データセット仕様書
- 研究者メモ、タスク指示、既存のQC記録
- AIが確認可能なデータの構造・メタデータ

データの値そのものを確認できない場合でも、列名、型、ラベル、値コードなどのメタデータから確認できる範囲を明示します。

## 根拠ゲート

各情報は、次の順序で扱います。

1.  文書またはメタデータに明記されているか
2.  ファイル名、節、表、変数などの根拠を示せるか
3.  複数資料の記載が一致しているか
4.  根拠がなければ、未確認または欠落として記録する
5.  AIの提案は、文書上の事実と分ける

文書にない治療群コード、解析対象集団、評価時点、欠測処理、intercurrent
event strategyなどを推測で確定しません。

`Evidence`には、少なくとも資料名と識別可能な位置を含めます。利用可能であれば版、日付、節、表、ページ、変数名を記録します。同じ項目を複数資料が支持する場合は、それぞれの根拠を列挙します。

候補解釈はDocument-supported contentへ記入せず、QC summaryのIssues
requiring attentionへ候補であることを明示して記録します。

## 分析上重要な14項目

### 1. Primary Objective(s) and Associated Estimand(s)

主要目的の文言、対応する臨床的問い、関連付けられたestimandを根拠位置とともに記録します。目的とestimandの対応が明記されていない場合は、対応を推定しません。

### 2. Population

対象患者集団、疾患・病期などの主要属性、選択・除外条件を記録します。試験対象集団と解析対象集団は同一概念として扱いません。

### 3. Treatment

比較する治療条件、投与量、投与経路、投与期間、併用・救済治療を記録します。estimand上のtreatment
condition、無作為化群、実治療、データ上の治療群コードを区別します。

### 4. Endpoint

評価項目の概念、測定方法、評価時点、単位、導出規則、元変数を記録します。元変数が候補にとどまる場合は、文書支持された対応として確定しません。

### 5. Population-Level Summary

群間差、比、ハザード比、平均値などのpopulation-level
summaryと比較方向を記録します。統計手法だけが記載され、要約量が特定できない場合は`Unclear`とします。

### 6. Description of Intercurrent Event

治療中止、救済治療、死亡などについて、事象の定義、発生時点、評価の解釈または存在への影響を記録します。一般的に起こり得る事象を、試験固有のintercurrent
eventとして追加しません。

### 7. Intercurrent Event Strategy

各intercurrent eventに対して、文書に支持されたtreatment
policy、hypothetical、composite、while-on-treatment、principal
stratumなどのstrategyを対応付けます。根拠がなければstrategyを割り当てません。

### 8. Analysis Sets

FAS、ITT、PPS、Safety
setなどについて、名称、包含・除外規則、治療群の分類規則、適用する解析を記録します。

### 9. Statistical Analysis Method

主要な統計手法、モデル式、効果指標、共変量、層別因子、比較、推定方法、信頼区間、検定を記録します。

### 10. Handling of Data in Relation to Primary Estimand(s)

測定値、評価時点、治療中止後データ、救済治療後データなどを主要estimandに対して採用、除外、導出または打ち切る規則を記録します。

### 11. Handling of Missing Data in Relation to Primary Estimand(s)

欠測の定義、欠測理由、主要解析での処理、補完またはモデル化の方法、基礎となる仮定を記録します。

### 12. Sensitivity Analysis

各感度分析について、対象となる主要解析の仮定、変更する条件、対象集団、変数、モデル、比較対象を記録します。

### 13. Multiplicity Adjustments

仮説ファミリー、検定順序、α配分、ゲートキーピング、中間解析を含む多重性調整の規則を記録します。

### 14. Sample Size Determination

計算方法、効果量、分散、イベント数、有意水準、検出力、配分比、脱落率などの仮定と、その根拠資料を記録します。

必要に応じて、安全性評価、サブグループ、データカット、無作為化・層別因子、外部データなど、R実装に重要な追加項目も扱います。

## Semantic mapの状態値

各項目について、内容と根拠を分け、主に次の状態を付けます。

| 状態 | 適用条件 |
|----|----|
| `Provided` | 明示的な支持内容と識別可能な根拠位置がある |
| `Partially provided` | 解析上必要な情報の一部だけが支持される |
| `Not provided` | 関連資料を確認したが、該当項目を特定できない |
| `Unclear` | 関連記載はあるが、意味を一意に決定できない |
| `Inconsistent` | 提供資料間で記載が矛盾する |
| `Cannot assess` | 必要資料が未提供、読取不能または確認範囲外である |
| `Not applicable` | 非該当であることが資料または試験デザインから支持される |

`Not provided`は、その情報が試験に存在しないという意味ではありません。確認した資料の範囲で特定できなかったことを意味します。`Not applicable`は根拠なしに使用しません。`Not provided`と`Cannot assess`では、原則としてDocument-supported
contentを空欄にします。

## 文書間の矛盾

矛盾を見つけた場合、どちらかを自動的に正しいと決めず、次を記録します。

- 矛盾する内容
- 各記載のファイルと位置
- 版と日付
- 解析やR実装への影響
- 解決に必要な担当者または資料

## 出力スキーマ：二つの標準出力

### M11SEMANTIC_MAP.md

``` text
ai_project/ai_output/m11semantic/M11SEMANTIC_MAP.md
```

分析上重要な項目ごとに、文書によって支持された内容、根拠、状態、未解決事項を整理します。これは意味情報のマップであり、承認済みSAPやデータ仕様書の代わりではありません。

Semantic
mapの主要表は、`Item`、`Document-supported content`、`Evidence`、`Status`の4列で構成します。

### M11SEMANTIC_QC_SUMMARY.md

``` text
ai_project/qc/m11semantic/M11SEMANTIC_QC_SUMMARY.md
```

確認範囲、Rコード作成への準備状況、領域別QC、対応が必要な問題、ユーザーの意思決定事項、AIによる仮定リスク、次工程への引き渡しを記録します。

QC summaryは次の8セクションで構成します。

1.  Review target
2.  Readiness for R coding
3.  Domain-level QC summary
4.  Issues requiring attention
5.  User decisions required
6.  AI assumption risks
7.  Recommended next step
8.  `QC_STATUS.md` update note

Issues requiring
attention表には、`ID`、`Issue type`、`Severity`、`Item`、`Evidence`、`Analysis impact`、`Required resolution`を含めます。候補解釈はこの表に記録し、semantic
mapの文書支持内容へ混入させません。

## Rコード作成への準備状況

| 状態 | 意味 |
|----|----|
| Ready | 重要な意味情報が根拠付きで整理され、重大な未解決事項がない |
| Partially ready | 限定した作業には進めるが、重要な不足が残る |
| Not ready | 研究固有の推測なしに実装できない |
| Cannot assess | 必要資料またはデータ構造が不足して判断できない |

意味情報が整理されても、データ上の列名、型、コード、行単位が不明であれば、Rコード作成には進めません。

### 判定規則

- 主要目的、治療、主要評価項目、解析対象集団などにCritical
  Issueがある場合、R実装可能性を`Ready`にしない
- 文書支持内容はあるが、変数対応または解析仕様が不足する場合は`Partially ready`
- 必要資料が確認できず、重要項目の存在自体を評価できない場合は`Cannot assess`
- 文書間の矛盾をAIが解消せず、`Inconsistent`として意思決定へ引き渡す
- semantic mapの充足件数をスコアまたはM11準拠率として扱わない

## 判定例

``` text
Item: Endpoint
Document-supported content: Week 24の眼軸長のベースラインからの変化量
Evidence: Protocol 8.2.1; CRF AL_FORM; data_definition.xlsx AL_BL, AL_W24
Status: Partially provided

Issue type: Ambiguous
Severity: Major
Analysis impact: 左右眼の選択規則がなく、解析単位と導出を一意に決定できない。
Required resolution: 解析眼の選択規則を統計担当者が確定する。
```

## SAP QCとの関係

M11 SEMANTIC QCは、複数資料から意味情報を整理します。[SAP
QC](https://gestimation.github.io/airsetup/articles/qc-sap-jp.md)は、SAPの統計仕様と実装可能性を確認します。意味情報の整理が複雑な試験では、M11
SEMANTIC QCの出力をSAP作成またはSAP
QCの入力として利用できます。ただし、`M11SEMANTIC_MAP.md`がなければSAP
QCを実施できないわけではありません。

## 確認範囲

M11 SEMANTIC
QCは、提供された資料から意味情報を抽出し、その根拠と不足を整理します。ICH
M11への準拠性、文書の正式承認、データ値の正確性、統計手法の妥当性、R実装の正確性を認定するものではありません。
