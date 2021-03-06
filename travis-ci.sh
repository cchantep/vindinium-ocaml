# OPAM version to install
export OPAM_VERSION=1.1.1
# OPAM packages needed to build tests
export OPAM_PACKAGES='ocamlfind oasis core async_ssl cohttp ounit'

# install ocaml from apt
sudo apt-get update -qq
sudo apt-get install -qq ocaml

# install opam
curl -L https://github.com/OCamlPro/opam/archive/${OPAM_VERSION}.tar.gz | tar xz -C /tmp
pushd /tmp/opam-${OPAM_VERSION}
./configure
make
sudo make install
opam init -a
eval `opam config -env`
popd

# install packages from opam
opam install -q -y ${OPAM_PACKAGES}

# compile & run tests (here assuming OASIS DevFiles)
cp _tags.dist _tags
oasis setup
./configure --enable-tests
make test
