Blog Setup
==========

This uses [Babushka](https://babushka.me/) to set up a digital ocean container
for my personal ghost blog

## Getting Started
SSH into the brand new digital ocean box as root.

Next, clone this repo, and update submodules:

```sh
git clone https://github.com/cgthornt/blog-setup.git
cd blog-setup
git submodule init
git submodule update
```

Now install any dependencies:


```sh
./initial-setup.sh
```

Finally, install all the things:

```sh
./babushka 'all the things'
```