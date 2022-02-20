# ベースImageの取得
FROM python:3.9.5-buster

# 必要ライブラリのインストール
RUN pip3 install -U pip && \
    pip3 install pipenv

# pipenv の環境を使用できるように環境変数設定
ENV PIPENV_VENV_IN_PROJECT true