"""プロファイリングを行うためのモジュール"""
import sys
import cProfile
import pstats
import configparser


# config ファイルから設定
config_ini = configparser.ConfigParser()
config_ini.read('config.ini', encoding='utf-8')
path_profile = config_ini["DEFAULT"]["PATH_PROFILE"]


def profile_decolator(func, filename: str):
    """ある関数において実行結果をプロファイルする
    """
    cProfile.run(
        f"{func.__name__}()",
        filename=f"{path_profile}{filename}.prof"
    )


def output_profile_result(filename: str):
    """プロファイル結果を確認"""
    sts = pstats.Stats(f"{path_profile}{filename}.prof")
    sts.strip_dirs().sort_stats("ncalls").print_stats()


if __name__ == "__main__":
    """標準入力から実行された際は出力結果を確認

    `{標準入力された文字列}.prof` ファイルの結果を読み込む
    """
    prof_file_name = sys.argv[1]
    output_profile_result(prof_file_name)
