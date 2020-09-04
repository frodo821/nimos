# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import ./kernel/submodule

{.emit: "__attribute__ ((__section__(\".init.text\")))".}
proc startKernel() {.exportc: "start_kernel", stdcall.} =
  outHello()
