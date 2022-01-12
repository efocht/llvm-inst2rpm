THIS_MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR = $(abspath $(dir ${THIS_MAKEFILE_PATH}))

IPREFIX ?= $(lastword $(wildcard /usr/local/ve/llvm-ve-rv-*))
VERSION_STRING	= $(lastword $(subst -, ,$(IPREFIX)))
$(if $(IPREFIX),,$(error No directory /usr/local/ve/llvm-ve-rv-* found))
NAME		= llvm-ve-rv-${VERSION_STRING}
RELEASE_STRING 	= 1

DIR=${NAME}-${VERSION_STRING}

all: rpm

prep:
	mkdir -p SPECS SOURCES
	cp -p llvmvars.sh ${BUILD_TOP_DIR}/SOURCES
	cp -p llvm-ve-rv.spec.in ${BUILD_TOP_DIR}/SPECS/${NAME}.spec

rpm: prep
	rpmbuild -ba --define "_topdir ${BUILD_TOP_DIR}" \
	  --define "name ${NAME}" \
	  --define "version ${VERSION_STRING}" \
	  --define "release ${RELEASE_STRING}" \
	  --define "iprefix ${IPREFIX}" \
	  ${BUILD_TOP_DIR}/SPECS/${NAME}.spec

clean:
	rm -rf BUILD BUILDROOT SPECS SOURCES SRPMS RPMS

.PHONY: all rpm prep clean FORCE
