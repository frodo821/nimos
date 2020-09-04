# Package

version       = "0.0.1"
author        = "frodo821"
description   = "An operating system fully implemented by nim"
license       = "MIT"
srcDir        = "src"
bin           = @["nimos"]


# Dependencies

requires "nim >= 1.2.4"

# Tasks

task clean, "clean up build cache":
  exec "rm -f postcompile/*.*"

task make, "":
  `clean Task`()
  exec "nimble build"
  exec "objcopy -O elf64-x86-64 nimos.exe image/CD/images/kernel.c32"
  exec "rm nimos.exe"
  exec "mkisofs -o build/output.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table image/CD"
