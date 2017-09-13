
# 画像処理のためのDockerfile
## 概要
画像処理のためのツールを詰めたDockerfile
GPUを使うことを前提としている
## 使い方
### イメージのプル
イメージは[dockerhub](https://hub.docker.com/r/sakakib/)に登録している。

```
docker pull sakakib/opencv
```
### コンテナの作成
```
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv /usr/bin/fish
```

- ```-p 8888:8888```はjupuyter notebook用
- ```-p 52698:52698```でrsub(for sublime text)を使用可能にする。

jupyter notebookのパスワード設定にはコンテナ作成後に
```
python jupyter-password.py
```
を実行する。このスクリプトはhttps://github.com/paderijk/jupyter-password のものである。


## 中身

- ベース
    - ubuntu16.04
- 計算環境
    - opencv 3.3.0 (python3のみ)
    - python 3.5.2
    - cuda 8.0
    - tensorflow 1.3
- 開発ツール
    - fish shell
    - powerfont
    - jupyter notebook / lab
    - microsoft powershell

## 注意
```python3```と書かなければpython3は起動しません。
摘便デフォルトのpythonを変更してください。
jupyterはデフォルトで全てのIPからの接続を許可しています。
jupyter notebookの初期パスワードを設定していますが、適当に変更して使ってください。