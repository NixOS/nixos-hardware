{ fetchFromGitHub, rev, hash }:
{
  linux-surface = fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = rev;
    hash = hash;
  };
}