object editmidieventfrm: Teditmidieventfrm
  Left = 436
  Top = 132
  BorderStyle = bsToolWindow
  Caption = 'MIDI-Event bearbeiten'
  ClientHeight = 329
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape4: TShape
    Left = 0
    Top = 288
    Width = 777
    Height = 41
    Align = alBottom
    Pen.Style = psClear
  end
  object Shape1: TShape
    Left = 0
    Top = 288
    Width = 777
    Height = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 761
    Height = 81
    Caption = ' Messages '
    TabOrder = 0
    object Label2: TLabel
      Left = 136
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Message'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 200
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Data 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 264
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Data 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object message1b: TLabel
      Left = 136
      Top = 60
      Width = 8
      Height = 13
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object data1b: TLabel
      Left = 200
      Top = 60
      Width = 8
      Height = 13
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object data2b: TLabel
      Left = 264
      Top = 60
      Width = 8
      Height = 13
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 8
      Top = 24
      Width = 745
      Height = 9
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Label5: TLabel
      Left = 54
      Top = 39
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = 'Aufgezeichnet:'
    end
    object Label6: TLabel
      Left = 16
      Top = 60
      Width = 109
      Height = 13
      Alignment = taRightJustify
      Caption = 'Letztes MIDI-IN Signal:'
    end
    object Label1: TLabel
      Left = 368
      Top = 16
      Width = 108
      Height = 13
      Caption = 'Wert beziehen von'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label18: TLabel
      Left = 544
      Top = 16
      Width = 56
      Height = 13
      Caption = 'Optionen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object recordmidi: TCheckBox
      Left = 544
      Top = 39
      Width = 209
      Height = 17
      Caption = 'Bei n'#228'chstem MIDI-Event anlernen'
      TabOrder = 0
    end
    object data2a: TEdit
      Left = 264
      Top = 36
      Width = 33
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = data2aChange
    end
    object data1chk: TRadioButton
      Left = 368
      Top = 39
      Width = 57
      Height = 17
      Caption = 'Data 1'
      TabOrder = 4
    end
    object data2chk: TRadioButton
      Left = 424
      Top = 39
      Width = 52
      Height = 17
      Caption = 'Data2'
      Checked = True
      TabOrder = 5
      TabStop = True
    end
    object usemidibacktrack: TCheckBox
      Left = 544
      Top = 56
      Width = 209
      Height = 17
      Caption = 'Midi Backtrack verwenden'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object Data1box: TComboBox
      Left = 200
      Top = 36
      Width = 52
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      ItemHeight = 13
      TabOrder = 8
      OnCloseUp = Data1boxCloseUp
      OnDropDown = Data1boxDropDown
      OnSelect = Data1boxSelect
      Items.Strings = (
        '-')
    end
    object data1a: TEdit
      Left = 200
      Top = 36
      Width = 33
      Height = 21
      TabOrder = 2
      Text = '0'
      OnChange = data1aChange
    end
    object MSGbox: TComboBox
      Left = 136
      Top = 36
      Width = 52
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      ItemHeight = 13
      TabOrder = 7
      OnCloseUp = MSGboxCloseUp
      OnDropDown = MSGboxDropDown
      OnSelect = MSGboxSelect
      Items.Strings = (
        'Note-On Event (144...159)'
        'Note-Off Event (128...143)'
        'Polyphonic Key Pressure (160...175)'
        'Control Change (179...191)'
        'Program Change (192...207)'
        'Channel Pressure (208...223)'
        'Pitch Bend (224...239)'
        'MIDI Machine Control Response (245)'
        'MIDI Machine Control Command (253)')
    end
    object message1a: TEdit
      Left = 136
      Top = 36
      Width = 33
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = message1aChange
    end
  end
  object okbtn: TButton
    Left = 16
    Top = 296
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object cancelbtn: TButton
    Left = 96
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 96
    Width = 761
    Height = 185
    Caption = ' Befehl bearbeiten '
    TabOrder = 3
    object Label7: TLabel
      Left = 8
      Top = 19
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label8: TLabel
      Left = 256
      Top = 19
      Width = 68
      Height = 13
      Caption = 'Beschreibung:'
    end
    object Label9: TLabel
      Left = 8
      Top = 59
      Width = 63
      Height = 13
      Caption = 'Programmteil:'
    end
    object Label10: TLabel
      Left = 256
      Top = 59
      Width = 52
      Height = 13
      Caption = 'Steuerung:'
    end
    object Label11: TLabel
      Left = 504
      Top = 59
      Width = 102
      Height = 13
      Caption = 'Ger'#228't/Gruppe/Effekt:'
      Visible = False
    end
    object Label12: TLabel
      Left = 584
      Top = 19
      Width = 74
      Height = 13
      Caption = 'Schaltschwelle:'
    end
    object Label13: TLabel
      Left = 504
      Top = 19
      Width = 72
      Height = 13
      Caption = 'Untere Grenze:'
    end
    object Label19: TLabel
      Left = 664
      Top = 19
      Width = 69
      Height = 13
      Caption = 'Obere Grenze:'
    end
    object ZeitBox: TGroupBox
      Left = 584
      Top = 104
      Width = 169
      Height = 73
      Caption = ' Zeiteinstellungen '
      TabOrder = 4
      Visible = False
      object Label14: TLabel
        Left = 8
        Top = 24
        Width = 6
        Height = 13
        Caption = 'h'
      end
      object Label15: TLabel
        Left = 48
        Top = 24
        Width = 16
        Height = 13
        Caption = 'min'
      end
      object Label16: TLabel
        Left = 88
        Top = 24
        Width = 5
        Height = 13
        Caption = 's'
      end
      object Label17: TLabel
        Left = 128
        Top = 24
        Width = 13
        Height = 13
        Caption = 'ms'
      end
      object hEdit: TEdit
        Left = 8
        Top = 40
        Width = 35
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = hEditChange
      end
      object minEdit: TEdit
        Left = 48
        Top = 40
        Width = 35
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = hEditChange
      end
      object sEdit: TEdit
        Left = 88
        Top = 40
        Width = 35
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = hEditChange
      end
      object msEdit: TEdit
        Left = 128
        Top = 40
        Width = 35
        Height = 21
        TabOrder = 3
        Text = '0'
        OnChange = hEditChange
      end
    end
    object Edit1: TEdit
      Left = 8
      Top = 32
      Width = 241
      Height = 21
      TabOrder = 0
      OnChange = Edit1Change
    end
    object Edit2: TEdit
      Left = 256
      Top = 32
      Width = 241
      Height = 21
      Hint = 
        'Hier besteht die M'#246'glichkeit einen kleinen Beschreibungstext ein' +
        'zugeben.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = Edit2Change
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 72
      Width = 241
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 2
      OnSelect = ComboBox1Select
    end
    object ComboBox2: TComboBox
      Left = 256
      Top = 72
      Width = 241
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 3
      OnEnter = ComboBox2Enter
      OnExit = ComboBox2Exit
      OnSelect = ComboBox2Select
    end
    object Optionen1Box: TGroupBox
      Left = 8
      Top = 104
      Width = 185
      Height = 73
      Caption = ' Optionen 1 '
      TabOrder = 5
      Visible = False
      object Arg1Label: TLabel
        Left = 8
        Top = 23
        Width = 28
        Height = 13
        Caption = 'Arg 1:'
      end
      object Arg1Edit: TEdit
        Left = 8
        Top = 40
        Width = 169
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = Arg1EditChange
      end
      object Arg1Combobox: TComboBox
        Left = 8
        Top = 40
        Width = 169
        Height = 21
        Style = csDropDownList
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 1
        Visible = False
        OnSelect = Arg1ComboboxSelect
      end
    end
    object Optionen2Box: TGroupBox
      Left = 200
      Top = 104
      Width = 185
      Height = 73
      Caption = ' Optionen 2 '
      TabOrder = 6
      Visible = False
      object Arg2Label: TLabel
        Left = 8
        Top = 23
        Width = 28
        Height = 13
        Caption = 'Arg 2:'
      end
      object Arg2Edit: TEdit
        Left = 8
        Top = 40
        Width = 169
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = Arg2EditChange
      end
      object Arg2Combobox: TComboBox
        Left = 8
        Top = 40
        Width = 169
        Height = 21
        Style = csDropDownList
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 1
        Visible = False
        OnSelect = Arg2ComboboxSelect
      end
    end
    object devicelist: TComboBox
      Left = 504
      Top = 72
      Width = 249
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 7
      Visible = False
      OnSelect = devicelistSelect
    end
    object Optionen3Box: TGroupBox
      Left = 392
      Top = 104
      Width = 185
      Height = 73
      Caption = ' Optionen 3 '
      TabOrder = 8
      Visible = False
      object Arg3Label: TLabel
        Left = 8
        Top = 23
        Width = 28
        Height = 13
        Caption = 'Arg 3:'
      end
      object Arg3Edit: TEdit
        Left = 8
        Top = 40
        Width = 169
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = Arg3EditChange
      end
      object Arg3Combobox: TComboBox
        Left = 8
        Top = 40
        Width = 169
        Height = 21
        Style = csDropDownList
        DropDownCount = 20
        ItemHeight = 13
        TabOrder = 1
        Visible = False
        OnSelect = Arg3ComboboxSelect
      end
    end
    object OffValue: TJvSpinEdit
      Left = 504
      Top = 32
      Width = 73
      Height = 21
      MaxValue = 126.000000000000000000
      TabOrder = 9
      OnChange = OffValueChange
    end
    object OnValue: TJvSpinEdit
      Left = 664
      Top = 32
      Width = 89
      Height = 21
      MaxValue = 127.000000000000000000
      MinValue = 1.000000000000000000
      Value = 127.000000000000000000
      TabOrder = 10
      OnChange = OnValueChange
    end
    object grouplist: TComboBox
      Left = 504
      Top = 72
      Width = 249
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 11
      Visible = False
      OnSelect = grouplistSelect
    end
    object effektlist: TComboBox
      Left = 504
      Top = 72
      Width = 249
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 12
      Visible = False
      OnSelect = effektlistSelect
    end
    object SwitchValue: TJvSpinEdit
      Left = 584
      Top = 32
      Width = 73
      Height = 21
      MaxValue = 127.000000000000000000
      Value = 64.000000000000000000
      TabOrder = 13
      OnChange = SwitchValueChange
    end
    object ScaleValue: TCheckBox
      Left = 664
      Top = 53
      Width = 89
      Height = 17
      Caption = 'Skaliere Wert'
      TabOrder = 14
      OnMouseUp = ScaleValueMouseUp
    end
    object InvertSwitchValue: TCheckBox
      Left = 616
      Top = 53
      Width = 41
      Height = 17
      Hint = 'Invertiert die Schaltschwellenrichtung'
      Caption = 'INV'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      OnMouseUp = InvertSwitchValueMouseUp
    end
  end
end
