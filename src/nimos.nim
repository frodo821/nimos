# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

proc main*() {.exportc: "start_kernel_nim", inline.} =
  echo "Hello, World from OS!"
