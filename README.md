
# 画像処理のためのDockerfile
## 概要
画像処理のためのツールを詰めたDockerfile
GPUを使うことを前提としている
```
nvidia-docker run --rm -it -p 8888:8888 sakaki/opencv /usr/bin/fish
```
で起動する。

dockerhub: https://hub.docker.com/r/sakakib/

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

ビルドに時間がかかります。
OPENCVのコンパイルが長い(12コアのマシンで3時間程度かも...)です。