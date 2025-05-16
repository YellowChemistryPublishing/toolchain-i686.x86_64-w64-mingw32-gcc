import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument(
    "--no-compress", action="store_true", default=False, dest="noCompress"
)
parser.add_argument("--no-lto", action="store_true", default=False, dest="noLTO")
parser.add_argument(
    "--arch", action="store", default="i686", dest="arch", choices=["x86_64", "i686"]
)
args = parser.parse_args()

os.system(
    (
        f"./build --mode=gcc-15.1.0 --arch={args.arch} --enable-languages=c,c++,fortran --no-multilib --bootstrapall {'--bin-compress' if not args.noCompress else ''} {'--use-lto' if not args.noLTO else ''} "
        "--rt-version=v12 --exceptions=dwarf --threads=posix --with-default-msvcrt=msvcrt --with-default-win32-winnt=0x0501 "
        f' --show-subtargets --update-sources --logviewer-command=cat --wait-for-logviewer --buildroot="{cwd}/build-i686-w64-mingw32" --jobs=$(nproc)'
    )
)
