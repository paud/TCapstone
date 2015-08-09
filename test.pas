program test;

uses
  SysUtils, Classes, Capstone, CapstoneCmn, CapstoneApi;

var
  disasm: TCapstone;
  addr: Int64;
  insn: TCsInsn;
  stream: TMemoryStream;
  fs: TFileStream;
  filename: string;
begin
  if ParamCount = 0 then begin
    WriteLn('test <filename>');
    Halt(1);
	end;
  filename := ParamStr(1);
  if not FileExists(filename) then begin
    WriteLn(Format('File %s not found', [filename]));
    Halt(1);
	end;
  fs := TFileStream.Create(filename, fmOpenRead);
  try
    fs.Position := 0;
    stream := TMemoryStream.Create;
    try
      stream.LoadFromStream(fs);
      stream.Position := 0;
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
		finally
      stream.Free;
		end;
	finally
	end;
end.

