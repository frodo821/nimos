CYLS EQU 10

  ORG 0x7c00

  JMP entry
BS_OEMName       DB "NimOS1.0"
BPB_BytsPerSec   DW 0x0200
BPB_SecPerClus   DB 0x08
BPB_RsvdSecCnt   DW 0x0020
BPB_NumFATs      DB 0x02
BPB_RootEntCnt   DW 0x0000
BPB_TotSec16     DW 0x0000
BPB_Media        DB 0xf8
BPB_FATSz16      DW 0x0000
BPB_SecPerTrk    DW 0x003f
BPB_NumHeads     DW 0x00ff
BPB_HiDDSec      DD 0x0000003f
BPB_TotSec32     DD 0x00f17fc1
BPB_FATSz32      DD 0x00003c40
BPB_ExtFlags     DW 0x0000
BPB_FSVer        DW 0x0000
BPB_RootClus     DD 0x00000002
BPB_FSInfo       DW 0x0001
BPB_BkBootSec    DW 0x0006
TIMES 12         DB 0
BS_DrvNum        DB 0x80
BS_Reserved1     DB 0x00
BS_BootSig       DB 0x29
BS_VolID         DD 0x4e494f53
BS_VolLab        DB "NimOS BOOT "
BS_FileSysType   DB "FAT32   "

entry:
  XOR AX,AX
  MOV DS,AX
  MOV ES,AX
  MOV FS,AX
  MOV GS,AX
  MOV SS,AX
  MOV SP,0x7c00
  MOV DS,AX
  MOV AH,0x03
  MOV AL,0x00
  INT 0x10

readdisk:
  MOV AX,0x0820
  MOV ES,AX
  MOV CH,0
  MOV DH,0
  MOV CL,2

.readloop:
  MOV SI,0

.retry:
  MOV AH,0x02
  MOV AL,1
  MOV BX,0
  MOV DL,0x00
  INT 0x13
  JNC .next
  ADD SI,1
  CMP SI,5
  JAE .error
  MOV AH,0x00
  MOV DL,0x00
  INT 0x13
  JMP .retry

.next:
  MOV AX,ES
  ADD AX,0x0020
  MOV ES,AX
  ADD CL,1
  CMP CL,18
  JBE .readloop
  MOV CL,1
  ADD DH,1
  CMP DH,2
  JB  .readloop
  MOV DH,0
  ADD CH,1
  CMP CH,CYLS
  JB  .readloop
  JMP .success

.success:
  MOV SI,msg_SuccessDR
  CALL prints
  JMP exit

.error:
  MOV SI,msg_ErrorDR
  CALL prints
  JMP exit

prints:
  LODSB
  CMP AL,0
  JE .exit
  MOV AH,0x0e
  INT 0x10
  JMP prints
.exit:
  RET

exit:
  HLT
  JMP exit

msg_Hello:
  DB "Hello, World!", 0x0d, 0x0a, 0x00
msg_ErrorDR:
  DB "An error has been detected while reading from disk.", 0x0d, 0x0a, 0x00
msg_SuccessDR:
  DB "Successfully loaded from disk.", 0x0d, 0x0a, 0x00

times 510-($-$$) DB 0

Boot_Signature:
  DW 0xaa55

times 2880*512-($-$$) DB 0