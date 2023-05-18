# syntax=docker/dockerfile:1

FROM ubuntu:16.04
SHELL ["/bin/bash", "-c"]

ARG workdir=/prepare
WORKDIR $workdir
# ANCHOR Install prerequisites
RUN <<-EOT
	sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	apt-get -y update
	# DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai \
	apt-get -y install \
		build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev bison \
		zlib1g-dev pkg-config libhwloc-dev cmake liblzma-dev openssl libssl-dev cpputest \
		libsqlite3-dev libtool uuid-dev git autoconf libcmocka-dev libunwind-dev ethtool \
		libmnl-dev libnetfilter-queue-dev flex
EOT

ARG thread=15
# ANCHOR Compile and install source
RUN <<-"EOT"
	apt-get -y install \
		wget
	prerequisites=(
		# https://github.com/rurban/safeclib/releases/download/v3.7.1/safeclib-3.7.1.tar.gz
		# https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
		# https://github.com/gperftools/gperftools/releases/download/gperftools-2.10/gperftools-2.10.tar.gz
		# http://www.colm.net/files/ragel/ragel-6.10.tar.gz
		# https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz

		# https://github.com/intel/hyperscan/archive/refs/tags/v5.4.0.tar.gz
		# https://github.com/google/flatbuffers/archive/refs/tags/v2.0.8.tar.gz
		https://github.com/snort3/libdaq/archive/refs/tags/v3.0.9.tar.gz
	)
	function getRepoVerionTag {
		# Get parameter
		local link=$1

		# Define regex template
		local user_name='[^/]+' # Regex for USER NAME
		local repo_name='([^/]+)' # Regex for REPOsitory NAME, (\1) Select
		local repo_vtag='v(([0-9]+\.)*[0-9]+)' # Regex for REPOsitory Version TAG, (\2)(\3) Select
		local comp_type='((\.[0-9a-zA-Z]+)+)' # Regex for COMPressed file TYPE, (\4)(\5) Select

		local rpsc_tmpl='github.com\/'"$user_name"'\/'"$repo_name"\
		'\/archive\/refs\/tags\/'"$repo_vtag$comp_type" # RePository SourCe TeMPLate
		local vtag_rank='\1-\2\4' # Back-Reference sequence for vtag in regex

		# Get repository Version TAG
		echo `echo $link | sed -rn 's/.*'$rpsc_tmpl'.*/'$vtag_rank'/p'`
	}

	mkdir $workdir/src
	mkdir $workdir/build
	for link in ${prerequisites[@]} ; do
		file_name=$(getRepoVerionTag $link)
		# Check, if link isnt a form of github source, then use the filename after last '/'
		if [ -z $file_name ] ; then
			file_name=${link##*/}
		fi
		wget $link -O $workdir/src/$file_name

		tar -xzvf $workdir/src/$file_name -C $workdir/build
		cd $workdir/build/$file_name
			./configure

			make -j $thread
			make install
		cd $workdir
	done
EOT