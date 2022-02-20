"""データの読み込み・書き込みに関する module
"""
from __future__ import annotations
from abc import ABCMeta, abstractmethod
import configparser

config_ini = configparser.ConfigParser()
config_ini.read('config.ini', encoding='utf-8')
path_data = config_ini["DEFAULT"]["PATH_DATA"]


class CannotReadError(Exception):
    """この module で読み込みができない場合に発生するエラー"""
    pass


class DataAccessInterface(metaclass=ABCMeta):
    """データのやり取りを行うための抽象クラス"""
    @abstractmethod
    def read(self, name: str):
        """読み込みを行う抽象メソッド"""
        pass

    @abstractmethod
    def write(self, obj, name: str):
        """書き込みを行う抽象メソッド"""
        pass


class CsvHandler(DataAccessInterface):
    """csv ファイルの読み込み・書き込みに関する class"""
    def __init__(self, path_data: str = path_data):
        """初期化. `data` ディレクトリへのパスを設定する"""
        self._path = path_data

    def add_postfix(self, filename: str) -> str:
        """`.csv` がファイル名についていなければ追加する"""
        postfix = ".csv"
        if not filename.endswith(postfix):
            filename += postfix
        return filename

    def read(self, name: str):
        return super().read(name)

    def write(self, obj, name: str):
        return super().write(obj, name)
