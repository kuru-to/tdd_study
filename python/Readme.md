# 使い方
## Set up
### パッケージインストール
#### 開発環境
```
pipenv install --dev
```

#### 本番環境
```
pipenv install
```

## ユニットテスト
```
pipenv run test
```

### テストの対象関数
`test_*.py` のファイルにある `test_*`という形式のメソッド.
テストを追加する際は上記の形式

### 処理の遅いテストを実行する場合
```
pipenv run test -m slow
```

## 文書の build
### set up
```
pipenv run make_rst
```

以下の条件に適合した場合、上記 set up コマンドをうつ必要がある

- 初めてローカルに `git clone` した
- フォルダの構成を変更した
- 新しく文書化対象のコードを追加した（`index.rst` も変更する必要あり）

### 最新のコードを文書に反映
```
pipenv run make_docs
```

### 文書の格納場所
```
docs/_build/index.html
```

webで開けばHTML形式で確認可能
`_build` ディレクトリは `.gitignore` の対象なので、`git clone` あとには必ず上記のコード群を実行する

## パッケージインストール
```
pipenv install <module>
```

`Pipfile` に書き込みが行われるので, commit すること

---

## docker の起動
### build
```
docker build .devcontainer -t {イメージの名前}:{version}
```

### run
```
docker run --rm -v "$PWD":/workspace -w /workspace -name {コンテナの名前}
```

#### run後に実行すべきコマンド
```
docker exec -it {コンテナの名前} /bin/bash
```

でコンテナの中に入ってから

```
# pipenv install
```

でパッケージインストール

### 参考
#### docker command チートシート
https://qiita.com/kite_999/items/e26d58b08e247134f7fe

### VSCode 上で開く場合
左下のボタンで, 今開いているフォルダの `Dockerfile` を参照して build & run 可能.

#### 参考
https://qiita.com/Yuki_Oshima/items/d3b52c553387685460b0
