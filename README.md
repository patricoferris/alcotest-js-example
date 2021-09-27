Alcotest-js Examples
--------------------

This repository is a partner to [this draft PR]() showing some more "real-world" examples (and also providing an easy way for anyone to set this up and test it).

Tl;dr [Alcotest live in your browser](https://patricoferris.github.io/alcotest-js-example/)!


### Running locally

```sh
git clone --recursive https://github.com/patricoferris/alcotest-js-example
opam pin add alcotest.dev './alcotest' -yn && opam pin add alcotest-js.dev './alcotest' -yn
opam install --deps-only alcotest.dev alcotest-js.dev
# For browser tests
dune build @browsertest # Then open /docs/index.html
# For node tests make sure node is installed then...
npm install
dune build @nodetest
```