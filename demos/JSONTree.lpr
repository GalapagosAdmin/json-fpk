program JSONTree;
///@000 2009.03.05 Goal is to read a JSON file and build a tree in the window.

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, JSONTreeUnit, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R JSONTree.rc}{$ENDIF}

begin
  {$I JSONTree.lrs}
  Application.Initialize;
  Application.Createform(Tfrmjsontree, Frmjsontree);
  Application.Run;
end.

