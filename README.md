# Capstone for Delphi

Delphi/Free Pascal Unit to use the [Capstone Disassembler Library](http://www.capstone-engine.org/).
This Unit has been tested with Free Pascal 2.6.4 and Delphi XE3.

I didn't try it on Linux, I even don't know if the Capstone library is available for Linux.
But there is no reason why it should not run on Linux, it does not use anything Windows specific.

[Sad Sam](https://0x2a.wtf/projects/sad) uses this unit to disassemble binaries.

## Usage

Included is the wrapper class `TCapstone` in `Capstone.pas`. The example bellow 
is incomplete, but it may give you an impression how to use it.

    uses
      ..., Capstone, CapstoneCmn, CapstoneApi;
      
    var 
      disasm: TCapstone;
      addr: Int64;
      insn: TCsInsn;
      stream: TMemoryStream;
    begin
      // Load the code into stream
      disasm := TCapstone.Create;
      try
        disasm.Mode := [csm32];
        disasm.Arch := csaX86;
        addr := 0;
        if disasm.Open(stream.Memory, stream.Size) = CS_ERR_OK then begin
          while disasm.GetNext(addr, insn) do begin
            WriteLn(Format('%x  %s %s', [addr, insn.mnemonic, insn.op_str]));
          end;
        end else begin
          WriteLn('ERROR!');
        end;
      finally
        disasm.Free;
      end;
    end;

## Compiling

The Capstone DLL is *early binded*, so make sure it is in the applications 
search path, preferably in the same directory of the executeable when you run it.

Lazarus
: To compile the Test program, open the file `test.lpi` in [Lazarus](http://www.lazarus-ide.org/) and click Start -> Compile.

Delphi
: Rename `test.pas` to `test.dpr`, open it in Delphi and click Compile.

## Screenshot

![Capstone](http://0x2a.wtf/content/projects/capstone.png "Capstone test program output")
