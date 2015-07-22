obj-m += helloworld.o

all:
	make -C kernelHeaders M=$(PWD) modules

clean:
	make -C kernelHeaders M=$(PWD) clean

kernelHeaders:
	-rm -fr $@ $@.tmp
	mkdir $@.tmp
	cp -rL /lib/modules/$(shell uname -r)/build/* $@.tmp/
	find $@.tmp -name '*.h' | xargs sed 's/\<and\>/and___/g' -i
	find $@.tmp -name '*.h' | xargs sed 's/\<false\>/false___/g' -i
	find $@.tmp -name '*.h' | xargs sed 's/\<true\>/true___/g' -i
	find $@.tmp -name '*.h' | xargs sed 's/\<private\>/private___/g' -i
	find $@.tmp -name '*.h' | xargs sed 's/\<namespace\>/namespace___/g' -i
	sed -i 's/typedef[ \t]\+_Bool[ \t]\+bool;/typedef char bool;/' $@.tmp/include/linux/types.h
	find $@.tmp -name '*.h' | xargs sed 's/\<bool\>/bool___/g' -i
	find $@.tmp -name '*.h' | xargs sed 's/\<extern asmlinkage\>/asmlinkage/g' -i
	cd $@.tmp; patch -p1 < ../fix_cpp_issues_in_kernel_header_files.patch
	mv $@.tmp $@
