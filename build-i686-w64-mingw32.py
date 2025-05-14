import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument(
    "--no-compress", action="store_true", default=False, dest="noCompress"
)
parser.add_argument("--no-lto", action="store_true", default=False, dest="noLTO")
args = parser.parse_args()

cwd = os.path.dirname(os.path.abspath(__file__))
os.chdir(cwd)
os.system(
    (
        f"./build --mode=gcc-trunk --arch=i686 --enable-languages=c,c++,fortran,objc,obj-c++ --no-multilib --bootstrapall {'--bin-compress' if not args.noCompress else ''} {'--use-lto' if not args.noLTO else ''} "
        "--rt-version=v11 --exceptions=dwarf --threads=posix --with-default-msvcrt=msvcrt --with-default-win32-winnt=0x0501 --update-sources --show-subtargets "
        f'--logviewer-command=cat --wait-for-logviewer --buildroot="{cwd}/i686-w64-mingw32-build" --jobs=$(nproc)'
    )
)
