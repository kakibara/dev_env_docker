
# ぼくのかんがえたさいつよのDockerfile
dockerhub: https://hub.docker.com/r/sakakib/
## 中身

- ベース
    - ubuntu16.04
    - fish shell
    - jupyter notebook / lab
    - microsoft power shell
- 計算環境
    - opencv(python3のみ)
    - python3.5
    - cuda
    - tensorflow

## 注意
```python3```と書かなければpython3は起動しません。
摘便デフォルトのpythonを変更してください。

ビルドに時間がかかります。
OPENCVのコンパイルが長い(12コアのマシンで3時間程度かも...)です。