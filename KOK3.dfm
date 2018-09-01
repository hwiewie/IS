視窗雙開
procedure TForm1.Button1Click(Sender: TObject);
var
I:Integer;
WindowName:String;
begin
  Ghwnd := FindWindow(nil, 'Element Client');
  If Ghwnd=0 then
  showmessage('找不到遊戲視窗');
  For I:=1 to 100 do
  begin
    WindowName:='Element Client'+Format('%d',);
    Ghwnd1 := FindWindow('ElementClient Window', Pchar(WindowName));
    If Ghwnd1=0 then
    begin
      SetWindowText(Ghwnd,Pchar(WindowName));
      break;
    end;
    Application.ProcessMessages;
  end;
end;
遊戲程式讀取
procedure TForm1.Button2Click(Sender: TObject);
  begin
  Ghwnd := FindWindow(nil, pchar(edit1.text));   //尋找視窗名稱
  if Ghwnd = 0 then
  begin
    ShowMessage('無此視窗名稱');
  end;
  GetWindowThreadProcessId(Ghwnd, ProcID);   //程序id
  ProcessID := OpenProcess(PROCESS_ALL_ACCESS, False, ProcID);   // 開啟程序
  if ProcessID = 0 then   //程序讀取失敗時
  begin
    showMessage('請先登入人物或檢查是否輸入名稱錯誤');   //跳出錯誤視窗
  end;
  if ProcessID <> 0 then   //讀取成功時,讓所有外掛功能可以使用
  begin
    edit1.Enabled := False ;   //讓填寫外掛名稱的欄位變灰
    GroupBox3.Enabled := True ;
    GroupBox2.Enabled := True ;
    GroupBox1.Enabled := True ;
  end;
end;
怪物訊息 人物訊息和保護 以timer控制刷新速度
procedure TForm1.Timer1Timer(Sender: TObject);
var
  Nkey1,nkey2:integer;
  ft,mp,maxhp,maxmp,hp,MONHP,MONMHP,MONLV:Dword;
  tt: cardinal;
begin
    if combobox1.ItemIndex<6 then   //按鈕定義
    Nkey1:=$31+combobox1.ItemIndex   //定義按鈕 1-6
        Else
    Nkey1:=112+combobox1.ItemIndex -6;   //定義按鈕 F1~F8

    if combobox2.ItemIndex<6 then   //第二組按鈕
    Nkey2:=$31+combobox2.ItemIndex      
        Else
    Nkey2:=112+combobox2.ItemIndex -6;

    if ProcessID <> 0 then   //當程序不為0,即有讀取到程序時
    begin
          //********************讀取生命值****************
  ReadProcessMemory(ProcessID, Pointer(W2i_Base), @ft, 4, tt);   //讀取一級基址
  ReadProcessMemory(ProcessID, Pointer(ft+$20), @ft, 4, tt);   //人物基址
  ReadProcessMemory(ProcessID, Pointer(ft+$450), @hp, 4, tt);   //目前血量偏移
  ReadProcessMemory(ProcessID, Pointer(ft+$480), @maxhp, 4, tt);   //最大血量偏移
  ReadProcessMemory(ProcessID, Pointer(ft+$454), @mp, 4, tt);   //目前魔力偏移
  ReadProcessMemory(ProcessID, Pointer(ft+$484), @maxmp, 4, tt);   //最大魔力偏移

  if (maxhp<1) or (maxhp>100000) then   //當血量不正常時(即過畫面或是遊戲關閉時)                           
  begin
    Groupbox3.Enabled:=false;   //關閉功能 取消血魔保護勾選
    checkbox5.State:=cbUnchecked;
    checkbox6.State:=cbUnchecked;
  end;

  label4.Caption := inttostr(hp)+'/'+inttostr(maxhp);   //標籤顯示 血和最大血
  label6.Caption := inttostr(mp)+'/'+inttostr(maxmp);   //標籤顯示 魔和最大魔
  gauge1.Progress := round(mp*1000/(maxmp+1));   //gauge(血條顯示),+1是避免分母為0的丁丁寫法
  gauge2.Progress := round(hp*1000/(maxhp+1));

  if checkbox5.Checked  and (hp*100/maxhp < strtoint(edit2.Text)) then   //假如勾選血魔保護,而且血魔%低於設定值時
  SendMessageW (Ghwnd,WM_KEYDOWN ,nkey1,0);   //發送鍵盤訊息
  if checkbox6.Checked  and (mp*100/maxmp < strtoint(edit3.Text)) then
  SendMessageW (Ghwnd,WM_KEYDOWN ,nkey2,0);
  end;


  if ProcessID <> 0 then
  begin
          //********************讀取怪物資訊****************
  ReadProcessMemory(ProcessID, Pointer(W2i_Base), @ftt, 4, tt);   //此部分偏移請對照GOD4的偏移大全,不再累述
  ReadProcessMemory(ProcessID, Pointer(ftt+$08), @ftt, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(ftt+$24), @ta, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(ta+$24), @tmp1, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(ta+$18), @tmp2, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(W2i_Base), @MID, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(MID+$20), @MID, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(MID+$A20), @MID, 4, tt);
  eax := tmp2 + ((MID Mod tmp1)) * 4 ;
  ReadProcessMemory(ProcessID, Pointer(eax), @ftt, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(ftt+$4), @eax, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(eax+$12c), @MONHP, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(eax+$15c), @MONMHP, 4, tt);
  ReadProcessMemory(ProcessID, Pointer(eax+$124), @MONLV, 4, tt);
  label7.Caption := inttostr(MONLV) ;
  label13.Caption := inttostr(MONHP)+'/'+inttostr(MONMHP);
  end;
end;
卡鍵功能區
procedure TForm1.Timer2Timer(Sender: TObject);
var Nkey:integer;
begin
  label11.Caption :=floattostr((strtofloat(label11.Caption)*10-1)/10);   //剩餘秒數,每次減少0.1

  if combobox3.ItemIndex<6 then   //按鈕定義,上面已有提過
  Nkey:=$31+combobox3.ItemIndex
  Else
  Nkey:=112+combobox3.ItemIndex -6;

  if strtofloat(label11.Caption)<=0 then   //當標籤內數值(讀秒)減少到0時     
  SendMessageW (Ghwnd,WM_KEYDOWN ,Nkey,0);   //發送卡鍵訊息
  if strtofloat(label11.Caption)<=0 then   //當標籤內數值(讀秒)減少到0時  
  label11.Caption:=edit4.Text ;   //將標籤值再回復到設定秒數
end;

procedure TForm1.CheckBox9Click(Sender: TObject);
begin
if checkbox9.Checked then   //當卡鍵功能勾選時
    Begin
        label11.Caption:=edit4.Text ;   //標籤值(剩餘秒數)讀取為設定值
        combobox3.Enabled:=false;    //讓按鈕選項無法使用
        edit4.Enabled:=false;    //讓秒數設定欄無法使用
    End
    Else   //當卡鍵功能取消勾選時
    Begin
       label11.Caption:='0';   //標籤值(剩餘秒數)恢復為0
        combobox3.Enabled:=true;   //讓按鈕選項可以再使用
        edit4.Enabled:=true;    //讓秒數設定欄可以再使用
    End;
  timer2.Enabled:=checkbox9.Checked ;   //在勾選卡鍵功能時才開啟timer
end;

procedure TForm1.Edit4Change(Sender: TObject);   //避免秒數設定欄為空時所造成問題
begin
    try
      strtofloat(edit4.Text);                                             
      checkbox9.Enabled:=true;
    except
      checkbox9.Enabled:=false;
    End;
end;
白目功能
procedure TForm1.CheckBox2Click(Sender: TObject);   //隱藏建築
begin
  cha := $00421198 ;   //修改位址
  fu:= $7a;   //開啟值
  f1:=$7b;   //關閉值
  if CheckBox2.Checked then   //當 勾選此功能時
  Writeprocessmemory(ProcessID,pointer(cha),@fu,1,tt)   //將開啟值寫入記憶體修改位址
  Else   //取消勾選時
  Writeprocessmemory(ProcessID,pointer(cha),@f1,1,tt);   //將關閉值寫入記憶體修改位址
end;

procedure TForm1.CheckBox3Click(Sender: TObject);      //穿牆
begin
  cha := $00405223 ;
  fu:= $d8;
  f1:=$d9;
  if CheckBox3.Checked then
  Writeprocessmemory(ProcessID,pointer(cha),@fu,1,tt)
  Else
  Writeprocessmemory(ProcessID,pointer(cha),@f1,1,tt);
end;

procedure TForm1.CheckBox4Click(Sender: TObject);      //無限跳
begin
  cha := $00450426;
  fu:= $01;
  f1:=$0a;
  if CheckBox4.Checked then
  Writeprocessmemory(ProcessID,pointer(cha),@fu,1,tt)
  Else
  Writeprocessmemory(ProcessID,pointer(cha),@f1,1,tt);
end;

procedure TForm1.CheckBox7Click(Sender: TObject);      //無限視野
begin
  cha := $004056e7;
  fu:= $74 ;
  f1:=$75  ;
  if CheckBox7.Checked then
  Writeprocessmemory(ProcessID,pointer(cha),@fu,1,tt)
  Else
  Writeprocessmemory(ProcessID,pointer(cha),@f1,1,tt);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);        //飛天
begin
  cha := $004586D1;
  fu:= $75 ;
  f1:=$74  ;
  if CheckBox1.Checked then
  Writeprocessmemory(ProcessID,pointer(cha),@fu,1,tt)
  Else
  Writeprocessmemory(ProcessID,pointer(cha),@f1,1,tt);
end;

procedure TForm1.CheckBox8Click(Sender: TObject);         //表情多發
begin
  cha := $006c7797;
  fu:= $49 ;
  f1:=$41  ;
  if CheckBox8.Checked then
  Writeprocessmemory(ProcessID,pointer(cha),@fu,1,tt)
  Else
  Writeprocessmemory(ProcessID,pointer(cha),@f1,1,tt);
end;
