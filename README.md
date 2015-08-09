# Capstone for Delphi

Delphi/Free Pascal Unit to use the [Capstone Disassembler Library](http://www.capstone-engine.org/).
This Unit has been test with Free Pascal 2.6.4 and Delphi XE3.

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
