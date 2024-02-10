# Haiku Revision Switcher

This little bash script lets you switch nightly releases in Haiku easily. It fetches the latest from the web and lets you pick a revision to switch to.

This basically helps you do faster what is [explained here](https://www.haiku-os.org/guides/daily-tasks/updating-system/)



It looks like this:

```
----------------------------
Pick Haiku Revision to install
----------------------------
If anything goes wrong go back to stable
Current will enable UNSTABLE nightly builds
Pick a hrev to test and keep a specific build
----------------------------

> stable
  current
  r1~beta4_hrev57576
  r1~beta4_hrev57575
  r1~beta4_hrev57573
  r1~beta4_hrev57571
  r1~beta4_hrev57564
  r1~beta4_hrev57560
```

Installing:

```
  git clone https://github.com/blackjack75/haiku_rev_switcher
```

Running:

```
  cd haiku_rev_switcher
  ./haikurev.sh
```

