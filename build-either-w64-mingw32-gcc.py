import argparse
import os
import subprocess

cwd = os.path.dirname(os.path.realpath(__file__))
os.chdir(cwd)

parser = argparse.ArgumentParser()
parser.add_argument(
    "--no-compress", action="store_true", default=False, dest="noCompress"
)
parser.add_argument(
    "--arch", action="store", default="i686", dest="arch", choices=["x86_64", "i686"]
)
parser.add_argument(
    "--buildroot",
    action="store",
    default=f"{cwd}/toolchain-build",
    dest="buildroot",
    type=str,
)
args = parser.parse_args()

ret = subprocess.call(
    (
        f"./build --mode=gcc-15.1.0 --arch={args.arch} --enable-languages=c,c++,fortran --no-multilib --bootstrapall {'--bin-compress' if not args.noCompress else ''} "
        f'--rt-version=v12 --exceptions={"dwarf" if args.arch == "i686" else "seh"} --threads=posix --with-default-msvcrt=msvcrt --with-default-win32-winnt=0x0501 '
        f' --show-subtargets --logviewer-command=cat --wait-for-logviewer --buildroot="{args.buildroot}" --jobs=$(nproc)'
    ),
    shell=True,
)
assert ret == 0 or ret == 1, f"Subcommand failed with exit code {ret}."

buildArtifacts = None
for subdir, dirs, files in os.walk(args.buildroot):
    for dir in dirs:
        if "rt_v" in dir:
            buildArtifacts = f'{args.buildroot}/{dir}/mingw{"32" if args.arch == "i686" else "64"}'
            break
assert buildArtifacts is not None

ret = subprocess.call(
    f'7z a {args.arch}-w64-mingw32-gcc.7z "{buildArtifacts}"',
    shell=True,
)
assert ret == 0, f"Subcommand failed with exit code {ret}."
