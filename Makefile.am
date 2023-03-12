# don't delete intermediate targets
.SECONDARY:

# don't run any of these meta-rules in parallel when invoked with 'make -j'
# (for example, the gcc build rule itself invokes make -j.  And it needs to complete before zlib.)
.NOTPARALLEL:

SUBDIRS = \
	gcc \
	cmake \
	zlib \
	hdf5 \
	mpich

git-clobber:
	git clean -xdfn --exclude utils/autotools --exclude import
