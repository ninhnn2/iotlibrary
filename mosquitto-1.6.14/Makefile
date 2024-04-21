include config.mk

DIRS=lib client src
DOCDIRS=man
DISTDIRS=man
DISTFILES= \
	client/ \
	examples/ \
	installer/ \
	lib/ \
	logo/ \
	man/ \
	misc/ \
	security/ \
	service/ \
	src/ \
	test/ \
	\
	CMakeLists.txt \
	CONTRIBUTING.md \
	ChangeLog.txt \
	LICENSE.txt \
	Makefile \
	about.html \
	aclfile.example \
	compiling.txt \
	config.h \
	config.mk \
	edl-v10 \
	epl-v10 \
	libmosquitto.pc.in \
	libmosquittopp.pc.in \
	mosquitto.conf \
	notice.html \
	pskfile.example \
	pwfile.example \
	readme-windows.txt \
	readme.md

.PHONY : all mosquitto api docs binary check clean reallyclean test install uninstall dist sign copy localdocker

all : $(MAKE_ALL)

api :
	mkdir -p api p
	naturaldocs -o HTML api -i lib -p p
	rm -rf p

docs :
	set -e; for d in ${DOCDIRS}; do $(MAKE) -C $${d}; done

binary : mosquitto

mosquitto :
ifeq ($(UNAME),Darwin)
	$(error Please compile using CMake on Mac OS X)
endif

	set -e; for d in ${DIRS}; do $(MAKE) -C $${d}; done

clean :
	set -e; for d in ${DIRS}; do $(MAKE) -C $${d} clean; done
	set -e; for d in ${DOCDIRS}; do $(MAKE) -C $${d} clean; done
	$(MAKE) -C test clean

reallyclean : 
	set -e; for d in ${DIRS}; do $(MAKE) -C $${d} reallyclean; done
	set -e; for d in ${DOCDIRS}; do $(MAKE) -C $${d} reallyclean; done
	$(MAKE) -C test reallyclean
	-rm -f *.orig

check : test

test : mosquitto
	$(MAKE) -C test test

ptest : mosquitto
	$(MAKE) -C test ptest

utest : mosquitto
	$(MAKE) -C test utest

install : mosquitto
	install -d /var/tmp/midware/lib
	install  lib/libmosquitto.so.1 /var/tmp/midware/lib/libmosquitto.so.1
	ln -sf /var/tmp/midware/lib/libmosquitto.so.1 /var/tmp/midware/lib/libmosquitto.so
	install -d /var/tmp/midware/include/
	install lib/mosquitto.h /var/tmp/midware/include/mosquitto.h
	install lib/mqtt_protocol.h /var/tmp/midware/include/mqtt_protocol.h
	install -d /var/tmp/midware/lib/pkgconfig
	install -m644 libmosquitto.pc.in /var/tmp/midware/lib/pkgconfig/libmosquitto.pc
	sed -i -e "s#@CMAKE_INSTALL_PREFIX@#/usr/local#" -e "s#@VERSION@#1.6.6#" /var/tmp/midware/lib/pkgconfig/libmosquitto.pc
	#$(MAKE) -C lib/cpp install
	install -d /var/tmp/midware/lib
	install  lib/cpp/libmosquittopp.so.1 /var/tmp/midware/lib/libmosquittopp.so.1
	ln -sf /var/tmp/midware/lib/libmosquittopp.so.1 /var/tmp/midware/lib/libmosquittopp.so
	install -d /var/tmp/midware/include/
	install lib/cpp/mosquittopp.h /var/tmp/midware/include/mosquittopp.h
	install -d /var/tmp/midware/lib/pkgconfig
	install -m644 libmosquittopp.pc.in /usr/local/lib/pkgconfig/libmosquittopp.pc

uninstall :
	set -e; for d in ${DIRS}; do $(MAKE) -C $${d} uninstall; done
	rm -f "${DESTDIR}/etc/mosquitto/mosquitto.conf.example"
	rm -f "${DESTDIR}/etc/mosquitto/aclfile.example"
	rm -f "${DESTDIR}/etc/mosquitto/pwfile.example"
	rm -f "${DESTDIR}/etc/mosquitto/pskfile.example"

dist : reallyclean
	set -e; for d in ${DISTDIRS}; do $(MAKE) -C $${d} dist; done
	
	mkdir -p dist/mosquitto-${VERSION}
	cp -r ${DISTFILES} dist/mosquitto-${VERSION}/
	cd dist; tar -zcf mosquitto-${VERSION}.tar.gz mosquitto-${VERSION}/

sign : dist
	cd dist; gpg --detach-sign -a mosquitto-${VERSION}.tar.gz

copy : sign
	cd dist; scp mosquitto-${VERSION}.tar.gz mosquitto-${VERSION}.tar.gz.asc mosquitto:site/mosquitto.org/files/source/
	scp ChangeLog.txt mosquitto:site/mosquitto.org/

coverage :
	lcov --capture --directory . --output-file coverage.info
	genhtml coverage.info --output-directory out

localdocker : reallyclean
	set -e; for d in ${DISTDIRS}; do $(MAKE) -C $${d} dist; done
	
	rm -rf dockertmp/
	mkdir -p dockertmp/mosquitto-${VERSION}
	cp -r ${DISTFILES} dockertmp/mosquitto-${VERSION}/
	cd dockertmp/; tar -zcf mosq.tar.gz mosquitto-${VERSION}/
	cp dockertmp/mosq.tar.gz docker/local
	rm -rf dockertmp/
	cd docker/local && docker build .

