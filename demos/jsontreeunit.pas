Unit JSONTreeUnit;

{$mode objfpc}{$H+}

//@001 2010.04.05 Added File Menu, tabs

Interface

Uses
  Classes, Sysutils, Fileutil, Lresources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, EditBtn, Buttons, ExtCtrls, ActnList, Menus;

Type

  { TfrmJSONTree }

  TfrmJSONTree = Class(Tform)
    acnFileOpen: TAction;
    acnUpdateTreePath: TAction;
    Actionlist1: Tactionlist;
    Btnanalyze: Tbutton;
    Mainmenu1: Tmainmenu;
    miFileOpen: TMenuItem;
    miFile: TMenuItem;
    Mmfile: Tmemo;
    Opendialog1: Topendialog;
    Pagecontrol1: Tpagecontrol;
    Statusbar1: Tstatusbar;
    Tabsheet1: Ttabsheet;
    Tabsheet2: Ttabsheet;
    Treeview1: Ttreeview;
    Procedure Acnfileopenexecute(Sender: Tobject);
    Procedure Acnupdatetreepathexecute(Sender: Tobject);
    Procedure btnAddNodeClick(Sender: Tobject);
    Procedure Btnanalyzeclick(Sender: Tobject);
    Procedure btnFileLoadClick(Sender: Tobject);
    Procedure Edfilenamebuttonclick(Sender: Tobject);
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End; 

Var
  frmJSONTree: TfrmJSONTree;

Implementation

{ TfrmJSONTree }

Uses
 jsondecode in '../JSONDecode.pas';

Procedure Tfrmjsontree.btnAddNodeClick(Sender: Tobject);
 var i:integer;
    s:string;
Begin
 // TreeView1.Items.Clear;




  //if there are no nodes, create a root node with a parent of Nil
  if TreeView1.Items.Count = 0 then
    begin
      Treeview1.Items.Add (nil,'Root Node');
      exit;
    end;

  //Set up a simple text for each new node - Node1 , Node2 etc
  i:=treeview1.Items.Count;
  s:= 'Node '+inttostr(i);
  //Add a new node to the currently selected node
  if TreeView1.Selected <> nil then
    Treeview1.Items.AddChild(Treeview1.Selected ,s);

End;

Procedure Tfrmjsontree.Acnfileopenexecute(Sender: Tobject);
var
 decoded:TStringList;
 i:integer;
 edFileNameText:String;
Begin
//  if edFileName.Text = '' then
    If OpenDialog1.execute then
      edFileNameText :=  OpenDialog1.FileName;
  if edFileNameText = '' then exit;
  mmFile.Lines.LoadFromFile(edFileNameText);
  if mmfile.Lines.Count <> 0 then
//  Decoded := TStringList.Create;
   begin
     treeview1.Items.Clear;
     Treeview1.Items.Add (nil, mmfile.lines.text);
   End;
//  JSON2StringList(mmFile.Lines.Text, Decoded);

//  For i := 0 to Decoded.Count -1 do
//   begin
//    Treeview1.Items.Add (nil, Decoded.Strings[i]);
//   End;
//  Decoded.free;

End;

Procedure Tfrmjsontree.Acnupdatetreepathexecute(Sender: Tobject);
Begin
     StatusBar1.SimpleText:=
       TreeView1.selected.GetTextPath;
End;

Procedure Tfrmjsontree.Btnanalyzeclick(Sender: Tobject);
 var
 decoded:TStringList;
 i:integer;
 key:string;
 value:string;
Begin
    if TreeView1.Selected = nil then exit;
       If JSONDataIsList(Treeview1.selected.Text) then
       begin
        Writeln('Processing as list.');
//         value := JSONGetValue(Treeview1.selected.Text);
//         key := JSONGetKey(Treeview1.selected.Text);
//       showmessage('value='+ value);
//         if length(value) = 0 then exit;
         Decoded := TStringList.Create;
         JSON2StringList(Treeview1.selected.Text, Decoded);
         Writeln('Entries:', decoded.Count);
         For i := 0 to Decoded.Count -1 do
           begin
//            Treeview1.Items.Add (nil, Decoded.Strings[i]);
             Treeview1.Items.AddChild(Treeview1.Selected, Trim(Decoded.Strings[i]));
           End;
         // This has to be done LAST
         If JSONDataIsObject(Treeview1.selected.Text) Then
           Treeview1.selected.Text := '{object}'
         else  If JSONDataIsArray(Treeview1.selected.Text) Then
             Treeview1.selected.Text := '[Array]';
         Treeview1.selected.Expand(True);
         Decoded.free;
       End  // of JSON List Processing
     else if JSONDataIsKeyValuePair(Treeview1.selected.Text) then // NOT list
       begin
         Writeln('Processing as Key-Value pair.');
         value := JSONGetValue(Treeview1.selected.Text);
         key := JSONGetKey(Treeview1.selected.Text);
         Treeview1.selected.Text := key;
//       showmessage('value='+ value);
         if length(value) = 0 then exit;
          // We just put the value as it is, since it's not a list
         Treeview1.Items.AddChild(Treeview1.Selected, Trim(Value));
         Treeview1.selected.Expand(True);
       end; // not list
       acnUpdateTreePath.Execute;
End;  // of PROCEDURE

Procedure Tfrmjsontree.btnFileLoadClick(Sender: Tobject);
//var
// decoded:TStringList;
// i:integer;
Begin
    acnFileOpen.Execute;
    {*  if edFileName.Text = '' then
    If OpenDialog1.execute then
      edFileName.Text :=  OpenDialog1.FileName;
  if edFileName.Text = '' then exit;
  mmFile.Lines.LoadFromFile(edFileName.Text);
  if mmfile.Lines.Count <> 0 then
//  Decoded := TStringList.Create;
   begin
     treeview1.Items.Clear;
     Treeview1.Items.Add (nil, mmfile.lines.text);
   End;
//  JSON2StringList(mmFile.Lines.Text, Decoded);

//  For i := 0 to Decoded.Count -1 do
//   begin
//    Treeview1.Items.Add (nil, Decoded.Strings[i]);
//   End;
//  Decoded.free;
        *}
End;

Procedure Tfrmjsontree.Edfilenamebuttonclick(Sender: Tobject);
Begin
  //  If OpenDialog1.execute then
  //  edFileName.Text :=  OpenDialog1.FileName;
End;

Initialization
  {$I jsontreeunit.lrs}

End.

