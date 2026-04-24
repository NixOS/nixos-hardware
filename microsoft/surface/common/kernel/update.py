#!/usr/bin/env python3

import json
import os
import re
import subprocess

KERNEL_VERSION = os.getenv("KERNEL", "6.19.8")
LINUX_SURFACE_VERSION = os.getenv("LINUX_SURFACE", "debian-6.19.8-1")


class Version:
    def __init__(self, version: str):
        self.version = version

    def __str__(self) -> str:
        return self.version

    @property
    def version(self) -> str:
        return self.__version

    @version.setter
    def version(self, version):
        self.__version = version
        self.__split()

    def __split(self):
        suffix = ""
        numbers = self.__version.split(".", 2)
        self.major = numbers[0]
        self.minor = numbers[1]
        try:
            suffix = re.match(r'(\d+|)(\D.*|)$', numbers[2])
        except Exception:
            print(f"{numbers=}")
            raise

        try:
            self.patch = suffix.group(1)
            self.pre_release = suffix.group(2)
        except Exception:
            print(f"{numbers=} {suffix=}")
            raise


class NixPrefetchMessage:
    def __init__(self, version: str, download_type: str):
        self.version = Version(version)
        self.download_type = download_type

    def message(self):
        return f"# Version {self.version}, {self.download_type}: {self.download_hash!r}"


class NixPrefetch(NixPrefetchMessage):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.download_metadata = {}

    @property
    def download_hash(self):
        try:
            return self.download_metadata["hash"]
        except Exception:
            print(f"{self.download_metadata=}")
            raise

    def extract_metadata(self, json_output):
        self.download_metadata = json.loads(json_output)
        return self

    def prefetch(self):
        out = subprocess.run(self.command, stdout=subprocess.PIPE)
        out.check_returncode()
        try:
            self.extract_metadata(out.stdout)
        except subprocess.CalledProcessError as e:
            print(out.stdout)
            print(e)
            raise
        return self


class NixPrefetchFile(NixPrefetch):
    @property
    def command(self):
        return ["nix", "store", "prefetch-file", "--json", self.url]


class NixPrefetchGithub(NixPrefetch):
    def __init__(self, owner: str, repo: str, **kwargs):
        super().__init__(**kwargs)
        self.owner = owner
        self.repo = repo

    @property
    def command(self):
        return ["nix-prefetch-github", "--rev", str(self.version), self.owner, self.repo]


class NixPrefetchLinuxKernel(NixPrefetchFile):
    def __init__(self, **kwargs):
        super().__init__(download_type="Linux Kernel", **kwargs)

    @property
    def url(self):
        return f"https://cdn.kernel.org/pub/linux/kernel/v{self.version.major}.x/linux-{self.version}.tar.xz"


class NixPrefetchSurfacePatch(NixPrefetchGithub):
    def __init__(self, **kwargs):
        super().__init__(
            download_type="Microsoft Surface Kernel Patch",
            owner="linux-surface",
            repo="linux-surface",
            **kwargs,
        )


#####


def main():
    message = "\n".join(
        [
            NixPrefetchLinuxKernel(version=KERNEL_VERSION).prefetch().message(),
            NixPrefetchSurfacePatch(version=LINUX_SURFACE_VERSION).prefetch().message(),
        ]
    )
    print(message)
    with open("../default.nix", "a") as file:
        print(message, file=file)


main()
