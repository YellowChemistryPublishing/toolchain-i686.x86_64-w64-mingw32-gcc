import argparse
import os
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument(
    "--no-compress", action="store_true", default=False, dest="noCompress"
)
parser.add_argument("--no-lto", action="store_true", default=False, dest="noLTO")
parser.add_argument(
    "--arch", action="store", default="i686", dest="arch", choices=["x86_64", "i686"]
)
args = parser.parse_args()

cwd = os.path.dirname(os.path.realpath(__file__))
os.chdir(cwd)

assert (
    subprocess.call(
        (
            f"./build --mode=gcc-15.1.0 --arch={args.arch} --enable-languages=c,c++,fortran --no-multilib --bootstrapall {'--bin-compress' if not args.noCompress else ''} {'--use-lto' if not args.noLTO else ''} "
            f"--rt-version=v12 --exceptions={"dwarf" if args.arch == "i686" else "seh"} --threads=posix --with-default-msvcrt=msvcrt --with-default-win32-winnt=0x0501 "
            f' --show-subtargets --update-sources --logviewer-command=cat --wait-for-logviewer --buildroot="{cwd}/build-i686-w64-mingw32" --jobs=$(nproc)'
        ),
        shell=True,
    )
    == 0
)

buildArtifacts = None
for subdir, dirs, files in os.walk(f"build-{args.arch}-w64-mingw32"):
    for dir in dirs:
        if "rt_v" in dir:
            buildArtifacts = f"{cwd}/build-{args.arch}-w64-mingw32/{dir}/mingw32"
            break
assert buildArtifacts is not None

assert (
    subprocess.call(
        f"7z a {args.arch}-w64-mingw32-gcc.7z {buildArtifacts}",
        shell=True,
    )
    == 0
)
